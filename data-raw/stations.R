stations<-read.csv("data-raw/statii_meteo.csv")
stations$X1<-NULL
stations$Y1<-NULL

devtools::use_data(stations, overwrite = TRUE)

