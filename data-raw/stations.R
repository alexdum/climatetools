stations<-read.csv("data-raw/statii_meteo.csv")

devtools::use_data(stations, overwrite = TRUE)

