library("archdata")
library("dplyr")
library("MASS")
library("factoextra")
library("FactoMineR")
library("gplots")
library("ggmap")

data(Bornholm)
bh <- Bornholm
str(bh)


## Location Map
base_map <- get_map(location = "Bornholm", zoom = 10)
ggmap(base_map, extent = "normal") +
coord_cartesian(xlim = c(14.6, 15.22),
                ylim = c(54.95, 55.33),
                expand = FALSE)



## Background of current research
Bornholm.ca <- corresp(bh[, 4:42], nf=2)

# Symetric Biplot of Ornamentation by Site labeled by Time period
plot(Bornholm.ca$rscore, pch=substring(bh$Period, 1, 1), cex=.75)
# Boxplot of 1st CA dimension raw score by Time period
boxplot(Bornholm.ca$rscore[, 1]~bh$Period, main="First CA Axis by Period")


## Current Analysis
bh2 <- group_by(bh, Period) %>%
dplyr::select(-Number, -Site) %>%
summarise_each(funs(sum)) %>%
mutate(Period = as.character(Period)) %>%
tibble::column_to_rownames(., "Period") %>%
data.frame()

print(bh2[,1:15]) # example of first 10 columns

# convert to matrix for balloonplot() function
bh2_table <- as.table(as.matrix(bh2))
# balloon plotto show frequency of styles per time period
balloonplot(x = t(bh2_table), main = "Ornamentation by Style and Time Period", xlab ="", ylab="",
label = FALSE, show.margins = FALSE)
# mosaic plot visualizes the freqncy as the length of the bar and deviation for the expected-by-random frequency as color (red for less than expected, blue for more than expected)
mosaicplot(bh2_table, shade = TRUE, las=2, main = "Ornamentation by Style and Time Period")

ca3 <- CA(bh2, ncp = 2, graph = FALSE) # ncp = 2 indicates 2 CA dimensions 
summary(ca3, nb.dec = 2, ncp = 2) 
# use factoextra::fviz_ca_biplot() to create the same style plot as the Symetric Biplot above
fviz_ca_biplot(ca3) + # the basic plot from the fviz_ca_biplot() function
theme_minimal()     # add further ggplot2 calls

eig <- get_eigenvalue(ca3)
trace <- sum(eig$eigenvalue) 
cor.coef <- sqrt(trace)
cor.coef # > 0.2 = significant (general rule)

chi2 <- trace*sum(as.matrix(bh2))
# Degree of freedom
df <- (nrow(bh2) - 1) * (ncol(bh2) - 1)
# P-value
pval <- pchisq(chi2, df = df, lower.tail = FALSE)
paste0("chisq = ", round(chi2,3), ", p-value = ", round(pval,3)) # same as summary(ca3)

row_random <- (1/(nrow(bh2)-1))*100 # expected explained var by random for row
col_random <- (1/(ncol(bh2)-1))*100 # expected explained var by random for col

fviz_screeplot(ca3) +
geom_hline(yintercept = max(row_random, col_random), linetype=2, color="red") +
theme_bw()
# dimension 1 and 2 are included because dim > 3 could be by radom
# e.g. below max(row_random, col_random)

# contirbution of rows to global solution
fviz_ca_row(ca3, col.row="contrib")+
scale_color_gradient2(low="white", mid="blue", 
high="red", midpoint=10)+
theme_bw()

# contirbution of columns to global solution
fviz_ca_col(ca3, col.col="contrib")+
scale_color_gradient2(low="white", mid="blue", 
high="red", midpoint=5)+
theme_bw()

# asymetric biplot in the measuremnet space of rows
fviz_ca_biplot(ca3, map ="rowprincipal", arrow = c(TRUE, FALSE)) +
theme_bw()

# dressed up symetric biplot
fviz_ca_biplot(ca3, arrow = c(TRUE, FALSE), label = "row", labelsize = 5,
jitter = list(what = "label", width = 0.1, height = 0.1)) +
theme_bw() +
labs(title="CA Analysis: Symetric Biplot for Ornament Style and Time Period ",
subtitle="39 ornamentations from 77 female graves at Iron age sites in Bornholm, Denmark",
caption="Data: Ørsnes, M. (1966)") +
theme(
panel.border = element_rect(colour = "gray90"),
axis.text.x = element_text(angle = 0, size = 10, family = "Trebuchet MS"),
axis.text.y = element_text(size = 9, family = "Trebuchet MS"),
axis.title.y = element_text(size = 11, family = "Trebuchet MS"),
axis.title.x = element_text(size = 11, family = "Trebuchet MS"),
plot.caption = element_text(size = 10, hjust = 0, margin=margin(t=10), 
family = "Trebuchet MS"),
plot.title=element_text(family="TrebuchetMS-Bold"),
plot.subtitle=element_text(family="TrebuchetMS-Italic")
)

#contribution biplot
fviz_ca_biplot(ca3, map ="rowprincipal", arrow = c(TRUE, FALSE), repel = TRUE) +
theme_bw() +
labs(title="CA Analysis: Conribution Biplot for Ornament Style and Time Period ",
subtitle="39 ornamentations from 77 female graves at Iron age sites in Bornholm, Denmark",
caption="Data: Ørsnes, M. (1966)") +
theme(
panel.border = element_rect(colour = "gray90"),
axis.text.x = element_text(angle = 0, size = 10, family = "Trebuchet MS"),
axis.text.y = element_text(size = 9, family = "Trebuchet MS"),
axis.title.y = element_text(size = 11, family = "Trebuchet MS"),
axis.title.x = element_text(size = 11, family = "Trebuchet MS"),
plot.caption = element_text(size = 10, hjust = 0, margin=margin(t=10), 
family = "Trebuchet MS"),
plot.title=element_text(family="TrebuchetMS-Bold"),
plot.subtitle=element_text(family="TrebuchetMS-Italic")
)

sessionInfo()







