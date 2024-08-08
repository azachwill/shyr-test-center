---
layout: upgrade-note
title: Upgrade notes for Shiny 1.1.0
---

This is a significant release for Shiny, with a major new feature that was nearly a year in the making: support for asynchronous operations! Until now, R's single-threaded nature meant that performing long-running calculations or tasks from Shiny would bring your app to a halt for other users of that process. This release of Shiny deeply integrates the [promises](https://rstudio.github.io/promises/) package to allow you to execute some tasks asynchronously, including as part of reactive expressions and outputs. See the [promises](https://rstudio.github.io/promises/) documentation to learn more.

## Full changelog

### Breaking changes

* `extractStackTrace` and `formatStackTrace` are deprecated and will be removed in a future version of Shiny. As far as we can tell, nobody has been using these functions, and a refactor has made them vestigial; if you need this functionality, please file an issue.

### New features

* Support for asynchronous operations! Built-in render functions that expected a certain kind of object to be yielded from their `expr`, now generally can handle a promise for that kind of object. Reactive expressions and observers are now promise-aware as well. ([#1932](https://github.com/rstudio/shiny/pull/1932))

* Introduced two changes to the (undocumented but widely used) JavaScript function `Shiny.onInputChange(name, value)`. First, we changed the function name to `Shiny.setInputValue` (but don't worry--the old function name will continue to work). Second, until now, all calls to `Shiny.onInputChange(inputId, value)` have been "deduplicated"; that is, anytime an input is set to the same value it already has, the set is ignored. With Shiny v1.1, you can now add an options object as the third parameter: `Shiny.setInputValue("name", value, {priority: "event"})`. When the priority option is set to `"event"`, Shiny will always send the value and trigger reactivity, whether it is a duplicate or not. This closes [#928](https://github.com/rstudio/shiny/issues/928), which was the most upvoted open issue by far! Thanks, @daattali. ([#2018](https://github.com/rstudio/shiny/pull/2018))

### Minor new features and improvements

* Addressed [#1978](https://github.com/rstudio/shiny/issues/1978): `shiny:value` is now triggered when duplicate output data is received from the server. (Thanks, @andrewsali! [#1999](https://github.com/rstudio/shiny/pull/1999))

* If a shiny output contains a css class of `shiny-report-size`, its container height and width are now reported in `session$clientData`. So, for an output with an id with `"myID"`, the height/width can be accessed via `session$clientData[['output_myID_height']]`/`session$clientData[['output_myID_width']]`. Addresses [#1980](https://github.com/rstudio/shiny/issues/1980). (Thanks, @cpsievert! [#1981](https://github.com/rstudio/shiny/pull/1981))

* Added a new `autoclose = TRUE` parameter to `dateInput()` and `dateRangeInput()`. This closed [#1969](https://github.com/rstudio/shiny/issues/1969) which was a duplicate of much older issue, [#173](https://github.com/rstudio/shiny/issues/173). The default value is `TRUE` since that seems to be the common use case. However, this will cause existing apps with date inputs (that update to this version of Shiny) to have the datepicker be immediately closed once a date is selected. For most apps, this is actually desired behavior; if you wish to keep the datepicker open until the user clicks out of it use `autoclose = FALSE`. ([#1987](https://github.com/rstudio/shiny/pull/1987))

* The version of Shiny is now accessible from Javascript, with `Shiny.version`. There is also a new function for comparing version strings, `Shiny.compareVersion()`. ([#1826](https://github.com/rstudio/shiny/pull/1826), [#1830](https://github.com/rstudio/shiny/pull/1830))

* Addressed [#1851](https://github.com/rstudio/shiny/issues/1851): Stack traces are now smaller in some places `do.call()` is used. ([#1856](https://github.com/rstudio/shiny/pull/1856))

* Stack traces have been improved, with more aggressive de-noising and support for deep stack traces (stitching together multiple stack traces that are conceptually part of the same async operation).

* Addressed [#1859](https://github.com/rstudio/shiny/issues/1859): Server-side selectize is now significantly faster. (Thanks to @dselivanov [#1861](https://github.com/rstudio/shiny/pull/1861))

* [#1989](https://github.com/rstudio/shiny/issues/1989): The server side of outputs can now be removed (e.g. `output$plot <- NULL`). This is not usually necessary but it does allow some objects to be garbage collected, which might matter if you are dynamically creating and destroying many outputs. (Thanks, @mmuurr! [#2011](https://github.com/rstudio/shiny/pull/2011))

* Removed the (ridiculously outdated) "experimental feature" tag from the reference documentation for `renderUI`. ([#2036](https://github.com/rstudio/shiny/pull/2036))

* Addressed [#1907](https://github.com/rstudio/shiny/issues/1907): the `ignoreInit` argument was first added only to `observeEvent`. Later, we also added it to `eventReactive`, but forgot to update the documentation. Now done, thanks [@flo12392](https://github.com/flo12392)! ([#2036](https://github.com/rstudio/shiny/pull/2036))

### Bug fixes

* Fixed [#1006](https://github.com/rstudio/shiny/issues/1006): Slider inputs sometimes showed too many digits. ([#1956](https://github.com/rstudio/shiny/pull/1956))

* Fixed [#1958](https://github.com/rstudio/shiny/issues/1958): Slider inputs previously displayed commas after a decimal point. ([#1960](https://github.com/rstudio/shiny/pull/1960))

* The internal `URLdecode()` function previously was a copy of `httpuv::decodeURIComponent()`, assigned at build time; now it invokes the httpuv function at run time.

* Fixed [#1840](https://github.com/rstudio/shiny/issues/1840): with the release of Shiny 1.0.5, we accidently changed the relative positioning of the icon and the title text in `navbarMenu`s and `tabPanel`s. This fix reverts this behavior back (i.e. the icon should be to the left of the text and/or the downward arrow in case of `navbarMenu`s). ([#1848](https://github.com/rstudio/shiny/pull/1848))

* Fixed [#1600](https://github.com/rstudio/shiny/issues/1600): URL-encoded bookmarking did not work with sliders that had dates or date-times. ([#1961](https://github.com/rstudio/shiny/pull/1961))

* Fixed [#1962](https://github.com/rstudio/shiny/issues/1962): [File dragging and dropping](https://blog.rstudio.com/2017/08/15/shiny-1-0-4/) broke in the presence of jQuery version 3.0 as introduced by the [rhandsontable](https://jrowen.github.io/rhandsontable/) [htmlwidget](https://www.htmlwidgets.org/). ([#2005](https://github.com/rstudio/shiny/pull/2005))

* Improved the error handling inside the `addResourcePath()` function, to give end users more informative error messages when the `directoryPath` argument cannot be normalized. This is especially useful for `runtime: shiny_prerendered` Rmd documents, like `learnr` tutorials. ([#1968](https://github.com/rstudio/shiny/pull/1968))

* Changed script tags in reactlog ([inst/www/reactive-graph.html](https://github.com/rstudio/shiny/blob/master/inst/www/reactive-graph.html)) from HTTP to HTTPS in order to avoid mixed content blocking by most browsers. (Thanks, @jekriske-lilly! [#1844](https://github.com/rstudio/shiny/pull/1844))

* Addressed [#1784](https://github.com/rstudio/shiny/issues/1784): `runApp()` will avoid port 6697, which is considered unsafe by Chrome.

* Fixed [#2000](https://github.com/rstudio/shiny/issues/2000): Implicit calls to `xxxOutput` not working inside modules. (Thanks, @GregorDeCillia! [#2010](https://github.com/rstudio/shiny/pull/2010))

* Fixed [#2021](https://github.com/rstudio/shiny/issues/2021): Memory leak with `reactiveTimer` and `invalidateLater`. ([#2022](https://github.com/rstudio/shiny/pull/2022))

### Library updates

* Updated to ion.rangeSlider 2.2.0. ([#1955](https://github.com/rstudio/shiny/pull/1955))


## Known issues

In some rare cases, interrupting an application (by pressing Ctrl-C or Esc) may result in the message `Error in execCallbacks(timeoutSecs) : c++ exception (unknown reason)`. Although this message sounds alarming, it is harmless, and will go away in a future version of the later package (more information [here](https://github.com/r-lib/later/issues/55)).
