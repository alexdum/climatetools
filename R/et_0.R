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

et_0 <- function(Alt, Lon, Lat, Dates, Tmax,Tmin, RHmax, RHmin, Sd = NA, Rs = NA, Ws) {

  # dd <- read.csv("data-raw/bucharest_baneasa.csv")
  # Lon = 26.07969
  # Lat = 44.51072
  # Alt <- 100
  # Tavg <- 16.9
  # Tmax <- 21.5
  # Tmin <- 12.3
  # Rs <- 22.07
  # RHmax <- 84
  # RHmin <- 63
  # Ws <- 2.078
  # Dates <- as.Date("2015-07-06")
  # Lat <- 50.80
  # convert coordinate to Spatial Points
  hels <- matrix(c(Lon, Lat), nrow = 1)
  Hels <- SpatialPoints(hels, proj4string = CRS("+proj=longlat +datum=WGS84"))


  # compute dy length
  up <- sunriset(Hels, as.POSIXct(Dates, tz = "EET"), direction = "sunrise", POSIXct.out = TRUE)
  down <- sunriset(Hels, as.POSIXct(Dates, tz = "EET"), direction = "sunset", POSIXct.out = TRUE)
  dl <- as.numeric(down$time - up$time)


  # extract Julian dai and latitude
  J <- as.integer(format(Dates,"%j"))
  lat <- Lat

  tt <- Tavg
  ur <- Rh
  if (!is.na(Sd)) ds <- Sd
  ws <- Ws
  Alt <- Alt
  tmax <- Tmax
  tmin <- Tmin
  rhmax <- RHmax
  rhmin <- RHmin
  rs <- Rs

  # Atmospheric Pressure (P) kPa
  P <- 101.3*(((293 - 0.0065*Alt)/293))^5.26

  # Slope of saturation vapor pressure curve (Δ) kPa/°C
  D <- 4098*(0.6108*exp(17.27*tt/(tt+237.3)))/(tt + 237.3)^2

  # Psychrometric constant (γ)  kPa °C-1
  g <- 0.000665*P

  # Delta Term (DT) (auxiliary calculation for Radiation Term)
  Dt <- D/(D + g*(1 + 0.34*ws))

  # Psi Term (PT) (auxiliary calculation for Wind Term)
  Pt <- g/(D + g*(1 + 0.34*ws))

  # Temperature Term (TT) (auxiliary calculation for Wind Term)
  Tt <- 900/(tt + 273)*ws

  # Mean saturation vapor pressure derived from air temperature (es) kPa
  esmax <-  0.6108*exp(17.27*tmax/(tmax + 237.3))
  esmin <-  0.6108*exp(17.27*tmin/(tmin + 237.3))
  es <- (esmax + esmin)/2

  # Actual vapor pressure (ea) derived from relative humidity kPa
  ea <- (esmin*(RHmax/100) + esmax*(RHmin/100))/2

  # Vapour pressure deficit
  ed <- es-ea

  # The inverse relative distance Earth-Sun (dr) and solar declination (d)
  dr <- 1 + 0.033*cos(2*pi*J/365)
  d <- 0.409*sin(2*pi*J/365 - 1.39)

  #  Conversion of latitude (φ) in degrees to radians
  lat.rad <- pi/180*lat

  # Step 14: Sunset hour angle (ωs)
  wsh <- acos(-tan(lat.rad)*tan(d))

  # Step 15: Extraterrestrial radiation (Ra)
  ra <- (24*60)/pi*0.0820*dr*((wsh*sin(lat.rad)*sin(d)) + (cos(lat.rad)*cos(d)*sin(wsh)))

  # Step 16: Clear sky solar radiation (Rso)
  rs0 <- (0.75 + 0.00002*Alt)*ra

  # Step 17: Net solar or net shortwave radiation (Rns)
  rns <- (1 - 0.23)*rs

  # Step 18: Net outgoing long wave solar radiation (Rnl)
  rnl <- 0.000000004903*((tmax+273.16)^4 + (tmin+273.16)^4)/2*(0.34-0.14*sqrt(ea))*(1.35*(rs/rs0)-0.35)

  # Step 19: Net radiation (Rn)
  rn <- rns - rnl

  # To express the net radiation (Rn) in equivalent of evaporation (mm) (Rng)
  rng <- 0.408 * rn

  # FS1. Radiation term (ETrad)
  ETrad <- Dt * rng

  # FS2. Wind term (ETwind)
  ETwind = Pt * Tt * (es - ea)

  ETo <-  round(ETwind + ETrad,1)

  # saturated vapour presure
  pm <- 6.11*10^((7.5*t)/(237.7 + t))
  phg <- pm*0.0295300

  # kpa saturated vapour presure
  ea <- 33.8639*(phg/10)

  #actual vapour presure
  ed <- ur*ea/100
  ead <- ea - ed

  #pas 2 Calculate available energy
  alpha<-(3.14/180)*(lat)
  dr <- 1 + 0.033*cos(2*3.14*(J)/365)
  beta <- 0.409*sin(2*3.14*(J)/365 - 1.39)
  omegas<-acos(-tan(alpha)*tan(beta))
  var1<-sin(alpha)*sin(beta)
  var2<-cos(alpha)*cos(beta)
  # extraterestrial radiation
  Ra <- 24*60/3.14*0.0820*dr*(omegas*(var1) + var2*sin(omegas))

  Rnl = 2.45*10^-9*(0.9*ds/dl + 0.1)*(0.34 - 0.14*sqrt(ed))*2*(273 + t)^4


  # calculeaza in functie daca ai radiatie globala sau stralucire Soare
  if (!is.na(Rs) & is.na(Sd)) {
    RnG = Rs - Rnl - 0
  } else {
    Rns = (0.25 + 0.5*ds/dl)*Ra
    # Rns = 0.77*(0.25 + 0.5*ds/dl)*Ra
    RnG = Rns - Rnl - 0
  }




  # pas 3 calculate other values required

  # slope of saturated vapour pessure curve
  slope <- 4098*ea/(t+237.3)^2

  # pas 4 final

  et<-(0.408*slope*RnG)/(slope+0.066*(1+0.34*ws))+(0.066*(900/(t+273)*ws*ead))/(slope+0.066*(1+0.34*ws))
  return(et)
}


et_0 <- Vectorize(et_0)
