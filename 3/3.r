library(ggplot2)
library(readr)
df <- read.csv("music_genre_dataset.csv")
p <- ggplot(df, aes(x = RMS.Energy)) +
geom_histogram(bins = 10, fill = '#094e92', color = '#e43f08', alpha = 0.7) +
labs(title = "Histogram")
print(p)