---
layout: upgrade-note
title: Upgrade notes for Shiny 0.12.2
---

* GitHub changed URLs for gists from .tar.gz to .zip, so `runGist` was updated to work with the new URLs.

* Callbacks from the session object are now guaranteed to execute in the order in which registration occurred.

* Minor bugs in sliderInput's animation behavior have been fixed. (#852)

* Updated to ion.rangeSlider to 2.0.12.

* Added `shiny.minified` option, which controls whether the minified version of shiny.js is used. Setting it to FALSe can be useful for debugging. (#826, #850)

* Fixed an issue for outputting plots from ggplot objects which also have an additional class whose print method takes precedence over `print.ggplot`. (#840, 841)

* Added `width` option to Shiny's input functions. (#589, #834)

* Added two alias functions of `updateTabsetPanel()` to update the selected tab: `updateNavbarPage()` and `updateNavlistPanel()`. (#881)

* All non-base functions are now explicitly namespaced, to pass checks in R-devel.

* Shiny now correctly handles HTTP HEAD requests. (#876)
