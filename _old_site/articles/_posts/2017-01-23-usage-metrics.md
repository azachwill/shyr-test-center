---
layout: post
title: "Shiny App Usage Tracking"
edited: 2017-01-23
author: Sean Lopp
description: You may want to track visitors to your Shiny application and analyze how they interact with it. This article will demonstrate techniques for implementing 3rd party tools that track and analyze usage metrics.
---

You may want to track visitors to your Shiny application and analyze how they interact with it. This article will demonstrate techniques for implementing 3rd party tools that track and analyze usage metrics.

![Example Matomo Dashboard](/images/usage-tracking-piwik-screenshot.png)


## Background

There are two types of metrics that can be tracked and analyzed for a Shiny application: usage metrics and hosting metrics.

*Usage metrics* provide valuable insights such as the number of unique visitors to an application, a user's typical behavior (what inputs are changed, time on the application) and information about the visitor (location, browser, screen size). **Implementing usage metrics typically requires Javascript. This article does not provide a comprehensive overview, but most Shiny users should be able to implement these techniques.**

*Hosting metrics* deal with how responsive the application is to concurrent use, how fast the application loads, and what server resources are appropriate for the application. Tools and techniques for analyzing hosting metrics are covered in the [admin guides](http://docs.rstudio.com/) for shinyapps.io, RStudio Connect, and Shiny Server and additionally in support articles on [Performance Tuning in Shiny Server Pro](https://support.rstudio.com/hc/en-us/articles/220546267-Scaling-and-Performance-Tuning-Applications-in-Shiny-Server-Pro) and [Performance Tuning in RStudio Connect](https://support.rstudio.com/hc/en-us/articles/231874748).

### Google Analytics / Matomo 

There are many 3rd party tools that provide usage tracking for web applications. Picking the appropriate tool will depend on your requirements. Luckily, the steps necessary to integrate these tools with Shiny applications are similar. This article covers the patterns along with specific examples for Google Analytics and Matomo.

Google Analytics is a popular cloud-based tool for usage tracking that includes free and paid plans. See this article for [detailed step-by-step instructions to setting up Google Analytics with a basic Shiny application](http://shiny.rstudio.com/articles/google-analytics.html). This article will extend the patterns to add event and user ID tracking.

[Matomo](https://matomo.org/) is an open-source tool that can be hosted on-premise. Subscription based support and online, hosted versions are also available. 

Once you've selected a specific platform and setup the tool there are three common steps to integrate usage tracking into a Shiny application:

1. Add a Tracking ID
2. Incorporate Event Tracking
3. Capture User ID

Step 1 is required for Steps 2 and 3. Steps 2 and 3 are often optional and are independent (Step 3 can be implemented with or without Step 2 and vice-versa).

### Adding Javascript to Shiny Applications

All 3 steps will require adding Javascript to your Shiny application. There are a few ways to do so:

- Add a separate .js file to the application directory and include the file by using the function `includeScript()`. *Warning*: the `includeScript` function places the content of the script inside a pair of script tags `<script></script>`. If you copy and paste Javascript code into a .js file be sure to remove these tags. This method is nice because is separates the tracking code from the application code.

- Add the Javascript within the Shiny application's UI code using the `tags$script` function. Similar to `includeScript`, this function expects Javascript so do not include the script tags `<script></script>`. For example:

{% highlight r %}
# pseudocode
ui <- fluidPage(
    tags$script(HTML(
     // Javascript code 
    )),
    ...  
)
{% endhighlight %}


Javascript can be inserted into the body of the HTML file or in the head of the file. Some usage tracking code needs to go in the head. To place code in the head of the HTML file use the `tags$head` function in combination with one of the methods above. 

## Step 1: Enable Tracking

The first step to enable tracking is to add tracking code. This code is typically provided after registering the Shiny application and is designed to be copied directly into the head of the HTML file.

### Template

{% highlight r %}
# pseudocode
ui <- fluidPage(
    tags$head(tags$script(HTML(
     // Copy and Paste from 3rd Party Provider
    ))),
    ...  
)
{% endhighlight %}

This code sets up tracking for page views. Every time a browser requests your application, this Javascript code records and sends information on the browser's location, the type of device, screen resolution, and potentially other metrics. Depending on provider, this code can also provide insight into page load times.


### Google Analytics

{% highlight r %}
ui <- fluidPage(
    tags$head(HTML(
      "<script>
      (function(i,s,o,g,r,a,m){
        i['GoogleAnalyticsObject']=r;i[r]=i[r]||
        function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();
          a=s.createElement(o), m=s.getElementsByTagName(o)[0];
          a.async=1;
          a.src=g;m.parentNode.insertBefore(a,m)
        })
      (window, document, 'script',
        '//www.google-analytics.com/analytics.js','ga');
      
        ga('create', 'YOUR_APP_ID', 'auto');
        ga('send', 'pageview');
      
      </script>"
    )),
    ...  
)
{% endhighlight %}

### Matomo 

{% highlight r %}
ui <- fluidPage(
    tags$head(HTML(
      "<script>
      var _paq = _paq || [];
      _paq.push(['trackPageView']);
      _paq.push(['enableLinkTracking']);
      _paq.push(['enableHeartBeatTimer']);
      (function() {
        var u='<YOUR_MATOMO_SERVER_URL/matomo>';
        _paq.push(['setTrackerUrl', u+'matomo.php']);
        _paq.push(['setSiteId', '2']);
        var d=document,
            g=d.createElement('script'),
            s=d.getElementsByTagName('script')[0];
            g.type='text/javascript'; 
            g.async=true; g.defer=true;
            g.src=u+'matomo.js';
            s.parentNode.insertBefore(g,s);
      })();
    </script>"
    )),
    ...  
)
{% endhighlight %}


## Step 2: Event Tracking

In addition to page loads, it can be valuable to track the events that occur on a specific page. An event is an action that a user can take. For example, changing a select input would be an event. Most tracking tools provide a Javascript function for tracking events. Tracking events can provide insight into the actions a user is taking in an application: which inputs are changed, how frequently they change, and the order in which they change.

The following template adds basic tracking for an application's inputs. The template relies on [Shiny's Javascript events](http://shiny.rstudio.com/articles/js-events.html).

### Template

{% highlight r %}
# pseudocode
ui <- fluidPage(
   tags$script(HTML(
   "$(document).on('shiny:inputchanged', function(event) {
     trackingFunction('trackEvent',
       'input', 'updates', event.name, event.value);
  });"
  )),
  ...
)
{% endhighlight %}

This template has a number of parts:

1. `shiny:inputchanged` acts as a trigger. The subsequent function is called anytime the app's inputs change. (To conceptually understand, think of this process as being similar to Shiny's `observeEvent(input, {function})` pattern).  Sometimes `shiny:inputchanged` will be triggered without the inputs changing, see [this article](http://shiny.rstudio.com/articles/js-events.html) for details.

2. `event` When the input changes, the Javascript function will have access to the `event` object. The `event` object includes the name of the input that was changed, `event.name`, and the new value of the input, `event.value`. 

3. `trackingFunction` This is a made up function! This function will be implemented by the 3rd party metrics provider. See the specific examples below for Matomo and Google Analytics. Usually this function looks like: `trackingFunction('trackEvent',Category, Action, Label, Value)`. The function is responsible for recording the event. Category, Action, Label, and Value provide more information about the event that can be helpful when analzying user's history. In this template I set Label equal to `event.name` and Value to `event.value`. I've hardcoded Category to `input` and Action to `updates`. The [Google Analytics help page](https://developers.google.com/analytics/devguides/collection/analyticsjs/events) provides more information.


As an example, imagine a simple Shiny application with a `selectInput` named 'model' that can be either 'A' or 'B' and a `numericInput` named 'value'. If I interact with the application, the `trackingFunction` from our template would send the following information to the metrics server:

{% highlight bash %}
02:00:00  192.154.0.45 'input' 'updates' model 'A'
02:01:00  192.154.0.45 'input' 'updates' model 'B'
02:01:00  192.154.0.45 'input' 'updates' value 30
{% endhighlight %}

This trace corresponds to a user with IP address 192.154.0.45 who toggled the select input between 'A' and 'B' and set the numeric input to 30. Category was hardcoded as 'input' and Action was hardcoded as 'updates'.

A variation of this template would be:

{% highlight r %}
#pseudocode 
ui <- fluidPage(
   # -- Plotting Controls
   numericInput(plot, ...),
   textInput(ignored, ...),
   
   # -- Model Input
   selectInput(model, ...),
   
   # -- Tracking Code
   tags$script(HTML(
     "$(document).on('shiny:inputchanged', function(event) {
       if (event.name === 'model) {
         trackingFunction(['trackEvent', 'Modeling Input',
           'Class of Model', event.name, event.value]);
       }
       if (event.name === 'value') {
         trackingFunction(['trackEvent', 'Plotting Control',
           'Class of Model', event.name, event.value]);
       }
     });"
  )),
  ...
)
{% endhighlight %}

