---
layout: post
title: Display modes
edited: 2014-02-03
author: Garrett Grolemund
description: Shiny can display your apps in two different ways -- normal mode and showcase mode.
---

Shiny can display your apps in two different ways. Your app can appear in normal display mode, as pictured below.

![Normal mode](/images/normal-mode.png)

Or your app can appear in showcase mode. Showcase mode displays your app alongside the code that generates it; showcase mode also displays a title, author and description for your app.

![Showcase mode](/images/showcase-mode.png)

To view an app in showcase mode, launch it with the argument `display.mode = "showcase"`, e.g.

{% highlight console %}
> runApp("MyApp", display.mode = "showcase")
{% endhighlight %}

Apps can be set to open in showcase mode by default. If you would prefer to view such an app in normal mode, use the argument `display.mode = "normal"`. 

{% highlight console %}
> runApp("MyApp", display.mode = "showcase")
{% endhighlight %}

Shiny's built in example apps will automatically open in showcase mode when you call `runExample`, e.g.

{% highlight console %}
> runExample("01_hello")
{% endhighlight %}

## Showcase mode features

When you display your app in showcase mode, Shiny presents the app along with

* the R files in the app's directory, placed in a shared tabset that your user can place next to the app, or below it. These files will always contain server.R and ui.R.
* a title
* an author
* a license
* explanatory text
* code highlighting

### Code highlighting

Shiny showcase will highlight lines of code in server.R as it runs them. The highlight will appear in yellow and fade out after a few moments. This helps reveal how Shiny creates reactivity; when your user manipulates an app, Shiny reruns parts of server.R to create updated output. 

![Code highlighting](/images/code-highlighting.png)

## Showcase layout

Once an app is open, you can change its layout the buttons labelled `show with app` and `show below`. These will place the app's R scripts either next to the app or below it. The app will automatically scale to fit nicely with the code in your browser window.

![Showcase layout](/images/showcase-layout.png)

## Writing for Showcase mode

You can provide information about your app that Shiny showcase will use by creating a DESCRIPTION file. The file should be written in plain text and contain Title, Author, and DisplayMode fields in [Debian Control File (DCF) format](http://www.debian.org/doc/debian-policy/ch-controlfields.html). You can also include other optional fields, such as AuthorUrl, License, and Tags. The description file of Shiny's built in 01_hello example is displayed below

{% highlight r %}
Title: Hello Shiny!
Author: RStudio, Inc.
AuthorUrl: http://www.rstudio.com/
License: GPL-3
DisplayMode: Showcase
Tags: getting-started
Type: Shiny
{% endhighlight %}

Shiny will use the DisplayMode field to determine the default display mode for your app. If you set the field to Showcase, Shiny will open your app in showcase mode. If you set it to Normal, Shiny will open your app in Normal mode. Your users can override this default by using the `display.mode` argument of `runApp`.

Once you've written your DESCRIPTION file, place it alongside the server.R and ui.R files in your app's directory.

![DESCRIPTION](/images/description.png)

You can also create a readme file for your app. Shiny will display the text of the readme beneath the app in showcase mode. Write your readme in markdown and save it in your app directory as Readme.md. Shiny will automatically use any DESCRIPTION and Readme.md files that you place in your app.

![README](/images/readme.png)

Here's an example of the short readme for 01_hello.

{% highlight console %}
This small Shiny application demonstrates Shiny's automatic UI updates. Move the *Number of observations* slider and notice how the `renderPlot` expression is automatically re-evaluated when its dependant, `input$obs`, changes, causing a new distribution to be generated and the plot to be rendered.
{% endhighlight %}

## Showcase and privacy

Some developers would prefer not to expose their code with showcase mode. That's not a problem. Your users will not be able to turn on showcase mode unless you let them. It is impossible to force an app into Showcase mode unless (a) you manually launch the app in showcase mode, or (b) the DESCRIPTION file explicitly states that the app should be shown in showcase mode. 

However, it is possible for users to turn off showcase mode if they do not like it. A user can turn off showcase mode for an app if they add `?showcase=0` to the end of the app's URL. This won't affect how other users see the app.