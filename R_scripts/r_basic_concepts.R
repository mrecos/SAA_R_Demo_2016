### Load libraries
library("dplyr") # for data manipulation
library("tidyr") 

# # Basic data types and working with data structures
# R has three main data types: chracter, numeric, and logical
# These data types are used as single objects, or within data structures
# incuding: vector, matrix, list, and data.frame

# simple chracter
"a"
# but not unquoted, because R expects that to be an object defined as somthing
prtint(a) # returns: Error: object 'a' not found
# use the assignment operator '<-' to assign a value to the object 'a'
a <- "x"
print(a)# returns: [1] "x"
class(a) # tells us the data type of the object a: [1] "character"
# now the object 'a' is assigned the chracter value "x"

## That object can be used in a printed string with the paste0() function
print(paste0("object a contains the value: ", a))
# we can change the value of 'a' by reassigning it with another value
a <- "y" # R does not warn you that 'a' already is assigned a value!
print(paste0("object a contains the value: ", a))

## object 'a' can also be a numeric
a <- 2
print(a)
# assign another number to object 'b'
b <- 5
# now we can add the two object since they are just placeholders for numbers
a + b
# this could also be accomplished simply by typeing:
2 + 5
# but using objects allows for the declaration of values, types, and all sorts of stuff

### Vectors
# character vector
v <- c("1", "x", "ch")
v1 <- c("The", "brown", "dog")
v2 <- c("runs", "fast!")
# concatenate character vectors
v3 <- c(v1, v2)
new_sentence <- (paste0(v3, collapse = ' '))
print(new_sentence) 

# numeric vector 
bvec <- c(1,4,78)
# logical vector
c <- c(TRUE, FALSE, TRUE)
as.numeric(c)

# make a numeric vector from a sequence
bvec1 <- 1:10
# find the length of a vector
length(bvec1)
# [1] 10
# or - to get the same thing
bvec2 <- seq(from = 1, to = 10, by = 1)
# add vectors
bvec1 + bvec2
# vector of boot strpped samples from vector b1
boot_samp <- sample(bvec1, 40, replace = TRUE)
# a vector of length 1000 filled with random standard normals
set.seed(717)
rand_norm <- rnorm(1000,0,1)
length(rand_norm)

## factor - a nomial data type. Each nomial value is mapped and stored as an interger
# make a factor data type 
colors <- sample(c("orange", "green", "blue"), 15, replace = TRUE)
fact1 <- factor(colors)
# prints as color names, but is stored internally as integer values assigned based on alphabetical order
print(fact1)
levels(fact1)
as.numeric(fact1)
as.character(fact1)
## Sometimes the realtive order of the levels matter
fact2 <- factor(fact1, levels = c("blue", "orange", "green"))
levels(fact2)
## Other times, factors need to be expliclty ordered
ord_fact <- ordered(colors, levels = c("blue", "orange", "green"))
# notice that the Levels attribute shows that blue is less than orange is less than green
print(ord_fact)


## qualities and quantities of vectors
table(v)
table(c)
table(boot_samp)
sum(boot_samp) 
mean(rand_norm)
var(rand_norm)
sd(rand_norm)^2
quantile(rand_norm)

# Matrix - n x m dimentsional, all data the same type (e.g. character, numeric, etc...) 
m1 <- matrix(1:20, nrow = 5)
m2 <- matrix(1:20, ncol = 6)
m2 <- matrix(1:20, ncol = 2)
m3 <- matrix(letters[1:20], ncol = 2)
dim(m3)
nrow(m3)
ncol(m3)
summary(m3)
summary(m2)
colnames(m2) <- c("Column 1", "Column 2")
t(m2)
m4 <- matrix(c(1:10,letters[1:10]), ncol = 2)

# lists - A vector that contains any ther data object
# ex. a list of three elements: 1) a single numeric, 2) a chracter vector, 3) a numeric marix
l1 <- list(b, new_sentence, m2)
y_var <- rbinom(10,1,0.5)
x_vars <- matrix(c(rnorm(10,0,1),rnorm(10,4,0.5)),ncol = 2)
mod1 <- glm(y_var ~ x_vars, family = "binomial")
model_list <- list(y = y_var, x = x_vars, model = summary(mod1))


### Indexing vectors & subsetting matrices/lists/data.frames
## Each of the data structures can be indexed and subsetted to retieve elements, rows, vectors, etc...
# for vectors
char1 <- v1[2]
num1 <- bvec[3]
num2 <- boot_samp[3:15]

## Matrices are indexed by row (n) the column (m) as [n,m]
# single value from row 1, column 1
m2[1,1]
m2[5,2]
# get entire row - index by row number, but leave column index blank
# returns as single row matrix
m2[5,]
# get entire column - index by column number, but leave row index blank
# returns a vector
m2[,2]
# or return a single column matrix
m2[,2,drop = FALSE]
# return a range of rows, same works for columns
m2[1:3,]

## adding rows or columns
# create some random data to append
new_row <- c(99,109)
new_col <- sample(1:11,11)
# add row with rbind() function
new_matrix <- rbind(m2,new_row)
# add column with cbind() function
new_matrix <- cbind(new_matrix, new_col)
# set row and column names
colnames(new_matrix) <- c("col1", "col2", "col3")
rownames(new_matrix) <- NULL
print(new_matrix)

