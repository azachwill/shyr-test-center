---
layout: post
title: Plot Caching
author: Winston Chang
edited: 2018-11-01
description: Using cached plots can dramatically speed up your app when there are many users.
---

<div style="border: 1px solid #EBB; border-radius: 3px; background-color: #FCFCFC; padding: 1em;" markdown="1">

<div style="color: #A00;" markdown="1">

> NOTE: This document explains how to use `renderCachedPlot()`, which was introduced in Shiny 1.2.0. As of Shiny 1.6.0, we recommend using `renderPlot()` with `bindCache()` instead. Please see the [caching](caching.html) article to learn more.

</div>

Creating plots in a Shiny application can take anywhere from a fraction of a second to multiple seconds. If there are multiple plots in an application they can be a significant source of perceived slowness. Improving the responsiveness of plots can greatly improve users' experience of your application.

There are multiple ways you can improve the performance of your plots. For example, you could consider using R's base graphics instead of a plotting package, using JavaScript graphics that render on the client instead of static plots that render on the server, or you could change the type of plot, e.g. switching from `ggplot2::geom_point` to `ggplot2::geom_hex`. However, there are cases where you might want to keep using the plotting code you already have.

As of Shiny 1.2.0, it is possible to cache plots with `renderCachedPlot()`. Plot caching can significantly improve the performance of your Shiny application with minimal code changes. Plot caching works by storing rendered plots in a cache so that, if the same plot is requested again, it can be drawn from the cache almost instantly. By default, the cache is shared among multiple users of an application. The more users your application has, the more performance benefits you'll see from caching!


### Example scenario: dashboard

Imagine a dashboard containing three plots which take a total of 3 seconds to render. With the usual `renderPlot()`, every user will have to wait 3 seconds to load the dashboard. If there are many concurrent users, then it might take even longer for some users, because some users might need to wait for others' plots to finish rendering before theirs can be rendered. (This is assuming that the application is served with one R process; it is, however, possible to avoid this problem by using more R processes, a feature supported in RStudio Connect and Shiny Server Pro.)

If the dashboard switches to `renderCachedPlot()`, then the first user to visit will have to wait 3 seconds for the plots to render, but then every subsequent user will get the plots from the shared cache, which is almost instantaneous. The more users there are, the more likely it is for any given person to get a cache hit, and the the greater the average performance benefit will be.


## Using cached plots

Usage is simple: in the most basic form, simply replace your `renderPlot()` with `renderCachedPlot()`, and add a *cache key expression* argument. For example, your server function might look like this:


```r
function(input, output) {
  renderCachedPlot(
    {
      rownums <- seq_len(input$n)
      plot(cars$speed[rownums], cars$dist[rownums])
    },
    cacheKeyExpr = { input$n }
  )
}
```

In this case, the first time a particular of value `input$n` is seen, Shiny will render the plot and store it in the cache. If it changes to another value and then back again, instead of re-executing the plotting code, it will simply get the saved plot from the cache.

<details>
    <summary>Click here to see full app code</summary>

{% highlight r %}
library(shiny)
shinyApp(
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderInput("n", "Number of points", 4, 32, value = 8, step = 4)
      ),
      mainPanel(plotOutput("plot"))
    )
  ),
  function(input, output, session) {
    output$plot <- renderCachedPlot(
      {
        Sys.sleep(2)  # Add an artificial delay
        rownums <- seq_len(input$n)
        plot(cars$speed[rownums], cars$dist[rownums],
            xlim = range(cars$speed), ylim = range(cars$dist))
      },
      cacheKeyExpr = {input$n }
    )
  }
)
{% endhighlight %}