This modified template uses `if` statements to filter by the name of the input. Changes to the `model` and `plot` inputs are tracked, but not changes to `textInput`. `model` inputs and `plot` inputs are labelled separately using the 'Category' attribute. 

The event tracking code can be specialized to accomodate many levels of tracking.

### Google Analytics

{% highlight r %} 
ui <- fluidPage(
   numericInput(bins, ...),
   selectInput(col, ...),
   
   tags$script(HTML(
     "$(document).on('shiny:inputchanged', function(event) {
       if (event.name === 'bins' || event.name ==-= 'col') {
         ga('send','event', 'input', 
            'updates', event.name, event.value);
       }
     });"
  )),
  # ...
)
{% endhighlight %}

### Matomo 

{% highlight r %}
ui <- fluidPage(
   numericInput(bins, ...),
   selectInput(col, ...),
   
   tags$script(HTML(
     "$(document).on('shiny:inputchanged', function(event) {
       if (event.name === 'bins' || event.name === 'col') {
         _paq.push(['trackEvent', 'input', 
           'updates', event.name, event.value]);
       }
     });"
  )),
  # ...
)
{% endhighlight %}

## Step 3: User ID Tracking

It is also valuable to link usage metrics to specific users. To do so, we can send the username to the metrics server. **Sending the username only works for applications that require authentication. For other applications `session$user` is null.** Sending the username is similar to sending an event.

