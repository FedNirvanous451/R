library(readr)
music_data <- read.csv("D:/Documents/Learning/3/R/music_genre_dataset.csv")

# Проверим уникальные жанры в данных
unique_genres <- unique(music_data$Жанр)
print("Уникальные жанры:")
print(unique_genres)

# Создаем числовые коды для каждого жанра
genre_mapping <- data.frame(
  Жанр = c("рок", "хип-хоп", "поп"),  # именно в таком порядке
  Код = 0:2
)
print("Таблица соответствия жанров и кодов:")
print(genre_mapping)

# Объединяем с исходными данными
music_data <- merge(music_data, genre_mapping, by = "Жанр", all.x = TRUE)

# Переименовываем колонку
names(music_data)[names(music_data) == "Код"] <- "Код.Жанра"
print("Первые несколько строк объединенных данных:")
print(head(music_data))

# Сохраняем преобразованный датасет
write.csv(music_data, "music_data_encoded.csv", row.names = FALSE)
print("Преобразованный датасет сохранен в music_data_encoded.csv")

# Сохраняем таблицу соответствия
write.csv(genre_mapping, "genre_mapping.csv", row.names = FALSE)
print("Таблица соответствия сохранена в genre_mapping.csv")

library(e1071)
library(caret)
library(rgl)

data_music <- read.csv("D:/Documents/Learning/3/R/music_data_encoded.csv")
print("Размер исходных данных:")
print(dim(data_music))
print("Тип данных Код.Жанра до разделения:")
print(class(data_music$Код.Жанра))

# 3. Разделение на обучающую и тестовую выборки
set.seed(123) # для воспроизводимости
n <- nrow(data_music)
train_indices <- sample(1:n, size = round(0.8 * n))
train <- data_music[train_indices, ]
test <- data_music[-train_indices, ]

print("Размер обучающей выборки:")
print(dim(train))
print("Размер тестовой выборки:")
print(dim(test))

# ПРЕОБРАЗУЕМ В ФАКТОРЫ ПОСЛЕ РАЗДЕЛЕНИЯ
train$Код.Жанра <- factor(train$Код.Жанра)
print("Тип данных Код.Жанра в обучающей выборке (после преобразования):")
print(class(train$Код.Жанра))
print("Уровни Код.Жанра в обучающей выборке:")
print(levels(train$Код.Жанра))

test$Код.Жанра <- factor(test$Код.Жанра, levels = levels(train$Код.Жанра))  # Важно сохранить уровни
print("Тип данных Код.Жанра в тестовой выборке (после преобразования):")
print(class(test$Код.Жанра))
print("Уровни Код.Жанра в тестовой выборке:")
print(levels(test$Код.Жанра))

# 4. Обучение модели SVM
svm_model <- svm(Код.Жанра ~ BPM + RMS.Energy + Zero.Crossing.Rate,
                 data = train,
                 kernel = "radial",  # Радиальное ядро
                 scale = TRUE,       # Масштабирование признаков
                 probability = TRUE) # Для получения вероятностей

# Предсказание
predictions <- predict(svm_model, test)
print("Первые несколько предсказанных значений:")
print(head(predictions))

# Преобразуем predictions в фактор (уровни берем из train)
predictions <- factor(predictions, levels = levels(train$Код.Жанра))
print("Тип данных predictions (после преобразования):")
print(class(predictions))
print("Уровни predictions:")
print(levels(predictions))


# Матрица ошибок
print("Матрица ошибок:")
print(confusionMatrix(predictions, test$Код.Жанра))

