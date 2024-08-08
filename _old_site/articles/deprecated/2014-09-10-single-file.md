---
layout: post
title: Single-file Shiny apps
edited: 2014-09-10
author: Winston Chang
description: As of version 0.10.2, Shiny supports single-file applications. You no longer need to build separate `server.R` and `ui.R` files for your app; you can just create a file called `app.R` that contains both the server and UI components.
---

## NOTE: This article is deprecated. It is not linked from the website. The two-file article takes its place.

As of version 0.10.2, Shiny supports single-file applications. You no longer need to build separate `server.R` and `ui.R` files for your app; you can just create a file called `app.R` that contains both the server and UI components.

## Example

To create a single-file app, create a new directory (for example, `newdir/`) and place a file called `app.R` in the directory. To run it, call `runApp("newdir")`.

Your `app.R` file should call `shinyApp()` with an appropriate UI object and server function, as demonstrated below:

{% highlight r %}
server <- function(input, output) {
  output$distPlot <- renderPlot({
    hist(rnorm(input$obs), col = 'darkgray', border = 'white')
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", "Number of observations:", min = 10, max = 500, value = 100)
    ),
    mainPanel(plotOutput("distPlot"))
  )
)

shinyApp(ui = ui, server = server)
{% endhighlight %}

One nice feature about single-file apps is that you can copy and paste the entire app into the R console, which makes it easy to quickly share code for others to experiment with. For example, if you copy and paste the code above into the R command line, it will start a Shiny app.


## Details

The `shinyApp()` function returns an object of class `shiny.appobj`. When this is returned to the console, it is printed using the `print.shiny.appobj()` function, which launches a Shiny app from that object.

You can also use a similar technique to create and run files that aren't named `app.R` and don't reside in their own directory. If, for example, you create a file called `test.R` and have it call `shinyApp()` at the end, you could then run it from the console with:

{% highlight r %}
print(source("test.R"))
{% endhighlight %}

When the file is sourced, it returns a `shiny.appobj`—but by default, the return value from `source()` isn't printed. Wrapping it in `print()` causes Shiny to launch it.

This method is handy for quick experiments, but it lacks some advantages that you get from having an `app.R` in its own directory. When you do `runApp("newdir")`, Shiny will monitor the file for changes and reload the app if you reload your browser, which is useful for development. This doesn't happen when you simply source the file. Also, Shiny Server and shinyapps.io expect an app to be in its own directory. So if you want to deploy your app, it should go in its own directory.