</details>

 You can see the application in action below (or [here](https://gallery.shinyapps.io/136-plot-cache/)).

<iframe src="https://gallery.shinyapps.io/136-plot-cache/?showcase=0" frameborder="no" class="scale65" height="418px" style="margin-bottom: -135px;"></iframe>


In this example, there are two expressions given to `renderCachedPlot()`. The first expression contains the code that generates a plot. Unlike the plotting expression that's used in a regular `renderPlot()`, this expression does not take any reactive dependencies -- it will not, by itself, automatically re-execute. That's where the second expression comes in. You can, of course, reference user inputs in this expression, it is only the affect on the reactive dependency graph that is different.

The second expression, `cacheKeyExpr`, serves two purposes. The first is that it sets up reactive dependencies: whenever any reactive expressions or reactive values in that expression change, it causes the plotting expression to re-execute -- with a big exception, which we'll see soon. (If you've used `eventReactive()` or `observeEvent()`, this is similar the `eventExpr` that they have.) In technical terms, when `cacheKeyExpr` is invalidated, it causes the plotting expression to re-execute.

The other use of `cacheKeyExpr` is, not surprisingly, for caching. When the plot expression is executed, the resulting plot is stored in a cache, using the result from `cacheKeyExpr` as the cache key. (Techincal note: the value from `cacheKeyExpr` is actually serialized and then hashed, and the resulting hash value is used as the key.) Whenever the `cacheKeyExpr` is invalidated and re-executed, Shiny looks first looks in the cache to see if there's a previously-saved plot. If there is, then the saved plot is sent to the client web browser, and the plotting expression does not need to re-execute. If there is not, then it re-executes the plotting expression, caches the resulting plot, and sends it to the browser.


### The cache key expression

In the example above, the cache key expression only contains one thing, `input$n`. It can, however, contain multiple values, if you simply combine them in a list. For example, in addition to user input values that can change, you may have a data set that can change. The `cacheKeyExpr` might look like this:


```r
  output$plot <- renderCachedPlot(
    {
      # Plotting code here...
    },
    cacheKeyExpr = { list(input$n, dataset()) }
  )
```

<details>
    <summary>Click here to see full app</summary>

{% highlight r %}
library(shiny)
dataset <- reactiveVal(data.frame(x = rnorm(400), y = rnorm(400)))

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("n", "Number of points to display", 50, 400, 100, step = 50),
      actionButton("newdata", "Generate new data")
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  # When the newdata button is clicked, change the data set to new random data
  observeEvent(input$newdata, {
    dataset(data.frame(x = rnorm(400), y = rnorm(400)))
  })

  output$plot <- renderCachedPlot(
    {
      Sys.sleep(2)     # Add an artificial delay
      d <- dataset()
      rownums <- seq_len(input$n)
      plot(d$x[rownums], d$y[rownums], xlim = range(d$x), ylim = range(d$y))
    },
    cacheKeyExpr = {
      list(input$n, dataset())
    }
  )
}

shinyApp(ui, server)
{% endhighlight %}

</details>

You can see the application in action below (or [here](https://gallery.shinyapps.io/137-plot-cache-key/)).

<iframe src="https://gallery.shinyapps.io/137-plot-cache-key/?showcase=0" frameborder="no" class="scale65" height="418px" style="margin-bottom: -135px;"></iframe>


### Plot sizing

Sizing for cached plots works a bit differently from regular plots: with regular plots, the plot is rendered to exactly fit the div on the web page; with cached plots, the plot is rendered to a close-fitting size, and scaled to fit the div on the web page.

With `renderPlot()`, the plot is rendered at exactly the dimensions of the div containing the image in the browser. If the div is 500 pixels wide and 400 pixels tall, then it will create a plot that is exactly 500×400 pixels. If you resize the window, and the div then becomes 550x400 pixels (typically the width is variable, but the height is fixed), then Shiny will render another plot that is 550x400, which can take some time.

With `renderCachedPlot()`, the plot is not rendered to be an exact fit. There are a number of possible sizes, and Shiny will render the plot to be the closest size that is larger than the div on the web page, and cache it. For example, possible widths include 400, 480, 576, 691, and so on, both smaller and larger; each width is 20% larger than the previous one. Heights work the same way.

If the width of the div is 450 pixels, then Shiny will render a plot that is 480 pixels wide and scale it down to fit the 450 pixel wide div. If the div is then resized to 500 pixels, then Shiny will render a plot that is 576 pixels wide.

The reason that `renderCachedPlot()` works this way is so that it doesn't have to cache a plot of every possible size; doing that would greatly reduce the usefuless of caching, since each browser would likely have a slightly different width, and so there would be very few cache hits.

This behavior is controlled by the `sizePolicy` parameter -- it is a function that takes two numbers (the actual dimensions of the div) and returns two numbers (the dimensions of the plot that will be rendered). If you want to use a different strategy, you can pass in a different function.

