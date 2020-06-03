#' Citeste tabelele din sinteze climatice si alege perioada (procentele) cu
#' date lipsa
#' @param path caracter reprezentand calea catre tabelul *.csv descarcat din
#' sinteze climatologice
#' @param missing numar intreg reprezentand cat la suta din date lipsa sa fie
#' luate in calcul
#' @details
#' Tabelele sunt descarcate din baza de date Sinteze Climatologice Lunare
#' @author Alexandru Dumitrescu
#' @return data.frame cu tabelul continand cele 12 luni de la statiile care au
#' mai putin de nr lipsuri definit in missing
#' @examples
#' # Citeste normalele de temperatura cu 5% lipsuri
#' temp5 <- sinteze_lipsuri(system.file("extdata/tt_1981_2010.csv",
#' package = "climatetools"),5)
#' @importFrom utils read.table
#' @export

sinteze_lipsuri <- function(path,missing = 0)
{
  norm <- read.table(path,skip = 4,nrows = 265,sep = ";",na.strings = "-")
  lipsuri <- read.table(path,skip = 270,sep = ";",na.strings = "-")
  lipsuri[is.na(lipsuri)] <- 0
  norm <- norm[lipsuri[,15] <= missing,]
  #numele coloanelor
  names(norm) <- c("CODGE","NUME","Jan","Feb","Mar","Apr","May","Jun","Jul",
                 "Aug","Sep","Oct","Nov","Dec")

  return(norm[,1:14])
}



