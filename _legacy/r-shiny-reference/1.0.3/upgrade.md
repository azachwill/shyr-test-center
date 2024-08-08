---
layout: upgrade-note
title: Upgrade notes for Shiny 1.0.3
---

This is a hotfix release of Shiny. With previous versions of Shiny, when running an application on the newly-released version of R, 3.4.0, it would print a message: `Warning in body(fun) : argument is not a function`. This has no effect on the application, but because the message could be alarming to users, we are releasing a new version of Shiny that fixes this issue.

## Full changelog

### Bug fixes

* Fixed [#1672](https://github.com/rstudio/shiny/issues/1672): When an error occurred while uploading a file, the progress bar did not change colors. ([#1673](https://github.com/rstudio/shiny/pull/1673))

* Fixed [#1676](https://github.com/rstudio/shiny/issues/1676): On R 3.4.0, running a Shiny application gave a warning: `Warning in body(fun) : argument is not a function`. ([#1677](https://github.com/rstudio/shiny/pull/1677))
