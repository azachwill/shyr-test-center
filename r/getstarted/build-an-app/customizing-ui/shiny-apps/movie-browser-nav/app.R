#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(tidyverse)

load("movies.RData")

# Define UI for application that draws a histogram
ui <- page_sidebar(
  title = "Movie browser, 1970 to 2014",
  window_title = "Movies",
  sidebar = sidebar(
      checkboxGroupInput(
        inputId = "type",
        label = "Title type:",
        choices = levels(movies$title_type),
        selected = "Feature Film"
      )
    ),
  navset_pill_list(

    nav_panel("Plot", plotOutput("plot")),

    nav_panel("Summary", tableOutput("summary")),

    nav_panel("Data", DT::dataTableOutput("data")),

    nav_panel(
      "Reference",
      markdown(
        glue::glue(
          "These data were obtained from [IMDB](http://www.imdb.com/) and [Rotten Tomatoes](https://www.rottentomatoes.com/).

        The data represent {nrow(movies)} randomly sampled movies released between 1972 to 2014 in the United States.
        "
        )
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  load("movies.RData")

  movies_subset <- reactive({
    movies %>%
      filter(title_type %in% input$type)
  })

  output$plot <- renderPlot({
    ggplot(movies_subset(), aes(x = critics_score, y = audience_score, color = mpaa_rating)) +
      geom_point()
  })
  output$summary <- renderTable(
    {
      movies_subset() %>%
        group_by(mpaa_rating) %>%
        summarise(
          mean_as = mean(audience_score), sd_as = sd(audience_score),
          mean_cs = mean(critics_score), sd_cs = sd(critics_score),
          n = n(), cor = cor(audience_score, critics_score)
        )
    },
    digits = 3
  )
  output$data <- DT::renderDataTable({
    movies_subset() %>%
      DT::datatable(options = list(pageLength = 10), rownames = FALSE)
  })

}

# Run the application
shinyApp(ui = ui, server = server)
