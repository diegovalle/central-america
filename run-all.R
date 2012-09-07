########################################################
## Author: Diego Valle-Jones
## Website: www.diegovalle.net
## Date Created: Thu Sep  6 17:33:20 2012
## Email: diegovalle at gmail.com
## Purpose: Analyze violence in Central America and Southern Mexico
## Copyright (c) Diego Valle-Jones. All rights reserved


library(directlabels)
library(RColorBrewer)
library(lubridate)
library(ggplot2)
library(stringr)
library(scales)
library(reshape2)
library(plyr)
library(reshape)
library(maptools)
library(rgdal)
library(geosphere)
library(raster)
gpclibPermit()

source("src/load_data.R")
source("src/plots.R")
source("src/writeSHP.R")





