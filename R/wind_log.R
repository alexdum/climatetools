#'Extrapolate the wind speed at a certain height by using the log law
#'@param Vref known velocity at height Zref
#'@param Zref reference height where vref is known
#'@param Z0 roughness length in the current wind direction
#'@param Z height above ground level for velocity to be calculated
#'
wind_log <- function (Vref, Zref, Z0, Z) {

  u_z0 <- Vref*(log(Z/Z0)/log(Zref/Z0))
  return(u_z0)
}
