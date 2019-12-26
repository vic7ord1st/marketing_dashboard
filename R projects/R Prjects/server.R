library(plotly)
plotdata <- read.csv('plotdata.csv')
clicksByDevice <-read.csv('clicks by device.csv')
conversionByDevice <- read.csv('conversion by device.csv')
costByDevice <- read.csv('cost by device.csv')
engagementByGender<-read.csv('engagement by gender.csv')
engagementByAge <- read.csv('engagement by age.csv')
mobile <- read.csv('mobileData.csv')
adsData <- read.csv('AdsData.csv')
adsData$Day<-as.Date(adsData$Day, format = "%m/%d/%Y")
maleEngagement <- engagementByAge[engagementByAge$Gender == 'male',]
femaleEngagement <- engagementByAge[engagementByAge$Gender == 'female',]
dateSession <- read.csv('dateSession.csv')
channelData <- read.csv('channelData.csv')
channelData<-channelData[order(-channelData$Sessions, -channelData$Pageviews),]




server <- function(input, output){
  output$Users <- renderValueBox({
    valueBox(
      paste0(sum(plotdata$Users, na.rm = TRUE)), 'Users')
  })
  
  output$Sessions <- renderValueBox({
    valueBox(
      paste0(sum(plotdata$Sessions, na.rm = TRUE)), 'Sessions')
  })
  
  output$PageViews <- renderValueBox({
    valueBox(
      paste0(sum(plotdata$Pageviews, na.rm = TRUE)), 'Page Views')
  })
  
  output$NewUsers <- renderValueBox({
    valueBox(
      paste0(sum(plotdata$new.users, na.rm = TRUE)), 'New Users')
  })
  
  output$sessionsPlot <- renderPlotly({
    plot_ly(dateSession, x = ~Date, y = ~Session, type = 'scatter', mode = 'lines', line = list(color = 'rgba(0,131,143,1)', width = 2))%>%layout(xaxis = list(title = '', showgrid = FALSE, showline = TRUE, type='date', tickformat='%d %b', tickangle = -90), yaxis = list(title = '', showgrid = FALSE))%>%layout(plot_bgcolor='rgb(236, 240, 245)') %>%layout(paper_bgcolor='rgb(236, 240, 245)')
  })
  
  output$sessionsMap <- renderPlotly({
    plot_geo(plotdata) %>%
      add_trace(
        z = ~Sessions, color = ~Sessions, colors = 'Blues',
        text = ~Country, locations = ~Code, marker = list(line = list(color = toRGB("grey"), width = 0.5))
      ) %>%
      colorbar(title = '') %>%
      layout(
        geo = list(
          showframe = FALSE,
          showcoastlines = FALSE,
          projection = list(type = 'Mercator')
        )
      )
  })
  
  output$engagement <- renderPlotly({
    plot_ly(channelData, y = ~Default.Channel.Grouping, x = ~Sessions, type = 'bar', name = 'Sessions', marker = list(color = 'rgb(244, 67, 54)')) %>%
      add_trace(x = ~Pageviews, name = 'Pageviews', marker = list(color = 'rgb(0, 172, 193)')) %>%
      layout(yaxis = list(title = ''), barmode = 'group')%>%layout(xaxis = list(title = '', showgrid = FALSE, showline = FALSE, tickangle = -45), yaxis = list(title = '', showgrid = FALSE, categoryorder = 'category ascending', categoryarray = ~Default.Channel.Grouping))%>%layout(plot_bgcolor='rgb(236, 240, 245)') %>%layout(paper_bgcolor='rgb(236, 240, 245)')
  })
  
  output$engagementByAge <- renderPlotly({
      plot_ly(labels = engagementByGender$Gender, values = engagementByGender$Pageviews, marker = list(colors = c('rgb(0, 188, 212)', 'rgb(115, 218, 231)'))) %>%
        add_pie(hole = 0.6) %>%
        layout(showlegend = TRUE,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  output$engagementPlot <- renderPlotly({
    plot_ly(engagementByAge, y = engagementByAge$Age, x = engagementByAge[engagementByAge$Gender == 'male',], type = 'bar', name = 'Male', marker= list(color = 'rgb(0, 188, 212)'))%>%add_trace(x = engagementByAge[engagementByAge$Gender == 'female',], name = 'Female', marker = list(color = 'rgb(115, 218, 231)'))%>%layout(xaxis = list(title = ''), barmode = 'stack')%>%layout(plot_bgcolor='rgb(236, 240, 245)') %>%layout(paper_bgcolor='rgb(236, 240, 245)')
    
  })
  
  output$mobile <- renderPlotly({
    plot_ly(labels = mobile$Devices, values = mobile$Sessions, marker = list(colors = c('rgb(0, 188, 212)', 'rgb(115, 218, 231)'))) %>%
      add_pie(hole = 0.6) %>%
      layout(showlegend = TRUE,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  })
  
  
  output$clicks <- renderValueBox({
    valueBox(paste0(sum(adsData$Clicks)), 'Clicks')
  })
  
  output$ctr <- renderValueBox({
    valueBox(paste0(sum(round(adsData$CTR, 1)), '%', sep=''), 'CTR')
  })
  
  output$conversion <- renderValueBox({
    valueBox(paste0(sum(round(adsData$Conversions, 2)), sep=''), 'Conversion')
  })
  
  output$conversionRate <- renderValueBox({
    valueBox(paste0(sum(round(adsData$Conv..rate, 1)), '%', sep=''), 'Conv. Rate')
  })
  
  output$costConver <- renderValueBox({
    valueBox(paste0('$',round(sum(adsData$Cost)/sum(adsData$Conversions), 3), sep=''), 'Cost/Conv')
  })
  
  
  output$avgCostPerClick <- renderValueBox({
    valueBox(paste0('$',round(mean(adsData$Avg..CPC), 2), sep=''), 'Avg. Cost ')
  })
  
  output$clicksCTR <- renderPlotly({
    plot_ly(adsData, x = ~Day, y = ~Clicks, type = 'scatter', mode = 'lines', name = "Clicks", line = list(color = 'rgba(0,131,143,1)', width = 2))%>%add_lines(x = ~Day, y = ~CTR*100, name = "CTR", line = list(color = 'rgba(73,162,76,1)', width = 2))%>%layout(xaxis = list(title = '', showgrid = FALSE, showline = FALSE, type='date', tickformat='%d %b', tickangle = -90, tickfont = list(size = 10, color = "white")), yaxis = list(title = '', showgrid = FALSE, tickfont = list(size = 10, color = "white")))%>%layout(plot_bgcolor='rgb(41, 41, 41)') %>%layout(paper_bgcolor='rgb(41, 41, 41)')%>%layout(legend = list(orientation = "h", y = 1, font = list(color = "#FFF", size = 8)))
  })
  
  output$convRate <- renderPlotly({
    plot_ly(adsData, x = ~Day, y = ~Conversions, type = 'scatter', mode = 'lines', name = "Conv", line = list(color = 'rgba(0,131,143,1)', width = 2))%>%add_lines(x = ~Day, y = ~Conv..rate*100, name = "Conv. Rate", line = list(color = 'rgba(73,162,76,1)', width = 2))%>%layout(xaxis = list(title = '', showgrid = FALSE, showline = FALSE, type='date', tickformat='%d %b', tickangle = -90, tickfont = list(size = 10, color = "white")), yaxis = list(title = '', showgrid = FALSE, tickfont = list(size = 10, color = "white")))%>%layout(plot_bgcolor='rgb(41, 41, 41)') %>%layout(paper_bgcolor='rgb(41, 41, 41)')%>%layout(legend = list(orientation = "h", y = 1, font = list(color = "#FFF", size = 8)))
  })
  
  output$costClick <- renderPlotly({
    plot_ly(adsData, x = ~Day, y = ~Cost, type = 'scatter', mode = 'lines', name = "Cost", line = list(color = 'rgba(0,131,143,1)', width = 2))%>%add_lines(x = ~Day, y = ~Avg..CPC, name = "Avg CPC", line = list(color = 'rgba(73,162,76,1)', width = 2))%>%layout(xaxis = list(title = '', showgrid = FALSE, showline = FALSE, type='date', tickformat='%d %b', tickangle = -90, tickfont = list(size = 10, color = "white")), yaxis = list(title = '', showgrid = FALSE, tickfont = list(size = 10, color = "white")))%>%layout(plot_bgcolor='rgb(41, 41, 41)') %>%layout(paper_bgcolor='rgb(41, 41, 41)')%>%layout(legend = list(orientation = "h", y = 1,  font = list(color = "#FFF", size = 8)))
  })
  
  
  output$deviceClicks <- renderPlotly({
    plot_ly(labels = clicksByDevice$Device, values = clicksByDevice$Clicks, marker = list(colors = c('rgb(0, 188, 212)', 'rgb(115, 218, 231)', 'rgb(73,162,76)')), textfont = list(color = '#FFFFFF', size = 16)) %>%
      add_pie(hole = 0.6) %>%
      layout(showlegend = FALSE,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE), paper_bgcolor='rgba(41, 41, 41, 1)')
  })
  
  output$deviceConversion <- renderPlotly({
      plot_ly(labels = conversionByDevice$Device, values = conversionByDevice$Conversions, marker = list(colors = c('rgb(0, 188, 212)', 'rgb(115, 218, 231)', 'rgb(73,162,76)')), textfont = list(color = '#FFFFFF', size = 16)) %>%
        add_pie(hole = 0.6) %>%
        layout(showlegend = FALSE,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE), paper_bgcolor='rgba(41, 41, 41, 1)')
    })
  
  output$deviceCost <- renderPlotly({
      plot_ly(labels = costByDevice$Device, values = costByDevice$Cost, marker = list(colors = c('rgb(0, 188, 212)', 'rgb(115, 218, 231)', 'rgb(73,162,76)')),  textfont = list(color = '#FFFFFF', size = 16)) %>%
        add_pie(hole = 0.6) %>%
        layout(showlegend = FALSE,
               xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
               yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE), paper_bgcolor='rgba(41, 41, 41, 1)')
    })
} 