library(shiny)
library(bslib)
library(mirai)
library(promises)

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
    x <- input$x
    y <- + input$y
    mirai({
        Sys.sleep(5)
        x + y
    }, x=x, y=y) |> as.promise()
  })

  output$sum <- renderText({
    sum_values()
  })
}

shinyApp(ui, server)