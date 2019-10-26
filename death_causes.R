#sample_n() is in the dplyr package
library(dplyr)
library(ggmap)
library(ggplot2)

#read in dataset
deaths <- read.csv("Deaths_in_122_U.S._cities_from_1962-2016.csv")

deaths_sample <- sample_n(deaths, 10)

deaths_cities <- paste(deaths_sample$City, deaths_sample$State, sep = " ")

deaths_latlon <- geocode(deaths_cities, source = "google")

deaths_getmap <- get_map(location = deaths_latlon, zoom = "auto", maptype = "watercolor")
ggmap(deaths_getmap, extent = "device")