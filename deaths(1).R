#sample_n() is in the dplyr package
library(dplyr)
library(ggmap)
library(ggplot2)
library(reshape2)
library(maps)

#read in dataset
deaths <- read.csv("deaths.csv")



#**THIS IS FOR GGMAP, BUT DOESN'T CURRENTLY WORK**
#TODO
deaths_cities <- paste(deaths$City, deaths$State, sep = " ")
deaths_latlon <- geocode(deaths_cities, source == "google")
#deaths_getmap <- get_map(location = deaths_latlon, zoom = "auto", maptype = "watercolor")
#ggmap(deaths_getmap, extent = "device")

deaths_sample <- select(deaths_sample, -(Week.Ending.Date:REGION))

names(deaths_sample) <- c("year", "week", "state", "city", "Pneumonia_&_Influenza_deaths", "all_deaths", "<1yrs_old", "1-24yrs_old", "25-44yrs_old", "45-64yrs_old", ">65yrs_old")

rownames(deaths) <- NULL

deaths_melt <- melt(deaths_sample)

deaths <- deaths[,c(2, 1, 3, 4)]

map('usa', col = "purple")

death_levels <- c("<1yrs_old", "1-24yrs_old", "25-44yrs_old", "45-64yrs_old", ">65yrs_old")

ggplot(data = deaths, aes(x = factor(variable, levels = death_levels), y = value))
+ geom_point(aes(color = state), position ="jitter") 
+ geom_line()

deaths_cities <- paste(deaths$city, deaths$state)

death_map <- ggmap(get_map(location = 'usa', zoom = 4))
death_map + geom_point(aes(x = deaths_latlon$lat))

ggmap(get_map(location = 'usa', zoom = 4)) + geom_point(aes(x = deaths_latlon$lon, y = deaths_latlon$lat, colour = "red"), data = deaths_latlon)

ggplot(data = deaths, aes(deaths$value)) + geom_histogram(binwidth = 5) + facet_grid(~both)

ggplot(data = deaths) +
  geom_bar(aes(x=variable,y=value),stat="identity") + facet_grid(~both)

ggplot(data = deaths, aes(fill = variable)) +
  +   geom_bar(aes(x=factor(variable, death_levels) ,y=value), stat="identity") + facet_grid(~both)