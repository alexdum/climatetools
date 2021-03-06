#' The FAO Penman-Monteith crop reference evapotranspiration
#' @description The panel of experts recommended  in May 1990 the adoption of the
#' FAO Penman-Monteith  combination method as a new standard for reference
#' evapotranspiration and  advised on procedures for calculation of the various
#'  parameters (http://www.fao.org/docrep/X0490E/x0490e06.htm)
#'@param Lat latitude in degrees (WGS84; EPSG:4326)
#'@param Alt station altitude (m)
#'@param Dates date field reprezenting days of measurements
#'@param Tavg daily mean temperature (ºC)
#'@param Tmax daily maximum temperature (ºC)
#'@param Tmin daily minimum temperature (ºC)
#'@param Rh daily mean relative humidity (\%)
#'@param RHmax daily maximum relative humidity (\%)
#'@param RHmin daily minimum relative humidity (\%)
#'@param Sd daily sunshine duration (hours)
#'@param Rs daily global solar radiation (MJ m-2 day-1)
#'@param Ws daily wind speed (m/s) at 2m above ground level
#'@param Rads if is TRUE return shortwave and longwave radiation
#'@references http://www.fao.org/docrep/X0490E/x0490e08.htm
#'@examples
#'data(buc_baneasa)
#' # convert wind speed form 10 magl to 2 magl
#'ws2m <- wind_log(buc_baneasa$Ws,10, 0.1, 2)
#' # compute ET0
#'et <- et_0( Alt = 90, Lat = 44.51072, Dates = as.Date(buc_baneasa$Date),
#'Tmax = buc_baneasa$Tmax, Tmin = buc_baneasa$Tmax, Rh = buc_baneasa$Rh,
#'Sd = buc_baneasa$Sd, Ws = ws2m)
#'plot(buc_baneasa$Date, buc_baneasa$Sd, type = "l")

#'@export
et_0 <- function(Alt, Lat, Dates, Tavg = NA, Tmax, Tmin, Rh = NA, RHmax = NA, RHmin = NA, Sd = NA, Rs = NA, Ws, Rads = F) {

  # dd <- read.csv("data-raw/bucharest_baneasa.csv")
  # Lon = 4.3517
  # Lat = 50.80
  # Alt <- 100
  # Tavg <- 16.9
  # Tmax <- 21.5
  # Tmin <- 12.3
  # Sd = 9.25
  # Rs <- 22.07
  # RHmax <- 84
  # RHmin <- 63
  # Ws <- 2.078
  # Dates <- as.Date("2015-07-06")
  # convert coordinate to Spatial Points

  # extract Julian day and latitude
  J <- as.integer(format(Dates,"%j"))
  lat <- Lat

  if (!is.na(Tavg)) {
    tt <- Tavg
  } else {
    tt <- (Tmax + Tmin)/2
  }
  if (!is.na(Rh)) rh <- Rh
  if (!is.na(Sd)) ds <- Sd
  if (!is.na(Rs)) rs <- Rs
  ws <- Ws
  Alt <- Alt
  tmax <- Tmax
  tmin <- Tmin
  rhmax <- RHmax
  rhmin <- RHmin



  # Atmospheric Pressure (P) kPa
  P <- 101.3*(((293 - 0.0065*Alt)/293))^5.26

  # Slope of saturation vapor pressure curve (delta) kPa/degree C
  D <- 4098*(0.6108*exp(17.27*tt/(tt + 237.3)))/(tt + 237.3)^2

  # Psychrometric constant (lambda)  kPa degree C-1
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


  if (!is.na(Rh[1])) {
    # In the absence of RHmax and RHmin:
    ea <- Rh/100 * ((esmin + esmax)/2)
  } else {
    # Actual vapor pressure (ea) derived from relative humidity kPa
    ea <- (esmin*(RHmax/100) + esmax*(RHmin/100))/2
  }

  # Vapour pressure deficit
  ed <- es - ea

  # The inverse relative distance Earth-Sun (dr) and solar declination (d)
  dr <- 1 + 0.033*cos(2*pi*J/365)
  d <- 0.409*sin(2*pi*J/365 - 1.39)

  #  Conversion of latitude (φ) in degrees to radians
  lat.rad <- pi/180*lat

  # Step 14: Sunset hour angle (us)
  wsh <- acos(-tan(lat.rad)*tan(d))

  # Step 15: Extraterrestrial radiation (Ra)
  ra <- (24*60)/pi*0.0820*dr*((wsh*sin(lat.rad)*sin(d)) + (cos(lat.rad)*cos(d)*sin(wsh)))

  # Step 16: Clear sky solar radiation (Rso)
  rs0 <- (0.75 + 0.00002*Alt)*ra

  # daca nu ai radiatie si stralucire return NA
  if (is.na(Sd) & is.na(Rs)) {
    return(NA)
  } else {
    # sloar radiation from sunshine duration
    # daylight hours (N)
    if (!is.na(Sd[1])) {
      n <- 24/pi*wsh
      rs <- (0.25 + 0.50*(ds/n))*ra
    }

    # Step 17: Net solar or net shortwave radiation (Rns)
    rns <- (1 - 0.23)*rs

    # Step 18: Net outgoing long wave solar radiation (Rnl)
    rnl <- 0.000000004903*((tmax + 273.16)^4 + (tmin + 273.16)^4)/2*(0.34 - 0.14*sqrt(ea))*(1.35*(rs/rs0) - 0.35)

    # Step 19: Net radiation (Rn)
    rn <- rns - rnl

    # To express the net radiation (Rn) in equivalent of evaporation (mm) (Rng)
    rng <- 0.408 * rn

    # FS1. Radiation term (ETrad)
    ETrad <- Dt * rng

    # FS2. Wind term (ETwind)
    ETwind = Pt * Tt * (es - ea)

    ET0 <-  round(ETwind + ETrad,1)

    if (isTRUE(Rads)) {
      return(cbind(ET0, rns, rnl))
    } else {
      return(ET0)
    }
  }
}



et_0 <- Vectorize(et_0)
