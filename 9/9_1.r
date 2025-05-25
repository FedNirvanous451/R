library(e1071)
library(caret)


data_music <- read.csv("D:/Documents/Learning/3/R/music_data_encoded.csv")

# 3. Разделение на обучающую и тестовую выборки
set.seed(123) # для воспроизводимости
n <- nrow(data_music)
train_indices <- sample(1:n, size = round(0.8 * n))
train <- data_music[train_indices, ]
test <- data_music[-train_indices, ]

model_log1 <- glm(Код.Жанра ~ BPM + RMS.Energy + Zero.Crossing.Rate, data = train, family = "multinomial")
print(summary(model_log1))

pred_prob <- predict(model_log1, test, type = 'response')
pred_class <- max.col(pred_prob)
conf_matrix <- table(pred_class, test$Код.Жанра)
print(conf_matrix)

accuracy1 <- sum(diag(conf_matrix)) / sum(conf_matrix)
print(accuracy1)