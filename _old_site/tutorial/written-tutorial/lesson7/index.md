---
title: Share your apps
lesson: 7
layout: tutorial
categories: tutorial
author: Garrett Grolemund and Mine Cetinkaya-Rundel
---

You can now build a useful Shiny app, but can you share it with others? This lesson will show you several ways to share your Shiny apps.

When it comes to sharing Shiny apps, you have two basic options:

1. **Share your Shiny app as R scripts.** This is the simplest way to share an app, but it works only if your users have R on their own computer (and know how to use it). Users can use these scripts to launch the app from their own R session, just like you've been launching the apps so far in this tutorial.

2. **Share your Shiny app as a web page.** This is definitely the most user friendly way to share a Shiny app. Your users can navigate to your app through the internet with a web browser. They will find your app fully rendered, up to date, and ready to go.

## Share as R scripts

Anyone with R can run your Shiny app. They will need a copy of your `app.R` file, as well as any supplementary materials used in your app (e.g., `www` folders or `helpers.R` files).

To send your files to another user, email the files (perhaps in a zip file) or host the files online.

Your user can place the files into an app directory in their working directory. They can launch the app in R with the same commands you used on your computer.

{% highlight r %}
# install.packages("shiny")
library(shiny)
runApp("census-app")
{% endhighlight %}

![Zipped folder](images/zip.png){: .example-screenshot}

Shiny has three built in commands that make it easy to use files that are hosted online: `runUrl`, `runGitHub`, and `runGist`.

### runUrl

`runUrl` will download and launch a Shiny app straight from a weblink.

To use `runURL`:

* Save your Shiny app's directory as a zip file
* Host that zip file at its own link on a web page. Anyone with access to the link can launch the app from inside R by running:

{% highlight r %}
library(shiny)
runUrl( "<the weblink>")
{% endhighlight %}

### runGitHub

If you don't have your own web page to host the files at, you can host your the files for free at [www.github.com](http://www.github.com).

GitHub is a popular project hosting site for R developers since it does more than just host files. GitHub provides many features to support collaboration, such as issue trackers, wikis, and close integration with the [git](http://git-scm.com/) version control system. To use GitHub, you'll need to sign up (it's free) and choose a user name.

To share an app through GitHub, create a project repository on GitHub. Then store your `app.R` file in the repository, along with any supplementary files that the app uses.

Your users can launch your app by running:

{% highlight r %}
runGitHub( "<your repository name>", "<your user name>")
{% endhighlight %}


### runGist

If you want an anonymous way to post files online, GitHub offers a pasteboard service for sharing files at [gist.github.com](http://gist.github.com). You don’t need to sign up for a GitHub account to use this service. Even if you have a GitHub account, gist can be a simple, quick way to share Shiny projects.

To share your app as a gist:

* Copy and paste your `app.R` files to the gist web page.
* Note the URL that GitHub gives the gist.

Once you've made a gist, your users can launch the app with `runGist("<gist number>")` where `"<gist number>"` is the number that appears at the end of your Gist's web address.

[Here](https://gist.github.com/mine-cetinkaya-rundel/eb3470beb1c0252bd0289cbc89bcf36f) is an example of an app hosted as a gist. You could launch this app with:

{% highlight r %}
runGist("eb3470beb1c0252bd0289cbc89bcf36f")
{% endhighlight %}

## Share as a web page

All of the above methods share the same limitation. They require your user to have R and Shiny installed on their computer.

However, Shiny creates the perfect opportunity to share output with people who do _not_ have R (and have no intention of getting it). Your Shiny app happens to be one of the most widely used communication tools in the world: a web page. If you host the app at its own URL, users can visit the app (and not need to worry about the code that generates it).

If you are familiar with web hosting or have access to an IT department, you can host your Shiny apps yourself.

If you'd prefer an easier experience or need support, RStudio offers three ways to host your Shiny app as a web page:

1. shinyapps.io
2. Shiny Server
3. RStudio Connect

### Shinyapps.io

The easiest way to turn your Shiny app into a web page is to use [shinyapps.io](http://www.shinyapps.io/), RStudio’s hosting service for Shiny apps.

shinyapps.io lets you upload your app straight from your R session to a server hosted by RStudio. You have complete control over your app including server administration tools. You can find out more about shinyapps.io by visiting [shinyapps.io](http://www.shinyapps.io/).

### Shiny Server

Shiny Server is a companion program to Shiny that builds a web server designed to host Shiny apps. It's free, open source, and available from GitHub.

Shiny Server is a server program that Linux servers can run to host a Shiny app as a web page. To use Shiny Server, you'll need a Linux server that has explicit support for Ubuntu 12.04 or greater (64 bit) and CentOS/RHEL 5 (64 bit). If you are not using an explicitly supported distribution, you can still use Shiny Server by building it from source.

You can host multiple Shiny applications on multiple web pages with the same Shiny Server, and you can deploy the apps from behind a firewall.

To see detailed instructions for installing and configuring a Shiny Server, visit the Shiny Server [guide](https://github.com/rstudio/shiny-server/blob/master/README.md).


### RStudio Connect

If you use Shiny in a for-profit setting, you may want to give yourself the server tools that come with most paid server programs, such as

* Password authentication
* SSL support
* Administrator tools
* Priority support

If so, check out [RStudio Connect](https://www.rstudio.com/products/connect/), a publishing platform for the work your teams create in R. Share Shiny applications, R Markdown reports, dashboards, plots, Jupyter Notebooks, and more in one convenient place. With RStudio Connect, you can publish from the RStudio IDE with the push of a button and schedule execution of reports and flexible security policies.

If you'd like to learn more about RStudio Connect and the features it offers, see [here](https://www.rstudio.com/products/connect/).

## Recap

Shiny apps are easy to share. You can share your app as a couple of R scripts, or as a fully functioning web app with its own URL. Each method has its own advantages.

You learned:

* Anyone can launch your app as long as they have a copy of R, Shiny, and a copy of your app's files.
* `runUrl`, `runGitHub`, and `runGist` make it simple to share and retrieve Shiny files from web links.
* You can turn your app into a live web app at its own URL with [shinyapps.io](http://shinyapps.io/).
* You can use the open source Shiny Server to build a Linux server that hosts Shiny apps.
* If you need closer control, or want to manage large volumes of traffic, you can purchase [RStudio Connect](https://www.rstudio.com/products/connect/) from RStudio.

Congratulations. You’ve worked through the entire Shiny development process. You can build a sophisticated, reactive app, deploy it, and share it with others. Users can interact with your data and follow your stories in a new way.

The next step is to practice, and then explore the advanced features of Shiny.

The [Shiny Dev Center](http://shiny.rstudio.com) can help you along the way. It hosts a [gallery](/gallery/) of inspiring apps, along with the code that makes the apps.

The Shiny Dev Center also includes an [articles](/articles/) section for continuing education. Each article examines an intermediate to advanced Shiny topic in depth.

You now know enough to build your own Shiny apps. See what you can do!
