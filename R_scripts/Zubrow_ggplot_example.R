library("ggplot2") # dev version
library("ggalt") # for ggsave()
library("extrafont")

# read in data from CSV
dat <- read.csv("./data/Zubrow.csv")

# extract from data.frame for use in plots
pop <- dat$Population
year <- unique(dat$Year)

# base R line plot of population over year
plot(dat$Population ~ dat$Year, type = "l")

# ggplot line plot of population over year
ggplot(dat, aes(x = as.factor(Year), y = Population)) +
  geom_line()

# ggplot bar plot of population over year
ggplot(dat, aes(x = as.factor(Year), y = Population)) +
  geom_bar(stat = "identity")

# ggplot line plot of population over year, grouped by Site
ggplot(dat, aes(x = as.factor(Year), y = Population, group = Site)) +
  geom_line()

# same with smoothed lines
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
            se = FALSE, color = "gray10", size = 0.5)

# smoothed lines as a horizontal line at the mean
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "gray10", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35")

# facet wrap on the East_Label, each site is its own plot
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "gray10", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35") +
  facet_wrap( ~ East_label, nrow = 2)

# added background data into each facet
# adapted first geom_smooth to call the data and set the facet variable to NULL
# this way it plots all the data everytime, ignoring the facet call
# color the data in the second geom_smooth a brigth red to focus on that site's line
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(data = transform(dat, East_label = NULL),
                     method = "lm", formula = y ~ splines::bs(x, 3),
                     se = FALSE, color = "gray90", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35") +
  facet_wrap( ~ East_label, nrow = 2) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
                     se = FALSE, color = "red", fill = "gray70")

# Start to work on design by adding theme_bw() to remove most of the defaults
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(data = transform(dat, East_label = NULL),
              method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "gray90", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35") +
  facet_wrap( ~ East_label, nrow = 2) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "red", fill = "gray70") +
  theme_bw()

# Modify the axis lables, title, subtitle, and caption
# this require the developers version of ggplot2 and ggalt (both from Github)
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(data = transform(dat, East_label = NULL),
              method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "gray90", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35") +
  facet_wrap( ~ East_label, nrow = 2) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "red", fill = "gray70") +
  theme_bw() +
  labs(title="Population Change in New Mexico Pueblos, 1760 to 1950",
       subtitle="Arranged from East to West",
       caption="Data: Zubrow(1974)",
       x = "Year")

# added theme() block where all the detail work is done
# these lines adjust the facets
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(data = transform(dat, East_label = NULL),
              method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "gray90", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35") +
  facet_wrap( ~ East_label, nrow = 2) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "red", fill = "gray70") +
  theme_bw() +
  labs(title="Population Change in New Mexico Pueblos, 1760 to 1950",
       subtitle="Arranged from East to West",
       caption="Data: Zubrow(1974)",
       x = "Year") +
  theme(
    strip.background = element_rect(colour = "white", fill = "white"),
    strip.text.x = element_text(colour = "black", size = 7, face = "bold", 
                                family = "Trebuchet MS"),
    panel.margin = unit(0, "lines"),
    panel.border = element_rect(colour = "gray90")
  )

# Formatting axis text
# X axis text is rotate 90 degrees
# the changing of fonts requires the extrafont package and a bit of doing
# easier on OSX than Windows, but follow tutorial here:
# http://blog.revolutionanalytics.com/2012/09/how-to-use-your-favorite-fonts-in-r-charts.html
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(data = transform(dat, East_label = NULL),
              method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "gray90", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35") +
  facet_wrap( ~ East_label, nrow = 2) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "red", fill = "gray70") +
  theme_bw() +
  labs(title="Population Change in New Mexico Pueblos, 1760 to 1950",
       subtitle="Arranged from East to West",
       caption="Data: Zubrow(1974)",
       x = "Year") +
  theme(
    strip.background = element_rect(colour = "white", fill = "white"),
    strip.text.x = element_text(colour = "black", size = 7, face = "bold", 
                                family = "Trebuchet MS"),
    panel.margin = unit(0, "lines"),
    panel.border = element_rect(colour = "gray90"),
    axis.text.x = element_text(angle = 90, size = 6, family = "Trebuchet MS"),
    axis.text.y = element_text(size = 6, family = "Trebuchet MS"),
    axis.title = element_text(size = 8, family = "Trebuchet MS")
  )

# Finally adjust the title and caption text
# again, this requires the dev version of ggplot2 and galt
ggplot(dat, aes(x = as.factor(Year), y = log(Population), group = East)) +
  geom_smooth(data = transform(dat, East_label = NULL),
              method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "gray90", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35") +
  facet_wrap( ~ East_label, nrow = 2) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "red", fill = "gray70") +
  theme_bw() +
  labs(title="Population Change in New Mexico Pueblos, 1760 to 1950",
       subtitle="Arranged from East to West",
       caption="Data: Zubrow(1974)",
       x = "Year") +
  theme(
    strip.background = element_rect(colour = "white", fill = "white"),
    strip.text.x = element_text(colour = "black", size = 7, face = "bold", 
                                family = "Trebuchet MS"),
    panel.margin = unit(0, "lines"),
    panel.border = element_rect(colour = "gray90"),
    axis.text.x = element_text(angle = 90, size = 6, family = "Trebuchet MS"),
    axis.text.y = element_text(size = 6, family = "Trebuchet MS"),
    axis.title = element_text(size = 8, family = "Trebuchet MS"),
    plot.caption = element_text(size = 8, hjust=0, margin=margin(t=5), 
                                family = "Trebuchet MS"),
    plot.title=element_text(family="TrebuchetMS-Bold"),
    plot.subtitle=element_text(family="TrebuchetMS-Italic")
  )

## WITH HADLEY"S SUGGESTION OF DATES ON X AXIS
ggplot(dat, aes(x = Year, y = log(Population), group = East)) +
  geom_smooth(data = transform(dat, East_label = NULL),
              method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "gray90", size = 0.5) +
  geom_hline(yintercept = mean(log(pop)), linetype = 5, color = "gray35") +
  facet_wrap( ~ East_label, nrow = 2) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 3),
              se = FALSE, color = "red", fill = "gray70") +
  theme_bw() +
  scale_x_continuous(breaks = year, labels = year) +
  labs(title="Population Change in New Mexico Pueblos, 1760 to 1950",
       subtitle="Arranged from East to West",
       caption="Data: Zubrow(1974)",
       x = "Year") +
  theme(
    strip.background = element_rect(colour = "white", fill = "white"),
    strip.text.x = element_text(colour = "black", size = 7, face = "bold", 
                                family = "Trebuchet MS"),
    panel.margin = unit(0, "lines"),
    panel.border = element_rect(colour = "gray90"),
    axis.text.x = element_text(angle = 90, size = 6, family = "Trebuchet MS"),
    axis.text.y = element_text(size = 6, family = "Trebuchet MS"),
    axis.title = element_text(size = 8, family = "Trebuchet MS"),
    plot.caption = element_text(size = 8, hjust=0, margin=margin(t=5), 
                                family = "Trebuchet MS"),
    plot.title=element_text(family="TrebuchetMS-Bold"),
    plot.subtitle=element_text(family="TrebuchetMS-Italic")
  )


# save the plot
ggsave(filename = "population.png", width = 8, height = 4)
# Done!
