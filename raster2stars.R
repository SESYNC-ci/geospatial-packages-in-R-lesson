# Code to setup 

library(sf)

shp <- 'data/cb_2016_us_county_5m'
counties <- st_read(
  shp,
  stringsAsFactors = FALSE)

sesync <- st_sfc(st_point(
  c(-76.503394, 38.976546)),
  crs = st_crs(counties))

library(dplyr)
counties_md <- filter(
  counties,
  STATEFP == '24')

shp <- 'data/huc250k'
huc <- st_read(
  shp,
  stringsAsFactors = FALSE)

#prj = st_crs(nlcd)$proj4string

prj <- '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'

counties_md <- st_transform(
  counties_md,
  crs = prj)
huc <- st_transform(
  huc,
  crs = prj)
sesync <- st_transform(
  sesync,
  crs = prj)

state_md <- st_union(counties_md)

huc_md <- st_intersection(
  huc,
  state_md)

# Make the note that a bunch of the stars functions sort of treat rasters like they are typical R objects
# You can use things like [] to subset them.

# Testing on 15 May 2021 with updated version of stars from github, that should have all bugfixes I reported except for fixing cellsize on st_warp.

library(stars)
nlcd <- read_stars("data/nlcd_agg.tif", proxy = FALSE)
nlcd <- droplevels(nlcd)

extent <- st_bbox(huc_md)
nlcd <- st_crop(nlcd, extent)

plot(nlcd, add.geom = st_geometry(huc_md))

library(ggplot2)

ggplot() +
  geom_stars(data = nlcd) +
  geom_sf(data = st_geometry(huc_md), fill = NA) +
  scale_fill_manual(values = attr(nlcd[[1]], 'colors'))

# Find alternative in stars
#### PIXEL -- which corner is this? I think bottom left. Can be seen by the delta.
nlcd[[1]][1,1]
# Equivalent
pull(nlcd)[1,1]

#### MASK
forest <- nlcd
forest[!forest %in% c('Evergreen Forest', 'Deciduous Forest', 'Mixed Forest')] <- NA

plot(forest)

pasture <- nlcd
pasture[pasture != "Hay/Pasture"] <- NA
plot(pasture)



# warp to aggregate. Currently cellsize is incorrectly implemented but hopefully this will be fixed soon.
nlcd_agg <- st_warp(nlcd,
                    cellsize = dim(nlcd)/10, method = 'mode', use_gdal = TRUE)

nlcd_agg # Delta is now 1500.
# Colors are retained but attributes have been stripped 
nlcd_agg <- droplevels(nlcd_agg) 
levels(nlcd_agg[[1]]) <- levels(nlcd[[1]]) 

plot(nlcd_agg)

# extract points
sesync_lc <- st_extract(nlcd, sesync) # Doesn't work.
nlcd[sesync]

# extract polygon
nlcd_agg[counties_md[1,]] 
plot(nlcd[counties_md[1,]]) # Shows Baltimore City
nlcd[counties_md[1,]] # Abbreviated table is shown.
nlcd[counties_md[1,]] %>% pull %>% table 

mymode <- function(x) names(which.max(table(x)))

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

modal_lc <- aggregate(nlcd_agg, huc_md, FUN = mymode) 

plot(st_as_sf(modal_lc))

huc_md <- huc_md %>% 
  mutate(modal_lc = modal_lc[[1]])

huc_md[, c('HUC_NAME', 'modal_lc')]
