# server.R

library(shiny)
library(quantmod)
source("helper.R")


shinyServer(function(input, output) {
  
  dataInput <- reactive({  
    if(input$get == 0) return(NULL)
    
    isolate({
      print("getting symbols")
      getSymbols(input$symb, src = "yahoo", 
                 from = input$dates[1],
                 to = input$dates[2],
                 auto.assign = FALSE)
    })
  })
  
  finalInput <- reactive({
    print("getting final input")
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })
  
  output$plot <- renderPlot({
    if(input$get == 0) return(NULL)
    
    print("charting series")
    chartSeries(finalInput(), theme = chartTheme("white"), 
                type = "line", log.scale = input$log, TA = NULL)
  })
})