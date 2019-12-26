setwd('C:/Users/CRUSADR/Documents/R/R projects')
library(shiny)
source('ui.R', local = TRUE)
source('server.R', local = TRUE)

shinyApp(ui = ui, server = server )
