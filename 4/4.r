library(readr)
ds <- read.csv("D:/Documents/Learning/3/R/ff.csv")
summary(ds)
library(modeest)

hiphop <- ds$`BPM`[ds$`Код.Жанра` == 1]
rock <- ds$`BPM`[ds$`Код.Жанра` == 0]
pop <- ds$`BPM`[ds$`Код.Жанра` == 2]
ds$genre <- factor(ds$Код.Жанра, levels = c(0, 1, 2),
 labels = c("рок", "хип-хоп", "поп"))
anova_result <- aov(BPM ~ genre, data = ds)
t_test_result <- t.test(rock, pop, var.equal = TRUE)

# Вывод результатов
print(anova_result)
print(summary(anova_result))


# Преобразуем Инструментальность в категории
ds$InstrumentalityCategory <- cut(ds$Инструментальность, 
                                    breaks = c(-0.01, 0.33, 0.66, 1.0), 
                                    labels = c("Low", "Medium", "High"),
                                    include.lowest = TRUE)

# Создаем переменную IsRock (1 — рок, 0 — остальные жанры)
ds$IsRock <- ifelse(ds$Код.Жанра == 0, 1, 0)

# Тест хи-квадрат
chi_test <- chisq.test(table(ds$InstrumentalityCategory, ds$IsRock))
print(chi_test)


mode_value <- mfv(ds$BPM)
print(paste("Мода: ", mode_value))
variance <- var(ds$BPM)
std_dev <- sd(ds$BPM)
print(paste("Дисперсия", variance))
print(paste("Отклонение", std_dev))
print(head(ds))
print(summary(ds))
ttest <- t.test(ds$`Код.Жанра` ~ ds$`BPM`)
print(ttest)

wtest <- wilcox.test(ds$`Код.Жанра` ~ ds$`BPM`)
print(wtest)

ctable <- table(ds$`Код.Жанра`, ds$`Вокал`)
ctable1 <- chisq.test(ctable)
print(ctable1)
print(head(ds))



