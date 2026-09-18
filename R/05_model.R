library(data.table)

games <- fread("data/processed/games_clean.csv")

welch <- oneway.test(positive_ratio ~ primary_genre,
                     data = games, var.equal = FALSE)
welch

aov_model <- aov(positive_ratio ~ primary_genre, data = games)
summary(aov_model)

ss <- summary(aov_model)[[1]][["Sum Sq"]]
eta_sq <- ss[1] / sum(ss)
eta_sq

tukey <- TukeyHSD(aov_model)
tukey

eta_results <- data.table(statistic = c("F", "num df", "denom df", "eta squared"),
                          value = c(welch$statistic, welch$parameter[1],
                                    welch$parameter[2], eta_sq))
fwrite(eta_results, "outputs/tables/welch_anova.csv")

tukey_dt <- as.data.table(tukey$primary_genre, keep.rownames = "comparison")
fwrite(tukey_dt, "outputs/tables/tukey_results.csv")

png("outputs/figures/tukey_plot.png", width = 900, height = 900)
par(mar = c(5, 14, 4, 2))
plot(tukey, las = 1)
dev.off()

games[, logit_ratio := log((Positive + 0.5) / (Negative + 0.5))]

summary(games$logit_ratio)

welch_logit <- oneway.test(logit_ratio ~ primary_genre,
                           data = games, var.equal = FALSE)
welch_logit

aov_logit <- aov(logit_ratio ~ primary_genre, data = games)
ss_logit <- summary(aov_logit)[[1]][["Sum Sq"]]
eta_sq_logit <- ss_logit[1] / sum(ss_logit)
eta_sq_logit

robustness <- data.table(
  model = c("raw ratio", "empirical logit"),
  F = c(welch$statistic, welch_logit$statistic),
  denom_df = c(welch$parameter[2], welch_logit$parameter[2]),
  eta_sq = c(eta_sq, eta_sq_logit)
)
fwrite(robustness, "outputs/tables/robustness_check.csv")
