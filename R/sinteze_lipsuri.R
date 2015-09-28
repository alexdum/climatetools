#' Citeste tabelele din sinteze climatologice si alege perioada (procentele) cu
#' date lipsa
#' @param input caracter reprezentand calea catre tabelul *.csv descarcat din
#' sinteze climatologice
#' @param missing numar intreg reprezentand cat la suta din date lipsa sa fie
#' luate in calcul
#' @return data.frame cu tabelul continand cele 12 luni de la statiile care au
#' mai putin de nr lipsuri definit in missing
#' @examples
#' Citeste tabelul cu temperaturi in R, obtinut din secarcarea sintezelor
#' climatologice, care au 5% lipsuri
#'
#' temp5 <- sinteze_lipsuri("tt_1981_2000.csv",5)
#' @export
sinteze_lipsuri<-function(input,missing) {
  norm<-read.table(input,skip=4,nrows =262,sep=";",na.strings="-")
  lipsuri<-read.table(input,skip=267,sep=";",na.strings="-")
  lipsuri[is.na(lipsuri)]<-0
  norm<-norm[lipsuri[,15]<= missing,]
  return(norm[,1:14])
}



