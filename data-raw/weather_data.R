bucharest_baneasa <- read.csv("data-raw/bucharest_baneasa.csv")
bucharest_baneasa$Date <- as.Date(bucharest_baneasa$Date)

devtools::use_data(bucharest_baneasa, overwrite = TRUE)



