

##Write a shapefile of Central America and Mexico to upload
##to Google Fusion Tables

merged <- merge(x=map@data, y=ca, by.x='NAME_1', by.y='id', all.x=TRUE)
correct.ordering <- match(map@data$NAME_1, merged$NAME_1)
map@data <- merged[correct.ordering, ]

writeOGR(map, "maps-out/CA.shp", "CA", driver="ESRI Shapefile")

