library(rgdal)
ws<-data.frame(readOGR(dsn="data-raw",layer="statii_aprilie_2008",stringsAsFactors = F))
ws$coords.x1<-NULL
ws$coords.x2<-NULL
ws$optional<-NULL

# completeaza statia Faurei
ws[164,"CODGE"] <- 505719
ws[164,"JU"] <- "BR"
ws[164,"X"] <- 679848.2
ws[164,"Y"] <- 400729.2
ws[164,"Z"] <- 41
ws[164, "Lon"] <- 27.28333333
ws[164, "Lat"] <- 45.08333333
ws[164,"CMR"] <- "MUNTENIA"


devtools::use_data(ws, overwrite = TRUE)


