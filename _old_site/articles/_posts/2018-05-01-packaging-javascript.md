---
layout: post
title: Packaging JavaScript code for Shiny
author: Joe Cheng
edited: 2018-05-01
description: Want to add some JavaScript code to your Shiny app, and don't know where to put it? You have several options.
---

If you want to write custom JavaScript code to customize and extend your Shiny app, you'll eventually need to figure out how to get Shiny to serve up your JavaScript. There are a number of different possibilities:

1. [Inline the JavaScript in your UI code, as literal text](#inlined-script-text)
2. [Create a .js file under a `www/` directory, and reference it from your UI using `<script>`](#javascript-file-under-www)
3. [Inline a .js file in your UI code](#inlined-javascript-file)
4. [Create an htmltools::htmlDependency object and include it in your UI](#htmldependency-object)
5. [[R Markdown only] Use a <code>```{js}</code> chunk](#r-markdown-only-use-a-js-chunk)

The right choice for your situation will depend primarily on how much JavaScript code you are writing, and whether/how you intend to reuse the JavaScript code across multiple Shiny apps (no reuse, ad hoc, or R package).

## Inlined script text

The quickest way to inject a bit of JavaScript is to include a `<script>` tag directly in your Shiny UI, using `tags$script()` and `HTML()`:

```R
ui <- fluidPage(
  tags$script(HTML(
    "document.body.style.backgroundColor = 'skyblue';"
  ))
)
```

You can generally feel free to add `tags$script()` calls anywhere in your UI where "normal" content is expected. (If for some reason you feel strongly about JavaScript only appearing in the `<head>` of a document, you can do `tags$head(tags$script(...))` and Shiny will hoist your script to the head at page render time.)

**Inlined script text should be reserved for only the smallest, one-time-use snippets of JavaScript.** While quick and convenient, there are considerable downsides to this approach:

1. No assistance from your IDE or text editor for coloring, indenting, or error-checking your JS code
2. Including multiple lines of code is a bit awkward
3. Need to escape double quotes (or single quotes, depending on which you use to form your R string) using "`\`"

Note the `HTML()` in the example above. This is necessary to prevent your JavaScript code string from being treated as regular text and being HTML-escaped; if that happens, all instances of the special characters `&`, `<`, and `>` in your code will be turned into `&amp;`, `&lt;`, and `&gt;`, respectively.

## JavaScript file under `www/`

Another option is creating a separate .js file and saving it in a `www` subdirectory (it must be directly under your app directory). This is only slightly less convenient than inlined script text, and removes most of the downsides.

#### www/myscript.js:

```javascript
document.body.style.backgroundColor = "skyblue";
```

#### app.R:

```R
ui <- fluidPage(
  tags$script(src = "myscript.js")
)
```

An app directory's `www` subdirectory is special to Shiny: any files and folders contained there are automatically made available to download. (Files in the app dir itself, or any other subdirectories, are not available to download; this is intentional, for obvious security reasons.) Notice that the script tag's `src` attribute is `"myscript.js"`, not `"www/myscript.js"`; you should never include a `www` prefix when creating URLs to content in the `www` directory.

Because the JavaScript code is in a dedicated file, you can use your favorite IDE or text editor to its full advantage. And there's no need to worry about escaping quotes.

**Use JavaScript files under `www/` anytime you are writing substantial logic that's specific to a single app.** The downsides to this approach come into play when you want your logic to be used in multiple apps. Because a file must be physically copied into each app dir's `www` subdirectory, it will never be as convenient for reuse as the next two approaches.

## Inlined JavaScript file

This approach can be thought of as a hybrid of the previous two approaches: you write your JavaScript code in a standalone .js file, but the end result is that the JavaScript is inlined completely into the main app's HTML.

To use this approach, place your .js file directly in the app directory (or in any subdirectory, like `js/`). Then, use the `includeScript` function in your UI, just like you would use `tags$script` in the previous two approaches.

#### myscript.js:

```javascript
document.body.style.backgroundColor = "skyblue";
```

#### app.R:

```R
ui <- fluidPage(
  includeScript(path = "myscript.js")
)
```

The `path` argument to `includeScript` should be a relative path to your script file, starting from the app directory (in this example, `myscript.js` would be placed directly in the app directory).

Unlike the previous (`www/`) option, this approach can also be easily used in package functions intended to be used by multiple apps. Put the JavaScript file under [your package's `inst` directory](http://r-pkgs.had.co.nz/inst.html), and use the `base::system.file` function to obtain an absolute path to your JavaScript file, which you then pass to `includeScript`. Do all this in a package function that returns the results of `includeScript`.

#### mypackage/inst/js/myscript.js

```javascript
document.body.style.backgroundColor = "skyblue";
```

#### mypackage/R/bluebg.R

```R
#' @export
blueBgScript <- function() {
  includeScript(system.file("js/myscript.js", package = "mypackage"))
}
```

#### app.R

```R
ui <- fluidPage(
	mypackage::blueBgScript()
)
```

**Inline a JavaScript file into the UI if you want to reuse it via package functions** (but also see the next option for an even more flexible approach).

Avoid using `includeScript` with a hardcoded absolute path to your user directory, or to any other directory outside of your app directory. Doing so will prevent your app from working for other R users, or for yourself on a different computer, or from being deployed successfully on ShinyApps.io or RStudio Connect.

## `htmlDependency` object

The previous approaches were just different ways of injecting `<script>` tags directly into your UI. This last option is very different.

Unlike `includeScript` or `tags$script`, the `htmltools::htmlDependency` function does not directly create a `<script>` tag. Instead, it creates an object that _describes_ a bundle of JS/CSS assets:

1. **`name`: The name of the bundle.** If you're creating an `htmlDependency` for a 3rd-party JS/CSS library, you'd use its name; e.g. `"jquery"`, `"font-awesome"`, `"bootstrap"`. If you're bundling some custom JS/CSS for your own package, pick a unique name based on your package name.
2. **`version`: A version number.** For a 3rd-party JS/CSS library, just use its version number; if custom JS/CSS for your own package, use `packageVersion()` to get the package version number.
3. **`src`: A source directory (or URL).** This is the parent directory (or URL) for all of the JS/CSS files.
   1. If you're using a URL (like to a CDN), you must make this explicit by using a named vector: `src = c(href = url)`.
   2. If you are building a package and the scripts/stylesheets are somewhere in the `inst` directory, you can also provide a `package` argument with your package name, and then the source directory would be a path that's relative to the package path.
4. **`script` and `stylesheet`: Relative paths to all JS and CSS files that should get their own `<script>` and `<link>` tags.** These paths should be relative to the source directory/URL.

Here's an example. Given an R package with this directory structure:

```
mypackage/
└─ inst/
   └─ assets/
      ├─ js/
      │  └─ myscript.js
      └─ css/
         ├─ reset.css
         └─ mystyles.css
```

You'd create an `htmlDependency` like this:

```R
mypackageDependencies <- function() {
  htmlDependency(name = "mypackage-assets", version = "0.1",
    package = "mypackage",
    src = "assets",
    script = "js/myscript.js",
    stylesheet = c("css/reset.css", "css/mystyles.css")
  )
}
```

You can include `htmlDependency` objects in your UI just like other tag objects. But they don't directly translate into `<script>` and `<link>`—at least, not right away. Instead, the dependency object is left alone until the entire page is ready to render.

At page render time, Shiny will look at all the `htmlDependency` objects present in the page, and crucially, weed out any duplicate dependencies (i.e. for a given dependency name, only a single copy of `htmlDependency` will be kept). The remaining dependency objects are then injected into the `<head>` of the page with the appropriate `<script>` and `<link>` tags.

If multiple dependencies have the same name but different versions, the more recent version is kept. (We assume that dependency libraries are backward compatible. Things get a bit complicated if that's not true, such as with d3 3.x vs 4.x.)

**Use `htmlDependency` objects if you have initialization code that should be run only once, but may be used multiple times on a single page; or if you intend for your JavaScript to be reused by other packages.**

## [R Markdown only] Use a <code>```{js}</code> chunk

For R Markdown documents, in addition to the options above, you can also use the [JavaScript chunk engine](https://rmarkdown.rstudio.com/authoring_knitr_engines.html#javascript). This is very convenient for small to medium sized code chunks, as it doesn't require you to create a separate file, nor must you stuff your JavaScript code into a string literal.

(One caveat for `runtime: shiny` apps, regardless of which option you choose: your Rmd is not rendered until well after the browser page has loaded, so you can't rely on the `DOMContentLoaded` event, or its jQuery equivalent, `$(document).ready()`.)
