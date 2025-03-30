library(ggplot2)
library(readr)
getwd()
df <- read.csv("D:/Documents/Learning/3/R/music_genre_dataset.csv")
p <- ggplot(df, aes(x = BPM,y = RMS.Energy)) +
geom_boxplot(fill = '#bb205b',color = 'blue') +
labs(title = 'boxplot')
print(p)