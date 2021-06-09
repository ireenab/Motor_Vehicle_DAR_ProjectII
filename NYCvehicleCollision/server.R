#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# 
# library(shiny)
# library(tidyverse)
# library(scales)
# library(leaflet)
# library(htmltools)
# library(DT)
# 
# # Read all the files
# yearly= read.csv(file ="./yearly.csv")
# monthly=read.csv(file ="./monthly.csv")
# weekly=read.csv(file ="./weekly.csv")
# hourly=read.csv(file ="./hourly.csv")
# half_hourly=read.csv(file ="./half_hourly.csv")
# causes = read.csv(file ="./causes.csv")
# one_per_week =read.csv(file = "./one_per_week.csv")
source("./global.R")
shinyServer(function(input, output) {
    
    output$distPlot <- renderPlot({
        if (input$timeframe == "Year"){
            g = yearly %>%
                ggplot(aes(x=year, y=count))+
                scale_x_continuous(breaks =2013:2020, labels = 2013:2020)+
                ggtitle("Number of collisions by year for each borough")+
                xlab("Year")
                
        }
        else if (input$timeframe == "Month"){
            g = monthly %>%
                ggplot(aes(x=as.Date(month), y=count))+
                scale_x_date(date_labels = "%b", breaks = "1 month")+
                ggtitle("Number of collisions by month for each borough")+
                xlab("Month")
            
        }
        else if (input$timeframe == "Weekday"){
            g = weekly %>%
                ggplot(aes(x=wday, y=count))+
                scale_x_continuous(breaks =1:7, labels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))+
                ggtitle("Number of collisions by day of the week for each borough")+
                xlab("Weekday")
            
        }
        else if (input$timeframe == "Hour"){
            g = hourly %>%
                ggplot(aes(x=as.POSIXct(hour), y=count))+
                scale_x_datetime(labels = date_format("%H", tz=Sys.timezone()), breaks = date_breaks("1 hour"))+
                ggtitle("Number of collisions by hour of the day for each borough")+
                xlab("Hour")
            
        }
        else if (input$timeframe == "30min"){
            g = half_hourly %>%
                ggplot(aes(x=as.POSIXct(half_hour), y=count))+
                scale_x_datetime(labels = date_format("%H", tz=Sys.timezone()), breaks = date_breaks("1 hour"))+
                ggtitle("Number of collisions in half hourly intervals for each borough")+
                xlab("Hour")
            
        }
        g +geom_line(stat="identity", aes(color=borough)) +
            geom_point() +
            theme_light() +
            theme(plot.title = element_text(hjust=0.5, face ="bold", size=20))+
            theme(axis.title.x =element_text(size = 16))+
            theme(axis.text.x = element_text(size=12))+
            ylab("Number of collisions")+
            theme(axis.title.y =element_text(size = 16)) +
            theme(axis.text.y = element_text(size=12))+
            guides(col=guide_legend("Borough"))+
            theme(legend.title =element_text(size = 16, face="bold"))+
            theme(legend.text = element_text(size = 13))
    })
    output$livePlot <- renderPlot({
        if (input$severity == "Injuries"){
            h = yearly %>%
                ggplot(aes(x=year, y=percent_pi))+
                ylab("Percent injured")+
                ggtitle("Percentage of people injured by year and borough")
        }
        else if (input$severity == "Fatalities"){
            h = yearly %>%
                ggplot(aes(x=year, y=percent_pk))+
                ylab("Percent killed")+
                ggtitle("Percentage of people killed by year and borough")
        }
        h +geom_line(stat="identity", aes(color=borough)) +
            scale_x_continuous(breaks =2013:2020, labels = 2013:2020)+
            geom_point() +
            theme_light() +
            theme(plot.title = element_text(hjust=0.5, face ="bold", size=20))+
            xlab("Year") +
            theme(axis.title.x =element_text(size = 16))+
            theme(axis.text.x = element_text(size=12))+
    
            theme(axis.title.y =element_text(size = 16)) +
            theme(axis.text.y = element_text(size=12))+
            guides(col=guide_legend("Borough"))+
            theme(legend.title =element_text(size = 16, face="bold"))+
            theme(legend.text = element_text(size = 13))
            # xlab("Year") +
            # theme(axis.title.x =element_text(size = 15))+
            # theme(axis.title.y =element_text(size = 15))+
            # guides(col=guide_legend("Borough"))+
            # theme(legend.title =element_text(size = 15, face="bold"))
})
    output$livePlotFacet <- renderPlot({
        if (input$severity == "Injuries"){
            i = yearly %>%
                pivot_longer(.,c(percent_mi, percent_pedi, percent_ci), names_to = "victim", values_to = "percent_injured") %>% 
                mutate(., victim = ifelse(victim == "percent_mi", "Motorists",
                                          ifelse(victim == "percent_pedi", "Pedestrians",
                                                 "Cyclists")
                )
                ) %>%
                ggplot(aes(x=year, y=percent_injured)) +
                ylab("Percent injured")
                
        }
        else if (input$severity == "Fatalities"){
            i = yearly %>%
                pivot_longer(.,c(percent_mk, percent_pedk, percent_ck), names_to = "victim", values_to = "percent_killed") %>% 
                mutate(., victim = ifelse(victim == "percent_mk", "Motorists",
                                          ifelse(victim == "percent_pedk", "Pedestrians",
                                                 "Cyclists")
                )
                ) %>%
                ggplot(aes(x=year, y=percent_killed))+
                ylab("Percent killed")
        }
        i +geom_line(stat="identity", aes(color=victim)) +
            # scale_x_continuous(breaks =2013:2020, labels = 2013:2020)+
            geom_point() +
            facet_grid(cols = vars(borough))+
            theme_light() +
            theme(
                plot.title = element_text(hjust=0.5, face ="bold", size=20),
                axis.title.x =element_text(size = 16),
                axis.text.x = element_text(size=12),
                axis.title.y =element_text(size = 16),
                axis.text.y = element_text(size=12),
                legend.title =element_text(size = 16, face="bold"), 
                legend.text = element_text(size = 13),
                strip.text.x = element_text(size = 13, colour = "black"),
                strip.background = element_rect(fill="white")
                )+
            xlab("Year")+
            guides(col=guide_legend("Victim"))+
            ggtitle("Victim details")
    })
    output$causesPlot<- renderPlot({
        causes %>% 
            filter(., borough == input$borough & rank>=input$causes_rank[1] & rank<=input$causes_rank[2]) %>%
            ggplot(aes(x=reorder(Contributing_Factor, pct), y=pct))+
            geom_bar(stat="identity", fill ="Sky blue", color = "Sky blue") +
            coord_flip()+
            theme_light()+
            theme(plot.title = element_text(hjust=0.5, face ="bold", size=20))+
            xlab("Contributing factors") +
            theme(axis.title.x =element_text(size = 16))+
            theme(axis.text.x = element_text(size=12))+
            ylab("Percent accidents") +
            theme(axis.title.y =element_text(size = 16)) +
            theme(axis.text.y = element_text(size=12))+
            ggtitle("Percentage of accidents by causal factors")
        })
    
    output$nycmap <- renderLeaflet({
        leaflet(one_per_week) %>%
            fitBounds(-74.11, 40.6, -73.70, 40.9) %>% 
            addProviderTiles(providers$Stamen.TonerLite,
                             options = providerTileOptions(noWrap = TRUE)
            ) %>%
            addCircleMarkers(
                ~longitude, ~latitude,
                radius = 6,#~count,
                color = "red",#~pal(count),
                stroke = FALSE,
                fillOpacity = 0.5,
                # popup = ~htmlEscape(paste(paste0("Lat = ", latitude),  paste0("Long = " , longitude), paste0("Count = " ,count), sep = "<br/>"))
                
                popup = ~htmlEscape(paste(on_street,  " & " , cross_street, " (", borough, ")", " Accidents = " ,count))
            ) 
    })
    output$tbl <-renderDT(
        as.data.frame(one_per_week)[,-c(1,3,4)],options=list(lengthchange=TRUE)
    )
})