---
layout: post
title: Communicating with Shiny via JavaScript
author: Joe Cheng
edited: 2018-05-01
description: Sometimes, you want some custom behavior between JavaScript and R that isn't a natural fit for a custom input or output binding. In these cases, you can skip the machinery around input/output bindings, and more or less directly send messages back and forth between JavaScript and R.
---

Shiny was designed with an emphasis on distinct input and output components in the UI. Inputs send values from the client to the server, and when the server has values for the client to display, they are received and rendered by outputs.

But sometimes, you may want some custom behavior in JavaScript that isn't a natural fit for a custom input or output binding. Here are some examples:

- You want the server to trigger logic on the client that doesn't naturally relate to any single output.
- You want the server to update a specific (custom) output on the client, but not by totally invalidating the output and replacing the value, just making a targeted modification.
- You have some client JavaScript that isn't related to any particular input, yet wants to trigger some behavior in R. For example, binding keyboard shortcuts on the web page to R functions on the server, or alerting R when the size of the browser window has changed.

In these cases, you can skip the machinery around input/output bindings, and more or less directly send messages back and forth between JavaScript and R.

This document describes:

1. How to communicate from JavaScript to R
2. How to communicate from R to JavaScript

In both cases, you'll also need to know how to package your JavaScript code with your Shiny app. See [this article](packaging-javascript.html) to learn about your options for doing that.

## From JavaScript to R

Communication from JavaScript to R works by setting a reactive input. While this is normally done using an input binding, you can skip all the ceremony and directly send a reactive input value to R with this JavaScript function:

```javascript
Shiny.setInputValue(id, value);
```

For example, `Shiny.setInputValue("foo", "bar")` will cause the server's `input$foo` to be set to `"bar"`. Either use this input value as part of your reactive expressions, output renderers, and observers; or use `observeEvent(input$foo, { … })` to run arbitrary R code in response to the value.

