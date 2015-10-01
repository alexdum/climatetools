library(rgdal)
ws<-data.frame(readOGR(dsn="data-raw",layer="statii_aprilie_2008"))
ws$coords.x1<-NULL
ws$coords.x2<-NULL
ws$optional<-NULL

devtools::use_data(ws, overwrite = TRUE)

