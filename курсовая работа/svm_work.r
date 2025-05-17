library(e1071)
library(caret)
library(rgl)

data_music <- read.csv("D:/Documents/Learning/3/R/ff.csv")

# 3. Разделение на обучающую и тестовую выборки
set.seed(123) # для воспроизводимости
n <- nrow(data_music)
train_indices <- sample(1:n, size = round(0.8 * n))
train <- data_music[train_indices, ]
test <- data_music[-train_indices, ]

# ПРЕОБРАЗУЕМ В ФАКТОРЫ ПОСЛЕ РАЗДЕЛЕНИЯ
train$Код.Жанра <- factor(train$Код.Жанра)
test$Код.Жанра <- factor(test$Код.Жанра, levels = levels(train$Код.Жанра))  # Важно сохранить уровни

# 4. Обучение модели SVM
svm_model <- svm(Код.Жанра ~ BPM + RMS.Energy + Zero.Crossing.Rate
                 + Инструментальность + Вокал,
                 data = train,
                 kernel = "radial",  # Радиальное ядро
                 scale = TRUE,       # Масштабирование признаков
                 probability = TRUE) # Для получения вероятностей

# Предсказание
predictions <- predict(svm_model, test)

# Преобразуем predictions в фактор (уровни берем из train)
predictions <- factor(predictions, levels = levels(train$Код.Жанра))

# Матрица ошибок
conf_matrix <- confusionMatrix(predictions, test$Код.Жанра)
print("Матрица ошибок:")
print(conf_matrix)

# Извлечение Precision, Recall и F1-Score
precision <- conf_matrix$byClass[, "Precision"]
recall <- conf_matrix$byClass[, "Recall"]
f1_score <- conf_matrix$byClass[, "F1"]

# Вывод результатов
cat("Precision:\n")
print(precision)
cat("\nRecall:\n")
print(recall)
cat("\nF1-Score:\n")
print(f1_score)

# Вывод средних значений
cat("\nСредний Precision:", mean(precision), "\n")
cat("Средний Recall:", mean(recall), "\n")
cat("Средний F1-Score:", mean(f1_score), "\n")
