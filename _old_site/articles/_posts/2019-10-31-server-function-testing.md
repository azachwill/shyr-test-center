---
layout: post
title: Server function testing with Shiny
edited: 2021-02-09
author: Jeff Allen and Winston Chang
rmd_source: https://gist.github.com/trestletech/4dceffbd2765f8c1b5d8bf31fcab3b51
description: Introduces the testServer() function which offer a framework for testing the relationships between reactives.
---


The `testServer()` function (introduced in Shiny 1.5.0) makes it possible to test code in server functions and modules, without needing to run the full Shiny application. This means that these tests will run more quickly and reliably than ones with shinytest, which simulate the entire session, including a headless web browser. The `testServer()` function can be used with a unit testing framework like testthat.

Here is a server function for a simple Shiny application:

```r
server <- function(input, output, session) {
  myreactive <- reactive({
    input$x * 2
  })
  output$txt <- renderText({
    paste0("I am ", myreactive())
  })
}
```

This server function

* depends on one input (`input$x`),
* creates an intermediate reactive (`myreactive`), and
* updates an output (`output$txt`) reactively.

It would be nice to write tests that confirm that the module behaves the
way we expect. We can do that using `testServer()`:

``` r
testServer(server, {
  cat("Initially, input$x is NULL, right?", is.null(input$x), "\n")

  # Give input$x a value.
  session$setInputs(x = 1)

  cat("Now that x is set to 1, myreactive is: ", myreactive(), "\n")
  cat("\tand output$txt is: ", output$txt, "\n")

  # Now update input$x to a new value
  session$setInputs(x = 2)

  cat("After updating x to 2, myreactive is: ", myreactive(), "\n")
  cat("\tand output$txt is: ", output$txt, "\n")
})
```

There are a few things to notice in this example.

First, the test expression provided here assumes the existence of some variables – specifically, `input`, `output`, and `myreactive`. The objects from inside the server function environment will be made available in the environment of the test expression.

Second, you’ll need to set the values to any inputs that you want to be defined; by default, they’re all `NULL`. We do that using the `session$setInputs()` method. The real `session` object that you’d see when running a Shiny app does not have `session$setInputs()`; the input values are set by the client's web browser. The `session` object used in `testServer()` differs from the real `session` object Shiny uses. This allows us to tailor it to be more suitable for testing purposes by modifying or creating new methods such as `setInputs()`.

Last, you’re likely used to assigning to `output`, but here we’re _reading_ from `output$txt` in order to check its value. When running inside `testServer()`, you can simply reference an output and it will give the value produced by the `render` function.


## Automated tests

In real tests, we don’t want to just print the values for manual inspection; we’ll want to use them in automated tests. That way, we’ll be able to build up a collection of tests that we can run against our module in the future to confirm that it always behaves correctly. You can use whatever testing framework you’d like (or none at all\!), but we’ll use the `expect_*` functions from the testthat package in this example.

``` r
# Bring in testthat for its expectations
library(testthat)
testServer(server, {
  session$setInputs(x = 1)
  expect_equal(myreactive(), 2)
  expect_equal(output$txt, "I am 2")
  session$setInputs(x = 2)
  expect_equal(myreactive(), 4)
  expect_equal(output$txt, "I am 4")
})
```

If there’s no error, then we know our tests ran successfully. If there
were a bug, we’d see an error printed. For example:

``` r
testServer(server, {
  session$setInputs(x = 1)

  expect_equal(myreactive(), 99)
})
```

    #> Error: myreactive() (`actual`) not equal to 99 (`expected`).
    #>
    #>   `actual`:  2
    #> `expected`: 99


## Shiny app objects

In the examples above, we've just used the `server` part of a Shiny application. In many cases, that's a readily accessible object. It's also possible to pass an entire `shinyApp()` object to `testServer()`, as in:


``` r
app <- shinyApp(
  ui = fluidPage(
    numericInput("x", "X", value = 5),
    textOutput("txt")
  ),
  server = function(input, output, session) {
    myreactive <- reactive({
      input$x * 2
    })
    output$txt <- renderText({
      paste0("I am ", myreactive())
    })
  }
)


testServer(server, {
  session$setInputs(x = 1)
  expect_equal(myreactive(), 2)
})
```

Notice that, even though the `numericInput()` sets a starting value for `input$x`, running tests with `testServer()` doesn't know that. This is because it runs the tests without the UI portion entirely -- it only knows about the server portion of the application.


## Test file layout

At this point you may be wondering how to use `testServer()` in a real application. In most cases, an `app.R` simply returns `shinyApp()`. How do we pass that object to `testServer()`? Where should the tests go?

