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
names(music_data)[names(music_data) == "Код"] <- "Жанр_код"

# Сохраняем преобразованный датасет
write.csv(music_data, "music_data_encoded.csv", row.names = FALSE)

# Сохраняем таблицу соответствия
write.csv(genre_mapping, "genre_mapping.csv", row.names = FALSE)

# Выводим первые строки для проверки
print(head(music_data))
