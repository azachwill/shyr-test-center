---
layout: upgrade-note
title: Upgrade notes for Shiny 0.14.1
---

This is a maintenance release of Shiny, with some bug fixes and minor new features.

## Full changelog

### Minor new features and improvements

* Restored file inputs are now copied on restore, so that the restored application can't modify the bookmarked file. ([#1370](https://github.com/rstudio/shiny/issues/1370))

* Added support for plot interaction in the development version of ggplot2, 2.1.0.9000. Also added support for ggplot2 plots with `coord_flip()` (in the development version of ggplot2). ([hadley/ggplot2#1781](https://github.com/hadley/ggplot2/issues/1781), [#1392](https://github.com/rstudio/shiny/pull/1392))


### Bug fixes

* Fixed [#1093](https://github.com/rstudio/shiny/issues/1093) better: `updateRadioButtons()` and `updateCheckboxGroupInput()` were not working correctly if the choices were given as a numeric vector. This had been solved in [#1291](https://github.com/rstudio/shiny/pull/1291), but that introduced a different bug [#1396](https://github.com/rstudio/shiny/issues/1396) that this better fix avoids. ([#1370](https://github.com/rstudio/shiny/pull/1397))

* Fixed [#1368](https://github.com/rstudio/shiny/issues/1368): If an app with a file input was bookmarked and restored, and then the restored app was bookmarked and restored (without uploading a new file), then it would fail to restore the file the second time. ([#1370](https://github.com/rstudio/shiny/pull/1370))

* Fixed [#1369](https://github.com/rstudio/shiny/issues/1369): `sliderInput()` did not allow showing numbers without a thousands separator.

* Fixed [#1346](https://github.com/rstudio/shiny/issues/1346) and [#1107](https://github.com/rstudio/shiny/issues/1107) : jQuery UI's datepicker conflicted with the bootstrap-datepicker used by Shiny's `dateInput()` and `dateRangeInput()`. ([#1374](https://github.com/rstudio/shiny/pull/1374))

### Library updates

* Updated to bootstrap-datepicker 1.6.4. ([#1218](https://github.com/rstudio/shiny/issues/1218), [#1374](https://github.com/rstudio/shiny/pull/1374))

* Updated to jQuery UI 1.12.1. Previously, Shiny included a build of 1.11.4 which was missing the datepicker component due to a conflict with the bootstrap-datepicker used by Shiny's `dateInput()` and `dateRangeInput()`. ([#1374](https://github.com/rstudio/shiny/pull/1374))
