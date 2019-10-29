
setwd('C:/Users/CRUSADR/Documents/R')
analyticsLocationData <- read.csv('analytics-location.csv')
analyticsLocationData <- analyticsLocationData[, -c(8:10), drop = FALSE]

library(shinydashboard)
library(shiny)
header <- dashboardHeader(title = 'google analytics dashboard')
body <- dashboardBody(
  fluidRow(
    column(width = 3,
      box(
        title = 'Users',
        textOutput(outputId = 'users')
      )
    ),
    column(width = 3,
      box(
        title = 'Sessions',
        textOutput(outputId = 'sessions')
      )
    ),
    column(width = 3,
      box(
        title = 'Page Views',
        textOutput(outputId = 'pageviews')
      )
    ),
    column(width = 3,
      box(
        title = 'Bounce Rate',
        textOutput(outputId = 'bounce_rate')
      )
    )
   
  )
)
ui <- dashboardPage(
  header = header,
  sidebar = dashboardSidebar(),
  body = body
)

server<- function(input, output){
  output$users <-renderText(sum(analyticsLocationData$Users, na.rm = TRUE))
    
  output$sessions <- renderText(sum(analyticsLocationData$Sessions, na.rm = TRUE))
}
shinyApp(ui, server)