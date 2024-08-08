--- 
title: Welcome to Shiny
lesson: 1
layout: tutorial
categories: tutorial
---
# Lesson 1: Welcome to Shiny

The Shiny package lets you build interactive web applications (apps) that run R code and display R results. This lesson will show you how to build a static web page with the Shiny package, the first step towards building a full Shiny app. You don't need to know HTML, CSS, or JavaScript. However, I'll assume that you already know how to program in R.

## The web

Shiny apps can do fun things that regular R graphics cannot because every Shiny app is a web page.

A web page is a document written in HTML that is maintained by a computer, known as a _server_. When you visit a web page, the server sends a copy of the HTML document to your computer. Your web browser then renders the document into a web page for you to see. The server can maintain the web page as you look at it by sending updated HTML documents to your browser.

![](images/web-process.png)

To build a web page, you would normally configure a server to host your page and then write an HTML document. Shiny provides a different way to build a web page: you write two R scripts, one named `server.R` and one named `ui.R`. You then call a Shiny function like `runApp` that will read the scripts and use them to set up a server and HTML document for your web page.

The best way to understand this process is to build a simple web page with Shiny.

## Your first Shiny app

Create a new folder somewhere on your computer, and give it a name like `App-1`. Now save two files inside the folder. You don't have to put anything in the files, just save them as `server.R` and `ui.R`. You must use these exact names -- Shiny will look for these files. Your `App-1` folder should look something like this.

![](images/example1-folder.png)

You now have the skeleton of a Shiny app, but your app will not work correctly until you add a few specific functions to your scripts.

## server.R

The `server.R` file must call the `shinyServer` function. `shinyServer` is a function that creates the boilerplate code needed to run a server. It takes one argument, an R function, and outputs everything needed to handle the server-side logic of your web page. The R function must take two arguments of its own, and their names _must_ be "input" and "output". Here's what that looks like in your `server.R` file.

    # server.R
    
    shinyServer(function(input, output) {})

This is the bare minimum code needed in a Shiny `server.R` file. Since your first app will not be interactive, you don't need to write a body for the function in `shinyServer`. You can just pass it an open and closed bracket`{}`, like above. When you're ready, copy and paste the above code into your `server.R` file and save the file. Then turn your attention to `ui.R`.

## ui.R

The `ui.R` file must call the `shinyUI` function. `shinyUI` tells Shiny how to write a web document for your app. `shinyUI` requires one argument to do its job. This argument should be a Shiny function that creates a layout for a web page. One of the simplest functions that does this is `pageWithSidebar`. It tells `shinyUI` to create a web page that has a sidebar, like this one.

![](images/pagewithsidebar.png)

This page also has a header panel, where the title goes, and a main panel, where the graph is displayed. You can create these additional panels with the arguments of `pageWithSidebar`.

![](images/pagewithsidebar2.png)

`pageWithSidebar` takes three arguments. The first tells `pageWithSidebar` what to put in the header panel, the second the sidebar panel, and the third the main panel. Each argument expects some specifically formulated output, which you can create with the functions: `headerPanel`, `sidebarPanel`, and `mainPanel`. 

When you put that all together, your `ui.R` file will look like this. Watch those parentheses!

    # ui.R
    
    shinyUI(pageWithSidebar(
      headerPanel(),
      sidebarPanel(),
      mainPanel()
    ))



There is one final thing to do. `headerPanel` will return an error if you do not give it a character string to display on the web page. This string will appear as the title of your page, so choose it wisely. The other functions are fine without arguments; leaving their arguments empty tells Shiny to leave the sidebar and main panels empty.

Once you've chosen a title for your page, copy and paste something like this into your `ui.R` file. 


    # ui.R
    
    shinyUI(pageWithSidebar(
      headerPanel("My Shiny App"),
      sidebarPanel(),
      mainPanel()
    ))


## Deploy your App

You are now ready to deploy your web page.

First, make sure the `App-1` folder is in your [working directory](http://www.rstudio.com/ide/docs/using/workspaces). If you're using RStudio, you can go to Session > Set Working directory > Choose Directory in the menu bar. Then choose whichever folder `App-1` is in.

Once `App-1` is in your working directory, you can deploy your Shiny app with the command

    library(shiny)
    runApp("App-1")

The argument of `runApp` is the filepath to whichever directory contains your `server.R` and `ui.R` files. So if `App-1` isn't in your working directory, you'll have to type out a more complete filepath. If you named your folder something different, you'll have to use that name in your filepath.

If all went well, your computer opened up its default web browser and is now showing a rather barebones webpage, like this.

![](images/example1.png)

If all didn't go well, you're probably using an older version of Microsoft Internet Explorer. Hit escape or click the stop sign icon in RStudio and then relaunch your app with

    runApp("App-1", port = 8100)

This will tell your computer to host the web page at a specific address, `http://localhost:8100/`. Once you've launched the app, open a different browser program (not Internet Explorer) and visit the web address `http://localhost:8100/`. Your Shiny app should be waiting for you.

## The back end

Your R session will be busy while the Shiny app is up. What is it doing? It's managing the Shiny app. If you hit escape (or click the stop sign icon in RStudio), R will come back and the Shiny app will go gray. You can start a new version of the same app by running `runApp("App-1")` again. R won't stop monitoring the Shiny app just because you close your web browser, you'll have to hit escape.

You now have a Shiny app that is being generated locally. Your computer is building the web page and sending it straight to your browser, no internet involved. This makes it difficult for others to see your Shiny app. In [Lesson 9](../Lesson9/) I'll show you how to publish your Shiny app, but first you'll learn how to make more interesting, interactive apps. 

## Recap

You now know the very basics about creating a Shiny app.

* Each app exists as a folder that contains two files: one named `server.R` and one named `ui.R`.
* `server.R` helps Shiny turn your computer into the web server for your app. It should include a function called `shinyServer`.
* `ui.R` helps Shiny generate an HTML document for your web page. It should contain a file named `shinyUI`.
* You can launch a Shiny app by running `runApp`
* Your R session will stay busy running the app until you hit escape.

You now have a web page. It has no content and no dynamism, but we'll soon fix that. Consider this app your "hello world" exercise. It doesn't do much, and you probably have a ton of questions. We'll start answering them in the next lesson.

See you [Lesson 2](../lesson2/)!
