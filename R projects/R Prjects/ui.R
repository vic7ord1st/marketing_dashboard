library(shinydashboard)
library(plotly)

ui <- dashboardPage(
  dashboardHeader(title = 'Marketing Website Summary'),
  dashboardSidebar(
    sidebarMenu(
      menuItem(text = 'Audience', tabName = 'audience'),
      menuItem(text = 'Ads Information', tabName = 'adsInformation' )
    )
  ),
  dashboardBody(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
    tabItems(
      tabItem(
        tabName = 'audience',
        column(
          fluidRow(
            valueBoxOutput('Users'),
            valueBoxOutput('Sessions'),
            valueBoxOutput('PageViews'),
            valueBoxOutput('NewUsers')
          ),
          column(
            fluidRow(
              box(title = 'How are sessions trending?',
                  plotlyOutput('sessionsPlot', height = 250, width = '100%'), width = '100%'
              )
            ),
            fluidRow(
              box(title = 'Which channels are driving engagement?',
                  plotlyOutput('engagement', height = 250, width = '100%'), width = '100%')
            ),
            
            box(title = 'Engagement By Age',
                plotlyOutput('engagementPlot', height = 250, width = '100%'), width = '100%'
            )
            , width = 6
          ),
          column(
            fluidRow(
              box(title = 'What are the top countries by sessions?',
                  plotlyOutput('sessionsMap', height = 250, width = '100%'),width = '100%'
              ),
              box(title = 'Engagement By Gender',
                  plotlyOutput('engagementByAge', height = 250, width = '100%'),width = '100%'
              ),
              box(title = "Engagement by Devices",
                  plotlyOutput('mobile', height = 250, width = '100%'), width = '100%'
              )
            ), width = 6
          ), width = 12
        )
      ),
      tabItem( tabName = 'adsInformation',
          h2('Click Through Rate, Conversion Rate & Cost Analysis'),
          fluidRow(
                valueBoxOutput('clicks'),
                valueBoxOutput('ctr'),
                valueBoxOutput('conversion'),
                valueBoxOutput('conversionRate'),
                valueBoxOutput('costConver'),
                valueBoxOutput('avgCostPerClick'),
                valueBoxOutput('avgCPM'),
                
              ),
          fluidRow(
            column(
              box(
                  plotlyOutput('clicksCTR', height = 250, width = '100%'), width = '100%'
              ), width = 4
            ),
            column(
              box(
                  plotlyOutput('convRate',  height = 250, width = '100%'), width = '100%'
                ), width = 4
              ),
            column(
              box(
                  plotlyOutput('costClick',  height = 250, width = '100%'), width = '100%'
              ), width = 4
            )
            ),
          fluidRow(
            h2('Device Breakdown'),
            p("by Clicks, Cost, and Conversions"),
            column(
              box(
                plotlyOutput('deviceClicks',  height = 250, width = '100%'), width = '100%'
              ), width = 4
            ),
            column(
              box(
                plotlyOutput('deviceConversion',  height = 250, width = '100%'), width = '100%'
              ), width = 4
            ),
            column(
              box(
                plotlyOutput('deviceCost',  height = 250, width = '100%'), width = '100%'
              ), width = 4
            )
          )
          )
        )
      )
    )
