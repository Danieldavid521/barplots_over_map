#sample_n() is in the dplyr package
#THIS IS R version 3.0.3 to use subplots
library(dplyr)
library(ggmap)
library(ggplot2)
library(reshape2)
library(maps)
library(dplyr)
library(ggsubplot)
 


#read in dataset
tot <- read.csv("total_deaths.csv")
tot <- select(tot, -c(WEEK, Week.Ending.Date, REGION, Pneumonia.and.Influenza.Deaths, All.Deaths))
tot <- filter(tot, Year == 2016)
names(tot) <- c("year", "state", "city", "<1yrs_old", "1-24yrs_old", "25-44yrs_old", "45-64yrs_old", ">65yrs_old")
tot$year <- NULL
tot_sample <- sample_n(tot, 100, replace = FALSE)
tot_melt <- melt(tot_sample)
names(tot_melt) <- c("state", "city", "age", "deaths")
tot_melt$both <- paste(tot_melt$city, tot_melt$state)
tot_melt$state <- as.character(tot_melt$state)
tot_melt$city <- as.character(tot_melt$city)
#getting location
tot_location <- geocode(tot_melt$both)
tot_melt$lat <- tot_location$lat
tot_melt$lon <- tot_location$lon
#setting up for graphs
death_levels <- c("<1yrs_old", "1-24yrs_old", "25-44yrs_old", "45-64yrs_old", ">65yrs_old")



#map of USA with State lines
states <- map_data("state")

#plotting map and barplots over map
p = ggplot() + geom_polygon(data = states, aes(x=long, y=lat,group=group))
p + geom_subplot(data=tot_melt, aes(lon, lat, group=both, subplot = geom_bar(aes(x = factor(both, death_levels), y = deaths, fill=age), alpha=1, stat="identity", position=position_dodge()))) 

p = ggplot() + geom_polygon(data = states, aes(x=long, y=lat,group=group))
p + geom_subplot(data=tot_melt, aes(lon, lat, group=both, subplot = geom_point(aes(x = both, y = deaths,e), alpha=1, stat="identity", position=position_dodge()))) 


#barplot of deaths
ggplot(data=tot_melt, aes(x=factor(both), y=deaths, fill=age)) +
  geom_bar(stat="identity", position=position_dodge()) 

THIS IS THE CODE I USED TO MAKE THE BARPLOTS OVER THE MAP
p = ggplot() + geom_polygon(data = usa_map, aes(x=long, y=lat,group=group)))
p + geom_subplot(data=death_levels, aes(lon, lat, group=both, subplot = geom_bar(aes(variable, value, fill=variable), 
 col='black', alpha=0.5, stat="identity")))
set.seed(1)
d = ddply(world_map,.(region),summarize,long=mean(long),lat=mean(lat))
d = d[sample(1:nrow(d), 50),]
d = rbind(d,d)
d$cat = rep(c('A','B'), each=nrow(d)/2)
d$value = sample(1:10, nrow(d), rep=T)
d <- d[order(d$lat),]
head(d)
p + geom_subplot(data=d, aes(long, lat, group=lat, 
                            subplot = geom_bar(aes(cat, value, fill=cat), 
                                               col='black', alpha=0.9, stat="identity")), width = 30, height=30)