The `shinyAppTemplate()` takes care of the details about how the files are laid out. (For more information, see [this section](https://shiny.rstudio.com/articles/testing-overview.html#creating-an-example) from the Testing Overview article.) In most cases, you can `shiny::runTests()` function to run all tests for an application.

To create an example application in a directory called `myapp`:

``` r
shinyAppTemplate("myapp", "all")
```

It will create the following files:

```
myapp/
|- app.R
|- R
|   |- example-module.R
|   `- example.R
`- tests
    |- shinytest.R
    |- shinytest
    |   `- mytest.R
    |- testthat.R
    `- testthat
        |- test-examplemodule.R
        |- test-server.R
        `- test-sort.R
```

The `tests/testthat/test-server.R` function has the following contents):

``` r
testServer(expr = {
  session$setInputs(size = 6)
  expect_equal(output$sequence, "1 2 3 4 5 6")
})
```

Notice that no `server` or `app` object is passed into this function. This is because the code that invokes this file (from `tests/testthat.R`) sets up the environment so that the `server` function is accessible to `testServer()`.




## Testing Shiny modules

In addition to testing server functions for Shiny applications, you can also test the server functions for Shiny modules.

Here is the server code for a module that's very similar to the full application above:

``` r
myModule <- function(id) {
  moduleServer(id, function(input, output, session) {
    myreactive <- reactive({
      input$x * 2
    })
    output$txt <- renderText({
      paste0("I am ", myreactive())
    })
  })
}
```

It can be tested in exactly the same way:

``` r
testServer(myModule, {
  session$setInputs(x = 1)
  expect_equal(myreactive(), 2)
})
```

### Modules with additional parameters

Some modules take additional parameters. Here's a version that takes `multiplier`:

``` r
myModule2 <- function(id, multiplier) {
  moduleServer(id, function(input, output, session) {
    myreactive <- reactive({
      input$x * multiplier
    })
    output$txt <- renderText({
      paste0("I am ", myreactive())
    })
  })
}
```

To pass in parameter values, use `args`:

``` r
testServer(myModule2, args = list(multiplier = 3), {
  session$setInputs(x = 1)
  expect_equal(myreactive(), 3)
})
```

### Modules with return values

Some modules return reactive objects. For such modules, it can be helpful to test the returned value as well. The returned value from the module is made available as a property on the mock `session` object as demonstrated in this example.

``` r
myModule3 <- function(id, multiplier) {
  moduleServer(id, function(input, output, session) {
    reactive({
      input$a + input$b
    })
  })
}

testServer(myModule3, {
  session$setInputs(a = 1, b = 2)
  expect_equal(session$returned(), 3)
  # And retains reactivity
  session$setInputs(a = 2)
  expect_equal(session$returned(), 4)
})
```



## Timers and polling

Testing behavior that relies on timing is notoriously difficult. Modules will behave differently on different machines and under different conditions. In order to make testing with time more deterministic, `testServer` uses simulated time that you control, rather than the actual computer time. Let’s look at what happens when you try to use "real" time in your testing.

``` r
server <- function(input, output, session){
  rv <- reactiveValues(x = 0)

  observe({
    # Cause the observer to invalidate every 0.1 second
    invalidateLater(100)
    isolate(rv$x <- rv$x + 1)
  })
}

testServer(server, {
  expect_equal(rv$x, 0)
  Sys.sleep(0.1)
  expect_equal(rv$x, 1)
})
#> Error: rv$x (`actual`) not equal to 1 (`expected`).
#>
#>   `actual`: 0
#> `expected`: 1
```

This behavior may be surprising. It seems like `rv$x` should have been incremented 10 times (or perhaps 9, due to computational overhead). But in truth, it hasn’t changed at all. This is because `testServer()` doesn’t consider the actual time on your computer, but instead it uses simulated time.

In order to cause `testServer()` to progress through time, instead of `Sys.sleep()`, we’ll use `session$elapse()` – another method that exists only on our mocked session object. Using the same server function as above:

``` r
testServer(server, {
  expect_equal(rv$x, 0)
  session$elapse(100)   # Simulate the passing of 100ms
  expect_equal(rv$x, 1) # The observer was invalidated and the value updated!

  # You can even simulate multiple events in a single elapse
  session$elapse(300)
  expect_equal(rv$x, 4)
})
```

As you can see, using `session$elapse()` caused `testServer()` to recognize that (simulated) time had passed which triggered the reactivity as we’d expect. This approach allows you to deterministically control time in your tests while avoiding expensive pauses that would slow down your tests. Using this approach, this test can complete in only a fraction of the 100ms that it simulates.

You should note that only certain time-based functions are aware of this
mocked time that can be managed via `elapse()`. Shiny functions like
`reactivePoll()`, `invalidateLater()`, and `reactiveTimer()` will all abide by
this simulated time, but time-based functions in other packages (such as
`later::later()` are not aware of mocked time and will not behave
according to these rules.)



## Complex outputs (plots, htmlwidgets)

Thus far, we’ve seen how to validate simple outputs like numeric or text values. Real Shiny applications and modules often use more complex outputs such as plots or htmlwidgets. Validating the correctness of these is not as simple, but is doable.

You can access the data for even complex outputs in `testServer`, but the structure of the output may initially be foreign to you.

``` r
server <- function(input, output, session){
  output$plot <- renderPlot({
    df <- data.frame(length = iris$Petal.Length, width = iris$Petal.Width)
    plot(df)
  })
}
testServer(server, {
  print(str(output$plot))
})
```

    ## List of 4
    ##  $ src     : chr "data:image/png;base64,iVBORw0KGgoAAAANSUhEU"| __truncated__
    ##  $ width   : num 600
    ##  $ height  : num 400
    ##  $ coordmap:List of 2
    ##   ..$ panels:List of 1
    ##   .. ..$ :List of 4
    ##   .. .. ..$ domain :List of 4
    ##   .. .. .. ..$ left  : num 0.764
    ##   .. .. .. ..$ right : num 7.14
    ##   .. .. .. ..$ bottom: num 0.004
    ##   .. .. .. ..$ top   : num 2.6
    ##   .. .. ..$ range  :List of 4
    ##   .. .. .. ..$ left  : num 59
    ##   .. .. .. ..$ right : num 570
    ##   .. .. .. ..$ bottom: num 326
    ##   .. .. .. ..$ top   : num 58
    ##   .. .. ..$ log    :List of 2
    ##   .. .. .. ..$ x: NULL
    ##   .. .. .. ..$ y: NULL
    ##   .. .. ..$ mapping: Named list()
    ##   ..$ dims  :List of 2
    ##   .. ..$ width : num 600
    ##   .. ..$ height: num 400
    ## NULL

As you can see, there are a lot of internal details that go into a plot. Behind the scenes, these are all the details that Shiny will use to correctly display a plot in a user’s browser. You don’t need to learn about all of these properties, and they’re all subject to change.

In terms of your testing strategy, you shouldn’t bother yourself with "is Shiny generating the correct structure so that the plot will render in the browser?" That’s a question that the Shiny package itself needs to answer (and one for which we have our own tests). The goal for your tests should be to ask "is the code that I wrote producing the plot I want?" There are two components to that question:

1.  Does the plot generate without producing an error?
2.  Is the plot visually correct?

`testServer` is great for assessing the first component here. By merely referencing `output$plot` in your test, you’ll confirm that the plot was generated without an error. The second component is better suited for a [shinytest](https://rstudio.github.io/shinytest/articles/shinytest.html) test which actually loads the Shiny app in a headless browser and confirms that the content visually appears the same as it did previously. Doing this kind of test in `testServer` would be complex and may not be reliable as graphics devices differ slightly from platform to platform; i.e. the exact bits in the `src` field of your plot will not necessarily be reproducible between different versions of R or different operating systems.

For htmlwidgets, you can adopt a similar strategy. The goal is not to confirm that the htmlwidget’s render function is behaving properly, but rather that the data that you intend to render is indeed getting passed through.

We could modify the above example to better represent this approach.

``` r
server <- function(input, output, session){
  # Move any complex logic into a separate reactive which can be tested comprehensively
  plotData <- reactive({
    data.frame(length = iris$Petal.Length, width = iris$Petal.Width)
  })

  # And leave the `render` function to be as simple as possible to lessen the
  # need for integration tests.
  output$plot <- renderPlot({
    plot(plotData())
  })
}

testServer(server, {
  # Confirm that the data reactive is behaving as expected
  expect_equal(nrow(plotData()), 150)
  expect_equal(ncol(plotData()), 2)
  expect_equal(colnames(plotData()), c("length", "width"))

  # And now the plot function is so simple that there's not much need for
  # automated testing. If we did wish to evaluate the plot visually, we could
  # do so using the shinytest package.
  output$plot # Just confirming that the plot can be accessed without an error
})
```

You could adopt a similar strategy with other plots or htmlwidgets: move the complexity into reactives that can be tested, and leave the `render` functions as simple as possible.


## Flushing Reactives

Reactive programming differs from imperative programming in that the processing required to update reactives can be deferred and batched together. While this is a boon for the computational speed of a reactive system, it does create some ambiguity about *when* the reactives should be processed or "flushed".

`testServer` will do its best to automatically flush the reactives at the right time. There are two triggers that will cause a reactive flush:

1.  Calling `session$setInputs()` - After setting the updated inputs, the reactives will be flushed.
2.  Calling `session$elapse()` - After the scheduled callbacks are executed, reactives will be flushed.

However, there may be other times that you might want to trigger a reactive flush. For instance, you might want to flush the reactives after updating an element in a `reactiveValues` like this one:

``` r
server <- function(input, output, session){
  rv <- reactiveValues(a = 1)
  output$txt <- renderText({
    rv$a
  })
}

testServer(server, {
  expect_equal(output$txt, "1")

  rv$a <- 2

  # testServer has no innate knowledge of our `rv` variable;
  # therefore, it hasn't been updated
  expect_equal(output$txt, "1")

  # We'll need to manually force a flush of the reactives
  session$flushReact()

  expect_equal(output$txt, "2")
})
```

As you can see, we can use `session$flushReact()` to trigger a reactive flush at any point we’d like. In this example, `testServer` knows nothing about our `rv` variable. Therefore if we want to observe reactive changes that occur after manually updating this variable, we’d need to explicitly flush the reactives.
