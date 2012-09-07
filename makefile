all:
	##Delete the shapefile create by R, otherwise writeOGR fails
	rm -f maps-out/*
	R CMD BATCH run-all.R
	##Convert the shapefile to kml
	ogr2ogr -f KML maps-out/central-america.kml maps-out/CA.shp

clean:
	rm -f maps-out/*
	rm -f graphs/*
