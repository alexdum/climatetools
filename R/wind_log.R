#'Extrapolate the wind speed at a certain height by using the log law
#'@description This function extrapolates the wind speed at a certain height
#'by using the log law. The increase or decrease of wind speed as a function of
#'height above ground can be computed by this logarithmic expression.
#'@param Vref known velocity at height Zref
#'@param Zref reference height where Vref is known
#'@param Z0 roughness length in the current wind direction
#'@param Z height above ground level for velocity to be calculated
#'@return Wind speed values computed at certain height (Z)
#'@references
#'Tennekes, H. "The logarithmic wind profile." Journal of the Atmospheric Sciences 30, no. 2 (1973): 234-238.
#'@export
wind_log <- function (Vref, Zref, Z0, Z) {

  u_z0 <- Vref*(log(Z/Z0)/log(Zref/Z0))
  return(u_z0)
}
