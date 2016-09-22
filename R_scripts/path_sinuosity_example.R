
absolute_length <- function(Line){
  coords <- Line@coords
  start <- coords[1,]
  end <- coords[nrow(coords),]
  x1 <- abs(end[1] - start[1])^2
  y1 <- abs(end[2] - start[2])^2
  length <- sqrt(x1 + y1)
  return(length)
}

library("ggplot2")
library("dplyr") # for left_join()
library("viridis") # for viridis color scale in ggplot
library("sp")
library("rgdal") # import GPX track

#### use LineLength() but segment path into sub-path lines first.
path <- data.frame(x = c(1:12), y = c(1, 2, 4, 5, 5, 4, 2, 3, 7, 8, 8, 9))
# need to make segmenting more efficient
p1 <- Line(path[1:4,])
p2 <- Line(path[5:8,])
p3 <- Line(path[9:12,])
seg_line_length <- sapply(list(p1,p2,p3), LineLength)
seg_total_length <- sapply(list(p1,p2,p3), absolute_length)
segment_sinuosity <- seg_line_length / seg_total_length
median(segment_sinuosity)

ggplot(path, aes(x = x, y = y)) +
  geom_line()

# need GPX to coords to try real example
gpx_loc <- paste0(getwd(), "/data/path_example.gpx")
gpx_track <- readOGR(dsn = gpx_loc, layer = "tracks")
UTM18N <- CRS("+proj=utm +zone=18 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")
gpx_track <- spTransform(gpx_track, UTM18N)
gpx_coords <- data.frame(coordinates(gpx_track)[[1]][[1]])
colnames(gpx_coords) <- c("x","y")

ggplot(gpx_coords, aes(x = x, y = y)) +
  geom_path(color = "red") +
  geom_point(size = 0.5) +
  theme_bw()

# divide into roughly two minute travel chunks
travel_time <- 40.28 # minutes
twomin_chunks <- travel_time / 2 # minutes
twomin_chunks <- floor(nrow(gpx_coords) / twomin_chunks)

chunks <- 0:nrow(gpx_coords) %/% twomin_chunks
chunks <- chunks[-length(chunks)]
gpx_split <- split(gpx_coords, chunks)
gpx_line <- lapply(gpx_split, Line)
gpx_seg_length <- sapply(gpx_line, LineLength)
gpx_abs_length <- sapply(gpx_line, absolute_length)
gpx_sinuosity <- gpx_seg_length / gpx_abs_length
med_sinuosity <- median(gpx_sinuosity, na.rm = TRUE)
print(med_sinuosity)
plot(density(gpx_sinuosity, na.rm = TRUE))

gpx_coords$chunks <- chunks
gpx_coords <- left_join(gpx_coords, 
                        data.frame(sinuosity = gpx_sinuosity, 
                                   chunks = seq(0,length(gpx_sinuosity)-1,1)),
                        on = "chunks")
gpx_coords$half <- ifelse(gpx_coords$chunks <= max(chunks)/2, "Outbound", "Inbound")
gpx_coords$half <- factor(gpx_coords$half, levels = c("Outbound", "Inbound"))

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


