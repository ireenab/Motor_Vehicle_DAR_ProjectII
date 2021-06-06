#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
#narm_fcv = read.csv(file ="./narm_fcv.csv")
shinyUI(fluidPage(

    # Application title
    titlePanel("NYC Motor Vehicle Collision Data Analysis"),
     # navlistPanel("Collisions by timeframe",
    tabsetPanel(
        tabPanel("Collisions", fluid = TRUE,
                 sidebarLayout(
                     sidebarPanel(selectizeInput(inputId = "timeframe",
                                                 label = "Time Frame",
                                                 choices = c("Year", "Month", "Weekday", "Hour", "30min"))
                     ),
                     mainPanel(plotOutput("distPlot")
                               )
                     )
                 ),
        tabPanel("Victims", fluid = TRUE,
                 sidebarLayout(
                     sidebarPanel(radioButtons(inputId = "severity",
                                               label ="Accidents Severity",
                                               choices =c("Fatalities", "Injuries"),
                                               selected = "Injuries")
                     ),
                     mainPanel(plotOutput("livePlot"), br(), br(), plotOutput("livePlotFacet")
                     )
                 )
        ),
        tabPanel("Causes", fluid = TRUE,
                 sidebarLayout(
                     sidebarPanel(
                         selectizeInput(inputId = "borough",
                                                 label = "Borough",
                                                 choices = c("Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island")
                                        ),
                          sliderInput(inputId = "causes_rank",
                                      label = "Display Top 'N' Causes",
                                      min =1, max=30, value = 5)
                     ),
                     mainPanel(plotOutput("causesPlot")
                     )
                 )
        )
    )
)
)
        