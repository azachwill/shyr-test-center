---
layout: upgrade-note
title: Upgrade notes for Shiny 0.14.2
---

This is a maintenance release of Shiny, with some bug fixes and minor new features.

## Full changelog

### Minor new features and improvements

* Added a `fade` argument to `modalDialog()` -- setting it to `FALSE` will remove the usual fade-in animation for that modal window. ([#1414](https://github.com/rstudio/shiny/pull/1414))

* Fixed a "duplicate binding" error that occurred in some edge cases involving `insertUI` and nested `uiOutput`. ([#1402](https://github.com/rstudio/shiny/pull/1402))

* Fixed [#1422](https://github.com/rstudio/shiny/issues/1422): When using the `shiny.trace` option, allow specifying to only log SEND or RECV messages, or both. (PR [#1428](https://github.com/rstudio/shiny/pull/1428))

* Fixed [#1419](https://github.com/rstudio/shiny/issues/1419): Allow overriding a JS custom message handler. (PR [#1445](https://github.com/rstudio/shiny/pull/1445))

* Added `exportTestValues()` function, which allows a test driver to query the session for values internal to an application's server function. This only has an effect if the `shiny.testmode` option is set to `TRUE`. ([#1436](https://github.com/rstudio/shiny/pull/1436))

### Bug fixes

* Fixed [#1427](https://github.com/rstudio/shiny/issues/1427): make sure that modals do not close incorrectly when an element inside them is triggered as hidden. ([#1430](https://github.com/rstudio/shiny/pull/1430))

* Fixed [#1404](https://github.com/rstudio/shiny/issues/1404): stack trace tests were not compatible with the byte-code compiler in R-devel, which now tracks source references.

* `sliderInputBinding.setValue()` now sends a slider's value immediately, instead of waiting for the usual 250ms debounce delay. ([#1429](https://github.com/rstudio/shiny/pull/1429))

* Fixed a bug where, in versions of R before 3.2, Shiny applications could crash due to a bug in R's implementation of `list2env()`. ([#1446](https://github.com/rstudio/shiny/pull/1446))
