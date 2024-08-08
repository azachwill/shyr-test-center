---
layout: post
title: Dashboards
edited: 2019-10-15
author: Mine Cetinkaya-Rundel
description: You have two package options for building Shiny dashboards -- flexdashboard and shinydashboard.
---

You have two package options for building Shiny dashboards: `flexdashboard` and `shinydashboard`.

## flexdashboard

Easy interactive dashboards for R that

- use R Markdown to publish a group of related data visualizations as a dashboard,
- support a wide variety of components including htmlwidgets; base, lattice, and grid graphics; tabular data; gauges and value boxes; and text annotations,
- are flexible and easy to specify row and column-based layouts with intelligent re-sizing to fill the browser and adapted for display on mobile devices,
- offer storyboard layouts for presenting sequences of visualizations and related commentary, and
- optionally use Shiny to drive visualizations dynamically.

See documentation and demos on the [flexdashboard homepage](http://rmarkdown.rstudio.com/flexdashboard/).

## shinydashboard

See documentation and demos on the [shinydashboard homepage](http://rstudio.github.io/shinydashboard/). Here, in addition to instructions for getting started, you can also browse [example dashboards](http://rstudio.github.io/shinydashboard/examples.html) built with `shinydashboard`, along with their source code.

## Comparison of two options

| flexdashboard      | shinydashboard        |
|--------------------|-----------------------|
| R Markdown         | Shiny UI code         |
| Super easy         | Not quite as easy     |
| Static or dynamic  | Dynamic               |
| CSS flexbox layout | Bootstrap grid layout |

## Learn more

For more on this topic, see the following resources:

[<i class="fas fa-play-circle fa-lg" aria-hidden="true"></i> Dynamic dashboards with Shiny](https://resources.rstudio.com/vimeo-webinars/dynamic-dashboards-with-shiny)

[<i class="fas fa-play-circle fa-lg" aria-hidden="true"></i> Building dashboards with Shiny tutorial](https://resources.rstudio.com/rstudio-conf-2017/building-dashboards-with-shiny-tutorial-joe-cheng-amp-winston-chang)

[<i class="fas fa-play-circle fa-lg" aria-hidden="true"></i> Dashboards made easy](https://resources.rstudio.com/rstudio-conf-2017/dashboards-made-easy-sean-lopp)
