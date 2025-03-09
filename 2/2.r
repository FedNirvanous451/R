library(dplyr)
library(readr)
ds <- read.csv("2/empl.csv", sep=';')
print(colSums(is.na(ds)))

