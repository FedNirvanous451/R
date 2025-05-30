library(readr)
ds <- read.csv("D:/Documents/Learning/3/R/ff.csv")
summary(ds)
library(modeest)

hiphop_data <- data$bpm[data$genre == "hiphop"]
rock <- ds$`BPM`[ds$`Код.Жанра` == 0]
pop <- ds$`BPM`[ds$`Код.Жанра` == 2]
t_test_result <- t.test(rock, pop, var.equal = TRUE)

# Вывод результатов
print(t_test_result)
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



