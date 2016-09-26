# Description
# A sites by types table of abundance data on vessel types in archaeological features of the
# Younger Neolithic Michelsberg Culture from Belgium, France and Germany by Birgit Höhn (2002).
# 
# Details
# Höhn (2002) recorded pottery vessel shapes from 108 archaeological features (pits, ditches etc.)
# from 69 sites of the Central European Younger Neolithic Michelsberg Culture (MBK; 4350-3500 BC)
# following Lüning’s (1967) typology. Her correspondence analysis of the abundance data (columns 5 to 39)
# exhibits a pronounced Guttman effect or arch, suggesting the data set is structured by a time gradient.
# Recently Mischka et al. (2015) projected an 109th Michelsberg assemblage, Flintbek LA48,
# a pit with Michelsberg pottery from a North German site of the Funnel Beaker Cul- ture (TRB),
# as a supplementary row into the existing chronology thereby connecting the relative chronologies
# of TRB and MBK. The data frame contains as attributes the references for the data, a typological
# key and the map projection. Note that ambiguous fragments of conical bowls (ks1 and ks2) are assigned
# as 0.5 to each of the two types resulting also in positive entries suitable to analysis by CA.
# 
# Source
# Höhn, B. 2002. Die Michelsberger Kultur in der Wetterau.
# Universitätsforschungen zur prähis- torischen Archäologie 87. Bonn: Habelt.
# Mischka, D., Roth, G. and K. Struckmeyer 2015. Michelsberg and Oxie in contact next to the Baltic Sea.
# In: Neolithic Diversities. Perspectives from a conference in Lund, Sweden.
# Acta Archaeologica Lundensia Ser. 8, No. 65, edited by Kr. Brink et al., pp 241–250.
# Lüning, J. 1967. Die Michelsberger Kultur: Ihre Funde in zeitlicher und räumlicher Gliederung.
# Berichte der Römisch-Germanischen Kommission 48, 1-350.

library("archdata") # where the data comes from
library("sp") # for spatial object
library("leaflet") # for interactive mapping
library("rgdal") # for geographic transformations
library("rgeos") # for geographic operations
library("spatstat")  # Needed for the dirichlet tesselation function
library("rworldmap") # library rworldmap provides different types of global maps, e.g:
library("ggmap") # for a static map example
library("gstat") # for IDW model
library("leaflet") # for interactive mapping
library("mapview") # for interactive mapping test with mapview(breweries91)
library("raster") # for raster operations

### bring in data from archdata package
data(Michelsberg)
# give a shorter name, less typing...
mb <- Michelsberg
# take a look at structure of data
str(mb)
# take a look at type and range of variables
summary(mb)

### create objects for geographic coordinate systems
## Proj4string from http://spatialreference.org/
# UTM 1983 zone 32 North
UTM32n <- CRS("+proj=utm +zone=32 +ellps=WGS84 +datum=WGS84 +units=m +no_defs") 
# World Geographic System 1984 (lat/long)
WGS84 <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84") 

### Create a spatialpointsdataframe object from our data
## pass long, lat, and data to function.  
## crs = the proper coordinate system as described in archdata package reference
mb_spat <-  SpatialPointsDataFrame(coords = mb[,c("x_utm32n", "y_utm32n")], 
                                   data = mb, 
                                   proj4string = UTM32n)
### Start to make maps!
## most basic plot (points)
plot(mb_spat)

## Putting it in geographic context
# get country boundary data
data(countriesLow)
# transform Michelsberg site data from UTM83n to WGS84
mb_spat_WGS84 <- spTransform(mb_spat, WGS84)
# plot the data and boundaries, then lable
plot(mb_spat_WGS84, pch = 20, col = "red")
# 'add' tell plot to add to the previous plot
plot(countriesLow, add = TRUE)
labelCountries()

# ggmap example: static map with nice basemap
# grab coordinates
WGS84_coords <- coordinates(mb_spat_WGS84)
# append WGS84 coords onto original data
mb$x_WGS84 <- WGS84_coords[,1]
mb$y_WGS84 <- WGS84_coords[,2]
# get a base map centered on Frankfurt at a certain zoom
base_map <- get_map(location = "Frankfurt, Germany", zoom = 6, color = "bw")
# use ggplot code to build out layers of map:
# basemap, add points, change color scale, set plot theme
ggmap(base_map, extent = "normal") +
  geom_point(aes(x = x_WGS84, y = y_WGS84, color = t2a), data = mb, alpha = .8, size = 4) +
  scale_color_distiller(palette = "PuOr", direction = 1) +
  theme_bw(16)

### Adding a shapefile
wd <- "/Users/mattharris/Documents/R_Local/SAA_R_Demo_2016/SAA_R_Demo_2016"
germany <- readOGR(paste0(wd, "/data/DEU_adm0.shp"), layer = "DEU_adm0")
germany <- spTransform(germany, WGS84)
germany <- gSimplify(germany, tol=0.001, topologyPreserve=TRUE)
plot(germany)

## fortifying for ggplot
germany_fort <- ggplot2::fortify(germany)
# basemap with points and SHP
ggmap(base_map, extent = "normal") +
  geom_polygon(data = germany, aes(x=long, y=lat, group=group), 
               fill = "transparent", color = "gray10", size = 1) +
  geom_point(aes(x = x_WGS84, y = y_WGS84, color = t2a), 
             data = mb, alpha = .8, size = 4) +
  scale_color_distiller(palette = "PuOr", direction = 1) +
  coord_map(ylim = c(min(mb$y_WGS84), max(mb$y_WGS84)),
              xlim = c(min(mb$x_WGS84), max(mb$x_WGS84))) +
  theme_bw(16)

