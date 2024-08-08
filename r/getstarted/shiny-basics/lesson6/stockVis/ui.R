library(shiny)
library(bslib)

page_sidebar(
  title = "stockVis",

  sidebar = sidebar(
    helpText("Select a stock to examine.

        Information will be collected from Yahoo finance."),
    textInput("symb", "Symbol", "SPY"),

    dateRangeInput("dates",
                   "Date range",
                   start = "2013-01-01",
                   end = as.character(Sys.Date())),

    br(),
    br(),

    checkboxInput("log", "Plot y axis on log scale",
                  value = FALSE),

    checkboxInput("adjust",
                  "Adjust prices for inflation", value = FALSE)
  ),

  card(
    card_header("Price over time"),
    plotOutput("plot")
  )
)
