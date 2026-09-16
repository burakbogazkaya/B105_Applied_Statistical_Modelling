library(data.table)
library(car)

set.seed(42)

games <- fread("data/processed/games_clean.csv")

model <- aov(positive_ratio ~ primary_genre, data = games)

png("outputs/figures/qq_residuals.png", width = 800, height = 600)
qqnorm(residuals(model))
qqline(residuals(model))
dev.off()

leveneTest(positive_ratio ~ as.factor(primary_genre), data = games)

shapiro_results <- tapply(games$positive_ratio, games$primary_genre,
                          function(x) shapiro.test(sample(x, min(length(x), 5000)))$p.value)

fwrite(data.table(genre = names(shapiro_results), shapiro_p = shapiro_results),
       "outputs/tables/shapiro_by_genre.csv")

#each row is a distinct game (unique AppID), so observations are
#independent in the sampling sense. Games sharing a developer or franchise may
# not be fully independent. noted as a limitation.