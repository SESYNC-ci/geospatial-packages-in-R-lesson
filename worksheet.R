## Vector Data

library(...)

shp <- 'data/cb_2016_us_county_5m'
counties <- ...(...)

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
plot(..., add = ...)
plot(..., col = "green", pch = 20, ...)

## Plotting with ggplot2

library(...)

ggplot() +
    ...(data = ..., aes(...)) +
    ...(..., size = 3, color = 'red')  

theme_set(theme_bw())

ggplot() +
    geom_sf(data = counties_md, aes(fill = ...), ...) +
    geom_sf(data = sesync, size = 3, color = 'red') +
    scale_fill_viridis_c(... = 'Land area (sq. km)') +
    theme(... = c(0.3, 0.3))

## Coordinate Transforms

shp <- 'data/huc250k'
huc <- st_read(...)

prj <- '+proj=aea +lat_1=29.5 +lat_2=45.5 \
        +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 \
        +datum=WGS84 +units=m +no_defs'

counties_md <- st_transform(
    counties_md,
    ...)
huc <- ...(huc, ...)
sesync <- ...

plot(st_geometry(...))
plot(...,
     border = 'blue', add = TRUE)
plot(..., col = 'green',
     pch = 20, add = TRUE)

## Geometric Operations

state_md <- ...
plot(...)

huc_md <- ...(..., ...)

plot(state_md)
plot(..., border = 'blue',
     col = NA, add = TRUE)

## Raster Data

library(...)
nlcd <- ...("data/nlcd_agg.tif", ...)
nlcd <- droplevels(...)

## Crop

md_bbox <- ...
nlcd <- st_crop(..., ...)

ggplot() +
    ...(data = nlcd) +
    ...(data = ..., fill = NA) +
    scale_fill_manual(values = attr(nlcd[[1]], ...))

## Raster math

forest_types <- c('Evergreen Forest', 'Deciduous Forest', 'Mixed Forest')
forest <- nlcd
forest[...(... %in% ...)] <- ...
plot(forest)

## Downsampling a raster

nlcd_agg <- ...(nlcd,
                ... = 1500, 
                method = ..., 
                use_gdal = TRUE)

nlcd_agg <- ...(nlcd_agg) 
...(...[[1]]) <- ...(nlcd[[1]]) 

plot(...)

## Mixing rasters and vectors

plot(nlcd, ... = FALSE)
plot(sesync, col = 'green',
     pch = 16, cex = 2, ...)

sesync_lc <- ...(nlcd, ...)

baltimore <- nlcd[...]
plot(baltimore)

nlcd %>%
    ...(counties_md[1, ]) %>%
    ... %>%
    ...

mymode <- function(x) names(which.max(table(x)))

modal_lc <- aggregate(..., ..., ... = mymode) 

huc_md <- huc_md %>% 
    ...(modal_lc = ...)

ggplot(..., aes(fill = ...)) + 
    geom_sf()

## Mapview

library(...)
...(huc_md)

mapview(..., legend = FALSE, ... = 0.5, 
        map.types = 'OpenStreetMap') +
    mapview(..., legend = FALSE, ... = 0.2)