## data.frames are similar to matrices, but can store values of either num, char, or logic for each column
## data.frames are more general than matrices and are a very common data format for analysis
df1 <- data.frame(new_matrix)
## df1 contains only numeric data, but we can add a column of characters using cbind()
# a matrix would warn you about this and convert all data to characters
df1 <- cbind(df1, col4 = letters[1:nrow(df1)])
## It can be indexed the same way as a matrix using [row,column]
# returns a vector of the second column
df1[,2]
# or single values
df1[5,2]
## data.frames can also be indexed by column names in two different ways
# 1) quoted string with brackets as above, e.g. [,"column_name"]
# note that it was automatically converted to a factor when cbind() added it to the dataframe
df1[,"col4"]
# or index by the column as its own object
## or multiple columns using the c() function and column names
df1[ ,c("col1", "col4")]
# or 2) with the '$' operator 
df1$col1


##### Working with data
## operators
df2 <- data.frame(col1 = rnorm(10,0,1),
                  col2 = rnorm(10,4,0.5),
                  col3 = rbinom(10,1,0.5))
print(df2)
df2$col4 <- df2$col1 + df2$col2
print(df2$col4)
df2$col4 <- df2$col1 - df2$col2
print(df2$col4)
df2$col4 <- df2$col1 / df2$col2
print(df2$col4)
df2$col4 <- df2$col1 * df2$col2
print(df2$col4)


### Basic Control structures
# if statement
if (condition) { 
  # do something
}
# if else statment
if (condition) {
  # do somthing
} else {
  # or do something else
}
# for loop
for (variable in vector) {
  # do something for each variable
}
# while loop
while (condition) {
  # do something while condition is TRUE
}
# examples

# if statment
some_data <- rnorm(10,0,1)
if (mean(some_data) > 0) {
  some_new_data <- mean(some_data)
  print(mean(some_data))
}
# if else statment
some_data <- rnorm(10,0,1)
if (mean(some_data) > 0) {
  some_new_data <- mean(some_data)
  print(mean(some_data))
} else {
  some_new_data <- NULL
  print("Mean of data is less than zero")
}
# for loop
some_data <- rnorm(10,0,1)
for (i in 1:length(some_data)) {
  some_new_data <- some_data[i]^2
  print(some_new_data)
}
# nested ifelse in for loop
some_data <- rnorm(10,0,1)
some_new_data <- NULL
for (i in 1:length(some_data)) {
  iter_data <- some_data[i]
  if (iter_data > 0) {
    some_new_data[i] <- iter_data^2
    print("Data positive")
  } else {
    some_new_data[i] <- abs(iter_data)^2
    print("Data < 0, applied asb()")
  }
}
print(some_new_data)
# vectorized version of above
some_new_data2 <- ifelse(some_data > 0, some_data^2, abs(some_data)^2)
print(some_new_data2)
identical(some_new_data, some_new_data2)
# while loop # be careful
i <- 0
while(i < 4){
  new_value <- rbinom(1,1,0.5)
  i <- i + new_value
  print(paste0("Value of 'i' is: ", i))
}


# functions
df2$col4 <- df2$col1 - mean(df2$col1)
print(df2$col4)
df2$col4 <- scale(df2$col1, center = TRUE, scale = FALSE)
print(df2$col4)
df2$col4 <- sign(df2$col1)
print(df2$col4)
df2$col4 <- ifelse(sign(df2$col1) == 1, TRUE, FALSE)
print(df2$col4)

# an arbitrary function
my_function <- function(x, y, constant){
  x <- ifelse(x >= 0, x^2, x/2)
  new_value <- mean(y) * x + constant
  return(new_value)
}

df2$col4 <- my_function(df2$col1, df2$col2, 0.5)
print(df2$col4)


# apply functions (brief)
df3 <- data.frame(col1 = rnorm(10,0,1),
                  col2 = rnorm(10,4,0.5),
                  col3 = rbinom(10,1,0.5))
# apply() # returns vector by applying function over margins of a matrix
column_means <- apply(df3,2,mean)
print(column_means)
row_means <- apply(df3,1,mean)
print(row_means)
sqrd_matrix <- apply(df3,1:2, function(x) x^2)
print(sqrd_matrix)
# colMeans(), rowMeans(), colSums(), rowSums() stand in for the above
# by # operations by a group
group_col_means <- by(df3[,1:2], df3$col3, colMeans)
print(group_col_means)
# lapply # apply a function to each element of a list; returns list
l2 <- list(part1 = rnorm(5,0,1), part2 = rnorm(12,3,1))
print(l2)
list_means <- lapply(l2, mean)
print(list_means)
list_sums <- lapply(l2, sum)
print(list_sums)
# sapply - similar to lapply, but returns vector of matrix
list_means2 <- sapply(l2, mean)
print(list_means2)
### Other apply methods should you need them


### dplyr & the tidyverse
## a suite of tools for doing all of the above and much more
# 

# functions



