The value can be anything that is JSON-encodable (don't perform the encoding yourself—it will be done automatically by Shiny).

(Note: if you have heard of a function called `Shiny.onInputChange`, that's just an older, more confusing name for `Shiny.setInputValue`; the latter was introduced in Shiny v1.1. Despite never being officially documented or supported, `Shiny.onInputChange` was/is widely used and we're not likely to remove it anytime soon, and its behavior is identical to `Shiny.setInputValue`.)

That's all most app authors will ever need to know. But Shiny also provides two other features for more advanced use of `Shiny.setInputValue` that may occasionally be useful.

#### Values vs. Events

By default, Shiny assumes that your app only cares about the latest value of a reactive input. `Shiny.setInputValue` uses this assumption to perform two optimizations by default:

1. Setting an input to the same value it already has, is a no-op.
2. If an input is set multiple times (with different values) before control returns to the JavaScript event loop, then only the most recent value will actually be sent to the server.

If your app just wants to calculate reactive expressions/outputs based on `input$foo`, then these optimizations are beneficial; any calculation that you perform on data that is outdated or unchanged is simply wasted effort.

If, on the other hand, you intend to use `input$foo` as an event that triggers `observeEvent`/`eventReactive`, then you don't want these optimizations. If you're using `input$foo` to provide notifications that, say, a button has been clicked, you don't want Shiny to "helpfully" suppress some of those notifications in an effort to save you work. You want to be notified for every call of `Shiny.setInputValue`.

As of Shiny v1.1, you can opt out of the optimizations and have Shiny notify you of every set, by passing a `priority: "event"` option:

```javascript
Shiny.setInputValue("foo", "bar", {priority: "event"});
```

This will cause `input$foo` to notify any reactive objects that depend on it, whether its value has actually changed or not.

#### Custom deserialization with input handlers

When communicating between JavaScript and R, your data will be encoded from JS objects to JSON, and then on the server side, from JSON to R objects (via `jsonlite::fromJSON`). The data types in JSON don't correspond one-to-one with the data types in R, so any attempt to decode JSON to R will inherently have to make some choices. (Should `"null"` be interpreted as `NA` or `NULL`? Is `"{a: [1,2], b: [3,4]}"` supposed to be a 2-by-2 matrix, a list of vectors, or a data frame?)

In the vast majority of cases, `jsonlite::fromJSON` will give you satisfactory results out of the box. But if you find a particular type of value isn't being decoded into your preferred form, you can define an *input handler* to refine the values that come out of `fromJSON` before they're set on the `input` object.

An input handler is simply a function that takes the result from `fromJSON` as an argument, and returns the value that should be used instead.

For example, let's say that our JavaScript code wants to send a geographic point in latitude/longitude coordinates, like so:

`Shiny.setInputValue("coord", {lat: 42.348905, long: -71.0404567})`

When decoded into R by `jsonlite::fromJSON`, it becomes:

`list(lat = 42.348905, long = -71.0404567)`

so that's what you'll get when you read from `input$coord`. That's OK, but it'd be even more convenient to turn it into a proper point using the [`sf` package](https://r-spatial.github.io/sf/). Here's a function that can perform that transformation:

```r
library(sf)
convertToPoint <- function(x, session, inputname) {
  lat <- x[["lat"]]
  long <- x[["long"]]

  # Create the point object
  point <- st_sfc(st_point(long, lat))
  # Set metadata indicating that the data is in lat/long
  st_crs(point) <- 4326

  point
}
```

Note that the `session` and `inputname` parameters are mandatory, even if you don't plan on using them.

Next, we need to register this handler with Shiny using a *type identifier*. This is a string you provide that will uniquely identify your handler; stick to simple identifiers with alphanumeric characters, undercores, and periods. In our case, we'll call it `"sf_coord_point"`:

```r
registerInputHandler("sf_coord_point", convertToPoint)
```

Input handlers should only be registered once per R process. If you're doing this for an R package, then your package's `.onLoad` function would be a good place to do this.

Finally, when sending a value from JavaScript, you need to tell Shiny that your intention is for the `sf_coord_point` handler to be used. You do this by adding type type identifier a suffix to your input name:

```javascript
Shiny.setInputValue("coord:sf_coord_point", {lat: lat, long: long});
```

Now, `input$coordinate` will return a full featured `sf` point object instead of just a generic list object!

## From R to JavaScript

Sending instructions from R to JavaScript is a bit different. Whereas communicating in the JavaScript-to-R direction piggybacks on the machinery for processing reactive inputs, the R-to-JavaScript direction does not have anything to do with reactive outputs, but instead has its own dedicated mechanism.

Messages sent from R must be directed to a specific browser, i.e. a specific session, so you send messages through a method on the `session` object:

```r
session$sendCustomMessage(type, message)
```

The `type` is an identifier string that will help Shiny identify the correct JavaScript code to invoke when the message is received. As usual, it's best to stick to simple identifiers with alphanumeric characters, undercores, and periods.

The `message` is any R object that can be encoded to JSON. Again, we use `jsonlite` for this, but Shiny passes specific options to `jsonlite::toJSON`; you can use `shiny:::toJSON(x)` (note the triple-colon!) to preview how your object will be converted to JSON.

On the JavaScript side, you need to register a function to receive messages of the given type:

```javascript
Shiny.addCustomMessageHandler(type, function(message) {...});
```

The `type` string should match the value in the call to `session$sendCustomMessage`, and the function argument should implement whatever logic you want. The `message` parameter is for the JSON-decoded object that was sent from the server; you can change the parameter name to something that's more meaningful for your data.

Here's a strange little example app that continuously sends rainbow colors from R to JavaScript, and uses the colors to update the background color:

```r
library(shiny)

# Make a palette of 40 colors
colors <- rainbow(40, alpha = NULL)
# Mirror the rainbow, so we cycle back and forth smoothly
colors <- c(colors, rev(colors[c(-1, -40)]))

ui <- fluidPage(
  tags$head(
    # Listen for background-color messages
    tags$script("
      Shiny.addCustomMessageHandler('background-color', function(color) {
        document.body.style.backgroundColor = color;
        document.body.innerText = color;
      });
    "),
    
    # A little CSS never hurt anyone
    tags$style("body { font-size: 40pt; text-align: center; }")
  )
)

server <- function(input, output, session) {
  pos <- 0L

  # Returns a hex color string, e.g. "#FF0073"
  nextColor <- function() {
    # Choose the next color, wrapping around to the start if necessary
    pos <<- (pos %% length(colors)) + 1L
    colors[[pos]]
  }
  
  observe({
    # Send the next color to the browser
    session$sendCustomMessage("background-color", nextColor())

    # Update the color every 100 milliseconds
    invalidateLater(100)
  })
}

shinyApp(ui, server)
```

When calling `session$sendCustomMessage`, keep in mind that this is, in reactive-programming speak, a *side effect*, and therefore something that generally needs to be done in an `observe` or `observeEvent` rather than a `reactive` or `eventReactive`.
