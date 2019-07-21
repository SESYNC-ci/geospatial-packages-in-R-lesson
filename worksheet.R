## Vector Data

library(...)

shp <- 'data/cb_2016_us_county_5m'
counties <- ...(
    ...,
    stringsAsFactors = FALSE)

sesync <- ...(
    ...(c(-76.503394, 38.976546)),
    crs = st_crs(counties))

## Bounding box

library(...)
counties_md <- ...

## Grid

... <- ...(counties_md, ...)


## Plot Layers

plot(...)
plot(...)

counties_md <- ...(counties_md, ...)
plot(...)
plot(..., col = "green", pch = 20, add = ...)

## Coordinate Transforms

shp <- 'data/huc250k'
huc <- st_read(
    ...,
    stringsAsFactors = FALSE)

prj <- '+proj=aea +lat_1=29.5 +lat_2=45.5 \
    +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0    \
    +ellps=GRS80 +towgs84=0,0,0,0,0,0,0   \
    +units=m +no_defs'

counties_md <- st_transform(
    counties_md,
    ...)
huc <- ...
sesync <- ...
plot(counties_md$geometry)
plot(...,
     border = 'blue', add = TRUE)
plot(..., col = 'green',
     pch = 20, add = TRUE)

## Geometric Operations

state_md <- ...
plot(...)

huc_md <- ...
plot(..., border = 'blue',
     col = NA, add = TRUE)

## Raster Data

library(...)
nlcd <- raster(...)

## Crop

... <- matrix(..., ...)
nlcd <- crop(..., ...)
plot(nlcd)
plot(...)

## Raster data attributes

nlcd_attr <- ...
lc_types <- nlcd_attr...

## Raster math

pasture <- mask(nlcd, nlcd == 81,
    maskvalue = FALSE)
plot(pasture)

nlcd_agg <- ...(nlcd,
    ...
...
plot(nlcd_agg)

## Mixing rasters and vectors: prelude

sesync_sp <- as(..., "Spatial")
huc_md_sp <- as(..., "Spatial")
counties_md_sp <- ...

## Mixing rasters and vectors

plot(nlcd)
plot(sesync_sp, col = 'green',
     pch = 16, cex = 2, ...)

sesync_lc <- ...(nlcd, sesync_sp)

county_nlcd <- ...

modal_lc <- extract(...)
... <- lc_types[modal_lc + 1]

## Leaflet

library(...)
... %>%
    ... %>%
    setView(lng = -77, lat = 39, 
        zoom = 7)

leaflet() %>%
    addTiles() %>%
    ...(
        data = ...) %>%
    setView(lng = -77, lat = 39, 
        zoom = 7)

leaflet() %>%
    addTiles() %>%
    ...(
        "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
        layers = "nexrad-n0r-900913", group = "base_reflect",
        options = WMSTileOptions(format = "image/png", transparent = TRUE),
        attribution = "weather data © 2012 IEM Nexrad") %>%
    setView(lng = -77, lat = 39, 
        zoom = 7)
