library(shiny)
library(bslib)

ui <- page_fluid(
  p("The time is ", textOutput("current_time", inline=TRUE)),
  hr(),
  numericInput("x", "x", value = 1),
  numericInput("y", "y", value = 2),
  input_task_button("btn", "Add numbers"),
  textOutput("sum")
)

server <- function(input, output, session) {
  output$current_time <- renderText({
    invalidateLater(1000)
    format(Sys.time(), "%H:%M:%S %p")
  })

  sum_values <- eventReactive(input$btn, {
    Sys.sleep(5)
    input$x + input$y
  })

  output$sum <- renderText({
    sum_values()
  })
}

shinyApp(ui, server)