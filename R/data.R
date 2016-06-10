#' Weather stations METEOROMANIA.
#'
#' Metadata of  meteorological stations and rain gauges from Romania.
#'
#' @format A data frame with 206 rows and 14 variables:
#' \itemize{
#'   \item CMR:     Regional Meteorological Center
#'   \item JU:      County
#'   \item CODST:   Synop ID
#'   \item CODGE:   Geographical ID
#'   \item NUME:    Station name
#'   \item X:       Longitude in meters (Stereo 70; EPSG:3844)
#'   \item Y:       Latitude in meters (Stereo 70; EPSG:3844)
#'   \item Z:       Altitude (m)
#'   \item SURSA_XY: Source of coordinates
#'   \item SURSA_Z: Source of altitude
#'   \item Lon:     Longitude in degrees (WGS84; EPSG:4326)
#'   \item Lat:     Latitude in degrees (WGS84; EPSG:4326)
#'   \item Rugozitate: roughness as extracted from CORINE Land Cover (CLC) 2006
#'   \item Cau_0_20: Capacitatea de aap utila a solului (m3/ha) 0-20 cm
#'   \item Cau_0_50: Capacitatea de aap utila a solului (m3/ha) 0-50 cm
#'   \item Cau_0_100: Capacitatea de aap utila a solului (m3/ha) 0-100 cm
#' }
#'
#' @source METEO ROMANIA \url{http://www.meteoromania.ro/}
#'
#' @examples
#' data(ws)
#' str(ws)
#' hist(ws$Z)
#'
#'
#'
#' @usage data(ws)
"ws"


#'Bucharest Baneasa daily climate data
#'
#' Daily climate data measured in 2015 at Bucuresti Baneasa weather station.
#'
#' @format A data frame with 365 rows and 9 variables:
#' \itemize{
#'   \item CODGE:    geographical ID
#'   \item Date:     date field
#'   \item Precip:   sums of precipitation  (mm)
#'   \item Tavg:     mean temperature (°C)
#'   \item Tmax:     maximum temperature (°C)
#'   \item Ws:       mean wind speed (°m/s)
#'   \item Rh:       relative humidity (%)
#' }
#'
#' @source METEO ROMANIA \url{http://www.meteoromania.ro/}
#'
#' @examples
#' data(buc_baneasa)
#' str(buc_baneasa)
#' hist(buc_baneasa$Precip)
#'
#'
#'
#' @usage data(buc_baneasa)
"buc_baneasa"
