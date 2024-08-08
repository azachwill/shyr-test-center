library(shiny)

# Define UI ----
ui <- page_sidebar(
  title = "My Shiny App",
  sidebar = sidebar(
    "Shiny is available on CRAN, so you can install it in the usual way from your R console:",
    code('install.packages("shiny")'),
  ),
  card(
    card_header("Introducing Shiny"),
    "Shiny is a package from Posit that makes it incredibly easy to build interactive web applications with R.
    For an introduction and live examples, visit the Shiny homepage (https://shiny.posit.co).",
    card_image("www/shiny.svg", height = "300px"),
    card_footer("Shiny is a product of Posit.")
  )
)

# Define server logic ----
server <- function(input, output) {

}

# Run the app ----
shinyApp(ui = ui, server = server)