--- 
layout: post
title: How to understand reactivity in R
edited: 2015-05-21
author: Garrett Grolemund
description: Reactivity is what makes your Shiny apps responsive. It lets the app instantly update itself whenever the user makes a change. You don't need to know how reactivity occurs to use it, but understanding reactivity will make you a better Shiny programmer.
---

Reactivity is what makes your Shiny apps responsive. It lets the app instantly update itself whenever the user makes a change. You don't need to know how reactivity occurs to use it (just follow the steps laid out in [Lesson 4](../lesson4/)), but understanding reactivity will make you a better Shiny programmer. You'll be able to

1. create more efficient and sophisticated Shiny apps, and
2. avoid the errors that come from misusing reactive values in R (which is easy to do!).

Let's take a look at reactivity by building a very simple Shiny app:

{% highlight r %}
# app.R
    
library(shiny)

ui <- fluidPage(
  headerPanel("basic app"),
  
  sidebarPanel(
    
    sliderInput("a", 
      label = "Select an input to display",
      min = 0, max = 100, value = 50)
  ),
      
  mainPanel(h1(textOutput("text")))
)

server <- function(input, output) {
    output$text <- renderText({
      print(input$a)
    })
}

shinyApp(ui = ui, server = server)
{% endhighlight %}

<iframe src="https://gallery.shinyapps.io/understanding-reactivity/" frameborder="no" class="scale65" height="250px" style="margin-bottom: -70px;"></iframe>

The app sets up a very basic reactive system: it has a single input value that can change (`input$a`); it has a single output value that can respond (`print(input$a)`); and it has a server that can oversee the process. Every Shiny app will have these same components, although most apps will have multiple input values and multiple output expressions.

![](/images/basic2.png)

When you move the slider, you can see reactivity in action: the number to the left of the slider automatically updates to show the current slider value. This may seem simple, but it is very special. Let's look at why.

## Reactivity is unexpected

Reactivity creates the illusion that changes in input values automatically flow to the plots, text, and tables that use the input---and cause them to update. You can think of this flow as a current of electricity, or a stream of water that _pushes_ information from input to output. You saw this illusion in action when you moved the slider bar. Changes in the slider bar seemed to automatically propagate to the number beside the bar.

![](/images/push.png)

This illusion is amazing, because information in R only travels through _pull_ mechanisms, not _push_ mechanisms. In other words, if you have a simple R expression like `{a + 1}`, R will retrieve information from `a` to evaluate the expression, but R won't modify the result of `{a + 1}` if you later change the value of `a`. 

{% highlight r %}
a <- 1
a + 1
## 2

a <- 2
## (nothing happens)
{% endhighlight %}

Pictorially, the system looks like this. Notice that the arrow in the diagram goes from right to left. This is to imply that the expression on the right is doing the work. It is telling R to look up the value of `a`. `a` is just sitting passively in memory.

![](/images/a.png)

For our app, this suggests that R should look up the value of `input$a` once, print the value, and then not notice when `input$a` changes.

![](/images/pull.png)

Incredibly, this isn't what happens, as you saw above. Reactivity appears to reverse the flow of information in R. How does it do that? 

## What is reactivity?

Think of reactivity as a magic trick: reactivity creates the illusion that one thing is happening, when in fact something else is going on. The illusion is that information is being pushed from inputs to outputs (or at least that inputs and outputs are linked in an inseperable way). The reality is that Shiny is re-running your R expressions in a carefully scheduled way.

I've prepared four maxims to help you understand this process. We'll look at each of them (and the process itself), with a simple thought experiment: how could we recreate our basic app without breaking the rules of R?

Here are our maxims

1. _R expressions update themselves, if you ask_
2. _Nothing needs to happen instantly_
3. _The app must do as little as possible_
4. _Think carrier pigeons, not electricity_


### 1. R expressions update themselves, _if you ask_

Reactivity ensures that the output of `print(input$a)` is always up to date, but what does it mean for output to be _out of date_? Let's consider output -- and the expression that made it -- to be out of date if one of the objects in the expression has been given a new value since the expression was called. For example, at the end of this code, the expression `print(a)` is out of date. The last time `print(a)` ran, `a` was 1.

{% highlight r %}
a <- 1
print(a)
## 1

a <- 2
{% endhighlight %}

Updating an out of date expression is not hard: you just need to re-run the expression. Everything in R updates itself each time it is run. This isn't reactivity; it's just standard R behavior.

{% highlight r %}
a <- 1
print(a)
## 1

a <- 2
print(a)
## 2
{% endhighlight %}


Think of it like this: every time you run an expression, the expression updates itself. It looks up the current value of each object that it uses and computes new ouput. However, you must tell R to run the expresssion for this to happen because R uses a style of execution known as _lazy evaluation_. In other words, R will not execute an expression until you force it to.

You could use this behavior -- and nothing else -- to create a reactive web app. All you need to do is manually re-run the expressions in the app whenever the user makes a change. 

### 2. Nothing needs to happen instantly

How quickly do you need to re-run an expression after a user makes a change? If the update appears instantaneous, the user will feel like they caused it. In other words, the update will create the illusion of reactivity. However, humans aren't very good at noticing small windows of time. You could actually let a few microseconds pass between change and update and your user wouldn't notice. This suggests a new feature for our plan.

