library(readr)
music_data <- read.csv("D:/Documents/Learning/3/R/music_genre_dataset.csv")

# Проверим уникальные жанры в данных
unique_genres <- unique(music_data$Жанр)
print(unique_genres)

# Создаем числовые коды для каждого жанра
genre_mapping <- data.frame(
  Жанр = c("рок", "хип-хоп", "поп"),  # именно в таком порядке
  Код = 0:2
)

# Объединяем с исходными данными
music_data <- merge(music_data, genre_mapping, by = "Жанр", all.x = TRUE)

# Переименовываем колонку
names(music_data)[names(music_data) == "Код"] <- "Код.Жанра"

# Сохраняем преобразованный датасет
write.csv(music_data, "music_data_encoded.csv", row.names = FALSE)

# Сохраняем таблицу соответствия
write.csv(genre_mapping, "genre_mapping.csv", row.names = FALSE)

library(e1071)
library(caret)
library(rgl)

data_music <- read.csv("D:/Documents/Learning/3/R/music_dataset.csv")

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
print("Матрица ошибок:")
print(confusionMatrix(predictions, test$Код.Жанра))
