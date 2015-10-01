weather_stations<-read.csv("data-raw/statii_meteo.csv")
weather_stations$X.1<-NULL
weather_stations$Y.1<-NULL

devtools::use_data(weather_stations, overwrite = TRUE)

