########################################################
## Author: Diego Valle-Jones
## Website: www.diegovalle.net
## Date Created: Thu Sep  6 17:34:21 2012
## Email: diegovalle at gmail.com
## Purpose: Choropleths of Central America and Mexico violence
## Copyright (c) Diego Valle-Jones. All rights reserved

#Theme to get rid of axis and panels
theme_nothing <- function() {
  theme_bw() + theme(axis.text.x = element_blank(),
                     axis.title.x = element_blank(),
                     axis.text.y = element_blank(),
                     axis.title.y = element_blank(),
                     axis.line = element_blank(), axis.ticks = element_blank(),
                     panel.background = element_blank(), 
                     panel.border = element_blank(), 
                     panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(), 
                     plot.background = element_blank()) 

}


getMaps <- function(codes, level) {
  column.name <- ifelse(level == 1, "NAME_0", "ISO")
  ##Download the maps
  country.ll <- llply(codes,
                      function(x) getData("GADM", path = "maps",
                                          country = x, level = level))
  ##Change the id of the maps since some are repeated and we need to
  ##merge them, use ISO code as the unique identifier
  country.ll <- llply(country.ll,
                      function(x) spChFIDs(x, str_c(row.names(x), x[[column.name]][1])))
  ##Merge the list of maps one by one
  for(i in 2:length(country.ll)){
    if(i == 2) {
      map <- spRbind(country.ll[[1]], country.ll[[2]])
    } else { 
      map <- spRbind(map, country.ll[[i]])
    }
  }
  map
}
##Codes for the Central American Countries
country.codes <- c("GTM", "BLZ", "HND", "SLV", "CRI", "NIC", "PAN")
##Get the maps of States/Districts
map <- getMaps(country.codes, level = 1)
map$NAME_1 <- iconv(map$NAME_1, from = "latin1", to = "UTF-8")

##Get the maps of the country outlines
map.borders <- getMaps(country.codes, level = 0)

##plot(map)


##Add the map of Mexican municipalities to the map of Central America
mx <- readOGR("maps/MUNICIPIOS-50.shp", "MUNICIPIOS-50")
##Make sure we are working with the same projection
mx <- spTransform(mx, CRS(proj4string(map)))
##Only the states bordering Guatemala and Belize:
##Chiapas, Tabasco, Campeche, Quintana Roo
mx <- mx[mx$CVE_ENT %in% c("07", "27", "04", "23"), ]
##Subset the data.frame that comes with the map to be
##able to merge the two maps
map <- map[, "NAME_1"]
mx$NAME_1 <- as.numeric(str_c(mx$CVE_ENT, mx$CVE_MUN))
mx <- mx[,"NAME_1"]

map <- spRbind(map, mx)

##Get rid of the Panama regions I wasn't able to merge with the map
map <- map[!map$NAME_1 %in% c("Emberá", "Kuna Yala", "Ngöbe Buglé", "Nicaragua"), ]


##Map of Mexican States
mx.states <- readOGR("maps/ESTADOS-90.shp", "ESTADOS-90")
mx.states <- spTransform(mx.states, CRS(proj4string(map)))
mx.states <- mx.states[mx.states$CVE_ENT %in% c("07", "27", "04", "23"), ]

##Prepare for ggplt
ca.map <- fortify(map, region = "NAME_1")
ca.map.borders <- fortify(map.borders, region = "NAME_ISO")
states.map.borders <- fortify(mx.states, region = "NOM_ENT")

##Merge with the homicide data
ca.map2 <- join(ca.map, ca, by = "id")
##Are any regions missing from the join?
##unique(ca.map2[is.na(ca.map2$rate),]$id)

##Prepare an additional map with homicide data from Police sources
snsp <- read.csv("data/snsp2011.csv", stringsAsFactors = FALSE)
names(snsp)[1] <- "id"
states.map.borders <- join(states.map.borders, snsp)


q <- ggplot(ca.map2, aes(long, lat, group=group)) +
  geom_polygon(aes(fill = rate), color = "black", size = .05) +
  geom_polygon(data = ca.map.borders,
               aes(long, lat, group=group),
               color = "gray10", size = .4, fill = NA) +
  scale_fill_gradientn("homicide\nrate", colours=brewer.pal(9, "Reds")) +
  guides(fill = guide_colorbar(colours = topo.colors(10))) +
  coord_map() +
  theme_nothing()

p <- q+ geom_polygon(data = states.map.borders,
               aes(long, lat, group=group),
               color = "gray10", size = .2, fill = NA) +
  ggtitle("Homicide Rates in Southern Mexico and Central America, by Municipality or Department\n(Mexican Rates from Vital Statistics)")
ggsave("graphs/central-america.png", dpi = 100,
       width = 9.6, height = 8, plot = p)


p <- q +
  geom_polygon(data = states.map.borders,
               aes(long, lat, group=group, fill = rate),
               color = "gray10", size = .2) +
  coord_map() +
  ggtitle("Homicide Rates in Southern Mexico and Central America, by State or Department\n(Mexican Rates from Police Sources)")
ggsave("graphs/central-america-states.png", dpi = 100,
       width = 9.6, height = 8, plot = p)
