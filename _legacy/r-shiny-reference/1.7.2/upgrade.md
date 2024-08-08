---
layout: upgrade-note
title: Upgrade notes for Shiny 1.7.2
---


## Full changelog

### Breaking changes

- Closed [#3626](https://github.com/rstudio/shiny/issues/3626): [`renderPlot()`](./renderPlot.html) (and [`plotPNG()`](./plotPNG.html)) now uses [`ragg::agg_png()`](https://ragg.r-lib.org/reference/agg_png.html) by default when the [`{ragg}` package](https://github.com/r-lib/ragg) is installed. To restore the previous behavior, set `options(shiny.useragg = FALSE)`. ([#3654](https://github.com/rstudio/shiny/issues/3654))

### New features and improvements

- Closed [#1545](https://github.com/rstudio/shiny/issues/1545): [`insertUI()`](./insertUI.html) now executes `<script>` tags. ([#3630](https://github.com/rstudio/shiny/issues/3630))

- [`fileInput()`](./fileInput.html) can set the `capture` attribute to facilitates user access to a device's media capture mechanism, such as a camera, or microphone, from within a file upload control ([W3C HTML Media Capture](https://www.w3.org/TR/html-media-capture/)). (Thanks to khaled-alshamaa, [#3481](https://github.com/rstudio/shiny/issues/3481))

- Closed [tidyverse/dplyr#5552](https://github.com/tidyverse/dplyr/issues/5552): Compatibility of dplyr 1.0 (and rlang chained errors in general) with [`req()`](./req.html), [`validate()`](./validate.html), and friends.

- Closed [tidyverse/dplyr#6154](https://github.com/tidyverse/dplyr/issues/6154): Values from an [`actionButton()`](./actionButton.html) had S3 classes in the incorrect order.

- Closed [#3346](https://github.com/rstudio/shiny/issues/3346): Default for `ref` input in `runGithub()` changed from `"master"` to `"HEAD"`. ([#3564](https://github.com/rstudio/shiny/issues/3564))

- Closed [#3619](https://github.com/rstudio/shiny/issues/3619): In R 4.2, [`splitLayout()`](./splitLayout.html) no longer raises warnings about incorrect length in an `if` statement. (Thanks to @dmenne, [#3625](https://github.com/rstudio/shiny/issues/3625))

### Bug fixes

- Closed [#3250](https://github.com/rstudio/shiny/issues/3250):[rlang](https://rlang.r-lib.org)/`{tidyeval}` conditions (i.e., warnings and errors) are no longer filtered from stack traces. ([#3602](https://github.com/rstudio/shiny/issues/3602))

- Closed [#3581](https://github.com/rstudio/shiny/issues/3581): Errors in throttled/debounced reactive expressions no longer cause the session to exit. ([#3624](https://github.com/rstudio/shiny/issues/3624))

- Closed [#3657](https://github.com/rstudio/shiny/issues/3657): `throttle.ts` and the `Throttler` typescript objects it provides now function as intended. (Thanks gto @dvg-p4, [#3659](https://github.com/rstudio/shiny/issues/3659))

- The auto-reload feature (`options(shiny.autoreload=TRUE)`) was not being activated by `devmode(TRUE)`, despite a console message asserting that it was. ([#3620](https://github.com/rstudio/shiny/issues/3620))

- Closed [#2297](https://github.com/rstudio/shiny/issues/2297): If an error occurred in parsing a value in a bookmark query string, an error would be thrown and nothing would be restored. Now a message is displayed and that value is ignored. (Thanks to @daattali, [#3385](https://github.com/rstudio/shiny/issues/3385))

- Restored the previous behavior of automatically guessing the `Content-Type` header for `downloadHandler` functions when no explicit `contentType` argument is supplied. ([#3393](https://github.com/rstudio/shiny/issues/3393))

- Previously, updating an input value without a corresponding Input binding element did not trigger a JavaScript `shiny:inputchanged` event. Now, if no Input binding element is found, the `shiny:inputchanged` event is triggered on `window.document`. ([#3584](https://github.com/rstudio/shiny/issues/3584))

- Closed [#2955](https://github.com/rstudio/shiny/issues/2955): Input and output bindings previously attempted to use `el['data-input-id']`, but that never worked. They now use `el.getAttribute('data-input-id')` instead. ([#3538](https://github.com/rstudio/shiny/issues/3538))

### Minor improvements

- When taking a test snapshot, the sort order of the json keys of the `input`, `output`, and `export` fields is currently sorted using the locale of the machine. This can lead to inconsistent test snapshot results. To opt-in to a consistent ordering of snapshot fields with [shinytest](https://github.com/rstudio/shinytest), please set the global option `options(shiny.snapshotsortc = TRUE)`. [shinytest2](https://rstudio.github.io/shinytest2/) users do not need to set this value. ([#3515](https://github.com/rstudio/shiny/issues/3515))

- Closed [rstudio/shinytest2#222](https://github.com/rstudio/shinytest2/issues/222): When restoring a context (i.e., bookmarking) from a URL, Shiny now better handles a trailing `=` after `_inputs_` and `_values_`. ([#3648](https://github.com/rstudio/shiny/issues/3648))

- Shiny's internal HTML dependencies are now mounted dynamically instead of statically. ([#3537](https://github.com/rstudio/shiny/issues/3537))

- HTML dependencies that are sent to dynamic UI now have better type checking, and no longer require a `dep.src.href` field. ([#3537](https://github.com/rstudio/shiny/issues/3537))