### Adding spatial analysis to our map
## use ggplot functions to creat site density grid
ggmap(base_map, extent = "normal") +
  stat_bin2d(aes(x = x_WGS84, y = y_WGS84, color = t2a),
  size = 1, bins = 20, alpha = 0.9, data = mb)
# density smooth
ggmap(base_map, extent = "normal") +
  stat_density2d(aes(x = x_WGS84, y = y_WGS84, fill = ..level.., alpha = ..level..),
  size = 1, bins = 20, data = mb,
  geom = "polygon")
# faceted density # this can take a while to render!
mb$group <- ifelse(mb$t2a <= 3, "t2a <= 3", "t2a > 3")
ggmap(base_map, extent = "normal") +
  stat_density2d(aes(x = x_WGS84, y = y_WGS84, fill = ..level.., alpha = ..level..),
                 size = 1, bins = 20, data = mb,
                 geom = "polygon") +
  scale_fill_distiller(palette = "PuOr", direction = 1) +
  theme_bw() +
  facet_wrap(~ group)

### Use gstat to perform spatial statistics on out data
## then format to display in out ggmap example
# get the min/max range for lat/long to make an empty grid 
x.range <- as.numeric(c(min(mb$x_WGS84), max(mb$x_WGS84)))  # min/max longitude of the interpolation area
y.range <- as.numeric(c(min(mb$y_WGS84), max(mb$y_WGS84)))  # min/max latitude of the interpolation area  
# from the range, exapnd the coordinates to make a regular grid
grd <- expand.grid(x = seq(from = x.range[1], to = x.range[2], by = 0.075), 
                   y = seq(from = y.range[1], to = y.range[2], by = 0.075))  # expand points to grid
# make the crid into spatial coords, grid, add spatial reference
coordinates(grd) <- ~x + y
gridded(grd) <- TRUE
proj4string(grd) <- WGS84
# quick plot to see what we have
plot(grd, cex = 1.5, col = "grey")
points(mb_spat_WGS84, pch = 1, col = "red", cex = 1)

### Because most attributes in example data don't have a great distribution
### I am simulating a made up attribute so tha mapping looks nicer
## simulate 'new_type' with spatial trend
# finds mean of site locations,
# assigns a value that increases from lower-left to upper-right
x_mean <- mean(mb$x_WGS84)
y_mean <- mean(mb$y_WGS84)
x_dist <- mb$x_WGS84 - x_mean
y_dist <- mb$y_WGS84 - y_mean
mb$xy_dist <- x_dist + y_dist
mb$pre_sort_id <- seq(1,nrow(mb))
mb <- mb[order(mb$xy_dist),]
mb$new_type <- seq(1,nrow(mb))*2
mb <- mb[order(mb$pre_sort_id),]
mb_spat_WGS84$new_type <- mb$new_type

### IDW interpolation of 'new_type' using gstat package
idw <- gstat::idw(formula = new_type ~ 1, locations = mb_spat_WGS84, newdata = grd)  # apply idw model for the data
# grab output of IDW for plotting
idw.output = as.data.frame(idw)  # output is defined as a data table
# set the names of the idw.output columns
# basic ggplot using geom_tile to display our interpolated grid within no map
ggplot() + 
  geom_tile(data = idw.output, aes(x = x, y = y, fill = var1.pred)) + 
  geom_point(data = mb, aes(x = x_WGS84, y = y_WGS84), shape = 21, color = "red") +
  scale_fill_distiller(palette = "PuOr", direction = 1) +
  theme_bw() 
# use ggmap as earlier to display interpolation in geographic space
# Can take a LONG time to render (~2 minutes)
ggmap(base_map, extent = "normal") +
  geom_tile(data = idw.output, aes(x = x, y = y, fill = var1.pred), alpha = 0.75) + 
  geom_point(data = mb, aes(x = x_WGS84, y = y_WGS84), shape = 19, color = "red") +
  scale_fill_distiller(palette = "PuOr", direction = 1) +
  theme_bw() 


### Create an interactive map!
## quick and dirty interactive map of site locations
maplayer1 <- mapview(germany)

## interactive map with layers
maplayer1 <- mapview(germany, 
                     color = "gray10", 
                     alpha.regions = 0)
maplayer2 <- mapview(mb_spat_WGS84)
maplayer1 + maplayer2

### Create interactive map of IDW results
## use raster packaage to turn IDW into raster object
idw_raster <- rasterFromXYZ(idw.output[,1:3], crs = WGS84)
# plot to see what happens
spplot(idw_raster)

## To clip raster to data region, creat convex hull, buffer, and mask (clip) raster
## perform convex hull and buffer operations on projected UTM32n data
mb_hull <- gConvexHull(mb_spat) # convex hull
mb_buff <- gBuffer(mb_hull, width = 25000) # arbitrary 25km buffer
# tranforms back to WGS84
mb_buff_WGS84 <- spTransform(mb_buff, WGS84)
# plot to see results
plot(mb_buff_WGS84)
points(mb_spat_WGS84)
# mask IDW raster to confine to region that we have sites for
idw_raster_crop <- mask(idw_raster, mb_buff_WGS84)
# create contours of the IDW
idw_contour <- rasterToContour(idw_raster_crop, nlevels = 15)
# plot to see results
spplot(idw_raster_crop)

### Use mapview package to create layered interactive map with
### basemap, data points, interpolated raster, and contours
## made in three seperate layers
m1 <- mapview(germany, color = "black", alpha.regions = 0)
m2 <- mapview(mb_spat_WGS84, legend = TRUE, zcol = "new_type")
m3 <- mapview(idw_raster_crop, alpha.regions = 0.50, na.color = "transparent")
m4 <- mapview(idw_contour, lwd = 1.5, color = "gray40")
# combine layers to plot
m1 + m2 + m3 + m4










