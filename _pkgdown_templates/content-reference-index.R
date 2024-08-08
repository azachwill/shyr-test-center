# Using `{pkgdown}` v2.0.6
# After running source("_scripts/generate_docs.R"), we can inspect the temp dir containing the put together shiny docs:
str(
  pkgdown:::data_reference_index(paste0(tempdir(), "/shiny_sym"))
)
#> List of 3
#>  $ pagetitle: chr "Function reference"
#>  $ rows     :List of 30
#>   ..$ :List of 4
#>   .. ..$ title      : chr "UI Layout"
#>   .. ..$ slug       : chr "ui-layout"
#>   .. ..$ desc       : chr "<p>Functions for laying out the user interface for your application.</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 22
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "absolutePanel.html"
#>   .. .. .. ..$ title  : chr "Panel with absolute positioning"
#>   .. .. .. ..$ aliases: chr [1:2] "absolutePanel()" "fixedPanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "bootstrapPage.html"
#>   .. .. .. ..$ title  : chr "Create a Bootstrap page"
#>   .. .. .. ..$ aliases: chr [1:2] "bootstrapPage()" "basicPage()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "column.html"
#>   .. .. .. ..$ title  : chr "Create a column within a UI definition"
#>   .. .. .. ..$ aliases: chr "column()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "conditionalPanel.html"
#>   .. .. .. ..$ title  : chr "Conditional Panel"
#>   .. .. .. ..$ aliases: chr "conditionalPanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "fillPage.html"
#>   .. .. .. ..$ title  : chr "Create a page that fills the window"
#>   .. .. .. ..$ aliases: chr "fillPage()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "fillRow.html"
#>   .. .. .. ..$ title  : chr "Flex Box-based row/column layouts"
#>   .. .. .. ..$ aliases: chr [1:2] "fillRow()" "fillCol()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "fixedPage.html"
#>   .. .. .. ..$ title  : chr "Create a page with a fixed layout"
#>   .. .. .. ..$ aliases: chr [1:2] "fixedPage()" "fixedRow()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "fluidPage.html"
#>   .. .. .. ..$ title  : chr "Create a page with fluid layout"
#>   .. .. .. ..$ aliases: chr [1:2] "fluidPage()" "fluidRow()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "helpText.html"
#>   .. .. .. ..$ title  : chr "Create a help text element"
#>   .. .. .. ..$ aliases: chr "helpText()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "icon.html"
#>   .. .. .. ..$ title  : chr "Create an icon"
#>   .. .. .. ..$ aliases: chr "icon()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "navbarPage.html"
#>   .. .. .. ..$ title  : chr "Create a page with a top level navigation bar"
#>   .. .. .. ..$ aliases: chr [1:2] "navbarPage()" "navbarMenu()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "navlistPanel.html"
#>   .. .. .. ..$ title  : chr "Create a navigation list panel"
#>   .. .. .. ..$ aliases: chr "navlistPanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "sidebarLayout.html"
#>   .. .. .. ..$ title  : chr "Layout a sidebar and main area"
#>   .. .. .. ..$ aliases: chr [1:3] "sidebarLayout()" "sidebarPanel()" "mainPanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "tabPanel.html"
#>   .. .. .. ..$ title  : chr "Create a tab panel"
#>   .. .. .. ..$ aliases: chr [1:2] "tabPanel()" "tabPanelBody()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "tabsetPanel.html"
#>   .. .. .. ..$ title  : chr "Create a tabset panel"
#>   .. .. .. ..$ aliases: chr "tabsetPanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "titlePanel.html"
#>   .. .. .. ..$ title  : chr "Create a panel containing an application title."
#>   .. .. .. ..$ aliases: chr "titlePanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "inputPanel.html"
#>   .. .. .. ..$ title  : chr "Input panel"
#>   .. .. .. ..$ aliases: chr "inputPanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "flowLayout.html"
#>   .. .. .. ..$ title  : chr "Flow layout"
#>   .. .. .. ..$ aliases: chr "flowLayout()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "splitLayout.html"
#>   .. .. .. ..$ title  : chr "Split layout"
#>   .. .. .. ..$ aliases: chr "splitLayout()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "verticalLayout.html"
#>   .. .. .. ..$ title  : chr "Lay out UI elements vertically"
#>   .. .. .. ..$ aliases: chr "verticalLayout()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "wellPanel.html"
#>   .. .. .. ..$ title  : chr "Create a well panel"
#>   .. .. .. ..$ aliases: chr "wellPanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "withMathJax.html"
#>   .. .. .. ..$ title  : chr "Load the MathJax library and typeset math expressions"
#>   .. .. .. ..$ aliases: chr "withMathJax()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:22] "absolutePanel" "bootstrapPage" "column" "conditionalPanel" ...
#>   .. .. ..- attr(*, "names")= chr [1:22] "absolutePanel.Rd" "bootstrapPage.Rd" "column.Rd" "conditionalPanel.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "UI Inputs"
#>   .. ..$ slug       : chr "ui-inputs"
#>   .. ..$ desc       : chr "<p>Functions for creating user interface elements that prompt the user for input values or interaction.</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 31
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "actionButton.html"
#>   .. .. .. ..$ title  : chr "Action button/link"
#>   .. .. .. ..$ aliases: chr [1:2] "actionButton()" "actionLink()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "checkboxGroupInput.html"
#>   .. .. .. ..$ title  : chr "Checkbox Group Input Control"
#>   .. .. .. ..$ aliases: chr "checkboxGroupInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "checkboxInput.html"
#>   .. .. .. ..$ title  : chr "Checkbox Input Control"
#>   .. .. .. ..$ aliases: chr "checkboxInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "dateInput.html"
#>   .. .. .. ..$ title  : chr "Create date input"
#>   .. .. .. ..$ aliases: chr "dateInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "dateRangeInput.html"
#>   .. .. .. ..$ title  : chr "Create date range input"
#>   .. .. .. ..$ aliases: chr "dateRangeInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "fileInput.html"
#>   .. .. .. ..$ title  : chr "File Upload Control"
#>   .. .. .. ..$ aliases: chr "fileInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "numericInput.html"
#>   .. .. .. ..$ title  : chr "Create a numeric input control"
#>   .. .. .. ..$ aliases: chr "numericInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "radioButtons.html"
#>   .. .. .. ..$ title  : chr "Create radio buttons"
#>   .. .. .. ..$ aliases: chr "radioButtons()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "selectInput.html"
#>   .. .. .. ..$ title  : chr "Create a select list input control"
#>   .. .. .. ..$ aliases: chr [1:2] "selectInput()" "selectizeInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "varSelectInput.html"
#>   .. .. .. ..$ title  : chr "Select variables from a data frame"
#>   .. .. .. ..$ aliases: chr [1:2] "varSelectInput()" "varSelectizeInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "sliderInput.html"
#>   .. .. .. ..$ title  : chr "Slider Input Widget"
#>   .. .. .. ..$ aliases: chr [1:2] "sliderInput()" "animationOptions()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "submitButton.html"
#>   .. .. .. ..$ title  : chr "Create a submit button"
#>   .. .. .. ..$ aliases: chr "submitButton()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "textInput.html"
#>   .. .. .. ..$ title  : chr "Create a text input control"
#>   .. .. .. ..$ aliases: chr "textInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "textAreaInput.html"
#>   .. .. .. ..$ title  : chr "Create a textarea input control"
#>   .. .. .. ..$ aliases: chr "textAreaInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "passwordInput.html"
#>   .. .. .. ..$ title  : chr "Create a password input control"
#>   .. .. .. ..$ aliases: chr "passwordInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateActionButton.html"
#>   .. .. .. ..$ title  : chr "Change the label or icon of an action button on the client"
#>   .. .. .. ..$ aliases: chr [1:2] "updateActionButton()" "updateActionLink()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateCheckboxGroupInput.html"
#>   .. .. .. ..$ title  : chr "Change the value of a checkbox group input on the client"
#>   .. .. .. ..$ aliases: chr "updateCheckboxGroupInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateCheckboxInput.html"
#>   .. .. .. ..$ title  : chr "Change the value of a checkbox input on the client"
#>   .. .. .. ..$ aliases: chr "updateCheckboxInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateDateInput.html"
#>   .. .. .. ..$ title  : chr "Change the value of a date input on the client"
#>   .. .. .. ..$ aliases: chr "updateDateInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateDateRangeInput.html"
#>   .. .. .. ..$ title  : chr "Change the start and end values of a date range input on the client"
#>   .. .. .. ..$ aliases: chr "updateDateRangeInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateNumericInput.html"
#>   .. .. .. ..$ title  : chr "Change the value of a number input on the client"
#>   .. .. .. ..$ aliases: chr "updateNumericInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateRadioButtons.html"
#>   .. .. .. ..$ title  : chr "Change the value of a radio input on the client"
#>   .. .. .. ..$ aliases: chr "updateRadioButtons()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateSelectInput.html"
#>   .. .. .. ..$ title  : chr "Change the value of a select input on the client"
#>   .. .. .. ..$ aliases: chr [1:4] "updateSelectInput()" "updateSelectizeInput()" "updateVarSelectInput()" "updateVarSelectizeInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateSliderInput.html"
#>   .. .. .. ..$ title  : chr "Update Slider Input Widget"
#>   .. .. .. ..$ aliases: chr "updateSliderInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateTabsetPanel.html"
#>   .. .. .. ..$ title  : chr "Change the selected tab on the client"
#>   .. .. .. ..$ aliases: chr [1:3] "updateTabsetPanel()" "updateNavbarPage()" "updateNavlistPanel()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "insertTab.html"
#>   .. .. .. ..$ title  : chr "Dynamically insert/remove a tabPanel"
#>   .. .. .. ..$ aliases: chr [1:4] "insertTab()" "prependTab()" "appendTab()" "removeTab()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "showTab.html"
#>   .. .. .. ..$ title  : chr "Dynamically hide/show a tabPanel"
#>   .. .. .. ..$ aliases: chr [1:2] "showTab()" "hideTab()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateTextInput.html"
#>   .. .. .. ..$ title  : chr "Change the value of a text input on the client"
#>   .. .. .. ..$ aliases: chr "updateTextInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateTextAreaInput.html"
#>   .. .. .. ..$ title  : chr "Change the value of a textarea input on the client"
#>   .. .. .. ..$ aliases: chr "updateTextAreaInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "updateQueryString.html"
#>   .. .. .. ..$ title  : chr "Update URL in browser's location bar"
#>   .. .. .. ..$ aliases: chr "updateQueryString()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "getQueryString.html"
#>   .. .. .. ..$ title  : chr "Get the query string / hash component from the URL"
#>   .. .. .. ..$ aliases: chr [1:2] "getQueryString()" "getUrlHash()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:31] "actionButton" "checkboxGroupInput" "checkboxInput" "dateInput" ...
#>   .. .. ..- attr(*, "names")= chr [1:31] "actionButton.Rd" "checkboxGroupInput.Rd" "checkboxInput.Rd" "dateInput.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "UI Outputs"
#>   .. ..$ slug       : chr "ui-outputs"
#>   .. ..$ desc       : chr "<p>Functions for creating user interface elements that, in conjunction with rendering functions, display differ"| __truncated__
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 11
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "htmlOutput.html"
#>   .. .. .. ..$ title  : chr "Create an HTML output element"
#>   .. .. .. ..$ aliases: chr [1:2] "htmlOutput()" "uiOutput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "plotOutput.html"
#>   .. .. .. ..$ title  : chr "Create an plot or image output element"
#>   .. .. .. ..$ aliases: chr [1:2] "imageOutput()" "plotOutput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "outputOptions.html"
#>   .. .. .. ..$ title  : chr "Set options for an output object."
#>   .. .. .. ..$ aliases: chr "outputOptions()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "textOutput.html"
#>   .. .. .. ..$ title  : chr "Create a text output element"
#>   .. .. .. ..$ aliases: chr [1:2] "textOutput()" "verbatimTextOutput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "downloadButton.html"
#>   .. .. .. ..$ title  : chr "Create a download button or link"
#>   .. .. .. ..$ aliases: chr [1:2] "downloadButton()" "downloadLink()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "Progress.html"
#>   .. .. .. ..$ title  : chr "Reporting progress (object-oriented API)"
#>   .. .. .. ..$ aliases: chr "Progress"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "withProgress.html"
#>   .. .. .. ..$ title  : chr "Reporting progress (functional API)"
#>   .. .. .. ..$ aliases: chr [1:3] "withProgress()" "setProgress()" "incProgress()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "modalDialog.html"
#>   .. .. .. ..$ title  : chr "Create a modal dialog UI"
#>   .. .. .. ..$ aliases: chr [1:2] "modalDialog()" "modalButton()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "urlModal.html"
#>   .. .. .. ..$ title  : chr "Generate a modal dialog that displays a URL"
#>   .. .. .. ..$ aliases: chr "urlModal()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "showModal.html"
#>   .. .. .. ..$ title  : chr "Show or remove a modal dialog"
#>   .. .. .. ..$ aliases: chr [1:2] "showModal()" "removeModal()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "showNotification.html"
#>   .. .. .. ..$ title  : chr "Show or remove a notification"
#>   .. .. .. ..$ aliases: chr [1:2] "showNotification()" "removeNotification()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:11] "htmlOutput" "plotOutput" "outputOptions" "textOutput" ...
#>   .. .. ..- attr(*, "names")= chr [1:11] "htmlOutput.Rd" "plotOutput.Rd" "outputOptions.Rd" "textOutput.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Interface builder functions"
#>   .. ..$ slug       : chr "interface-builder-functions"
#>   .. ..$ desc       : chr "<p>A sub-library for writing HTML using R functions. These functions form the foundation on which the higher le"| __truncated__
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 14
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "builder.html"
#>   .. .. .. ..$ title  : chr "Create HTML tags"
#>   .. .. .. ..$ aliases: chr [1:19] "tags" "p()" "h1()" "h2()" ...
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "HTML.html"
#>   .. .. .. ..$ title  : chr "Mark Characters as HTML"
#>   .. .. .. ..$ aliases: chr "HTML()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "include.html"
#>   .. .. .. ..$ title  : chr "Include Content From a File"
#>   .. .. .. ..$ aliases: chr [1:5] "includeHTML()" "includeText()" "includeMarkdown()" "includeCSS()" ...
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "singleton.html"
#>   .. .. .. ..$ title  : chr "Include content only once"
#>   .. .. .. ..$ aliases: chr [1:2] "singleton()" "is.singleton()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "tagList.html"
#>   .. .. .. ..$ title  : chr "Create a list of tags"
#>   .. .. .. ..$ aliases: chr "tagList()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "tagAppendAttributes.html"
#>   .. .. .. ..$ title  : chr "Append tag attributes"
#>   .. .. .. ..$ aliases: chr [1:3] "tagAppendAttributes()" "tagHasAttribute()" "tagGetAttribute()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "tagAppendChild.html"
#>   .. .. .. ..$ title  : chr "Modify tag contents"
#>   .. .. .. ..$ aliases: chr [1:4] "tagAppendChild()" "tagAppendChildren()" "tagSetChildren()" "tagInsertChildren()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "validateCssUnit.html"
#>   .. .. .. ..$ title  : chr "Validate proper CSS formatting of a unit"
#>   .. .. .. ..$ aliases: chr "validateCssUnit()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "withTags.html"
#>   .. .. .. ..$ title  : chr "Evaluate an expression using <code>tags</code>"
#>   .. .. .. ..$ aliases: chr "withTags()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "htmlTemplate.html"
#>   .. .. .. ..$ title  : chr "Process an HTML template"
#>   .. .. .. ..$ aliases: chr "htmlTemplate()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "bootstrapLib.html"
#>   .. .. .. ..$ title  : chr "Bootstrap libraries"
#>   .. .. .. ..$ aliases: chr "bootstrapLib()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "suppressDependencies.html"
#>   .. .. .. ..$ title  : chr "Suppress web dependencies"
#>   .. .. .. ..$ aliases: chr "suppressDependencies()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "insertUI.html"
#>   .. .. .. ..$ title  : chr "Insert and remove UI objects"
#>   .. .. .. ..$ aliases: chr [1:2] "insertUI()" "removeUI()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "markdown.html"
#>   .. .. .. ..$ title  : chr "Insert inline Markdown"
#>   .. .. .. ..$ aliases: chr "markdown()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:14] "builder" "HTML" "include" "singleton" ...
#>   .. .. ..- attr(*, "names")= chr [1:14] "builder.Rd" "HTML.Rd" "include.Rd" "singleton.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Rendering functions"
#>   .. ..$ slug       : chr "rendering-functions"
#>   .. ..$ desc       : chr "<p>Functions that you use in your application’s server side code, assigning them to outputs that appear in your"| __truncated__
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 9
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "renderPlot.html"
#>   .. .. .. ..$ title  : chr "Plot Output"
#>   .. .. .. ..$ aliases: chr "renderPlot()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "renderCachedPlot.html"
#>   .. .. .. ..$ title  : chr "Plot output with cached images"
#>   .. .. .. ..$ aliases: chr "renderCachedPlot()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "renderPrint.html"
#>   .. .. .. ..$ title  : chr "Text Output"
#>   .. .. .. ..$ aliases: chr [1:2] "renderPrint()" "renderText()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "renderDataTable.html"
#>   .. .. .. ..$ title  : chr "Table output with the JavaScript DataTables library"
#>   .. .. .. ..$ aliases: chr [1:2] "dataTableOutput()" "renderDataTable()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "renderImage.html"
#>   .. .. .. ..$ title  : chr "Image file output"
#>   .. .. .. ..$ aliases: chr "renderImage()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "renderTable.html"
#>   .. .. .. ..$ title  : chr "Table Output"
#>   .. .. .. ..$ aliases: chr [1:2] "tableOutput()" "renderTable()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "renderUI.html"
#>   .. .. .. ..$ title  : chr "UI Output"
#>   .. .. .. ..$ aliases: chr "renderUI()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "downloadHandler.html"
#>   .. .. .. ..$ title  : chr "File Downloads"
#>   .. .. .. ..$ aliases: chr "downloadHandler()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "createRenderFunction.html"
#>   .. .. .. ..$ title  : chr "Implement custom render functions"
#>   .. .. .. ..$ aliases: chr [1:3] "createRenderFunction()" "quoToFunction()" "installExprFunction()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:9] "renderPlot" "renderCachedPlot" "renderPrint" "dataTableOutput" ...
#>   .. .. ..- attr(*, "names")= chr [1:9] "renderPlot.Rd" "renderCachedPlot.Rd" "renderPrint.Rd" "renderDataTable.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Reactive programming"
#>   .. ..$ slug       : chr "reactive-programming"
#>   .. ..$ desc       : chr "<p>A sub-library that provides reactive programming facilities for R.</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 18
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "reactive.html"
#>   .. .. .. ..$ title  : chr "Create a reactive expression"
#>   .. .. .. ..$ aliases: chr [1:2] "reactive()" "is.reactive()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "observe.html"
#>   .. .. .. ..$ title  : chr "Create a reactive observer"
#>   .. .. .. ..$ aliases: chr "observe()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "observeEvent.html"
#>   .. .. .. ..$ title  : chr "Event handler"
#>   .. .. .. ..$ aliases: chr [1:2] "observeEvent()" "eventReactive()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "reactiveVal.html"
#>   .. .. .. ..$ title  : chr "Create a (single) reactive value"
#>   .. .. .. ..$ aliases: chr "reactiveVal()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "reactiveValues.html"
#>   .. .. .. ..$ title  : chr "Create an object for storing reactive values"
#>   .. .. .. ..$ aliases: chr "reactiveValues()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "bindCache.html"
#>   .. .. .. ..$ title  : chr "Add caching with reactivity to an object"
#>   .. .. .. ..$ aliases: chr "bindCache()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "bindEvent.html"
#>   .. .. .. ..$ title  : chr "Make an object respond only to specified reactive events"
#>   .. .. .. ..$ aliases: chr "bindEvent()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "reactiveValuesToList.html"
#>   .. .. .. ..$ title  : chr "Convert a reactivevalues object to a list"
#>   .. .. .. ..$ aliases: chr "reactiveValuesToList()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "is.reactivevalues.html"
#>   .. .. .. ..$ title  : chr "Checks whether an object is a reactivevalues object"
#>   .. .. .. ..$ aliases: chr "is.reactivevalues()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "isolate.html"
#>   .. .. .. ..$ title  : chr "Create a non-reactive scope for an expression"
#>   .. .. .. ..$ aliases: chr "isolate()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "invalidateLater.html"
#>   .. .. .. ..$ title  : chr "Scheduled Invalidation"
#>   .. .. .. ..$ aliases: chr "invalidateLater()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "debounce.html"
#>   .. .. .. ..$ title  : chr "Slow down a reactive expression with debounce/throttle"
#>   .. .. .. ..$ aliases: chr [1:2] "debounce()" "throttle()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "reactlog.html"
#>   .. .. .. ..$ title  : chr "Reactive Log Visualizer"
#>   .. .. .. ..$ aliases: chr [1:3] "reactlog()" "reactlogShow()" "reactlogReset()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "reactiveFileReader.html"
#>   .. .. .. ..$ title  : chr "Reactive file reader"
#>   .. .. .. ..$ aliases: chr "reactiveFileReader()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "reactivePoll.html"
#>   .. .. .. ..$ title  : chr "Reactive polling"
#>   .. .. .. ..$ aliases: chr "reactivePoll()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "reactiveTimer.html"
#>   .. .. .. ..$ title  : chr "Timer"
#>   .. .. .. ..$ aliases: chr "reactiveTimer()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "domains.html"
#>   .. .. .. ..$ title  : chr "Reactive domains"
#>   .. .. .. ..$ aliases: chr [1:3] "getDefaultReactiveDomain()" "withReactiveDomain()" "onReactiveDomainEnded()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "freezeReactiveValue.html"
#>   .. .. .. ..$ title  : chr "Freeze a reactive value"
#>   .. .. .. ..$ aliases: chr [1:2] "freezeReactiveVal()" "freezeReactiveValue()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:18] "reactive" "observe" "observeEvent" "reactiveVal" ...
#>   .. .. ..- attr(*, "names")= chr [1:18] "reactive.Rd" "observe.Rd" "observeEvent.Rd" "reactiveVal.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Running"
#>   .. ..$ slug       : chr "running"
#>   .. ..$ desc       : chr "<p>Functions that are used to run or stop Shiny applications.</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 8
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "runApp.html"
#>   .. .. .. ..$ title  : chr "Run Shiny Application"
#>   .. .. .. ..$ aliases: chr "runApp()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "runGadget.html"
#>   .. .. .. ..$ title  : chr "Run a gadget"
#>   .. .. .. ..$ aliases: chr "runGadget()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "runExample.html"
#>   .. .. .. ..$ title  : chr "Run Shiny Example Applications"
#>   .. .. .. ..$ aliases: chr "runExample()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "runUrl.html"
#>   .. .. .. ..$ title  : chr "Run a Shiny application from a URL"
#>   .. .. .. ..$ aliases: chr [1:3] "runUrl()" "runGist()" "runGitHub()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "stopApp.html"
#>   .. .. .. ..$ title  : chr "Stop the currently running Shiny app"
#>   .. .. .. ..$ aliases: chr "stopApp()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "viewer.html"
#>   .. .. .. ..$ title  : chr "Viewer options"
#>   .. .. .. ..$ aliases: chr [1:3] "paneViewer()" "dialogViewer()" "browserViewer()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "isRunning.html"
#>   .. .. .. ..$ title  : chr "Check whether a Shiny application is running"
#>   .. .. .. ..$ aliases: chr "isRunning()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "loadSupport.html"
#>   .. .. .. ..$ title  : chr "Load an app's supporting R files"
#>   .. .. .. ..$ aliases: chr "loadSupport()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:8] "runApp" "runGadget" "runExample" "runUrl" ...
#>   .. .. ..- attr(*, "names")= chr [1:8] "runApp.Rd" "runGadget.Rd" "runExample.Rd" "runUrl.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Bookmarking state"
#>   .. ..$ slug       : chr "bookmarking-state"
#>   .. ..$ desc       : chr "<p>Functions that are used for bookmarking and restoring state.</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 5
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "bookmarkButton.html"
#>   .. .. .. ..$ title  : chr "Create a button for bookmarking/sharing"
#>   .. .. .. ..$ aliases: chr "bookmarkButton()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "enableBookmarking.html"
#>   .. .. .. ..$ title  : chr "Enable bookmarking for a Shiny application"
#>   .. .. .. ..$ aliases: chr "enableBookmarking()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "setBookmarkExclude.html"
#>   .. .. .. ..$ title  : chr "Exclude inputs from bookmarking"
#>   .. .. .. ..$ aliases: chr "setBookmarkExclude()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "showBookmarkUrlModal.html"
#>   .. .. .. ..$ title  : chr "Display a modal dialog for bookmarking"
#>   .. .. .. ..$ aliases: chr "showBookmarkUrlModal()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "onBookmark.html"
#>   .. .. .. ..$ title  : chr "Add callbacks for Shiny session bookmarking events"
#>   .. .. .. ..$ aliases: chr [1:4] "onBookmark()" "onBookmarked()" "onRestore()" "onRestored()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:5] "bookmarkButton" "enableBookmarking" "setBookmarkExclude" "showBookmarkUrlModal" ...
#>   .. .. ..- attr(*, "names")= chr [1:5] "bookmarkButton.Rd" "enableBookmarking.Rd" "setBookmarkExclude.Rd" "showBookmarkUrlModal.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Extending Shiny"
#>   .. ..$ slug       : chr "extending-shiny"
#>   .. ..$ desc       : chr "<p>Functions that are intended to be called by third-party packages that extend Shiny.</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 5
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "createWebDependency.html"
#>   .. .. .. ..$ title  : chr "Create a web dependency"
#>   .. .. .. ..$ aliases: chr "createWebDependency()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "resourcePaths.html"
#>   .. .. .. ..$ title  : chr "Resource Publishing"
#>   .. .. .. ..$ aliases: chr [1:3] "addResourcePath()" "resourcePaths()" "removeResourcePath()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "registerInputHandler.html"
#>   .. .. .. ..$ title  : chr "Register an Input Handler"
#>   .. .. .. ..$ aliases: chr "registerInputHandler()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "removeInputHandler.html"
#>   .. .. .. ..$ title  : chr "Deregister an Input Handler"
#>   .. .. .. ..$ aliases: chr "removeInputHandler()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "markRenderFunction.html"
#>   .. .. .. ..$ title  : chr "Mark a function as a render function"
#>   .. .. .. ..$ aliases: chr "markRenderFunction()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:5] "createWebDependency" "addResourcePath" "registerInputHandler" "removeInputHandler" ...
#>   .. .. ..- attr(*, "names")= chr [1:5] "createWebDependency.Rd" "resourcePaths.Rd" "registerInputHandler.Rd" "removeInputHandler.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Utility functions"
#>   .. ..$ slug       : chr "utility-functions"
#>   .. ..$ desc       : chr "<p>Miscellaneous utilities that may be useful to advanced users or when extending Shiny.</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 25
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "devmode.html"
#>   .. .. .. ..$ title  : chr "Shiny Developer Mode"
#>   .. .. .. ..$ aliases: chr [1:6] "devmode()" "in_devmode()" "with_devmode()" "devmode_inform()" ...
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "shinyAppTemplate.html"
#>   .. .. .. ..$ title  : chr "Generate a Shiny application from a template"
#>   .. .. .. ..$ aliases: chr "shinyAppTemplate()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "req.html"
#>   .. .. .. ..$ title  : chr "Check for required values"
#>   .. .. .. ..$ aliases: chr "req()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "isTruthy.html"
#>   .. .. .. ..$ title  : chr "Truthy and falsy values"
#>   .. .. .. ..$ aliases: chr "isTruthy()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "validate.html"
#>   .. .. .. ..$ title  : chr "Validate input values and other conditions"
#>   .. .. .. ..$ aliases: chr [1:2] "validate()" "need()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "session.html"
#>   .. .. .. ..$ title  : chr "Session object"
#>   .. .. .. ..$ aliases: chr "session"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "shinyOptions.html"
#>   .. .. .. ..$ title  : chr "Get or set Shiny options"
#>   .. .. .. ..$ aliases: chr [1:2] "getShinyOption()" "shinyOptions()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "safeError.html"
#>   .. .. .. ..$ title  : chr "Declare an error safe for the user to see"
#>   .. .. .. ..$ aliases: chr "safeError()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "onFlush.html"
#>   .. .. .. ..$ title  : chr "Add callbacks for Shiny session events"
#>   .. .. .. ..$ aliases: chr [1:3] "onFlush()" "onFlushed()" "onSessionEnded()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "restoreInput.html"
#>   .. .. .. ..$ title  : chr "Restore an input value"
#>   .. .. .. ..$ aliases: chr "restoreInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "applyInputHandlers.html"
#>   .. .. .. ..$ title  : chr "Apply input handlers to raw input values"
#>   .. .. .. ..$ aliases: chr "applyInputHandlers()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "parseQueryString.html"
#>   .. .. .. ..$ title  : chr "Parse a GET query string from a URL"
#>   .. .. .. ..$ aliases: chr "parseQueryString()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "getCurrentOutputInfo.html"
#>   .. .. .. ..$ title  : chr "Get output information"
#>   .. .. .. ..$ aliases: chr "getCurrentOutputInfo()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "plotPNG.html"
#>   .. .. .. ..$ title  : chr "Capture a plot as a PNG file."
#>   .. .. .. ..$ aliases: chr "plotPNG()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "sizeGrowthRatio.html"
#>   .. .. .. ..$ title  : chr "Create a sizing function that grows at a given ratio"
#>   .. .. .. ..$ aliases: chr "sizeGrowthRatio()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "exportTestValues.html"
#>   .. .. .. ..$ title  : chr "Register expressions for export in test mode"
#>   .. .. .. ..$ aliases: chr "exportTestValues()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "setSerializer.html"
#>   .. .. .. ..$ title  : chr "Add a function for serializing an input before bookmarking application state"
#>   .. .. .. ..$ aliases: chr "setSerializer()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "snapshotExclude.html"
#>   .. .. .. ..$ title  : chr "Mark an output to be excluded from test snapshots"
#>   .. .. .. ..$ aliases: chr "snapshotExclude()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "snapshotPreprocessInput.html"
#>   .. .. .. ..$ title  : chr "Add a function for preprocessing an input before taking a test snapshot"
#>   .. .. .. ..$ aliases: chr "snapshotPreprocessInput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "snapshotPreprocessOutput.html"
#>   .. .. .. ..$ title  : chr "Add a function for preprocessing an output before taking a test snapshot"
#>   .. .. .. ..$ aliases: chr "snapshotPreprocessOutput()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "repeatable.html"
#>   .. .. .. ..$ title  : chr "Make a random number generator repeatable"
#>   .. .. .. ..$ aliases: chr "repeatable()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "serverInfo.html"
#>   .. .. .. ..$ title  : chr "Collect information about the Shiny Server environment"
#>   .. .. .. ..$ aliases: chr "serverInfo()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "onStop.html"
#>   .. .. .. ..$ title  : chr "Run code after an application or session ends"
#>   .. .. .. ..$ aliases: chr "onStop()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "httpResponse.html"
#>   .. .. .. ..$ title  : chr "Create an HTTP response object"
#>   .. .. .. ..$ aliases: chr "httpResponse()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "key_missing.html"
#>   .. .. .. ..$ title  : chr "A missing key object"
#>   .. .. .. ..$ aliases: chr [1:2] "key_missing()" "is.key_missing()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:25] "devmode" "shinyAppTemplate" "req" "isTruthy" ...
#>   .. .. ..- attr(*, "names")= chr [1:25] "devmode.Rd" "shinyAppTemplate.Rd" "req.Rd" "isTruthy.Rd" ...
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Plot interaction"
#>   .. ..$ slug       : chr "plot-interaction"
#>   .. ..$ desc       : chr "<p>Functions related to interactive plots</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 3
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "brushedPoints.html"
#>   .. .. .. ..$ title  : chr "Find rows of data selected on an interactive plot."
#>   .. .. .. ..$ aliases: chr [1:2] "brushedPoints()" "nearPoints()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "brushOpts.html"
#>   .. .. .. ..$ title  : chr "Create an object representing brushing options"
#>   .. .. .. ..$ aliases: chr "brushOpts()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "clickOpts.html"
#>   .. .. .. ..$ title  : chr "Control interactive plot point events"
#>   .. .. .. ..$ aliases: chr [1:3] "clickOpts()" "dblclickOpts()" "hoverOpts()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:3] "brushedPoints" "brushOpts" "clickOpts"
#>   .. .. ..- attr(*, "names")= chr [1:3] "brushedPoints.Rd" "brushOpts.Rd" "clickOpts.Rd"
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Modules"
#>   .. ..$ slug       : chr "modules"
#>   .. ..$ desc       : chr "<p>Functions for modularizing Shiny apps</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 3
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "NS.html"
#>   .. .. .. ..$ title  : chr "Namespaced IDs for inputs/outputs"
#>   .. .. .. ..$ aliases: chr [1:2] "NS()" "ns.sep"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "moduleServer.html"
#>   .. .. .. ..$ title  : chr "Shiny modules"
#>   .. .. .. ..$ aliases: chr "moduleServer()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "callModule.html"
#>   .. .. .. ..$ title  : chr "Invoke a Shiny module"
#>   .. .. .. ..$ aliases: chr "callModule()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:3] "NS" "moduleServer" "callModule"
#>   .. .. ..- attr(*, "names")= chr [1:3] "NS.Rd" "moduleServer.Rd" "callModule.Rd"
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Embedding"
#>   .. ..$ slug       : chr "embedding"
#>   .. ..$ desc       : chr "<p>Functions that are intended for third-party packages that embed Shiny applications.</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 2
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "shinyApp.html"
#>   .. .. .. ..$ title  : chr "Create a Shiny app object"
#>   .. .. .. ..$ aliases: chr [1:3] "shinyApp()" "shinyAppDir()" "shinyAppFile()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "maskReactiveContext.html"
#>   .. .. .. ..$ title  : chr "Evaluate an expression without a reactive context"
#>   .. .. .. ..$ aliases: chr "maskReactiveContext()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:2] "shinyApp" "maskReactiveContext"
#>   .. .. ..- attr(*, "names")= chr [1:2] "shinyApp.Rd" "maskReactiveContext.Rd"
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Testing"
#>   .. ..$ slug       : chr "testing"
#>   .. ..$ desc       : chr "<p>Functions intended for testing of Shiny components</p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 3
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "runTests.html"
#>   .. .. .. ..$ title  : chr "Runs the tests associated with this Shiny app"
#>   .. .. .. ..$ aliases: chr "runTests()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "testServer.html"
#>   .. .. .. ..$ title  : chr "Reactive testing for Shiny server functions and modules"
#>   .. .. .. ..$ aliases: chr "testServer()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "MockShinySession.html"
#>   .. .. .. ..$ title  : chr "Mock Shiny Session"
#>   .. .. .. ..$ aliases: chr "MockShinySession"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:3] "runTests" "testServer" "MockShinySession"
#>   .. .. ..- attr(*, "names")= chr [1:3] "runTests.Rd" "testServer.Rd" "MockShinySession.Rd"
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>   ..$ :List of 4
#>   .. ..$ title      : chr "Superseded"
#>   .. ..$ slug       : chr "superseded"
#>   .. ..$ desc       : chr "<p>Functions that have been <code>r lifecycle::badge(\"superseded\")</code></p>"
#>   .. ..$ is_internal: logi FALSE
#>   ..$ :List of 4
#>   .. ..$ topics       :List of 4
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "markRenderFunction.html"
#>   .. .. .. ..$ title  : chr "Mark a function as a render function"
#>   .. .. .. ..$ aliases: chr "markRenderFunction()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "shinyUI.html"
#>   .. .. .. ..$ title  : chr "Create a Shiny UI handler"
#>   .. .. .. ..$ aliases: chr "shinyUI()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "shinyServer.html"
#>   .. .. .. ..$ title  : chr "Define Server Functionality"
#>   .. .. .. ..$ aliases: chr "shinyServer()"
#>   .. .. .. ..$ icon   : NULL
#>   .. .. ..$ :List of 4
#>   .. .. .. ..$ path   : chr "exprToFunction.html"
#>   .. .. .. ..$ title  : chr "Convert an expression to a function"
#>   .. .. .. ..$ aliases: chr "exprToFunction()"
#>   .. .. .. ..$ icon   : NULL
#>   .. ..$ names        : Named chr [1:4] "markRenderFunction" "shinyUI" "shinyServer" "exprToFunction"
#>   .. .. ..- attr(*, "names")= chr [1:4] "markRenderFunction.Rd" "shinyUI.Rd" "shinyServer.Rd" "exprToFunction.Rd"
#>   .. ..$ row_has_icons: logi FALSE
#>   .. ..$ is_internal  : logi FALSE
#>  $ has_icons: logi FALSE
#>  - attr(*, "class")= chr "print_yaml"
