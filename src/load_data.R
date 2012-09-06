
##load data homicide data for Central America
##from: http://multimedia.laprensagrafica.com/pdf/2011/03/20110322-PDF-Informe-0311-Homicidios-en-Centroamerica.pdf
ca <- read.csv("data/all.csv", sep = "\t")
ca$id <- as.character(ca$id)
ca$name <- ca$id


##load and clean homicide data for Mexico
hom <- read.csv("data/homicides-dwrh-month-municipality.csv.bz2",
                stringsAsFactors = FALSE)
##Take into account that homicide are undercounted by around 3% for the
##last year on record
hom$V1 <- round(hom$V1*hom$per)
hom$year <- year(hom$date)
hom <- subset(hom, year == 2010)
##Only the southern states
hom <- subset(hom, CVE_ENT %in% c(7, 27, 4, 23))
hom$name <- ifelse(hom$MetroArea != "", hom$MetroArea,
                   str_c(hom$MunName, ", ", hom$StateName))
##We need yearly data
hom <- ddply(hom, .(id, year), summarise,
             V1 = sum(V1),
             Population = mean(Population),
             name = name[1])
##make sure we merge metro areas
hom <- ddply(hom, .(name),
             transform,
             rate = sum(V1) / sum(Population) * 10^5,
             pop = sum(Population),
             hom = sum(V1))
hom <- unique(hom[,c("id","name", "pop", "hom", "rate")])

ca <- rbind(ca, hom)
