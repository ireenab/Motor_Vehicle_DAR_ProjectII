# Load all libraries
library(shiny)
library(shinydashboard)
library(tidyverse)
library(scales)
library(leaflet)
library(htmltools)
library(DT)

# Read all the files
yearly= read.csv(file ="./yearly.csv")
monthly=read.csv(file ="./monthly.csv")
weekly=read.csv(file ="./weekly.csv")
hourly=read.csv(file ="./hourly.csv")
half_hourly=read.csv(file ="./half_hourly.csv")
causes = read.csv(file ="./causes.csv")
one_per_week =read.csv(file = "./one_per_week.csv")