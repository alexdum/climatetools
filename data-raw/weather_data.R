buc <- read.csv("data-raw/bucharest_baneasa.csv")
buc_baneasa$Date <- as.Date(bucharest_baneasa$Date)

devtools::use_data(buc_baneasa, overwrite = TRUE)



