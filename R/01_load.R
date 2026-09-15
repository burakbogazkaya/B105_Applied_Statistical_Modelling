library(data.table)

games <- fread("data/raw/games.csv")

setnames(games, c(
  "AppID", "Name", "Release date", "Estimated owners", "Peak CCU",
  "Required age", "Price", "Discount", "DLC count", "About the game",
  "Supported languages", "Full audio languages", "Reviews", "Header image",
  "Website", "Support url", "Support email", "Windows", "Mac", "Linux",
  "Metacritic score", "Metacritic url", "User score", "Positive", "Negative",
  "Score rank", "Achievements", "Recommendations", "Notes",
  "Average playtime forever", "Average playtime two weeks",
  "Median playtime forever", "Median playtime two weeks",
  "Developers", "Publishers", "Categories", "Genres", "Tags",
  "Screenshots", "Movies"
))


keep <- c("AppID", "Name", "Release date", "Price", "Positive", "Negative",
          "Genres", "Categories", "Estimated owners", "Peak CCU",
          "Metacritic score", "Achievements", "Windows", "Mac", "Linux",
          "Supported languages", "DLC count")

games_small <- games[, ..keep]

dim(games_small)


fwrite(games_small, "data/processed/games_selected.csv")
file.size("data/processed/games_selected.csv") / 1024^2