ws<-read.csv("data-raw/statii_meteo.csv")
ws$X.1<-NULL
ws$Y.1<-NULL

devtools::use_data(ws, overwrite = TRUE)

