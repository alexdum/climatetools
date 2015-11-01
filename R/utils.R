# set missing values in sraster files
fun.na <- function(x) { x[x<= -9999] <- NA; return(x)}
