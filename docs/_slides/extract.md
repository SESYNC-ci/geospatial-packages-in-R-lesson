---
---

## Mixing raster and vectors: prelude

The creation of geospatial tools in R has been a community effort, but not necessarilly a well-organized one. One current stumbling block is that the [raster](){:.rlib} package, which is tightly integrated with the [sp](){:.rlib} package, has not caught up to the [sf](){:.rlib} package.

Presently, to mix raster and vectors, we must convert the desired `sfc` objects to their counterpart `Spatial*` objects:


~~~r
sesync <- as(sesync, "Spatial")
~~~

~~~
Error in as(sesync, "Spatial"): no method or default for coercing "sfc_POINT" to "Spatial"
~~~

~~~r
huc_md <- as(huc_md, "Spatial")
~~~

~~~
Error in as(huc_md, "Spatial"): no method or default for coercing "sf" to "Spatial"
~~~

~~~r
counties_md <- as(counties_md, "Spatial")
~~~

~~~
Error in as(counties_md, "Spatial"): no method or default for coercing "sf" to "Spatial"
~~~
{:.text-document title="{{ site.handouts }}"}

## Mixing rasters and vectors

The `extract` function allows subsetting and aggregation of raster values based on a vector spatial object. When extracting by point locations (i.e. a *SpatialPoints* object), the result is a vector of values corresponding to each point.


~~~r
plot(nlcd)
plot(sesync, col = 'green', pch = 16, cex = 2, add = TRUE)
~~~
{:.text-document title="{{ site.handouts }}"}

===

![plot of chunk extract_pt]({{ site.baseurl }}/images/extract_pt-1.png)
{:.captioned}

===


~~~r
sesync_lc <- extract(nlcd, sesync)
~~~
{:.input}
~~~
Error in (function (classes, fdef, mtable) : unable to find an inherited method for function 'extract' for signature '"RasterLayer", "sfc_POINT"'
~~~
{:.output}


~~~r
lc_types[sesync_lc + 1]
~~~
{:.input}
~~~
Error in NextMethod("["): object 'sesync_lc' not found
~~~
{:.output}

===

When extracting with a polygon, the output is a vector of all raster values for pixels falling within that polygon.


~~~r
county_nlcd <- extract(nlcd_agg, counties_md[1,])
~~~

~~~
Error in (function (classes, fdef, mtable) : unable to find an inherited method for function 'extract' for signature '"RasterLayer", "sf"'
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
table(county_nlcd)
~~~
{:.input}
~~~
Error in table(county_nlcd): object 'county_nlcd' not found
~~~
{:.output}

===

To get a summary of raster values for **each** polygon in a `SpatialPolygons` object, add an aggregation function to `extract` via the `fun` argument. For example, `fun = modal` gives the most common land cover type for each polygon in `huc_md`.


~~~r
modal_lc <- extract(nlcd_agg, huc_md, fun = modal)
~~~

~~~
Error in (function (classes, fdef, mtable) : unable to find an inherited method for function 'extract' for signature '"RasterLayer", "sf"'
~~~

~~~r
huc_md$modal_lc <- lc_types[modal_lc + 1]
~~~

~~~
Error in NextMethod("["): object 'modal_lc' not found
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
head(huc_md)
~~~
{:.input}
~~~
Simple feature collection with 6 features and 10 fields
geometry type:  GEOMETRY
dimension:      XY
bbox:           xmin: 1396621 ymin: 1921148 xmax: 1720630 ymax: 2037741
epsg (SRID):    NA
proj4string:    +proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs
          AREA PERIMETER HUC250K_ HUC250K_ID HUC_CODE
903 6413577966  454290.2      904        916 02050306
915 1982478663  292729.7      916        927 02040205
937 5910074657  503796.5      938        948 02070004
956 3159193443  506765.4      957        968 02060002
966 4580816836  433034.1      967        978 05020006
975 2502118608  252945.8      976        987 02070009
                 HUC_NAME REG  SUB    ACC      CAT
903     Lower Susquehanna  02 0205 020503 02050306
915  Brandywine-Christina  02 0204 020402 02040205
937 Conococheague-Opequon  02 0207 020700 02070004
956     Chester-Sassafras  02 0206 020600 02060002
966          Youghiogheny  05 0502 050200 05020006
975              Monocacy  02 0207 020700 02070009
                          geometry
903 MULTIPOLYGON(((1683574.7794...
915 MULTIPOLYGON(((1707075.2893...
937 POLYGON((1563403.42000023 2...
956 POLYGON((1701439.3800023 20...
966 POLYGON((1441528.27771155 1...
975 POLYGON((1610556.9351812 20...
~~~
{:.output}
