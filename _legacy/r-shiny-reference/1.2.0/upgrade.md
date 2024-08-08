---
layout: upgrade-note
title: Upgrade notes for Shiny 1.2.0
---

This release features plot caching, an important new tool for improving performance and scalability. Using `renderCachedPlot` in place of `renderPlot` can greatly improve responsiveness for apps that show the same plot many times (for example, a dashboard or report where all users view the same data). Shiny gives you a fair amount of control in where the cache is stored and how cached plots are invalidated, so be sure to read [this article](https://shiny.posit.co/articles/plot-caching.html) to get the most out of this feature.

## Full changelog

### Breaking changes

* The URL paths for FontAwesome CSS/JS/font assets have changed, due to our upgrade from FontAwesome 4 to 5. This shouldn't affect you unless you're using `www/index.html` to provide your UI and have hardcoded the old FontAwesome paths into your HTML. If that's you, consider switching to [HTML templates](https://shiny.posit.co/articles/templates.html), which give you the syntax of raw HTML while still taking advantage of Shiny's automatic management of web dependencies.

### New features

* Added `renderCachedPlot()`, which stores plots in a cache so that they can be served up almost instantly. ([#1997](https://github.com/rstudio/shiny/pull/1997))

### Minor new features and improvements

* Upgrade FontAwesome from 4.7.0 to 5.3.1 and made `icon` tags browsable, which means they will display in a web browser or RStudio viewer by default ([#2186](https://github.com/rstudio/shiny/issues/2186)). Note that if your application or library depends on FontAwesome directly using custom CSS, you may need to make some or all of the changes recommended in [Upgrade from Version 4](https://fontawesome.com/how-to-use/on-the-web/setup/upgrading-from-version-4). Font Awesome icons can also now be used in static R Markdown documents.

* Address [#174](https://github.com/rstudio/shiny/issues/174): Added `datesdisabled` and `daysofweekdisabled` as new parameters to `dateInput()`. This resolves [#174](https://github.com/rstudio/shiny/issues/174) and exposes the underlying arguments of [Bootstrap Datepicker](http://bootstrap-datepicker.readthedocs.io/en/latest/options.html#datesdisabled). `datesdisabled` expects a character vector with values in `yyyy/mm/dd` format and `daysofweekdisabled` expects an integer vector with day interger ids (Sunday=0, Saturday=6). The default value for both is `NULL`, which leaves all days selectable. Thanks, @nathancday! ([#2147](https://github.com/rstudio/shiny/pull/2147))

* Support for selecting variables of a data frame with the output values to be used within tidy evaluation.  Added functions: `varSelectInput`, `varSelectizeInput`, `updateVarSelectInput`, `updateVarSelectizeInput`. ([#2091](https://github.com/rstudio/shiny/pull/2091))

* Addressed [#2042](https://github.com/rstudio/shiny/issues/2042): dates outside of `min`/`max` date range are now a lighter shade of grey to highlight the allowed range. ([#2087](https://github.com/rstudio/shiny/pull/2087))

* Added support for plot interaction when the plot is scaled. ([#2125](https://github.com/rstudio/shiny/pull/2125))

* Fixed [#1933](https://github.com/rstudio/shiny/issues/1933): extended server-side selectize to lists and optgroups. ([#2102](https://github.com/rstudio/shiny/pull/2102))

* Added namespace support when freezing reactiveValue keys. [#2080](https://github.com/rstudio/shiny/pull/2080)

* Upgrade selectize.js from 0.12.1 to 0.12.4 [#2028](https://github.com/rstudio/shiny/issues/2028)

* Addressed [#2079](https://github.com/rstudio/shiny/issues/2079): Added `coords_img`, `coords_css`, and `img_css_ratio` fields containing x and y location information for plot brush, hover, and click events. [#2183](https://github.com/rstudio/shiny/pull/2183)

### Bug fixes

* Fixed [#2033](https://github.com/rstudio/shiny/issues/2033): RStudio Viewer window not closed on `shiny::stopApp()`. Thanks, @vnijs! [#2047](https://github.com/rstudio/shiny/pull/2047)

* Fixed [#1935](https://github.com/rstudio/shiny/issues/1935): correctly returns plot coordinates when using outer margins. ([#2108](https://github.com/rstudio/shiny/pull/2108))

* Resolved [#2019](https://github.com/rstudio/shiny/issues/2019): `updateSliderInput` now changes the slider formatting if the input type changes. ([#2099](https://github.com/rstudio/shiny/pull/2099))

* Fixed [#2138](https://github.com/rstudio/shiny/issues/2138): Inputs that are part of a `renderUI` were no longer restoring correctly from bookmarked state. [#2139](https://github.com/rstudio/shiny/pull/2139)

* Fixed [#2093](https://github.com/rstudio/shiny/issues/2093): Make sure bookmark scope directory does not exist before trying to create it. [#2168](https://github.com/rstudio/shiny/pull/2168)

* Fixed [#2177](https://github.com/rstudio/shiny/issues/2177): The session name is now being recorded when exiting a context.  Multiple sessions can now view their respective reactlogs. [#2180](https://github.com/rstudio/shiny/pull/2180)

* Fixed [#2162](https://github.com/rstudio/shiny/issues/2162): `selectInput` was sending spurious duplicate values to the server when using backspace. Thanks, @sada1993! [#2187](https://github.com/rstudio/shiny/pull/2187)

* Fixed [#2142](https://github.com/rstudio/shiny/issues/2142): Dropping files on `fileInput`s stopped working on recent releases of Firefox. Thanks @dmenne for reporting! [#2203](https://github.com/rstudio/shiny/pull/2203)

* Fixed [#2204](https://github.com/rstudio/shiny/issues/2204): `updateDateInput` could set the wrong date on days where DST begins. (Thanks @GaGaMan1101!) [#2212](https://github.com/rstudio/shiny/pull/2212)

* Fixed [#2225](https://github.com/rstudio/shiny/issues/2225): Input event queue can stall in apps that use async. [#2226](https://github.com/rstudio/shiny/pull/2226)

* Fixed [#2228](https://github.com/rstudio/shiny/issues/2228): `reactiveTimer` fails when not owned by a session. Thanks, @P-Bettega! [#2229](https://github.com/rstudio/shiny/pull/2229)

### Documentation Updates

* Addressed [#1864](https://github.com/rstudio/shiny/issues/1864) by changing `optgroup` documentation to use `list` instead of `c`. ([#2084](https://github.com/rstudio/shiny/pull/2084))

