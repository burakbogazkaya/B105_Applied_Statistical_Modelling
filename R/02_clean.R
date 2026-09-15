library(data.table)

games <- fread("data/processed/games_selected.csv")

log_rows <- data.table(step = "raw", n = nrow(games))

valid_genres <- c("Action", "Adventure", "Casual", "Simulation",
                  "Strategy", "RPG", "Sports", "Racing",
                  "Massively Multiplayer")

get_primary_genre <- function(x) {
  if (is.na(x) || x == "") return(NA_character_)
  
  parts <- trimws(strsplit(x, ",")[[1]])
  
  kept <- intersect(parts, valid_genres)
  
  kept[1]
}

games[, primary_genre := sapply(Genres, get_primary_genre, USE.NAMES = FALSE)]

games <- games[!is.na(primary_genre)]

log_rows <- rbind(log_rows, data.table(step = "valid genre", n = nrow(games)))

games[, total_reviews := Positive + Negative]
games[, positive_ratio := Positive / total_reviews]