> This feature requires Shiny version 1.0.1 or above.

### Template

{% highlight r %}
#pseudocode 
tags$script(HTML(
    "$(document).one('shiny:idle', function(){
       trackingFunction('setUserId', Shiny.user)
       trackingFunction('trackPageView');
     })"
))
{% endhighlight %}

There are a few components: 

- `$(document).one('shiny:idle'` This portion of JQuery makes sure the function fires once after the application has loaded.
- `Shiny.user` This object contains the username
- `trackingFunction('setUserId', Shiny.user)` Similar to event tracking, this is a made up function. The specific function to use will be implemented by the 3rd party tracking tool.
- `trackingFunction('trackPageView')` After setting the username, any events sent to the metrics server will be associated with the username. However, the initial page load occurs before the `Shiny.user` object is available and before the username is sent to the metrics server. This code tells the metrics server to link the page view to the username.


The relevant GA and Matomo code snippets:

### Google Analytics

{% highlight r %}
ui <- fluidPage(
  tags$script(HTML(
    "$(document).one('shiny:idle', 
      function() {
        ga('set','userId', Shiny.user);
      }
     );"
  )),
  #...
)
{% endhighlight %}



### Matomo 

{% highlight r %}
ui <- fluidPage(
  tags$script(HTML(
    "$(document).one('shiny:idle', 
      function() {
        _paq.push(['setUserId', Shiny.user]);
        _paq.push(['trackPageView']);
      }
     );"
  )),
  #...
)
{% endhighlight %}


## Full Examples

The following examples are working applications for both Matomo and Google Analytics.  For these examples, the Javascript is written to a separate file and included using the `includeScript` function. Note that you will have to setup Matomo or Google Analytics before using these examples.

<details>
<summary>app.r</summary>
<br>

{% highlight r %}
library(shiny)

ui <- fluidPage(
  
  # -- Add Tracking JS File 
  tags$head(includeScript("google-analytics.js")),
  
  # -- Application UI
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins", "Number of bins:",
                  min = 1, max = 50, value = 30),
      selectInput("col", "Barplot Color",
                  c("blue", "grey", "purple", "orange"), selected = "grey")
    ),
    
    mainPanel(
      h1(textOutput("user")),
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output, session) {
  
  output$user <- renderText({
    paste0("Hello ", session$user,
      "! This app is tracked by Matomo")
  })
  
  output$distPlot <- renderPlot({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = input$col, border = 'white')
    
  })
  
}

shinyApp(ui = ui, server = server)
{% endhighlight %}

</details>

<details>
<summary>google-analytics.js</summary>
<br>

{% highlight js %}
// Initial Tracking Code
(function(i,s,o,g,r,a,m){
  i['GoogleAnalyticsObject']=r;
  i[r]=i[r] || 
  function(){
    (i[r].q=i[r].q||[]).push(arguments);
  },i[r].l=1*new Date();
  a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];
  a.async=1;
  a.src=g;
  m.parentNode.insertBefore(a,m);
})(window,document,'script',
  'https://www.google-analytics.com/analytics.js','ga');

ga('create', '<YOUR_APP_ID>', 'auto');
ga('send', 'pageview');

// Event Tracking Code
$(document).on('shiny:inputchanged', function(event) {
  if(event.name == 'bins' || event.name == 'col'){
    ga('send', 'event', 'input',
      'updates', event.name, event.value);
  }
});

// User Tracking Code
$(document).one('shiny:idle', function() {
  ga('set','userId', Shiny.user);
});
{% endhighlight %}

</details>

<details>
<summary>matomo.js</summary>
<br>

{% highlight js %}
// Initial Tracking Code
var _paq = _paq || [];
_paq.push(['enableLinkTracking']);
_paq.push(['enableHeartBeatTimer']);
(function() {
  var u = '<YOUR_MATOMO_URL>';  
  _paq.push(['setTrackerUrl', u+'matomo.php']);
  _paq.push(['setSiteId', '<YOUR_APP_ID>']);
  var d = document,
  g = d.createElement('script'),
  s = d.getElementsByTagName('script')[0];
  g.type = 'text/javascript';
  g.async = true;
  g.defer = true;
  g.src = u+'matomo.js';
  s.parentNode.insertBefore(g,s);
})();

// Event Tracking Code
$(document).on('shiny:inputchanged', function(event) {
  if (event.name === 'bins' || event.name === 'col') {
    _paq.push(['trackEvent', 'input',
      'updates', event.name, event.value]);
  }
});

// User Tracking Code
$(document).one('shiny:idle', function(){
  _paq.push(['setUserId', Shiny.user]);
  _paq.push(['trackPageView']);
});
{% endhighlight %}

</details>
