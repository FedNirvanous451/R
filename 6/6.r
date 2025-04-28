library(readr)
df <- read.csv("D:/Documents/Learning/3/R/5/df_without_genre.csv")

model <- lm(Zero.Crossing.Rate ~ BPM + RMS.Energy, data = df)
print(summary(model))

# Дополнительные метрики
predictions <- predict(model, df)
residuals <- df$Zero.Crossing.Rate - predictions
mse <- mean(residuals^2)
print(mse)
 
library(Metrics)
mse_val <- mse(df$Zero.Crossing.Rate, predictions)
r2_val <- cor(df$Zero.Crossing.Rate, predictions) ^ 2
print(paste("MSE =", mse_val))
print(paste("R^2 =", r2_val))

print(plot(df$Zero.Crossing.Rate, predictions, xlab = "Реальные значение (Y) ",
ylab = "Предсказанные значения (Y_pred) ",
main = "Реальные vs. Предсказанные"))
abline(a=0, b=1, col="yellow")

print(plot(model))