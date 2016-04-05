library(rgdal)
library(raster)
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


# adauga rugozitate -------------------------------------------------------
rug <- raster("data-raw/rugozitate.tif")
rug[rug<0] <- NA
sp <- SpatialPoints(cbind(ws$X, ws$Y))
ex <- round(extract(rug, sp),3)
ws$Rugozitate <- ex


# adauga Cau --------------------------------------------------------------
cau <- read.csv("data-raw/cau.csv")

m.ws <- merge(ws,cau, by.x = "CODST", by.y = "co", all.x = T)
ws$Cau_0_20 <- m.ws$cau_0_20
ws$Cau_0_50 <- m.ws$cau_0_50
ws$Cau_0_100 <- m.ws$cau_0_100


devtools::use_data(ws, overwrite = TRUE)


