stations<-read.csv("data-raw/statii_meteo.csv")
stations$X.1<-NULL
stations$Y.1<-NULL

devtools::use_data(stations, overwrite = TRUE)

