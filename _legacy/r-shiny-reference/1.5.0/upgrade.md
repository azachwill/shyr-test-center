---
layout: upgrade-note
title: Upgrade notes for Shiny 1.5.0
---

## Full changelog

### Breaking changes

* Fixed #2869: Until this release, `renderImage()` had a dangerous default of `deleteFile = TRUE`. (Sorry!) Going forward, calls to `renderImage()` will need an explicit `deleteFile` argument; for now, failing to provide one will result in a warning message, and the file will be deleted if it appears to be within the `tempdir()`. (#2881)

### New features

* The new `shinyAppTemplate()` function creates a new template Shiny application, where components are optional, such as helper files in an R/ subdirectory, a module, and various kinds of tests. (#2704)

* `runTests()` is a new function that behaves much like R CMD check. `runTests()` invokes all of the top-level R files in the tests/ directory inside an application, in that application's environment. (#2585)

* `testServer()` is a new function for testing reactive behavior inside server functions and modules. ([#2682](https://github.com/rstudio/shiny/pull/2682), [#2764](https://github.com/rstudio/shiny/pull/2764), [#2807](https://github.com/rstudio/shiny/pull/2807))

* The new `moduleServer` function provides a simpler interface for creating and using modules. (#2773)

* Resolved #2732: `markdown()` is a new function for writing Markdown with Github extensions directly in Shiny UIs. Markdown rendering is performed by the [commonmark](https://github.com/jeroen/commonmark) package. (#2737)

* The `getCurrentOutputInfo()` function can now return the background color (`bg`), foreground color (`fg`), `accent` (i.e., hyperlink) color, and `font` information of the output's HTML container. This information is reported by `plotOutput()`, `imageOutput()`, and any other output bindings containing a class of `.shiny-report-theme`. This feature allows developers to style an output's contents based on the container's CSS styling.  (#2740)

### Minor new features and improvements

* Fixed #2042, #2628: In a `dateInput` and `dateRangeInput`, disabled months and years are now a lighter gray, to make it easier to see that they are disabled. (#2690)

* `getCurrentOutputInfo()` previously threw an error when called from outside of an output; now it returns `NULL`. (#2707 and #2858)

* Added a label to observer that auto-reloads `R/` directory to avoid confusion when using `reactlog`. (#58)

* `getDefaultReactiveDomain()` can now be called inside a `session$onSessionEnded` callback and will return the calling `session` information. (#2757)

* Added a `'function'` class to `reactive()` and `reactiveVal()` objects. (#2793)

* Added a new option (`type = "hidden"`) to `tabsetPanel()`, making it easier to set the active tab via other input controls (e.g., `radioButtons()`) rather than tabs or pills. Use this option in conjunction with `updateTabsetPanel()` and the new `tabsetPanelBody()` function (see `help(tabsetPanel)` for an example and more details).  (#2814)

* Added function `updateActionLink()` to update an `actionLink()` label and/or icon value. (#2811)

* Fixed #2856: Bumped jQuery 3 from 3.4.1 to 3.5.1. (#2857)

### Bug fixes

* Fixed #2606: `debounce()` would not work properly if the code in the reactive expression threw an error on the first run. (#2652)

* Fixed #2653: The `dataTableOutput()` could have incorrect output if certain characters were in the column names. (#2658)

### Documentation Updates

### Library updates

* Updated from Font-Awesome 5.3.1 to 5.13.0, which includes icons related to COVID-19. For upgrade notes, see https://github.com/FortAwesome/Font-Awesome/blob/master/UPGRADING.md. (#2891)

