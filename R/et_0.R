et_0 <- function() {
  #tab<-read.csv("misc/tabele/Baneasa_PM_1961_2010_z.csv",stringsAsFactors=F)


  hels <- matrix(c(st$Lon,st$Lat), nrow=1)
  Hels <- SpatialPoints(hels, proj4string=CRS("+init=epsg:3844"))
  Hels<-spTransform(Hels,CRS("+init=epsg:4326"))

  # calculeaza dai length
  up <- sunriset(Hels, tt$DAT,direction="sunrise", POSIXct.out=TRUE)
  down <- sunriset(Hels, tt$DAT, direction="sunset", POSIXct.out=TRUE)
  dl <- as.numeric(down$time - up$time)



  rug<-st$Rugozitate
  VMED2m<-tt$VMED*(log(2/rug)/log(10/rug))

  t<- tt$TMED
  ur<-tt$UMRELM
  ds<-tt$DURS
  ws<-VMED2m
  #ws<-tt$VMED

  # extrage julina day si latitudinea
  J<-as.integer(format(tt$DAT,"%j"))
  lat<-Hels@coords[2]



  #pas 1 calculate vapour presure deficit
  #saturated vapour presure
  pm<-6.11*10^((7.5*t)/(237.7+t))
  phg<-pm*0.0295300

  #kpa saturated vapour presure
  ea<-33.8639*(phg/10)

  #actual vapour presure
  ed<-ur*ea/100
  ead<-ea-ed

  #pas 2 Calculate available energy

  alpha<-(3.14/180)*(lat)
  dr <- 1 + 0.033*cos(2*3.14*(J)/365)
  beta<-0.409*sin(2*3.14*(J)/365 - 1.39)
  omegas<-acos(-tan(alpha)*tan(beta))
  var1<-sin(alpha)*sin(beta)
  var2<-cos(alpha)*cos(beta)
  Ra<-24*60/3.14*0.0820*dr*(omegas*(var1) +var2* sin(omegas))

  Rns=0.77*(0.25+0.5*ds/dl)*Ra
  Rnl=2.45*10^-9*(0.9*ds/dl+0.1)*(0.34-0.14*sqrt(ed))*2*(273+t)^4
  RnG=Rns-Rnl-0

  #pas 3 calculate other values required

  # slope of saturated vapour pessure curve

  slope<- 4098*ea/(t+237.3)^2

  # pas 4

  tt$ETP_R<-(0.408*slope*RnG)/(slope+0.066*(1+0.34*ws))+(0.066*(900/(t+273)*ws*ead))/(slope+0.066*(1+0.34*ws))
}
