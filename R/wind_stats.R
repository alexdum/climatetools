#'Weibull parameters and wind speed characteristics
#'@param x a numeric vector containing hourly wind speed data
#'@param rho air density. Default value is \eqn{1.225 kgm^−3} for a
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
#'@export


wind_stats <- function(x, rho = 1.225) {

  # The option "lower = 0" is added because the parameters of the Weibull
  # distribution need to be >= 0
  fit_w <- MASS::fitdistr(x, densfun="weibull", lower = 0)
  A = as.numeric(fit_w$estimate["scale"])
  k = as.numeric(fit_w$estimate["shape"])

  # power density
  E <- 1/2 * rho * A^3* gamma(1+3/k)

  # maximum wind speed
  Um <- A * (k+2/k)^1/k

  # mean value
  ws_mean <- A * gamma(1+1/k)

  stats_f <- list(A = A, k = k, E = E, Um = Um, ws_mean = ws_mean)
  return(stats_f)
}
