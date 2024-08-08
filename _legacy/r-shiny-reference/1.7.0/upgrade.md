---
layout: upgrade-note
title: Upgrade notes for Shiny 1.7.0
---

## Full changelog

### Breaking changes

* The `format` and `locale` arguments to `sliderInput()` have been removed. They have been deprecated since 0.10.2.2 (released on 2014-12-08).

* Closed #3403: `insertTab()`'s `position` parameter now defaults to `"after"` instead of `"before"`. This has the benefit of allowing us to fix a bug in positioning when `target = NULL`, but has the drawback of changing the default behavior when `target` is not `NULL`. (#3404)

### New features and improvements

* Bootstrap 5 support. (#3410 and rstudio/bslib#304)
  * As explained [here](https://rstudio.github.io/bslib/index.html#basic-usage), to opt-in to Bootstrap 5, provide `bslib::bs_theme(version = 5)` to a page layout function with a `theme` argument (e.g., `fluidPage()`, `navbarPage()`, etc).

* Closed #3322, #3313, #1823, #3321, #3320, #1928, and #2310: Various improvements to `navbarPage()`, `tabsetPanel()`, `tabPanel()`, `navbarMenu()`, etc. Also, these functions are now powered by the `{bslib}` package's new `nav()` API (consider using `{bslib}`'s API to create better looking and more fully featured navs). (#3388)

* All uses of `list(...)` have been replaced with `rlang::list2(...)`. This means that you can use trailing `,` without error and use rlang's `!!!` operator to "splice" a list of argument values into `...`. We think this'll be particularly useful for passing a list of `tabPanel()` to their consumers (i.e., `tabsetPanel()`, `navbarPage()`, etc). For example, `tabs <- list(tabPanel("A", "a"), tabPanel("B", "b")); navbarPage(!!!tabs)`. (#3315 and #3328)

* `installExprFunction()` and `exprToFunction()` are now able to handle quosures when `quoted = TRUE`. So `render`-functions which call these functions (such as with `htmlwidgets`) can now understand quosures. Users can also use `rlang::inject()` to unquote a quosure for evaluation.  This also means that `render` function no longer need `env` and `quoted` parameters; that information can be embedded into a quosure which is then passed to the `render` function. Better documentation was added for how to create `render` functions. (#3472)

* `icon(lib="fontawesome")` is now powered by the `{fontawesome}` package, which will make it easier to use the latest FA icons in the future (by updating the `{fontawesome}` package). (#3302)

* Closed #3397: `renderPlot()` new uses `ggplot2::get_alt_text()` to inform an `alt` text default (for `{ggplot2}` plots). (#3398)

* `modalDialog()` gains support for `size = "xl"`. (#3410)

* Addressed #2521: Updated the list of TCP ports that will be rejected by default in runapp.R, adding 5060, 5061 and 6566. Added documentation describing the port range (3000:8000) and which ports are rejected. (#3456)

### Other improvements

* Shiny's core JavaScript code was converted to TypeScript. For the latest development information, please see the [README.md in `./srcts`](https://github.com/rstudio/shiny/tree/master/srcts). (#3296)

* Switched from `digest::digest()` to `rlang::hash()` for hashing. (#3264)

* Switched from internal `Stack` class to `fastmap::faststack()`, and used `fastmap::fastqueue()`. (#3176)

* Some long-deprecated functions and function parameters were removed. (#3137)

### Bug fixes

* Closed #3345: Shiny now correctly renders `htmltools::htmlDependency()`(s) with a `list()` of `script` attributes when used in a dynamic UI context. This fairly new `htmlDependency()` feature was added in `{htmltools}` v0.5.1. (#3395)

* Fixed [#2666](https://github.com/rstudio/shiny/issues/2666) and [#2670](https://github.com/rstudio/shiny/issues/2670): `nearPoints()` and `brushedPoints()` weren't properly account for missing values (#2666 was introduced in v1.4.0). ([#2668](https://github.com/rstudio/shiny/pull/2668))

* Closed #3374: `quoToFunction()` now works correctly with nested quosures; and as a result, quasi-quotation with rendering function (e.g., `renderPrint()`, `renderPlot()`, etc) now works as expected with nested quosures. (#3373)

* Exported `register_devmode_option()`. This method was described in the documentation for `devmode()` but was never exported. See `?devmode()` for more details on how to register Shiny Developer options using `register_devmode_option()`. (#3364)

* Closed #3484: In the RStudio IDE on Mac 11.5, selected checkboxes and radio buttons were not visible. (#3485)

### Library updates

* Closed #3286: Updated to Font-Awesome 5.15.2. (#3288)

* Updated to jQuery 3.6.0. (#3311)
