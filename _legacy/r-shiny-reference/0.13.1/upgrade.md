---
layout: upgrade-note
title: Upgrade notes for Shiny 0.13.1
---

* `flexCol` did not work on RStudio for Windows or Linux.

* Fixed RStudio debugger integration.

* BREAKING CHANGE: The long-deprecated ability to pass functions (rather than expressions) to reactive() and observe() has finally been removed.
