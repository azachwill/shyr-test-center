---
layout: post
title: Selecting rows of data
edited: 2015-05-13
description: A common use of mouse interactions is to select rows of data from an input data frame. Although you could write code that uses the x and y (or the corresponding min and max) values to filter rows from the data frame, there is an easier way to do it.
---


A common use of mouse interactions is to select rows of data from an input data frame. Although you could write code that uses the `x` and `y` (or the corresponding min and max) values to filter rows from the data frame, there is an easier way to do it. Shiny provides two convenience functions for selecting rows of data:

* `nearPoints()`: Uses the `x` and `y` value from the interaction data; to be used with `click`, `dblclick`, and `hover`.
* `brushedPoints()`: Uses the `xmin`, `xmax`, `ymin`, and `ymax` values from the interaction data; to be used with `brush`.

Note that these functions are only appropriate if the x and y variables are present in the data frame, without any transformation. If, for example, you have a plot where a the x position is *calculated* from a column of data, then these functions won't work. In such a case, it may be useful to first calculate a new column and store it in the data frame.

#### Selection with `nearPoints()`

Here is a basic example of the `nearPoints` function. If you pass it the data frame with the plotted data, the mouse interaction object from `input`, and the names of the x and y variables, it will return a data frame with just selected rows (to see it in action, click near a point the plot area of the app rendered below the code):

{% highlight r %}
ui <- basicPage(
  plotOutput("plot1", click = "plot_click"),
  verbatimTextOutput("info")
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  })

  output$info <- renderPrint({
    # With base graphics, need to tell it what the x and y variables are.
    nearPoints(mtcars, input$plot_click, xvar = "wt", yvar = "mpg")
    # nearPoints() also works with hover and dblclick events
  })
}

shinyApp(ui, server)
{% endhighlight %}

<iframe src="https://gallery.shinyapps.io/098-plot-interaction-article-3" frameborder="no" class="scale80" height="485px" style="margin-bottom: -90px;"></iframe>

By default, `nearPoints` will return all rows of data that are within 5 pixels of the mouse event, and they will be sorted by distance, with the nearest first. The radius can be customized with `threshold`, and the number of rows returned can be customized with `maxpoints`.

If you're using plots created by ggplot2, it's not necessary to specify `xvar` and `yvar`, since they can be autodetected. (Bear in mind that if the variables are *calculated* from the data -- for example with `aes(x = wt/2)` -- this won't work.)

The version below uses a plot with ggplot2, and displays the one point that is closest to the click, and within 10 pixels:

{% highlight r %}
library(ggplot2)
ui <- basicPage(
  plotOutput("plot1", click = "plot_click"),
  verbatimTextOutput("info")
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
  })

  output$info <- renderPrint({
    # With ggplot2, no need to tell it what the x and y variables are.
    # threshold: set max distance, in pixels
    # maxpoints: maximum number of rows to return
    # addDist: add column with distance, in pixels
    nearPoints(mtcars, input$plot_click, threshold = 10, maxpoints = 1,
               addDist = TRUE)
  })
}

shinyApp(ui, server)
{% endhighlight %}

<iframe src="https://gallery.shinyapps.io/099-plot-interaction-article-4" frameborder="no" class="scale80" height="485px" style="margin-bottom: -90px;"></iframe>

#### Selection with `brushedPoints()`

To select rows using a brush, use the `brushedPoints()` function. Basic usage is similar to `nearPoints()`: it returns the rows of data that are under the brush.

{% highlight r %}
ui <- basicPage(
  plotOutput("plot1", brush = "plot_brush"),
  verbatimTextOutput("info")
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  })

  output$info <- renderPrint({
    # With base graphics, need to tell it what the x and y variables are.
    brushedPoints(mtcars, input$plot_brush, xvar = "wt", yvar = "mpg")
  })
}

shinyApp(ui, server)
{% endhighlight %}

<iframe src="https://gallery.shinyapps.io/100-plot-interaction-article-5" frameborder="no" class="scale80" height="535px" style="margin-bottom: -90px;"></iframe>

With ggplot2 graphics, you don't need to supply `xvar` and `yvar` because they can be inferred automatically. Also, `brushedPoints()` and `nearPoints()` both work with facets in ggplot2.

{% highlight r %}
library(ggplot2)
ui <- basicPage(
  plotOutput("plot1", brush = "plot_brush", height = 250),
  verbatimTextOutput("info")
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point() +
      facet_grid(. ~ cyl) +
      theme_bw()
  })

  output$info <- renderPrint({
    brushedPoints(mtcars, input$plot_brush)
  })
}

shinyApp(ui, server)
{% endhighlight %}

<iframe src="https://gallery.shinyapps.io/101-plot-interaction-article-6" frameborder="no" class="scale80" height="385px" style="margin-bottom: -65px;"></iframe>

#### Getting the position of selected rows

Instead of getting just the selected rows, it's sometimes useful to get all the rows, but with a column indicating which rows are selected. For both `nearPoints()` and `brushedPoints()`, you can do this with the `allRows` option.

{% highlight r %}
library(ggplot2)
ui <- basicPage(
  plotOutput("plot1", brush = "plot_brush"),
  verbatimTextOutput("info")
)

server <- function(input, output) {
  options(width = 100) # Increase text width for printing table
  output$plot1 <- renderPlot({
    ggplot(mtcars, aes(x=wt, y=mpg)) + geom_point()
  })

  output$info <- renderPrint({
    brushedPoints(mtcars, input$plot_brush, allRows = TRUE)
  })
}

shinyApp(ui, server)
{% endhighlight %}

<iframe src="https://gallery.shinyapps.io/102-plot-interaction-article-7" frameborder="no" class="scale80" height="1055px" style="margin-bottom: -195px;"></iframe>

This can be useful if you need the row position of the selected points. For example, this can be used to allow clicking on points to exclude them from an analysis, as in [this example](https://gallery.shinyapps.io/106-plot-interaction-exclude/) where you can exclude points from a linear model.

### Options

Mouse interactions have default settings that are suitable for most use cases, but these settings can also be customized.

To do this, for the `click`, `dblclick`, `hover`, and `brush` options, instead of passing them a string, you would pass them the value from `clickOpts()`, `dblclickOpts()`, `hoverOpts()`, or `brushOpts()`.

For example, by default, a brush is a light transparent blue, and it can be controlled in both the vertical and horizontal directions. In the code below, using the `brushOpts()` function, we use the same input ID as before, `"plot_brush"`, but now we can set the fill color to a light gray, and make the brush operate just in the horizontal direction.


{% highlight r %}
library(ggplot2)
ui <- basicPage(
  plotOutput("plot1",
    brush = brushOpts(id = "plot_brush", fill = "#ccc", direction = "x"),
    height = 250
  )
)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(ChickWeight, aes(x=Time, y=weight, colour=factor(Chick))) +
      geom_line() +
      guides(colour=FALSE) +
      theme_bw()
  })
}

shinyApp(ui, server)
{% endhighlight %}

<iframe src="https://gallery.shinyapps.io/103-plot-interaction-article-8" frameborder="no" class="scale80" height="270px" style="margin-bottom: -40px;"></iframe>

For more information about the available options, see `?clickOpts`, `?dblclickOpts`, `?hoverOpts`, and `?brushOpts`.

**Next: learn about [advanced plot interaction](plot-interaction-advanced.html) features.**
