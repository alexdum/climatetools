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

# completeaza statie Sinaia Mănăstire
ws[165,"CODGE"] <- 521534
ws[165,"JU"] <- "PH"
ws[165,"X"] <- 543110.5
ws[165,"Y"] <- 428607.9
ws[165,"Z"] <- 560
ws[165, "Lon"] <- 25.548755
ws[165, "Lat"] <- 45.355916
ws[165,"CMR"] <- "MUNTENIA"
ws[165,"NUME"] <- "Sinaia Mănăstire"


# adauga rugozitate -------------------------------------------------------
rug <- raster("data-raw/rugozitate.tif")
rug[rug<0] <- NA
sp <- SpatialPoints(cbind(ws$X, ws$Y))
ex <- round(extract(rug, sp),3)
ws$Rugozitate <- ex


# adauga posturi ----------------------------------------------------------

post <- read.csv("data-raw/posturi_co_2016 .csv")

ws <- rbind(ws, post)


# adauga Cau --------------------------------------------------------------
cau <- read.csv("data-raw/cau.csv")
names(cau)[5:7] <- c("Cau_0_20","Cau_0_50","Cau_0_100")

ws <- merge(ws,cau[,c("co","Cau_0_20","Cau_0_50","Cau_0_100")], by.x = "CODST", by.y = "co", all.x = T)

devtools::use_data(ws, overwrite = TRUE)



