## Importing vector data

library(...)
library(...)

shp <- 'data/cb_2016_us_county_5m'
counties <- ...(..., stringsAsFactors = FALSE)

## Bounding box

library(...)
counties_md <- ...

## Grid

... <- ...(counties_md, ...)


## Plot layers

plot(...)
plot(...)

## Create geometry

sesync <- ...(
    ...(c(-76.503394, 38.976546)),
        ...)


counties_md <- ...(counties_md, ...)
plot(...)
plot(..., col = "green", pch = 20, add = ...)

## Exercise 1

...

## Coordinate transforms

shp <- 'data/huc250k'
huc <- st_read(...)

prj <- '+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs'

counties_md <- st_transform(counties_md, ...)
huc <- ...
sesync <- ...
plot(counties_md$geometry)
plot(..., border = 'blue', add = TRUE)
plot(..., col = 'green', pch = 20, add = TRUE)

## Geometric operations on vector layers

state_md <- ...
plot(...)

huc_md <- ...
plot(..., border = 'blue', col = NA, add = TRUE)

## Exercise 2

...

## Working with raster data

library(...)
nlcd <- raster(...)

## Crop

... <- matrix(..., ...)
nlcd <- crop(..., ...)
plot(nlcd)
plot(...)

## Raster data attributes

lc_types <- nlcd@data@attributes[[1]]$Land.Cover.Class

## Raster math

pasture <- mask(nlcd, nlcd == 81, maskvalue = FALSE)
plot(pasture)

nlcd_agg <- ...(nlcd, ..., ...)
...
plot(nlcd_agg)

## Exercise 3

...

## Mixing rasters and vectors: prelude

sesync <- as(..., "Spatial")
huc_md <- as(..., "Spatial")
counties_md <- ...

## Mixing rasters and vectors

plot(nlcd)
plot(sesync, col = 'green', pch = 16, cex = 2, ...)

sesync_lc <- ...(nlcd, sesync)

county_nlcd <- ...

modal_lc <- extract(...)
... <- lc_types[modal_lc + 1]

