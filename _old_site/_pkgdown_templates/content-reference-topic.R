
pkg <- pkgdown::as_pkgdown("shiny_sym/")
topic <- pkgdown:::data_reference_topic(
  topic = purrr::transpose(pkg$topics)$`htmlOutput.Rd`,
  pkg = pkg
)
str(topic)
#> List of 13
#>  $ name       : chr "htmlOutput"
#>  $ title      : chr "Create an HTML output element"
#>  $ pagetitle  : chr "Create an HTML output element — htmlOutput"
#>  $ source     : chr "Source: <a href='https://github.com/rstudio/shiny/blob/HEAD/R/bootstrap.R'><code>R/bootstrap.R</code></a>"
#>  $ filename   : chr "htmlOutput.Rd"
#>  $ author     : chr(0)
#>  $ aliases    : chr [1:2] "htmlOutput" "uiOutput"
#>  $ keywords   : chr(0)
#>  $ description:List of 2
#>   ..$ title   : chr "Description"
#>   ..$ contents: chr "<p>Render a reactive output variable as HTML within an application page. The\ntext will be included within an H"| __truncated__
#>  $ opengraph  :List of 1
#>   ..$ description: chr "Render a reactive output variable as HTML within an application page. The\ntext will be included within an HTML"| __truncated__
#>  $ usage      :List of 2
#>   ..$ title   : chr "Usage"
#>   ..$ contents: chr "<div class='sourceCode'><pre class='sourceCode r'><code><span class='fu'>htmlOutput</span><span class='op'>(</s"| __truncated__
#>  $ examples   : chr "<div class='sourceCode'><pre class='sourceCode r'><code><span class='r-in'><span class='fu'>htmlOutput</span><s"| __truncated__
#>  $ sections   :List of 3
#>   ..$ :List of 3
#>   .. ..$ title   : chr "Arguments"
#>   .. ..$ contents: chr "<dl>\n\n<dt>outputId</dt>\n<dd><p>output variable to read the value from</p></dd>\n\n\n<dt>inline</dt>\n<dd><p>"| __truncated__
#>   .. ..$ slug    : chr "arguments"
#>   ..$ :List of 3
#>   .. ..$ title   : chr "Value"
#>   .. ..$ contents: chr "\n\n<p>An HTML output element that can be included in a panel</p>"
#>   .. ..$ slug    : chr "value"
#>   ..$ :List of 3
#>   .. ..$ title   : chr "Details"
#>   .. ..$ contents: chr "<p><code>uiOutput</code> is intended to be used with <code>renderUI</code> on the server side. It is\ncurrently"| __truncated__
#>   .. ..$ slug    : chr "details"
