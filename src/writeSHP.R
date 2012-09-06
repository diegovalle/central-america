########################################################
## Author: Diego Valle-Jones
## Website: www.diegovalle.net
## Date Created: Thu Sep  6 17:33:40 2012
## Email: diegovalle at gmail.com
## Purpose: Write a shapefile to upload to google fusion table 
## Copyright (c) Diego Valle-Jones. All rights reserved


##Write a shapefile of Central America and Mexico to upload
##to Google Fusion Tables

merged <- merge(x=map@data, y=ca, by.x='NAME_1', by.y='id', all.x=TRUE)
correct.ordering <- match(map@data$NAME_1, merged$NAME_1)
map@data <- merged[correct.ordering, ]

map$NAME_1 <- iconv(map$NAME_1, to = "latin1", from = "UTF-8")


writeOGR(map, "maps-out/CA.shp", "CA", driver="ESRI Shapefile")

