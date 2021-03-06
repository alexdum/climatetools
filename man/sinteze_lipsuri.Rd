% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sinteze_lipsuri.R
\name{sinteze_lipsuri}
\alias{sinteze_lipsuri}
\title{Citeste tabelele din sinteze climatice si alege perioada (procentele) cu
date lipsa}
\usage{
sinteze_lipsuri(path, missing = 0)
}
\arguments{
\item{path}{caracter reprezentand calea catre tabelul *.csv descarcat din
sinteze climatologice}

\item{missing}{numar intreg reprezentand cat la suta din date lipsa sa fie
luate in calcul}
}
\value{
data.frame cu tabelul continand cele 12 luni de la statiile care au
mai putin de nr lipsuri definit in missing
}
\description{
Citeste tabelele din sinteze climatice si alege perioada (procentele) cu
date lipsa
}
\details{
Tabelele sunt descarcate din baza de date Sinteze Climatologice Lunare
}
\examples{
# Citeste normalele de temperatura cu 5\% lipsuri
temp5 <- sinteze_lipsuri(system.file("extdata/tt_1981_2010.csv",
package = "climatetools"),5)
}
\author{
Alexandru Dumitrescu
}
