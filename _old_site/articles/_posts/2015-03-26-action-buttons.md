---
layout: post
title: Using Action Buttons
edited: 2015-03-26
description: This article describes five patterns to use with Shiny's action buttons and action links, which are are different from other Shiny widgets because they are intended to be used exclusively with observeEvent or eventReactive.
---

This article describes five patterns to use with Shiny's [action buttons](/reference/shiny/latest/actionButton.html) and [action links](/reference/shiny/latest/actionButton.html). Action buttons and action links are different from other Shiny widgets because they are intended to be used exclusively with `observeEvent()` or `eventReactive()`.

## How action buttons work

Create an action button with `actionButton()` and an action link with `actionLink()`. Each of these functions takes two arguments: 

* `inputId` - the ID of the button or link
* `label` - the label to display in the button or link

{% highlight r %}
actionButton("button", "An action button")
actionLink("button", "An action link")
{% endhighlight %}

An action button appears as a button in your app. 

![](/images/action-button.png)

An action link appears as a hyperlink, but behaves in the same way as an action button.

![](/images/action-link.png)

Like all widgets, action buttons have a value. The value is an integer that changes each time a user clicks the button. You can access this value from within your app as `input$<inputId>` where `<inputId>` is the ID that you assigned to your action button. 

Action buttons are different from other widgets because the value of an action button is almost never meaningful by itself. The value is designed to be observed by one of `observeEvent()` or `eventReactive()`. These functions monitor the value, and when it changes they run a block of code. 

The patterns below explain this arrangement and illustrate the most popular ways to use an action button or an action link.


***

## Pattern 1 - Command

Use `observeEvent()` to trigger a command with an action button. 

### Example

<iframe src="https://gallery.shinyapps.io/088-action-pattern1/" height="470" width="100%" frameborder="no"></iframe>

