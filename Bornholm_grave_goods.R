# Details
# Data on the occurrence of 39 different types of ornamentation in 77 female graves at Iron age sites
# in in Bornholm, Denmark.
#
# Source
# Nielsen used data on 39 different types of ornaments from Ørsnes (1966) to seriate a series of
# 77 Germanic Iron Age graves from Bornholm, Denmark (1988, Table 4 and Figure 7). Baxter
# re-analyzed the data to illustrate correspondence analysis (1994: 104-107, Table A6). These data
# were taken from Nielsen’s Table 4 showing her seriation. Baxter’s version is scrambled in order to
# evaluate different seriation methods and does not include the ornament types (illustrated in Nielson’s
# Figure 7). The data include Ørsnes’s period designation (1966).
#
# References
# Baxter, M. J. 1994. Exploratory Multivariate Analysis in Archaeology. Edinburgh University Press.
# Edinburgh.
# Nielsen, D. H. 1988. Correspondence analysis applied to hords and graves of the Germanic Iron
# Age. In Multivariate Archaeology: Numerical Approaches in Scandinavian Archaeology, edited by
# Torsten Madsen, pp 37-54. Jutland Archaeological Society Publications XXI. Arahus University
# Press.
# Ørsnes, M. 1966. Form og stil i Sydskandinaviens yngre germanske jernalder. Nationalmuseets
# skrifter. Arkæologisk-historisk række 11. Copenhagen.

library("archdata")
library("dplyr")
library("MASS")

data(Bornholm)
bh <- Bornholm

str(bh)
summary(bh)
head(bh)

# from Baxter 1994 and Carlson 2016 (archdata)
?corresp
# by site
Bornholm.ca <- corresp(bh[, 4:42], nf=2)
plot(Bornholm.ca$rscore, pch=substring(bh$Period, 1, 1), cex=.75)
boxplot(Bornholm.ca$rscore[, 1]~bh$Period, main="First CA Axis by Period")

plot_dat <- data.frame(Bornholm.ca$rscore, label = substring(bh$Period, 1, 1))
ggplot(plot_dat, aes(x = X1, y = X2, label = label)) +
  geom_text() +
  theme_bw()

# y time period
bh2 <- group_by(bh, Period) %>%
  dplyr::select(-Number, -Site) %>%
  summarise_each(funs(sum)) %>%
  mutate(Period = as.character(Period)) %>%
  tibble::column_to_rownames(., "Period") %>%
  data.frame()

# EDA
# try using factominer pacakge and sthda.com wiki in CA
# http://www.sthda.com/english/wiki/correspondence-analysis-in-r-the-ultimate-guide-for-the-analysis-the-visualization-and-the-interpretation-r-software-and-data-mining
library("FactoMineR")
library("gplots")

# MASS and factoextra
ca2 <- corresp(bh2, nf = 2)
plot(ca2)
library("factoextra")
# use for GGPlot output of corresp object, maybe factominer too?
fviz_ca_biplot(ca2) +
  theme_minimal()
row <- get_ca_row(ca2)
row$coord
row$inertia
fviz_ca_row(ca2) +
  theme_minimal()
fviz_ca_col(ca2) +
  theme_minimal()

# FactoMineR
ca3 <- CA(bh2, ncp = 2)
print(ca3)
summary(ca3, nb.dec = 2, ncp = 2)

# eda steps
bh2_table <- as.table(as.matrix(bh2))
balloonplot(x = t(bh2_table), main = "Grave Goods by Style and Time Period", xlab ="", ylab="",
            label = FALSE, show.margins = FALSE)
mosaicplot(bh2_table, shade = TRUE, las=2, main = "Grave Goods by Style and Time Period")


eig <- get_eigenvalue(ca3)
trace <- sum(eig$eigenvalue) 
cor.coef <- sqrt(trace)
cor.coef # > 0.2 = significant (general rule)

# chi sq
chi2 <- trace*sum(as.matrix(bh2))
print(chi2)
# Degree of freedom
df <- (nrow(bh2) - 1) * (ncol(bh2) - 1)
# P-value
pval <- pchisq(chi2, df = df, lower.tail = FALSE)
print(pval)
# same as summary(ca3)

eigenvalues <- get_eigenvalue(ca3)
head(round(eigenvalues, 2))

factoextra::fviz_screeplot(ca3) + 
  theme_bw()

row_random <- (1/(nrow(bh2)-1))*100 # expected explained var by random
col_random <- (1/(ncol(bh2)-1))*100 # expected explained var by random

fviz_screeplot(ca3) +
  geom_hline(yintercept = max(row_random, col_random), linetype=2, color="red") +
  theme_bw()
# dimension 1 and 2 are included because dim > 3 could be by radom
# e.g. below max(row_random, col_random)

# symetric biplot
plot(ca3)
fviz_ca_biplot(ca3) +
  theme_bw()

# contirbution of rows and columns to global solution
fviz_ca_row(ca3, col.row="contrib")+
  scale_color_gradient2(low="white", mid="blue", 
                        high="red", midpoint=10)+
  theme_bw()

### If you were doing this for real...
# look deeper into row and column correlation (cos3) and contribution

# asymetric biplot
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
fviz_ca_biplot(ca3, map ="colgreen", arrow = c(TRUE, FALSE), repel = TRUE) +
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















