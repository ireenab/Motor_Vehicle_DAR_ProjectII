#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# library(shiny)
# library(shinydashboard)
# library(leaflet)


#narm_fcv = read.csv(file ="./narm_fcv.csv")
source("./global.R")
Header = dashboardHeader(
)

Sidebar = dashboardSidebar(
    sidebarMenu(
        menuItem("Introduction", tabName = "Introduction" , icon = icon("subway")),
        menuItem("Collisions", tabName = "Collisions" , icon = icon("car-crash")),
        menuItem("Victims", tabName = "Victims" , icon = icon("wheelchair")),
        menuItem("Causes", tabName = "Causes" , icon = icon("icicles")),
        menuItem("Hotspots", tabName = "Maps" , icon = icon("street-view"))
        
    )
)
Body = dashboardBody (
    tags$head(tags$style(
        type="text/css",
        "#image img {max-width: 100%; width: auto; height: auto}"
    )
    ),
    tabItems(
        tabItem(
            tabName = "Introduction",
            h1(tags$b("New York City Motor Vehicle Collision Data Analysis")),
            
            
            
            tags$table
            (
                tags$tr(
                    tags$td(
                        box(
                            title = "", width = 14, solidHeader = TRUE,img(src="Traffic.jpg", width=700))
                    )
                    
                    ,
                    
                    tags$td(
                        box(
                            # h1(tags$b("City of Dreams")),
                            title = h1(tags$b("City of Dreams")), width = 8, solidHeader = TRUE, background ="blue",
                            tags$p("People from all over the world come to NYC in search of opportunities and make it their home.
            It is thus, one of the most populated cities in United States. With over 27,000 people per square mile,
            it has the highest population density of any major city in the US. Additionally, it leads the list of cities with best
            public transportation system." ),
                            tags$p("And yet, it is also one of the top accident-prone cities in the country.
                        In the year 2014, the New York Police Department had started a citywide traffic safety initiative called “Vision Zero”.
            The goal of “Vision Zero” is to eliminate traffic fatalities by collecting comprehensive data on traffic accidents.
            Inspired by this, I decided to analyze the motor vehicle collision data to see if we could gain some insights,
            that would help NYPD to take adequate measures in ensuring public safety.
            I obtained this dataset from the NYC's OpenData website.")
                        )
                    )
                   
                )
            )
        )
        ,
        tabItem(
            tabName = "Collisions",
            "",
            fluidRow(
                column(width =12, selectizeInput(inputId = "timeframe",
                                                 label = "Time Frame",
                                                 choices = c("Year", "Month", "Weekday", "Hour", "30min")
                )
                )
            ),
            fluidRow(
                column(
                    width = 8,
                     plotOutput("distPlot")),
                box(
                    #title = h3(tags$b("Analysis")), 
                    width = 4, solidHeader = TRUE, background ="blue",
                    tags$p("Here, total number of collisions in each borough are plotted for different timeframes."),
                    tags$p(h4("Yearly")),
                    tags$p("As can be seen in the yearly plot,
                            Brooklyn seems to have the highest number of crashes consistently, followed by Queens, Manhattan, Bronx, and Staten Island, respectively.
                                            In 2019, the number of accidents slightly dropped compared to previous year in all 5 boroughs, with Bronx reporting the smallest decline of 4.3% and Staten Island  
                                            reporting a whopping drop of 42.0%. 
                                            It can perhaps be attributed to reduction in speed limit on NYC streets. In 2020, all the boroughs reported a steep decline in collisions, 
                                            which is plausibly owing to Covid lockdown."),
                    tags$p(h4("Monthly")),
                    tags$p("Looking at the monthly trends, we see a sharp dip in accidents in all boroughs in the month of April. 
                                            Apparently, there is a slight increase in police enforcement during the early part of spring. It is noted that several thousand more speeding tickets are issued in April
                                            compared to preceding or following months. A dip is also observed in February, which is likely accountable to snow leading to fewer bikers, pedestrians and other vehicles on road."),
                    tags$p(h4("Weekly")),
                    tags$p("For weekdays, Friday seems to be the worst for driving while weekend is the safest."),
                    tags$p(h4("Hourly")),
                    tags$p("Looking at the hourly trends, a sharp dip is noted at around 3:00 pm in all boroughs. The half-hourly plot makes it clearer that there
                                            is a drop in number of accidents around 3:30pm. I found out that the police shift changes around 3:40 pm so my hypothesis is that during this hour, officers from the previous shift are winding down and newer shift are warming up, so neither is 
                                            keeping a good record of the accidents, due to which it appears that cases are less but chances are that its the reporting that is less.")
                    
                )
                
            )
            
        ),
        tabItem(
            tabName ="Victims",
            fluidRow(
                column(
                    width = 12,
                    radioButtons(inputId = "severity",
                                 label ="Accidents Severity",
                                 choices =c("Fatalities", "Injuries"),
                                 selected = "Fatalities"
                    )
                )
            ),
            fluidRow(
                column(width = 8,
                       plotOutput("livePlot"),
                       br(),
                       plotOutput("livePlotFacet")
                       
                ),
                       box(
                         #  title = h3(tags$b("Analysis")), 
                           width = 4, solidHeader = TRUE, background ="blue",
                           tags$p(h4("Fatalities")),
                           tags$p("As can be seen, number of fatalities went up in 2020.
                        This may have resulted from healthcare resources directed to COVID patients. Overall, Staten Island seems to have noted greatest percantage of people killed
                        out of the total number of accidents per year in that borough. Manhattan has the lowest percentage of accidents that prove fatal. It could be due to the congestion and frequent stops,
                        which reduces the vehicle speed. It could also be accounted to big hospitals in Manhattan compared to other boroughs."),
                          tags$p("Amongst the victims, Manhattan shows the highest percentage of pedestrians dying in colllision. Cyclists appear safest in 
                                  all boroughs. Percent of motorists killed went up in year 2020, likely due to scarce healthcare resources."),
                           tags$p(h4("Injuries")),
                           tags$p("As can be seen, number of injuries went up in 2020.
                        Again, this may have resulted from redirecting of healthcare resources. Bronx and Brooklyn are leading in terms of percentage of people injured
                        each year in these boroughs. Manhattan is again at the bottom in this aspect. Further, we note that 
                        percent injured shot up in 2019 in Staten Island. However, in absolute numbers, there was no perceptible increase in the number of injured. Since, number of collisions had dropped 
                        almost 40% in 2019, the base was much lower leading to a sharp climb in percentage."),
                          tags$p("Amongst injured victims, motorists face most injuries followed by pedestrians and cyclists across all boroughs."),
                       )
            )
        )
        ,
        tabItem(
            tabName="Causes",
            fluidRow(
                column(width =4,
                       selectizeInput(inputId = "borough",
                                      label = "Borough",
                                      choices = c("Bronx", "Brooklyn", "Manhattan", "Queens", "Staten Island")
                       )
                       ),
                       
                column(width =4,
                       sliderInput(inputId = "causes_rank",
                                   label = "Display Top 'N' Causes",
                                   min =1, max=30, value = c(0,5))
                )
                ),
                fluidRow(
                    column(width = 8,
                           plotOutput("causesPlot")
                           ),
            box(
                # title = h3(tags$b("Analysis")), 
                width = 4, solidHeader = TRUE, background ="blue",
                tags$p("This plot illustrates the factors that contribute to collisions in different boroughs. If we look at the top 3 factors, we can see that
                      in more than 35% cases, the cause is 'Unspecified'. This is something that needs to be addressed. NYPD needs to be more diligent when recording
                      the cause of accident."),
                tags$p ("Using the slider, we can filter out a range of factors to examine others closely. The second factor that tops the list is Driver Inattention/Distraction'. The city authorities should ensure that there are 
                      no distractions like billboards on the streets. One of the other top causes in all boroughs is listed as 'Other vehicular', which is again ambiguous."
                       )
            
            )
            )
        )
        ,
        tabItem(
            tabName="Maps",
            fluidRow(
                column(width = 6,
                       leafletOutput("nycmap")
                ),
                column(width =6,
                       DTOutput('tbl')
                ),
                fluidRow(
                   column(width = 12,
                box(
                   # title = h3(tags$b("Analysis")), 
                    width = 6, solidHeader = TRUE, background ="blue",
                    tags$p("Finally, this map highlights the most accident-prone areas in 5 boroughs. 
                    The red dots show areas that witness at least one accident per week on average."
                    )
                )
            )
        )
            
    )
)
)
)

dashboardPage(
    Header,
    Sidebar,
    Body,
    title = "NYC Motor Vehicle Collision",
    skin = "yellow"
)