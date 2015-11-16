#' Download GPM (IMERG) H5 files to local directory
#' @param product  Character. Contents of the IMERG output.
#' @param begin Character. Subset begin date.
#' @param end Character. Subset end date.
#' @export
get_gpm<-function (product,begin=NULL,end=NULL)
{
  monthly<-"ftp://gpm1.gesdisc.eosdis.nasa.gov/data/s4pa/GPM_L3/GPM_3IMERGM.03/"
  late.run<-"ftp://gpm1.gesdisc.eosdis.nasa.gov/data/s4pa/GPM_L3/GPM_3IMERGHHL.03/"
  early.run<-"ftp://gpm1.gesdisc.eosdis.nasa.gov/data/s4pa/GPM_L3/GPM_3IMERGHHE.03"
  #daca lipseste numele produsului
  if (missing(product)) {
    stop("Please provide the supported-'product'. See  'Details'")
  }
  if (is.null(begin)) {
    stop("No begin date provided")
  }
  if (is.null(end)) {
    stop("No end date provided")
  }

  if(product=="monthly") {


  }
}

