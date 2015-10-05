#' Weather stations METEO ROMANIA
#'
#' A dataset containing the metada of the meteorological stations from
#' Romania.
#' @format A data frame with 163 rows and 14 variables:
#' \itemize{
#'   \item X: longitude in m (Stereo 70)
#'   \item Y: latitude in m (Stereo 70)
#'   \item CMR: Meteorological Center
#'   \item JU: County
#'   \item CODST: Synop ID
#'   \item CODGE: Geographical ID
#'   \item NUME:Station name
#'   \item z: depth in mm (0--31.8)
#'   \item depth: total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43--79)
#'   \item table: width of top of diamond relative to widest point (43--95)
#' }

#'  @source METEO ROMANIA \url{http://www.meteoromania.ro/}
#'  @examples data(ws)
#'  @usage data(ws)
'ws'

