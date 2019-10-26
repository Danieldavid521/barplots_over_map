library(ggsubplot)
library(ggplot2)
library(maps)
library(plyr)




p = ggplot() + geom_polygon(data = usa_map, aes(x=long, y=lat,group=group)))
p + geom_subplot(data=deaths, aes(lon, lat, group=both, subplot = geom_bar(aes(variable, value, fill=variable), 
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