---
layout: post
title: Advanced bookmarking
edited: 2016-08-23
author: Winston Chang
description: For applications that don't have a straightforward reactive flow -- where the state of the inputs at a given time doesn't fully determine the state of the outputs -- it may be necessary to use additional tools to save and restore the desired state.
---


## Applications with complex state

For applications that don't have a straightforward reactive flow -- where the state of the inputs at a given time doesn't fully determine the state of the outputs -- it may be necessary to use additional tools to save and restore the desired state.

Suppose your application uses a variable to record how many times an input has changed. A very basic version of the server function might contain something like this:

{% highlight r %}
function(input, output) {
  count <- 0

  observe({
    input$x   # Trigger this observer when input$x changes
    count <<- count + 1
  })
}
{% endhighlight %}

In actual use, it's likely that the value would be stored in a `reactiveValues` object so that it could trigger other reactives and observers. For example, this app displays the sum of all the previous slider values that the user explicitly adds to a running tally using an action button:

{% highlight r %}
ui <- fluidPage(
  sidebarPanel(
    sliderInput("n", "Value to add", min = 0, max = 100, value = 50),
    actionButton("add", "Add"), 
    br(), br()
  ),
  mainPanel(
    h4("Sum of all previous slider values:", textOutput("sum"))
  )
)

server <- function(input, output, session) {
  vals <- reactiveValues(sum = 0)
  
  observeEvent(input$add, {
    vals$sum <- vals$sum + input$n
  })
  output$sum <- renderText({
    vals$sum
  })
}

shinyApp(ui, server, enableBookmarking = "url")
{% endhighlight %}

In this app, the state of the outputs is not fully determined by the state of the inputs at a given time point; previous input values matter as well. Bookmarking this application therefore requires more than simply saving the current input values. We need to also record `vals$sum` and restore it later.


### `onBookmark` and `onRestore`

To record `vals$sum`, we will tell Shiny to save extra values when bookmarking state, and restore those values when restoring state. This is done by adding callbacks, using `onBookmark()` and `onRestore()` in the application's server function. The callback functions that you pass to `onBookmark()` and `onRestore()` must take one argument, typically named `state`. The `state` object has an environment object named `values`, to which you can write or read arbitrary values. For this app, it's simple: we'll just save `vals$sum` when we bookmark, and copy it back when we restore. We'd call the functions like this (in the server function):

{% highlight r %}
  # Save extra values in state$values when we bookmark
  onBookmark(function(state) {
    state$values$currentSum <- vals$sum
  })

  # Read values from state$values when we restore
  onRestore(function(state) {
    vals$sum <- state$values$currentSum
  })
{% endhighlight %}


Here's the full app:

{% highlight r %}
ui <- function(request) {
  fluidPage(
    sidebarPanel(
      sliderInput("n", "Value to add", min = 0, max = 100, value = 50),
      actionButton("add", "Add"), br(), br(),
      bookmarkButton()
    ),
    mainPanel(
      h4("Sum of all previous slider values:", textOutput("sum"))
    )
  )
}

server <- function(input, output, session) {
  vals <- reactiveValues(sum = 0)
  
  # Save extra values in state$values when we bookmark
  onBookmark(function(state) {
    state$values$currentSum <- vals$sum
  })

  # Read values from state$values when we restore
  onRestore(function(state) {
    vals$sum <- state$values$currentSum
  })

  # Exclude the add button from bookmarking
  setBookmarkExclude("add")

  observeEvent(input$add, {
    vals$sum <- vals$sum + input$n
  })
  output$sum <- renderText({
    vals$sum
  })
}

shinyApp(ui, server, enableBookmarking = "url")
{% endhighlight %}

Note that we exclude the add button from bookmarking with `setBookmarkExclude` so that when the app is restored the last value of `input$n` is not added to `vals$sum`.


### `onBookmarked` and `onRestored`

The `onBookmark` and `onRestore` callbacks are triggered just before the bookmarking and restoring events happen. They have counterpart callbacks that are triggered *after* bookmarking and restoring: `onBookmarked` and `onRestored`.

The `onBookmarked` callback behaves differently from the others. Its purpose is to display a URL in a modal dialog on the client browser. The callback function should take one argument, `url`, which is a string that contains the URL to display in the browser. If no `onBookmarked` callback is supplied the default is to use `showBookmarkUrlModal`. In other words, the default is equivalent to:

{% highlight r %}
  onBookmarked(showBookmarkUrlModal)
{% endhighlight %}

If you wish to display the URL another way, you can supply a different function for `onBookmarked()`.


The `onRestored` callback is similar to `onBookmark` and `onRestore` in that the function should take one argument, `state`, which is an object with a `values` member. This callback is invoked *after* the the application has been restored and running in the client browser, so it can be used to do things that must occur only after the application is ready. One example is calling an input updater function, like `updateTextInput`.

{% highlight r %}
ui <- function(request) {
  fluidPage(
    sliderInput("slider", "Add a value:", 0, 100, 0),
    bookmarkButton(),
    textInput("txt", "Application restored at:")
  )
}

server <- function(input, output, session) {
  onRestored(function(state) {
    # This works, because it doesn't use the inputMessageQueue. Should it use a
    # queue that's flushed on flushOutput?
    showNotification('xxxx')
    
    # This doesn't, because it uses the inputMessageQueue
    updateTextInput(session, "txt", value = "xxxx")
  })
}

shinyApp(ui, server, enableBookmarking = "url")
{% endhighlight %}
