#'Weibull parameters and wind speed characteristics
#'@param x a numeric vector containing hourly wind speed data
#'@param rho air density. Default value is 1.225 kgm^−3 for a
#'temperature of 15°C and a standard sea level pressure of 1013.25 hPa
#'@return A list with four components:
#'\itemize{
#'\item mean value:
#'\item max. power wind speed:
#'\item wind power density:
#'\item A scale parameter
#'\item k shape parameter
#'}
#'@details Calculate some simple characteristics
#'of a Weibull distribution function, given the scale parameter A and the
#'shape parameter k. The Weibull characteristics calculated are (Troen and Petersen, 1989):
#'\itemize{
#'\item mean value:
#'\item max. power wind speed:
#'\item wind power density:
#'}
#'@importFrom stats sd
#'@export


wind_stats <- function(x, rho = 1.225) {

  # The Weibull parameters
  k <- (sd(x, na.rm = T)/mean(x, na.rm = T))^(-1.086)
  A <- mean(x, na.rm = T)/(gamma(1+1/k))

  # power density
  E <- 1/2 * rho * A^3* gamma(1+3/k)

  # maximum wind speed
  Um <- A * (k+2/k)^1/k

  # mean value
  ws_mean <- A * gamma(1+1/k)

  stats_f <- list(A = A, k = k, E = E, Um = Um, ws_mean = ws_mean)
  return(stats_f)
}
