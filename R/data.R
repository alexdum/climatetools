#' Weather stations METEOROMANIA.
#'
#' Metadata of  meteorological stations from Romania.
#'
#' @format A data frame with 163 rows and 14 variables:
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
#'   \itme Rugozitate: roughness as extracted from CORINE Land Cover (CLC) 2006
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

