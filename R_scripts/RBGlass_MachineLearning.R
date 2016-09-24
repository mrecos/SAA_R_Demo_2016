library("archdata")
library("xgboost")
library("Ckmeans.1d.dp")
library("ggplot2")
data(RBGlass1)
rgb <- RBGlass1
rgb$Site <- as.numeric(rgb$Site)-1
train_index <- sample(nrow(rgb), floor(nrow(rgb)*0.75))
train_dat <- rgb[train_index,]
test_dat <- rgb[-train_index,]

model1 <- xgboost(data = as.matrix(train_dat[,-1]), 
                  label = train_dat$Site,
                  nrounds = 10,
                  objective = "binary:logistic")
pred1 <- predict(model1, newdata = as.matrix(test_dat[,-1]))
prediction <- data.frame(predicted = as.numeric(pred1 > 0.5),
                         observed = test_dat$Site)
table(prediction)
err <- mean(prediction$predicted != prediction$observed)
print(paste("test-error=", round(err,3)))

importance_matrix <- xgb.importance(colnames(train_dat[,-1]),
                                    model = model1)
print(importance_matrix) # Manganese and Antimony
xgb.plot.importance(importance_matrix = importance_matrix) +
  theme_bw()
