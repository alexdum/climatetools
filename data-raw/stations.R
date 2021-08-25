library(rgdal)
library(raster)
ws.old <- data.frame(readOGR(dsn = "data-raw",layer = "statii_aprilie_2008",stringsAsFactors = F))
ws.old <- ws.old[, !names(ws.old) %in% c("coords.x1", "coords.x2", "optional")]

ws <- data.frame(readOGR(dsn = "data-raw",layer = "statii_2019",stringsAsFactors = F))
ws <- ws[, !names(ws) %in% c("coords.x1", "coords.x2", "optional")]
names(ws)[c(8:11)] <- c("Lon", "Z", "X","Y")


# completeaza statia Fundulea
ws[164,"CODST"] <- 15424
ws[164,"CODGE"] <- 428632
ws[164,"JU"] <- "CL"
ws[164,"X"] <- 621373
ws[164,"Y"] <- 329264
ws[164,"Z"] <- 67
ws[164, "Lon"] <- 26.523548
ws[164, "Lat"] <- 44.452850
ws[164,"CMR"] <- "MUNTENIA"
ws[164,"NUME"] <- "Fundulea"

# completeaza statia Faurei
ws[165,"CODGE"] <- 505719
ws[165,"JU"] <- "BR"
ws[165,"X"] <- 679848.2
ws[165,"Y"] <- 400729.2
ws[165,"Z"] <- 41
ws[165, "Lon"] <- 27.28333333
ws[165, "Lat"] <- 45.08333333
ws[165,"CMR"] <- "MUNTENIA"
ws[165,"NUME"] <- "Faurei"

# completeaza statie Sinaia Mănăstire
ws[166,"CODGE"] <- 521534
ws[166,"JU"] <- "PH"
ws[166,"X"] <- 543110.5
ws[166,"Y"] <- 428607.9
ws[166,"Z"] <- 560
ws[166, "Lon"] <- 25.548755
ws[166, "Lat"] <- 45.355916
ws[166,"CMR"] <- "MUNTENIA"
ws[166,"NUME"] <- "Sinaia Mănăstire"

ws <- ws[order(ws$NUME),]



# adauga rugozitate -------------------------------------------------------
rug <- raster("data-raw/rugozitate.tif")
rug[rug < 0] <- NA
sp <- SpatialPoints(cbind(ws$X, ws$Y))
ex <- round(extract(rug, sp),3)
ws$Rugozitate <- ex


# adauga posturi ----------------------------------------------------------

post <- read.csv("data-raw/posturi_co_2016 .csv")

post <- data.frame(
                   CMR = post$CMR, JU = post$JU, CODST = post$CODST, CODGE = post$CODGE,
                   NUME = post$NUME, Autonoma = NA, Lat = post$Lat, Lon = post$Lon,
                   Z = post$Z, X = post$X, Y = post$Y, Rugozitate = NA
                   )

ws <- rbind(ws, post)


# adauga Cau --------------------------------------------------------------
cau <- read.csv("data-raw/cau.csv")
names(cau)[5:7] <- c("Cau_0_20","Cau_0_50","Cau_0_100")

ws <- merge(ws,cau[,c("co","Cau_0_20","Cau_0_50","Cau_0_100")], by.x = "CODST", by.y = "co", all.x = T)

usethis::use_data(ws, overwrite = TRUE)