Instead of watching the user (which would require logistics we haven't thought through), you could just have your server re-run each expression in the app every few microseconds. That way whenever the user makes a change, an update will follow within a few microseconds. If you re-run _every_ expression in the app, you don't even need to worry about which part of the app the user is changing.

What if the user doesn't make a change? Then the expressions will re-compute their previous results and the app will appear to be in the same state it was before. 

This plan creates the illusion of reactivity without violating the rules of R. Information still travels from input to output in a pull fashion. For example, `print(input$a)` only learns the new value of `input$a` because the server re-executes `print(input$a)`. Since `print(input$a)` is re-executed so often, it seems to learn of the change very fast, as if it were connected to `input$a` or as if `input$a` pushed its new value to `print(input$a)`.

Shiny uses this approach to create reactivity. That is why your R session becomes busy when you launch a Shiny app. Your server is using the R session to monitor the app and re-run expressions. However, Shiny takes this approach one step further. It creates an alert system that lets Shiny know exactly which expressions need to be re-run.

### 3. The app must do as little as possible

It takes a very powerful computer to re-run every expression in an app every few microseconds without bogging down. If you used our approach in reality, your app would quickly become slow and unresponsive, which would destroy the illusion of reactivity.

If you want your updates to run so fast that they appear instantaneous, you'll need to save your computer power for just the expressions that are out of date. However, your app may use hundreds of expressions. How will you know which ones are out of date? 

Shiny solves this problem by creating a system of alerts that lets the server know when an expression becomes out of date. The server still checks in on your app every few microseconds, but instead of re-running each expression each time, it only runs the expressions that the alert system has flagged as out of date. If no alerts have appeared, the server does not have to run anything at all. It can rest until the next check. If alerts have appeared, the server runs all of the expressions that are out of date at that moment, an event known as a _flush_.

This alert system is the key to reactivity. It allows your server to update your app as fast as possible, so fast that changes seem to travel instantly from inputs to outputs. Let's not try to brainstorm our own alert system. Instead let's examine the system that Shiny uses.

### 4. Think carrier pigeons, not electricity

The details of the alert system are fairly complicated. If they sound confusing in this next paragraph, don't worry. We're going to break them down step by step with an analogy that will make them more transparent.

Shiny implements reactivity with two special object classes, `reactivevalues` and `observers`. In our example `input$a` is a reactive values object and `print(input$a)` is an observer. These two classes behave like regular R values and R expressions with a few exceptions. Whenever an observer uses a reactive value, it registers a _reactive context_ with the value. This context contains an expression to be run if the value ever changes. The expression is called a _callback_ and it is always a command to re-run the observer. A single reactive value can hold many contexts if multiple observers use that value.

![](/images/context.png)

When the value of a reactive values object changes, the object will send any callbacks that it has collected to the server. Lets look at how this happens. 

A reactive values object is a type of list. In R, you change the value of a list by calling a settor function, either `$<-` or `[[<-`. These are the functions that R calls in the background whenever you combine the assignment arrow, `<-`, with the subsetting symbols `$` or `[[ ]]`. For example, R will call `$<-` when you run the second line of code below.

{% highlight r %}
myList <- list(a = 1, b = 2)
myList$b <- 3
{% endhighlight %}

Since reactive values objects are a special class of object, they have their own settor methods. The settor methods of reactive values objects (`$<-` and `[[<-`) include instructions to send any callbacks that the reactive value has received to the server. If the reactive values object is set to a new value, it executes these instructions and the server receives the callbacks. 

![](/images/context2.png)

The server saves the callbacks in a queue which acts as a list of observers that have become out of date. On the next flush, the server runs each callback in the queue which re-runs each out of date observer, which restarts the cycle.

![](/images/context3.png) 

If this seems complicated, think of reactivity as a carrier pigeon system between three objects. If you don't know what carrier pigeons are, check out this [link](http://en.wikipedia.org/wiki/Pigeon_post) -- it's pretty fascinating. Basically, you can take a carrier pigeon anywhere and when you release it, it will always fly back to the same location. Soldiers on the move used carrier pigeons to deliver messages to their headquarters. We're going to use them to deliver messages to the server.

A context is like a virtual carrier pigeon that an observer leaves with a reactive value. The context contains a message (its callback) that it will deliver to the server when released. The observer writes this message for the context, and it is a simple instruction to re-run the observer. An observer leaves behind a context each time it looks up a reactive values object. In fact, a reactive values object will return an error if an expression tries to access its value without leaving behind a context.

![](/images/pigeon1.png)

When a reactive values object receives a context, it simply holds onto it. It will collect multiple contexts if other observers look up the object as well. If the reactive value object ever changes, it will release all of the contexts it has collected (a process known as _invalidating the contexts_). This behavior is like releasing carrier pigeons, the pigeons are free to fly back to the server and deliver the callbacks that they have been holding onto. When a context is invalidated, it places its callback in the server's queue to be run on the next flush. Then the context ceases to be relevant, just like a pigeon that has delivered its message.

![](/images/pigeon2.png)

The callback of a context is an R command that when run, will re-execute the observer that created the context. This will cause the observer to update itself with the new value of the reactive values object. When the server checks in on the app, all it needs to do is run any callbacks that have arrived. This will automatically update the app.

Running the callbacks also sets up a new reactive cycle. When an observer is re-run, it looks up the reactive value objects that it uses, which causes it to register new contexts with each value. In short, the observer leaves a new homing pigeon behind and the cycle is ready to repeat itself. 

![](/images/pigeon4.png)

This system enables reactivity because it lets your server work fast enough to create the illusion of instant responses. Instead of re-running every expression in your app every few seconds, the server only needs to check its queue for new callbacks. The result is the quick, responsive updates you see in your Shiny app.

Now you know how reactivity works in Shiny. Notice that this system doesn't ask R to behave in a new way. Your observers are still looking up information from the reactive values. The values are not being pushed to the observer like a flow of electricity, or a stream---they only appear to be doing that. The key to this system is speed. Shiny enacts the pull mechanisms of R so fast that they look like push mechanisms.