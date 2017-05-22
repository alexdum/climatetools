#' The FAO Penman-Monteith crop reference evapotranspiration
#' @description The panel of experts recommended  in May 1990 the adoption of the
#' FAO Penman-Monteith  combination method as a new standard for reference
#' evapotranspiration and  advised on procedures for calculation of the various
#'  parameters (http://www.fao.org/docrep/X0490E/x0490e06.htm)
#'@param Lon longitude in degrees (WGS84; EPSG:4326)
#'@param Lat latitude in degrees (WGS84; EPSG:4326)
#'@param Dates date field reprezenting days of measurements
#'@param Tavg daily mean temperature (ºC)
#'@param Rh daily mean relative humidity (\%)
#'@param Sd daily sunshine duration (hours)
#'@param Rs daily sunshine duration (MJ m-2 day-1)
#'@param Ws daily wind speed (m/s) at 2m above ground level
#'@references http://www.fao.org/docrep/X0490E/x0490e08.htm
#'@examples
#'data(buc_baneasa)
#' # convert wind speed form 10 magl to 2 magl
#' ws2m <- wind_log(buc_baneasa$Ws,10, 0.1, 2)
#' # compute ET0
#' et <- et_0(Lon = 26.07969, Lat = 44.51072, Dates = as.Date(buc_baneasa$Date),
#'           Tavg = buc_baneasa$Tavg, Rh = buc_baneasa$Rh, Sd = buc_baneasa$Sd, Ws = ws2m)
#'plot(buc_baneasa$Date, et, type="l")
#'plot(buc_baneasa$Date, buc_baneasa$Sd, type="l")

#'@importFrom sp CRS SpatialPoints
#'@importFrom  maptools sunriset
#'@export

et_0 <- function(Lon, Lat, Dates, Tavg, Rh, Sd = NA, Rs = NA, Ws) {

  # dd <- read.csv("data-raw/bucharest_baneasa.csv")
  # Lon = 26.07969
  # Lat = 44.51072
  # Dates=as.Date(dd$Date)
  # convert coordinate to Spatial Points
  hels <- matrix(c(Lon, Lat), nrow=1)
  Hels <- SpatialPoints(hels, proj4string = CRS("+proj=longlat +datum=WGS84"))


  # compute dy length
  up <- sunriset(Hels, as.POSIXct(Dates, tz = "EET"), direction="sunrise", POSIXct.out=TRUE)
  down <- sunriset(Hels, as.POSIXct(Dates, tz = "EET"), direction="sunset", POSIXct.out=TRUE)
  dl <- as.numeric(down$time - up$time)


  # extract Julian dai and latitude
  J <- as.integer(format(Dates,"%j"))
  lat<-Hels@coords[2]

  t<- Tavg
  ur <- Rh
  ds <- Sd
  ws <- Ws

  # pas 1 calculate vapour presure deficit
  # saturated vapour presure
  pm<-6.11*10^((7.5*t)/(237.7+t))
  phg<-pm*0.0295300

  # kpa saturated vapour presure
  ea<-33.8639*(phg/10)

  #actual vapour presure
  ed<-ur*ea/100
  ead<-ea-ed

  #pas 2 Calculate available energy
  alpha<-(3.14/180)*(lat)
  dr <- 1 + 0.033*cos(2*3.14*(J)/365)
  beta<-0.409*sin(2*3.14*(J)/365 - 1.39)
  omegas<-acos(-tan(alpha)*tan(beta))
  var1<-sin(alpha)*sin(beta)
  var2<-cos(alpha)*cos(beta)
  Ra<-24*60/3.14*0.0820*dr*(omegas*(var1) +var2* sin(omegas))

  Rns=0.77*(0.25+0.5*ds/dl)*Ra
  Rnl=2.45*10^-9*(0.9*ds/dl+0.1)*(0.34-0.14*sqrt(ed))*2*(273+t)^4

  # calculeaza in functie daca ai radiatie globala sau stralucire Soare
  if (!is.null(Rs) & is.null(Sd)) {
    RnG = Rs - Rnl - 0
  } else {
    RnG = Rns - Rnl - 0
  }



  # pas 3 calculate other values required

  # slope of saturated vapour pessure curve

  slope<- 4098*ea/(t+237.3)^2

  # pas 4 final

  et<-(0.408*slope*RnG)/(slope+0.066*(1+0.34*ws))+(0.066*(900/(t+273)*ws*ead))/(slope+0.066*(1+0.34*ws))
  return(et)
}
