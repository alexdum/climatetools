buc_baneasa <- read.csv("data-raw/bucharest_baneasa.csv")
buc_baneasa$Date <- as.Date(buc_baneasa$Date)
names(buc_baneasa)[1] <- "CODGE"
usethis::use_data(buc_baneasa, overwrite = TRUE)



