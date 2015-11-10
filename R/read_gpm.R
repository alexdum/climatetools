#' Read GMP data to raster file
#' @param file a character string naming a H5 file
#' @param dataset to be read from H5 file; see details
#' @param extent of the gridfile to be read in R, a vector of a length 4;
#' order= xmin (-180), xmax (180), ymin (-90), ymax (90)
#' @details
#' In order to download data from the PPS FTPs you must first register your email
#' address with the Precipitation Processing System, using this page:
#'  http://registration.pps.eosdis.nasa.gov/registration/.
#'
#' Fisierele sunt desarcate de aici ftp://jsimpson.pps.eosdis.nasa.gov/data/imerg/early/
#'
#' Data sets:
#'
#'\itemize{
#' \item \code{HQobservationTime}: precipitation-relevant satellite passive microwave
#' source time (min. into half hour);
#' \item \code{HQprecipitation}: precipitation-relevant satellite passive microwave
#' source (mm/hr);
#' \item \code{HQprecipSource}: precipitation-relevant satellite passive microwave
#' source sensor identifier (index values);
#' \item \code{IRkalmanFilterWeight}: Kalman filter weight for IR (percent);
#' \item \code{IRprecipitation}: (mm/hr);
#' \item \code{precipitationCal}: snapshot precipitation – calibrated (mm/hr);
#' \item \code{probabilityLiquidPrecipitation}: probability of liquid precipitation phase.
#' }
#' @return raster object with layer names from dataset
#' @examples
#' # Read h5 gmp file to raster
#' require(raster)
#' r <- read_gpm(file=system.file("extdata/3B-HHR-E.MS.MRG.3IMERG.20151001-S000000-E002959.0000.V03E.RT-H5",
#' package = "climatetools"),dataset="precipitationCal", extent=c(20,30,43,49))
#' plot(r)
#' @export

read_gpm<-function (file,dataset,extent=NULL)
{

  if(extent[1]>extent[2]) stop ("xmin larger than xmax")
  if(extent[3]>extent[4]) stop ("ymin larger than ymax")
  hdf <- h5::h5file(file,mode="r+")

  #   list.datasets(file, recursive = TRUE)
  #   list.groups(file)

  #read dataset
  pp <- hdf[paste0("/Grid/",dataset)]


  #raster definition cu sau fara si extent
  if (all(is.null(extent)))
  {
    r<-raster::raster(x=apply(pp[], 1, rev), xmn=-180, xmx=180, ymn=-90, ymx=90,crs="+init=epsg:4326")

  }
  else
  {
    lon <- hdf["/Grid/lon"]
    lat <- hdf["/Grid/lat"]
    #     # eroarea daca lon si lat sunt mai mari sau mai mici

    #     if(extent[3] < lat[c(1),]-0.05 | extent[3]>lat[c(1800),]+0.05) stop ("the value of the ymin field must be between -90 and 90")
    #     if(extent[4] < lat[c(1),]-0.05 | extent[4]>lat[c(1800),]+0.05) stop ("the value of the ymax field must be between -90 and 90")

    # alege indicii pentru extent crop
    xmin<-which.min(abs(lon[]-extent[1]))
    xmax<-which.min(abs(lon[]-extent[2]))
    ymin<-which.min(abs(lat[]-extent[3]))
    ymax<-which.min(abs(lat[]-extent[4]))
    r<-raster::raster(x=apply(pp[c(xmin:xmax),c(ymin:ymax)], 1, rev), xmn=lon[xmin]-0.05,
                      xmx=lon[xmax]+0.05, ymn=lat[ymin]-0.05,ymx=lat[ymax]+0.05,
                      crs="+init=epsg:4326")


  }

  #transforma x<= -9999 in NA
  r<- raster::calc(r, fun.na)
  #adauga nume fisier
  names(r)<-dataset
  h5::h5close(hdf)

  #if(dataset="HQprecipSource")

  return(r)
}
