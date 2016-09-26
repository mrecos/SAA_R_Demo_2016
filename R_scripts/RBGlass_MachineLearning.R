library("archdata")
library("xgboost")
library("Ckmeans.1d.dp")
library("ggplot2")
library("dplyr")
library("reshape2")
library("tidyr")

data(RBGlass1)
rbg <- RBGlass1

rbg_elements <- group_by(rbg, Site) %>%
  summarise_each(funs(mean, median)) %>%
  t %>%
  as.data.frame( stringsAsFactors = FALSE) %>% 
  tibble::rownames_to_column() %>%
  rename(Leicester = V1,  Mancetter = V2) %>%
  filter(!grepl('Site', rowname)) %>%
  mutate(Leicester = round(as.numeric(Leicester),3),
         Mancetter = round(as.numeric(Mancetter),3)) %>%
  separate(rowname, into = c("element", "measure"), sep = "_") %>%
  reshape2::melt()

rbg_plot_mean <- filter(rbg_elements, measure == "mean") %>%
  ggplot(aes(x = element, y = value, color = variable)) +
           geom_point() + 
  scale_y_log10() +
  theme_bw()

rbg_plot_mean


rbg$Site <- as.numeric(rbg$Site)-1
train_index <- sample(nrow(rbg), floor(nrow(rbg)*0.75))
train_dat <- rbg[train_index,]
test_dat <- rbg[-train_index,]

model1 <- xgboost(data = as.matrix(train_dat[,-1]), 
                  label = train_dat$Site,
                  nrounds = 10,
                  objective = "binary:logistic")
pred1 <- predict(model1, newdata = as.matrix(test_dat[,-1]))
prediction <- data.frame(predicted = as.numeric(pred1 > 0.5),
                         observed = test_dat$Site)

prediction$predicted <- ifelse(prediction$predicted == 1, 
                               "Leicester", "Mancetter")
prediction$observed <- ifelse(prediction$observed == 1, 
                              "Leicester", "Mancetter")
table(prediction)
err <- mean(prediction$predicted != prediction$observed)
print(paste("test-error =", round(err,3)*100, "%"))

importance_matrix <- xgb.importance(colnames(train_dat[,-1]),
                                    model = model1)
print(importance_matrix) # Manganese and Antimony
xgb.plot.importance(importance_matrix = importance_matrix) +
  theme_bw()
