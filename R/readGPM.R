#' @param file cclea catre fisierul h5
#' @param dataset tipul de dataset care se doreste a se citi
#' @details
#' Fisierele sunt desarcate de aici ftp://jsimpson.pps.eosdis.nasa.gov/data/imerg/early/
#' @return raster object with layer names from dataset
#' @example
#' Read h5 file save locally
#' r<-readGMP(file=system.file("extdata/file=3B-HHR-E.MS.MRG.3IMERG.20151001-S000000-E002959.0000.V03E.RT-H5",
#' package = "climatetools"),dataset="precipitationCal")

readGPM<-function (file,dataset)
{
  # set missing values
  fun.na <- function(x) { x[x<= -9999] <- NA; return(x)}


  hdf <- h5::h5file(product,mode="r+")

  #   list.datasets(file, recursive = TRUE)
  #   list.groups(file)

  #read dataset
  pp <- hdf[paste0("/Grid/",file)]

  #raster definition

  r<-raster::raster(x=apply(pp[], 1, rev), xmn=-180, xmx=180, ymn=-90, ymx=90,crs="+init=epsg:4326")

  r<- raster::calc(r, fun.na)
  #adauga nume fisier
  names(r)<-dataset
  ht::h5close(file)

  #if(dataset="HQprecipSource")

  return(r)
}