In the code above, `session$setCustomMessage()` generates a popup message. `tags$head(tags$script(src = "message-handler.js"))` supplies the JavaScript that makes this possible. See [this example](http://shiny.rstudio.com/gallery/server-to-client-custom-messages.html) to learn more about`sendCustomMessage()`.

### Why the pattern works

Action buttons do not automatically generate actions in Shiny. Like other widgets, action buttons maintain a state (a value). The state changes when a user clicks the button.

`observeEvent()` observes a reactive value, which is set in the first argument of `observeEvent()`. Whenever the value changes, `observeEvent()` will run its second argument, which should be a block of code surrounded in braces. 

This pattern uses `observeEvent()` to connect the change in an action button's value to the code that the action button should trigger.

### Tips

* `observeEvent()` isolates the block of code in its second argument with `isolate()`. 

* `observeEvent()` only notices _changes_ in the value of the action button. It does not matter what the actual value of the button is. If your code depends on the value of the action button, it may be mis-written.

***

## Pattern 2 - Delay reactions

Use `eventReactive()` to delay reactions until a user clicks the action button. 

### Example

<iframe src="https://gallery.shinyapps.io/089-action-pattern2/" height="1000" width="100%" frameborder="no"></iframe>

### Why the pattern works

`eventReactive()` creates a reactive expression that monitors a reactive value, which is set in the first argument of `eventReactive()`. The expression will be invalidated whenever the value changes, but it will ignore changes in other reactive values.

Complete this pattern by using the reactive expression created by `eventReactive()` in rendered output. Output that depends on the expression will not update until the expression is invalidated, i.e. until the action button is clicked.

### Tips

* Like `observeEvent()`, `eventReactive()` isolates the block of code in its second argument with `isolate()`.  

* `eventReactive()` returns `NULL` until the action button is clicked. As a result, the graph does not appear until the user asks for it by clicking "Go".

***

## Pattern 3 - Dueling buttons

To build several action buttons that control the same object, combine `observeEvent()` calls with `reactiveValues()`. 

### Example

<iframe src="https://gallery.shinyapps.io/090-action-pattern3/" height="1100" width="100%" frameborder="no"></iframe>

### Why the pattern works

`reactiveValues()` creates a reactive values object, a list of reactive values that you can update and call programmatically. These values are like the values stored in Shiny's `input` object with one difference: you can update the values of a reactive values object, but you cannot normally update the values of the `input` object (those values are reserved for the user to update interactively).

To complete the pattern, monitor each button with its own `observeEvent()` call. Arrange for the calls to update the object created by `reactiveValues()`. Reactive values obey reference class semantics, which means that you can update them from within the scope of an `observeEvent()` function.

***

## Pattern 4 - Reset buttons

To create a reset button, use the above pattern to assign `NULL` to a reactive values object. 

### Example

<iframe src="https://gallery.shinyapps.io/091-action-pattern4/" height="1100" width="100%" frameborder="no"></iframe>

### Why this pattern works

You can apply the previous pattern to reset an element of a reactvie values object to its intial state (`NULL`). To do this, arrange for a button to assign `NULL` to the reactive values object with the help of `observeEvent()`.

***

## Pattern 5 - Reset on tab change

Observe the value of a `tabsetPanel()`, `navlistPanel()`, or `navbarPage()` with `observeEvent()` to rest the value of an object each time your user switches tabs. 

### Example

<iframe src="https://gallery.shinyapps.io/092-action-pattern5/" height="1660" width="100%" frameborder="no"></iframe>

### Why this pattern works

This pattern extends the previous reset pattern. You use `observeEvent()` to reset an element of a reactive values object. However, instead of observing the value of an action button, you observe the value of a tab function.

`tabsetPanel()`, `navlistPanel()`, and `navbarPage()` each combine multiple tabs (created with `tabPanel()`) into a single ui object. These functions maintain a reactive value that contains the title of the current tab. When your user navigates to a new tab, this value changes. `observeEvent()` resets the reactive value to `NULL` when it does.

As with the patterns above, this pattern requires you to store and manipulate a value created with `reactiveValues()`.

### Tips

* Although the example uses `tabsetPanel()`, you can acheive the same effect with `navlistPanel()` and `navbarPage()`.

***

## Recap

Action buttons and action links are meant to be used with one of `observeEvent()` or `eventReactive()`.  You can extend the effects of an action button with `reactiveValues()`.

* Use `observeEvent()` to trigger a block of code with an action button.
* Use `eventReactive()` to update derived/calculated output with an action button.
* Use `reactiveValues()` to maintain an object for multiple action buttons to interact with.


## Aside: about submit buttons

Before action buttons existed in Shiny, there were only [submit buttons]((/reference/shiny/latest/submitButton.html)). At this point, **our general recommendation is to avoid submit buttons** and only use action buttons. Note that any code that uses a submit button can be converted to code that uses an action button instead (while the reverse is generally not true) -- see example at the bottom.

### How are submit buttons and action buttons different?

With an action button, input values are sent from the browser to the server as usual (when they're changed) but you can control the reactive flow of the program by telling particular reactives to not compute until the action button is pressed. In contrast, if your app includes a submit button anywhere, none of the inputs will be sent from the client to the server until the button is pressed. However, submit buttons have unusual behavior in many ways, and we recommend that they not be used for anything but the simplest apps.

These issues include the following: A submit button has a global scope, so there is no way of specifying which inputs should be on hold and which shouldn't. If an app has two submit buttons, both of them will control the entire app, which is probably not what you want. Also, dynamically created submit buttons (for example, with [`renderUI()`](/reference/shiny/latest/renderUI.html) or [`insertUI()`](/reference/shiny/latest/insertUI.html)) will not work. 

### Translating `submitButton` code into `actionButton` code

Consider the app below, taken from the documentation for [`submitButton()`](/reference/shiny/latest/submitButton.html):

{% highlight r %}
shinyApp(
  ui = basicPage(
    numericInput("num", label = "Make changes", value = 1),
    submitButton("Update View", icon("refresh")),
    helpText("When you click the button above, you should see",
             "the output below update to reflect the value you",
             "entered at the top:"),
    verbatimTextOutput("value")
  ),
  server = function(input, output) {

    # submit buttons do not have a value of their own,
    # they control when the app accesses values of other widgets.
    # input$num is the value of the number widget.
    output$value <- renderPrint({ input$num })
  }
)
{% endhighlight %}

While this app *is* simple enough that a submit button is adequate, it can be easily translated to app using an action button instead (which has the added advantage of being a lot more scalable, since you can now add more inputs that will be independent of the action button):

{% highlight r %}
shinyApp(
  ui = basicPage(
    numericInput("num", label = "Make changes", value = 1),
    actionButton("update" ,"Update View", icon("refresh"),
                 class = "btn btn-primary"),
    helpText("When you click the button above, you should see",
             "the output below update to reflect the value you",
             "entered at the top:"),
    verbatimTextOutput("value")
  ),
  server = function(input, output) {
     output$value <- renderPrint({ 
       input$update
       isolate(input$num)
     })
  }
)
{% endhighlight %}

*Note:* The app above could also have been written using `eventReactive()` (as outlined in Pattern 2), instead of `isolate()`.