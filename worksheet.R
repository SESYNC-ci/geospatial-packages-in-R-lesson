
## Importing vector data

library(...)
library(...)

shp <- 'data/cb_2016_us_county_5m'
counties <- readOGR(...,
                    ...,
                    stringsAsFactors = FALSE)

...(..., xlim = c(-125, -65), ... = c(24, 50))

## Creating Spatial* object

sesync <- Spatial...(...(c(-76.505206, 38.9767231), ...), 
                        ...)

plot(counties, xlim = c(-125, -65), ylim = c(20, 50))
plot(...)

## Subsetting

counties_md <- counties[..., ]
plot(...)

## Exercise 1

...

## Coordinate transformations

shp <- "data/huc250k"
huc <- ...(dsn = shp
               ...,
               stringsAsFactors = FALSE)


## Albers equal-area projection

... "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

counties_md <- ...(counties_md, ...)
huc <- spTransform(..., proj1)
plot(counties_md)
plot(huc, ..., border = "blue")

## Geometric operations on vector layers

library(...)

state_md <- ...(counties_md)
plot(state_md)

huc_md <- ...(huc, state_md, ...)
plot(huc_md, ...)

## Exercise 2

...

## Working with raster data

library(...)

nlcd <- raster(...)

## Crop

nlcd <- crop(..., ...)
plot(nlcd)
plot(...)

## Raster data attributes

lc_types <- nlcd@data@attributes[[1]]$Land.Cover.Class
levels(lc_types)

## Raster manipulation

pasture <- mask(nlcd, nlcd == 81, maskvalue = FALSE)
plot(pasture)

nlcd_agg <- ...(nlcd, ..., ...)
...
plot(nlcd_agg)

## Exercise 3

...

## Mixing rasters and vectors

sesync <- ..(sesync, proj1)
plot(nlcd)
plot(sesync, col = 'green', pch = 16, cex = 2, ...)

county_nlcd <- extract(nlcd_agg, counties_md[1, ])
table(county_nlcd)

modal_lc <- extract(nlcd_agg, counties_md, fun = modal)
counties_md$modal_lc <- lc_types[modal_lc + 1]
