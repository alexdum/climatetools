library(sf)
sf.df <- st_as_sf(data.frame(x = 23.25027778, y = 45.30888889), coords = c("x", "y"), crs = 4326, agr = "constant") %>%
       st_transform(3844)
sf.df
