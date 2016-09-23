# ########################################
# This is a script create to proof an idea about measuring the sinuosity of paths
# Sinuosity is simply the length of  apath divided by the strainght line distance
# from beginningbegginning to end. This does not work for loops.  THe idea is to create
# a metric for sinuosity of segments based on travel distance.
# In an archaeological context, this could be useful for historic roads, walking paths,
# transportation, or geomorphology (stream sinuosity).
# 
# This example gives examples of making a function, using 'apply' functions, and ggplot()
# ########################################

######## FUNCTIONS #####################
absolute_length <- function(Line){
  coords <- Line@coords
  start <- coords[1,]
  end <- coords[nrow(coords),]
  x1 <- abs(end[1] - start[1])^2
  y1 <- abs(end[2] - start[2])^2
  length <- sqrt(x1 + y1)
  return(length)
}
#######################################
########### LIBRARIES #################
library("ggplot2") # for plotting
library("dplyr") # for left_join()
library("viridis") # for viridis color scale in ggplot
library("sp") # for spatial data class
library("rgdal") # import GPX track
#######################################

### Make proof of concept 
## create a simple example path
path <- data.frame(x = c(1:12), y = c(1, 2, 4, 5, 5, 4, 2, 3, 7, 8, 8, 9))

## split path into three segements (inefficeintly)
## Use sp::Line() to convert coordinates to a spatial object of class 'Line'
p1 <- Line(path[1:4,])
p2 <- Line(path[5:8,])
p3 <- Line(path[9:12,])

## use sapply() to apply the LineLenght function to each element of the list (of segments)
## sp::LineLength() measures the path distance of each group of coordinates [of class 'Line']
seg_line_length <- sapply(list(p1,p2,p3), LineLength)
## our own absolute_length() function to get the start-to-stop straight line length
## same use of sapply to apply function to each element of the list of coordinates
seg_total_length <- sapply(list(p1,p2,p3), absolute_length)
## Divide the vector or segment lengths by vector of total lengths
segment_sinuosity <- seg_line_length / seg_total_length
# find the median of that full path
median(segment_sinuosity)
# quick plot to see line
ggplot(path, aes(x = x, y = y)) +
  geom_line()

###### The proof-of-concept works, so now do the same with a real GPX track
# set location to GPX file
gpx_loc <- paste0(getwd(), "/data/path_example.gpx")
# read with OGR
gpx_track <- readOGR(dsn = gpx_loc, layer = "tracks")
# establish the coordinate system we want to use for analysis (projected, not geographic)
UTM18N <- CRS("+proj=utm +zone=18 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")
# reproject from WGS84 to UTM83 one 18N
gpx_track <- spTransform(gpx_track, UTM18N)
# extract coordinates from imported path
gpx_coords <- data.frame(coordinates(gpx_track)[[1]][[1]])
# give coordinates column names
colnames(gpx_coords) <- c("x","y")

# take a look to make sure it looks ok
ggplot(gpx_coords, aes(x = x, y = y)) +
  geom_path(color = "red") +
  geom_point(size = 0.5) +
  theme_bw()

# divide into approximately two minute travel chunks
travel_time <- 40.28 # total travel time in minutes
twomin_chunks <- travel_time / 2 # minutes
# rounded number of segments of two minutes
twomin_chunks <- floor(nrow(gpx_coords) / twomin_chunks)

## repeat the proof-of-concept on GPX data
# create a vector of group numbers for GPX points
chunks <- 0:nrow(gpx_coords) %/% twomin_chunks
# drop the last one
chunks <- chunks[-length(chunks)]
# split the GPX points into chunks, results in a list of each chunk
gpx_split <- split(gpx_coords, chunks)
# apply Line() to convert coords to 'Line' class objects. results in list
gpx_line <- lapply(gpx_split, Line)
# Next steps are the same as in the proof-of-concept
gpx_seg_length <- sapply(gpx_line, LineLength)
gpx_abs_length <- sapply(gpx_line, absolute_length)
gpx_sinuosity <- gpx_seg_length / gpx_abs_length
med_sinuosity <- median(gpx_sinuosity, na.rm = TRUE)
print(med_sinuosity)
# see distribution of segment sinuosity
plot(density(gpx_sinuosity, na.rm = TRUE))

### Prepare data for plotting
# add chunk designations
gpx_coords$chunks <- chunks
# left join segment sinuosity based on chunk designation
gpx_coords <- left_join(gpx_coords, 
                        data.frame(sinuosity = gpx_sinuosity, 
                                   chunks = seq(0,length(gpx_sinuosity)-1,1)),
                        on = "chunks")
# add column for 1st half or 2nd
gpx_coords$half <- ifelse(gpx_coords$chunks <= max(chunks)/2, "Outbound", "Inbound")
# make it a factor and put the levels in proper order
gpx_coords$half <- factor(gpx_coords$half, levels = c("Outbound", "Inbound"))

## build ggplot
ggplot(gpx_coords, aes(x = x, y = y)) +
  geom_point(aes(color = sinuosity), size = 1.5) +
  scale_color_viridis(option="viridis", limits = c(1,max(gpx_sinuosity)),
                      name = "",
                      breaks = c(1,1.2,1.5,2), 
                      labels = c("straight","sinuous","meandering","highly meandering")) +
  guides(color = guide_colorbar(ticks = FALSE, nbin = 100,
                                label.theme = element_text(family = "Trebuchet MS", 
                                                           size = 10,
                                                           angle = 0))) +
  theme_bw() +
  facet_grid(half~., switch = "y") +
  labs(title="Path Sinuosity Segmented by 2-minute Travel Time") +
  theme(
    strip.background = element_rect(colour = "white", fill = "white"),
    strip.text.y = element_text(size = 12, family = "Trebuchet MS", face = "bold"),
    panel.border = element_rect(colour = "gray90"),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(family="TrebuchetMS-Bold"),
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    # legend.title = element_text(family="TrebuchetMS-Bold"),
    legend.position = c(0.15, 0.25)
  )

ggsave("path_segment_sinuosity.png")


