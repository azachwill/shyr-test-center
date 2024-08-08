library(shiny)
library(bslib)

# Define UI ----
ui <- page_sidebar(
  title = "My Shiny App",
  sidebar = sidebar(),
  card_image("www/shiny.svg", height = "300px"),
)

# Define server logic ----
server <- function(input, output) {

}

# Run the app ----
shinyApp(ui = ui, server = server)
