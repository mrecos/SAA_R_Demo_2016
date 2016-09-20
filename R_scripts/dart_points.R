# Details
# Measurements on five types of dart points from Fort Hood in central Texas (Darl, Ensor, Pedernales, Travis, and Wells). The points were recovered during 10 different pedestrian survey projects during
# the 1980’s and were classified and measured by H. Blaine Ensor using the system created by Futato
# (1983) as described in Carlson, S., et al 1987, pp 51-70 and Appendices 4 and 7.
# 
# Source
# Fort Hood Projectile Points. Electronic database compiling the results of multiple surface surveys
# at Fort Hood in the possession of David L. Carlson, Department of Anthropology, Texas A&M University,
# College Station, TX. The artifacts are curated at Fort Hood, TX by the Cultural Resources
# Branch of the Directorate of Public Works.
# 
# References
# Carlson, S. B., H. B. Ensor, D. L. Carlson, E. A. Miller, and D E. Young. 1987. Archaeological
# Survey at Fort Hood, Texas Fiscal Year 1984. United States Army Fort Hood. Archaeological
# Resource Management Series, Research Report Number 14.
# Futato, E. M. 1983. Projectile Point Morphology: Steps Toward a Formal Account. in Proceedings
# of the Thirty-fourth Southeastern Archaeological Conference, Lafayette, Louisiana, October 27-19,
# 1977. Southeastern Archaeological Conference. Bulletin 21: 38–81.


### Load libraries
## These allow for extending the capabilities of base R
## Better to load all libraries up front
library("archdata") # for the archaeology data sets
library("dplyr") # for data manipulation
library("stringr") # for working with chracter strings
library("tidyr") 

### Load data
## the 'DartPoints' dataset is included in the 'archdata' library loaded above
## Call the dataset we want by using the data() function
data(DartPoints)
# assign the dataset to a variable called 'dp' to save some typing
dp <- DartPoints

### Explore data
## These steps can lead you down many paths, but the idea is to look into the data
## to better understand what it includes and how it is structured
# the str() function prints out the strcture of the object
str(dp)
# dplyr package has a similar function
glimpse(dp)
# summary() function gives a summary of the data that varies by data type
summary(dp)
# head() function prints out the 'head' or first few occurences/rows of the data
head(dp)
# adding an integer as the second argument to head will instruct the function on how 
# many occurences/rows to print.  THe default is n = 5
head(dp, 10)
# the tail() function works the same way, but for the end of the dataset
tail(dp,10)
# We can even take a look at the table in a more spreadsheet presentation
# not recommended for larger data sets
View(dp)

## visualizing the data helps too
hist(dp$Length)
# hist() has additional arguments that control the bin count
hist(dp$Length, breaks = 30)
# boxplots allow for the visualization of aggregated distributions
boxplot(dp$Length)
# boxplots can also be grouped to compare distributions
boxplot(dp$Length ~ dp$Name)
# or bivariate combinations of all numric variables
pairs(dp[,c(7:13)])

# vectors

# subsets

# dplyr 

# functions




dp1 <- dplyr::select(dp, Length, Width, Thickness, B.Width, J.Width, Length, Weight)
summary(dp1)
md.pattern(dp1)
imputed_Data <- mice(dp1, m=5, maxit = 50, method = 'pmm', seed = 500)
summary(imputed_Data)
dp_impute <- complete(imputed_Data,2)
summary(dp_impute)
dp_impute[is.na(dp$B.Width),"B.Width"]
BIC = mclustBIC(dp_impute)
clust1 <- Mclust(dp_impute, x = BIC)
summary(clust1)
summary(clust1, parameters = TRUE)
plot(clust1, what = "classification")
table(dp$TARL, clust1$classification)

ICL = mclustICL(X)
summary(ICL)
plot(ICL)
LRT = mclustBootstrapLRT(X, modelName = "VVV")
LRT

mod1dr = MclustDR(clust1)
summary(mod1dr)
plot(mod1dr, what = "pairs")
plot(mod1dr, what = "boundaries", ngrid = 200)

mod1dr = MclustDR(clust1, lambda = 1)
summary(mod1dr)
plot(mod1dr, what = "scatterplot")
plot(mod1dr, what = "boundaries", ngrid = 200)
