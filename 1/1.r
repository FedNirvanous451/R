library(dplyr)
library(readr)
df <- read.csv("empl.csv", sep=';')
f_df <- filter(df, employees_count >= 60)
print(f_df)
avg <- mean(df$employees_count, na.rm = TRUE)
print(avg)

