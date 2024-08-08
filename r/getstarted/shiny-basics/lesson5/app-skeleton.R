
# A place to put code

ui <- fluidpage(
  
)

server <- function(input, output) {
  
  # Another place to put code
  
  output$map <- renderPlot({
    
    # A third place to put code
    
  })
}

shinyApp(ui, server)

