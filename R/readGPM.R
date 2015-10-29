readGPM<-function (product,dataset)
{
  # set missing values 
  fun.na <- function(x) { x[x<= -9999] <- NA; return(x)}
  
  if (!require(raster)) {
    stop("You need to install the 'raster' package: install.packages('RCurl')")
  }
  
  if (!require(h5)) {
    stop("You need to install the 'h5' package: install.packages('RCurl')")
  }
  
  
  file <- h5file(product,mode="r+")
  
  #   list.datasets(file, recursive = TRUE)
  #   list.groups(file)
  
  #read dataset
  pp <- file[paste0("/Grid/",dataset)]
  
  #raster definition
  
  r<-raster(x=apply(pp[], 1, rev), xmn=-180, xmx=180, ymn=-90, ymx=90,crs="+init=epsg:4326")
  
  r<- calc(r, fun.na)
  #adauga nume fisier
  names(r)<-dataset
  h5close(file)
  
  #if(dataset="HQprecipSource") 
  
  return(r)
}
