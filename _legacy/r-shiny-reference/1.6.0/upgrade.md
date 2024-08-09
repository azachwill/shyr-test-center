---
layout: upgrade-note
title: Upgrade notes for Shiny 1.6.0
---

This release focuses on improvements in three main areas:

1. Better theming (and Bootstrap 4) support:
  * The `theme` argument of `fluidPage()`, `navbarPage()`, and `bootstrapPage()` all now understand `bslib::bs_theme()` objects, which can be used to opt-into Bootstrap 4, use any Bootswatch theme, and/or implement custom themes without writing any CSS. 
  * The `session` object now includes `$setCurrentTheme()` and `$getCurrentTheme()` methods to dynamically update (or obtain) the page's `theme` after initial load, which is useful for things such as [adding a dark mode switch to an app](https://rstudio.github.io/bslib/articles/theming.html#dynamic-theming-in-shiny) or some other "real-time" theming tool like `bslib::bs_themer()`.
  * For more details, see [`{bslib}`'s website](https://rstudio.github.io/bslib)

2. Caching of `reactive()` and `render*()` (e.g. `renderText()`, `renderTable()`, etc) expressions.
  * Such expressions automatically cache their _most recent value_, which helps to avoid redundant computation within a single "flush" of reactivity. The new `bindCache()` function can be used to cache _all previous values_ (as long as they fit in the cache). This cache may be optionally scoped within and/or across user sessions, possibly leading to huge performance gains, especially when deployed at scale across user sessions.
  * For more details, see `help(bindCache, package = "shiny")`
  
3. Various improvements to accessibility for screen-reader and keyboard users.
  * For more details, see the accessibility section below.

## Full changelog

### Breaking changes

* Closed #3074: Shiny no longer supports file uploads for Internet Explorer 8 or 9. (#3075)

* Subtle changes, and some soft-deprecations, have come to `freezeReactiveValue` and `freezeReactiveVal` (#3055). These functions have been fragile at best in previous releases (issues #1791, #2463, #2946). In this release, we've solved all the problems we know about with `freezeReactiveValue(input, "x")`, by 1) invalidating `input$x` and set it to `NULL` whenever we freeze, and 2) ensuring that, after a freeze, even if the effect of `renderUI` or `updateXXXInput` is to set `input$x` to the same value it already has, this will result in an invalidation (whereas by default, Shiny filters out such spurious assignments).

  Similar problems may exist when using `freezeReactiveVal`, and when using `freezeReactiveValue` with non-`input` reactive values objects. But support for those was added mostly for symmetry with `freezeReactiveValue(input)`, and given the above issues, it's not clear to us how you could have used these successfully in the past, or why you would even want to. For this release, we're soft-deprecating both of those uses, but we're more than willing to un-deprecate if it turns out people are using these; if that includes you, please join the conversation at https://github.com/rstudio/shiny/issues/3063. In the meantime, you can squelch the deprecation messages for these functions specifically, by setting `options(shiny.deprecation.messages.freeze = FALSE)`.

### Accessibility

* Added [bootstrap accessibility plugin](https://github.com/paypal/bootstrap-accessibility-plugin) under the hood to improve accessibility of shiny apps for screen-reader and keyboard users: the enhancements include better navigations for alert, tooltip, popover, modal dialog, dropdown, tab Panel, collapse, and carousel elements. (#2911)

* Closed #2987: Improved accessibility of "live regions" -- namely, `*Output()` bindings and `update*Input()`. (#3042)

* Added appropriate labels to `icon()` element to provide screen-reader users with alternative descriptions for the `fontawesome` and `glyphicon`: `aria-label` is automatically applied based on the fontawesome name. For example, `icon("calendar")` will be announced as "calendar icon" to screen readers. "presentation" aria role has also been attached to `icon()` to remove redundant semantic info for screen readers. (#2917)

* Closed #2929: Fixed keyboard accessibility for file picker button: keyboard users can now tab to focus on `fileInput()` widget. (#2937)

* Fixed #2951: screen readers correctly announce labels and date formats for `dateInput()` and `dateRangeInput()` widgets. (#2978)

* Closed #2847: `selectInput()` is reasonably accessible for screen readers even when `selectize` option is set to TRUE. To improve `selectize.js` accessibility, we have added [selectize-plugin-a11y](https://github.com/SLMNBJ/selectize-plugin-a11y) by default. (#2993)

* Closed #612: Added `alt` argument to `renderPlot()` and `renderCachedPlot()` to specify descriptive texts for `plotOutput()` objects, which is essential for screen readers. By default, alt text is set to the static text, "Plot object," but even dynamic text can be made with reactive function. (#3006, thanks @trafficonese and @leonawicz for the original PR and discussion via #2494)

* Added semantic landmarks for `mainPanel()` and `sidebarPanel()` so that assistive technologies can recognize them as "main" and "complementary" region respectively. (#3009)

* Closed #2844: Added `lang` argument to ui `*Page()` functions (e.g., `fluidPage`, `bootstrapPage`) that specifies document-level language within the app for the accessibility of screen readers and search-engine parsers. By default, it is set to empty string which is commonly recognized as a browser's default locale. (#2920)

* Improved accessibility for `radioButtons()` and `checkboxGroupInput()`: All options are now grouped together semantically for assistive technologies. (thanks @jooyoungseo, #3187).

### Minor new features and improvements

* Added support for Shiny Developer Mode. Developer Mode enables a number of `options()` to make a developer's life easier, like enabling non-minified JS and printing messages about deprecated functions and options. See `?devmode()` for more details. (#3174)

* New `reactiveConsole()` makes it easier to interactively experiment with reactivity at the console (#2518).

* When UI is specified as a function (e.g. `ui <- function(req) { ... }`), the response can now be an HTTP response as returned from the (newly exported) `httpResponse()` function. (#2970)

* `selectInput` and `selectizeInput` now warn about performance implications when thousands of choices are used, and recommend [server-side selectize](https://shyr-test-center.netlify.app/articles/selectize.html) be used instead. (#2959)

* Closed #2980: `addResourcePath()` now allows paths with a leading `.` (thanks to @ColinFay). (#2981)

* Closed #2972: `runExample()` now supports the `shiny.port` option (thanks to @ColinFay). (#2982)

* Closed #2692: `downloadButton()` icon can now be changed via the `icon` parameter (thanks to @ColinFay). (#3010)

* Closed #2984: improved documentation for `renderCachedPlot()` (thanks to @aalucaci). (#3016)

* `reactiveValuesToList()` will save its `reactlog` label as `reactiveValuesToList(<ID>)` vs `as.list(<ID>)` (#3017)

* Removed unused (and non-exported) `cacheContext` class.

* `testServer()` can accept a single server function as input (#2965).

* `shinyOptions()` now has session-level scoping, in addition to global and application-level scoping. (#3080)

* `runApp()` now warns when running an application in an R package directory. (#3114)

* Shiny now uses `cache_mem` from the cachem package, instead of `memoryCache` and `diskCache`. (#3118)

* Closed #3140: Added support for `...` argument in `icon()`. (#3143)

* Closed #629: All `update*` functions now have a default value for `session`, and issue an informative warning if it is missing. (#3195, #3199)

* Improved error messages when reading reactive values outside of a reactive domain (e.g., `reactiveVal()()`). (#3007)

### Bug fixes

* Fixed #1942: Calling `runApp("app.R")` no longer ignores options passed into `shinyApp()`. This makes it possible for Shiny apps to specify what port/host should be used by default. (#2969)

* Fixed #3033: When a `DiskCache` was created with both `max_n` and `max_size`, too many items could get pruned when `prune()` was called. (#3034)

* Fixed #2703: Fixed numerous issues with some combinations of `min`/`value`/`max` causing issues with `date[Range]Input()` and `updateDate[Range]Input()`. (#3038, #3201)

* Fixed #2936: `dateYMD` was giving a warning when passed a vector of dates from `dateInput` which was greater than length 1. The length check was removed because it was not needed. (#3061)

* Fixed #2266, #2688: `radioButtons` and `updateRadioButtons` now accept `character(0)` to indicate that none of the options should be selected (thanks to @ColinFay). (#3043)

* Fixed a bug that `textAreaInput()` doesn't work as expected for relative `width` (thanks to @shrektan). (#2049)

* Fixed #2859: `renderPlot()` wasn't correctly setting `showtext::showtext_opts()`'s `dpi` setting with the correct resolution on high resolution displays; which means, if the font was rendered by showtext, font sizes would look smaller than they should on such displays. (#2941)

* Closed #2910, #2909, #1552: `sliderInput()` warns if the `value` is outside of `min` and `max`, and errors if `value` is `NULL` or `NA`. (#3194)

### Library updates

* Removed html5shiv and respond.js, which were used for IE 8 and IE 9 compatibility. (#2973)

* Removed es5-shim library, which was internally used within `selectInput()` for ECMAScript 5 compatibility. (#2993)
