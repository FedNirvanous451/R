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
names(music_data)[names(music_data) == "Код"] <- "Код Жанра"

# Сохраняем преобразованный датасет
write.csv(music_data, "music_data_encoded.csv", row.names = FALSE)

# Сохраняем таблицу соответствия
write.csv(genre_mapping, "genre_mapping.csv", row.names = FALSE)

library(e1071)
library(caret)
library(rql)

data_music <- read.csv("D:/Documents/Learning/3/R/music_data_encoded.csv")

# 3. Разделение на обучающую и тестовую выборки
set.seed(123)
trainIndex <- createDataPartition(data_music$Код.Жанра, p = 0.8, list = FALSE)
train <- data_music[trainIndex, ]
test <- data_music[-trainIndex, ]

# 4. Обучение модели SVM
svm_model <- svm(Код.Жанра ~ BPM + RMS.Energy + Zero.Crossing.Rate, 
                 data = train,
                 kernel = "radial",  # Радиальное ядро
                 scale = TRUE,       # Масштабирование признаков
                 probability = TRUE) # Для получения вероятностей

# Предсказание
predictions <- predict(model, mtcars)
confusionMatrix(predictions, test$Код.Жанра)
# Оценка точности
table(predictions, test$Код.Жанра)
