library(ggplot2)
library(readr)
df <- read.csv("music_genre_dataset.csv")
p <- ggplot(df, aes(x = BPM,y = RMS.Energy)) +
geom_line() + geom_point() + labs(title = 'График')
print(p)

