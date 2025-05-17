library(readr)
ds <- read.csv("D:/Documents/Learning/3/R/ff.csv")
summary(ds$BPM)
library(modeest)
mode_value <- mfv(ds$BPM)
print(paste("Мода: ", mode_value))
variance <- var(ds$BPM)
std_dev <- sd(ds$BPM)
print(paste("Дисперсия", variance))
print(paste("Отклонение", std_dev))

ttest <- t.test(ds$`Код.Жанра` ~ ds$`BPM`)
print(ttest)

wtest <- wilcox.test(ds$`Код.Жанра` ~ ds$`BPM`)
print(wtest)

ctable <- table(ds$`Код.Жанра`, ds$`Вокал`)
ctable1 <- chisq.test(ctable)
print(ctable1)




