---
layout: upgrade-note
title: Upgrade notes for Shiny 0.13.0
---

* Fixed #962: plot interactions did not work with the development version of ggplot2 (after ggplot2 1.0.1).

* Fixed #902: the `drag_drop` plugin of the selectize input did not work.

* Fixed #933: `updateSliderInput()` does not work when only the label is updated.

* Multiple imageOutput/plotOutput calls can now share the same brush id. Shiny will ensure that performing a brush operation will clear any other brush with the same id.

* Added `placeholder` option to `textInput`.

* Improved support for Unicode characters on Windows (#968).

* Fixed bug in `selectInput` and `selectizeInput` where values with double quotes were not properly escaped.

* `runApp()` can now take a path to any .R file that yields a `shinyApp` object; previously, the path had to be a directory that contained an app.R file (or server.R if using separately defined server and UI). Similarly, introduced `shinyAppFile()` function which creates a `shinyApp` object for an .R file path, just as `shinyAppDir()` does for a directory path.

* Introduced Shiny Modules, which are designed to 1) simplify the reuse of Shiny UI/server logic and 2) make authoring and maintaining complex Shiny apps much easier. See the article linked from `?callModule`.

* `invalidateLater` and `reactiveTimer` no longer require an explicit `session` argument; the default value uses the current session.

* Added `session$reload()` method, the equivalent of hitting the browser's Reload button.

* Added `shiny.autoreload` option, which will automatically cause browsers to reload whenever Shiny app files change on disk. This is intended to shorten the feedback cycle when tweaking UI code.

* Errors are now printed with stack traces! This should make it tremendously easier to track down the causes of errors in Shiny. Try it by calling `stop("message")` from within an output, reactive, or observer. Shiny itself adds a lot of noise to the call stack, so by default, it attempts to hide all but the relevant levels of the call stack. You can turn off this behavior by setting `options(shiny.fullstacktrace=TRUE)` before or during app startup.

* Fixed #1018: the selected value of a selectize input is guaranteed to be selected in server-side mode.

* Added `req` function, which provides a simple way to prevent a reactive, observer, or output from executing until all required inputs and values are available. (Similar functionality has been available for a while using validate/need, but req provides a much simpler and more direct interface.)

* Improve stability with Shiny Server when many subapps are used, by deferring the loading of subapp iframes until a connection has first been established with the server.

* Upgrade to Font Awesome 4.5.0.

* Upgraded to Bootstrap 3.3.5.

* Upgraded to jQuery 1.12.4

* Switched to an almost-complete build of jQuery UI with the exception of the datepicker extension, which conflicts with Shiny's date picker.

* Added `fillPage` function, an alternative to `fluidPage`, `fixedPage`, etc. that is designed for apps that fill the entire available page width/height.

* Added `fillRow` and `fillCol` functions, for laying out proportional grids in `fillPage`. For modern browsers only.

* Added `runGadget`, `paneViewer`, `dialogViewer`, and `browserViewer` functions to support Shiny Gadgets. More detailed docs about gadgets coming soon.

* Added support for the new htmltools 0.3 feature `htmlTemplate`. It's now possible to use regular HTML markup to design your UI, but still use R expressions to define inputs, outputs, and HTML widgets.
