---
---

## Mixing raster and vectors: prelude

The creation of geospatial tools in R has been a community effort, but not necessarilly a well-organized one. One current stumbling block is that the [raster](){:.rlib} package, which is tightly integrated with the [sp](){:.rlib} package, has not caught up to the [sf](){:.rlib} package.

Presently, to mix raster and vectors, we must convert the desired `sfc` objects to their counterpart `Spatial*` objects:


~~~r
sesync <- as(sesync, "Spatial")
huc_md <- as(huc_md, "Spatial")
counties_md <- as(counties_md, "Spatial")
~~~
{:.text-document title="{{ site.handouts }}"}

## Mixing rasters and vectors

The `extract` function allows subsetting and aggregation of raster values based on a vector spatial object.


~~~r
plot(nlcd)
plot(sesync, col = 'green', pch = 16, cex = 2, add = TRUE)
~~~
{:.text-document title="{{ site.handouts }}"}

===

![plot of chunk extract_pt]({{ site.baseurl }}/images/extract_pt-1.png)
{:.captioned}

===

When extracting by point locations (i.e. a *SpatialPoints* object), the result is a vector of values corresponding to each point.


~~~r
sesync_lc <- extract(nlcd, sesync)
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
lc_types[sesync_lc + 1]
~~~
{:.input}
~~~
[1] Developed, Medium Intensity
18 Levels:  Barren Land Cultivated Crops ... Woody Wetlands
~~~
{:.output}

===

When extracting with a polygon, the output is a vector of all raster values for pixels falling within that polygon.


~~~r
county_nlcd <- extract(nlcd_agg, counties_md[1,])
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
table(county_nlcd)
~~~
{:.input}
~~~
county_nlcd
11 21 22 23 24 41 
 3  1  4  5  2  1 
~~~
{:.output}

===

To get a summary of raster values for **each** polygon in a `SpatialPolygons` object, add an aggregation function to `extract` via the `fun` argument. For example, `fun = modal` gives the most common land cover type for each polygon in `huc_md`.


~~~r
modal_lc <- extract(nlcd_agg, huc_md, fun = modal)
huc_md$modal_lc <- lc_types[modal_lc + 1]
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
head(huc_md)
~~~
{:.input}
~~~
          AREA PERIMETER HUC250K_ HUC250K_ID HUC_CODE
903 6413577966  454290.2      904        916 02050306
915 1982478663  292729.7      916        927 02040205
937 5910074657  503796.5      938        948 02070004
956 3159193443  506765.4      957        968 02060002
966 4580816836  433034.1      967        978 05020006
975 2502118608  252945.8      976        987 02070009
                 HUC_NAME REG  SUB    ACC      CAT         modal_lc
903     Lower Susquehanna  02 0205 020503 02050306 Deciduous Forest
915  Brandywine-Christina  02 0204 020402 02040205      Hay/Pasture
937 Conococheague-Opequon  02 0207 020700 02070004      Hay/Pasture
956     Chester-Sassafras  02 0206 020600 02060002 Cultivated Crops
966          Youghiogheny  05 0502 050200 05020006 Deciduous Forest
975              Monocacy  02 0207 020700 02070009 Cultivated Crops
~~~
{:.output}
