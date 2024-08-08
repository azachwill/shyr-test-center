library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "My dashboard",
  sidebar = sidebar(
    title = "Settings",
    sliderInput("n", "Observations", 1, 100, 50, ticks = FALSE),
    sliderInput("bins", "Bins", 1, 10, 5, step = 1, ticks = FALSE),
  ),
  plotOutput("plot")
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    hist(rnorm(input$n), breaks = input$bins, col = "#007bc2")
  })
}

shinyApp(ui, server)
