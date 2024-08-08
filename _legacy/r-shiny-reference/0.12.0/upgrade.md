---
layout: upgrade-note
title: Upgrade notes for Shiny 0.12
---

In addition to the changes listed in the [NEWS](https://github.com/rstudio/shiny/blob/v0.12.0/NEWS) file for Shiny 0.12.0, there is an infrastructure change that could affect existing Shiny apps. 

### JSON serialization

In Shiny 0.12.0, we've switched from RJSONIO to jsonlite. For the vast majority of users, this will result in no noticeable changes; however, if you use any packages in your Shiny apps which rely on the [htmlwidgets](http://www.htmlwidgets.org/), you will also need to update htmlwidgets to 0.4.0. Both of these packages will issue a message when loaded, if the other package needs to be upgraded.

POSIXt objects are now serialized to JSON in UTC8601 format (like
"2015-03-20T20:00:00Z"), instead of as seconds from the epoch. If you have a Shiny app which uses `sendCustomMessage()` to send datetime (POSIXt) objects, then you may need to modify your Javascript code to receive time data in this format.

### A note about Data Tables

Shiny 0.12.0 deprecated Shiny's dataTableOutput and renderDataTable functions and instructed you to migrate to the nascent [DT](https://rstudio.github.io/DT/) package instead. (We'll talk more about DT in a future blog post.) User feedback has indicated this transition was too sudden and abrupt, so we've undeprecated these functions in 0.12.1. We'll continue to support these functions until DT has had more time to mature.
