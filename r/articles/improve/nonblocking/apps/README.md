These apps are (kind of) used as examples in the nonblocking/index.qmd article.

* `sync/` - The synchronous version, whose source is shown in the article.
* `async/` - Version that uses asynchronous reactives; same user experience as `sync/` but better behavior with more than one user. **This is the actual app that is shown in an iframe above the `sync/` app's source code.** It's deployed at https://gallery.shinyapps.io/extended-task-sync/.
* `nonblocking/app-future.R` - The nonblocking version, whose source is shown in the article.
* `nonblocking/app.R` - The nonblocking version, but instead of future, it uses mirai. **This is the actual app that is shown in an iframe above the `async/` app's source code.** It's deployed at https://gallery.shinyapps.io/extended-task-nonblocking/. I wanted to try deploying a mirai app and this was a relatively low-stakes real-world opportunity.