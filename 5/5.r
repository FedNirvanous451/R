library(readr)
df <- read.csv("D:/Documents/Learning/3/R/ff.csv")
# Установите библиотеку ggcorrplot, если она еще не установлена
# install.packages("ggcorrplot")

# Вычисление корреляций
pearson_corr <- cor(df, method = "pearson")
spearman_corr <- cor(df, method = "spearman")

# Вывод результатов
cat("Корреляция Пирсона:\n")
print(pearson_corr)
cat("\nКорреляция Спирмена:\n")
print(spearman_corr)

# Визуализация корреляции Пирсона
library(ggcorrplot)
print(ggcorrplot(pearson_corr, lab = TRUE, title = "Корреляционная матрица Пирсона"))

model <- lm(BPM ~ RMS.Energy, data = df)
print(summary(model))
library(ggplot2)
#print(ggplot(df, aes(x = BPM, y = RMS.Energy)) +

#  geom_point() +
#  geom_smooth(method = "lm", color = "red") +
#  labs(title = "Линейная регрессия"))
