library(data.table)

games <- fread("data/processed/games_clean.csv")

genre_summary <- games[, .(n = .N,
                           mean = mean(positive_ratio),
                           median = median(positive_ratio),
                           sd = sd(positive_ratio)),
                       by = primary_genre][order(-n)]

genre_summary

fwrite(genre_summary, "outputs/tables/genre_summary.csv")

png("outputs/figures/ratio_distribution.png", width = 800, height = 600)
hist(games$positive_ratio, breaks = 50,
     main = "Distribution of positive review ratio",
     xlab = "Positive review ratio")
dev.off()

png("outputs/figures/ratio_by_genre.png", width = 900, height = 650)
par(mar = c(10, 4, 4, 2))
boxplot(positive_ratio ~ primary_genre, data = games,
        las = 2, xlab = "", ylab = "Positive review ratio",
        main = "Positive review ratio by genre")
dev.off()
