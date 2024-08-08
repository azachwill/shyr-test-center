---
layout: upgrade-note
title: Upgrade notes for Shiny 1.0.5
---

## Full changelog

### Bug fixes

* Fixed [#1818](https://github.com/rstudio/shiny/issues/1818): `conditionalPanel()` expressions that have a newline character in them caused the application to not work. ([#1820](https://github.com/rstudio/shiny/pull/1820))

* Added a safe wrapper function for internal calls to `jsonlite::fromJSON()`. ([#1822](https://github.com/rstudio/shiny/pull/1822))

* Fixed [#1824](https://github.com/rstudio/shiny/issues/1824): HTTP HEAD requests on static files caused the application to stop. ([#1825](https://github.com/rstudio/shiny/pull/1825))
