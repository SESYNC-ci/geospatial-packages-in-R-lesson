---
excerpt: Mixing Data Types
---

## Crossing Rasters with Vectors

Raster and vector geospatial data in R require different packages. 
The creation of geospatial tools in R has been a community effort, and not
necessarily a well-organized one. Development is still ongoing on many packages
dealing with raster and vector data.
One current stumbling block is that the [raster](){:.rlib} package, which is tightly 
integrated with the older [sp](){:.rlib} package, has not fully caught up to the [sf](){:.rlib} package. 
The [stars](https://r-spatial.github.io/stars/) package aims to remedy this problem,
and others, but has not yet released a "version 1.0" (it's at 0.4 as of this
writing). In addition, the [terra](){:.rlib} package, which is better integrated with
[sf](){:.rlib}, may ultimately replace the [raster](){:.rlib} package. It is also still in
development (version 0.6 as of this writing).
{:.notes}

Although not needed in this lesson, you may notice in some cases that it is necessary to
convert a vector object from [sf](){:.rlib} (class beginning with `sfc*`) to [sp](){:.rlib}
(class beginning with `Spatial*`) for the vector object to interact with rasters.
You can do this by calling `sp_object <- as(sf_object, 'Spatial')`.
{:.notes}

The `extract` function allows subsetting and aggregation of raster values based
on a vector spatial object. For example we might want to extract the NLCD land cover 
class at SESYNC's location.



~~~r
plot(nlcd)
plot(sesync, col = 'green',
     pch = 16, cex = 2, add = TRUE)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/extract/unnamed-chunk-1-1.png" %})
{:.captioned}

===

Pull the coordinates from the `sfc` object containing SESYNC's point location and call `extract`.
When extracting by point locations, the result is a vector of values corresponding to each point. 



~~~r
sesync_lc <- extract(nlcd, st_coordinates(sesync))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> lc_types[sesync_lc + 1]
~~~
{:title="Console" .input}


~~~
[1] Developed, Medium Intensity
18 Levels:  Barren Land Cultivated Crops ... Woody Wetlands
~~~
{:.output}


===

When extracting with a polygon, the output is a vector of all raster values for
pixels falling within that polygon. This code extracts all pixels within the first
polygon in the Maryland county data frame.



~~~r
county_nlcd <- extract(nlcd_agg,
    counties_md[1,])
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> table(county_nlcd)
~~~
{:title="Console" .input}


~~~
county_nlcd
11 21 22 23 24 41 
 3  1  4  5  2  1 
~~~
{:.output}


===

To get a summary of raster values for **each** polygon in a `SpatialPolygons`
object, add an aggregation function to `extract` via the `fun` argument. For
example, `fun = modal` gives the most common land cover type for each polygon in
`huc_md`.



~~~r
modal_lc <- extract(nlcd_agg,
    huc_md, fun = modal)
huc_md <- huc_md %>%
  mutate(modal_lc = lc_types[modal_lc + 1])
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> huc_md
~~~
{:title="Console" .input}


~~~
Simple feature collection with 30 features and 11 fields
geometry type:  GEOMETRY
dimension:      XY
bbox:           xmin: 1396621 ymin: 1837626 xmax: 1797029 ymax: 2037741
CRS:            +proj=aea +lat_1=29.5 +lat_2=45.5 
    +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0    
    +ellps=GRS80 +towgs84=0,0,0,0,0,0,0   
    +units=m +no_defs
First 10 features:
         AREA PERIMETER HUC250K_ HUC250K_ID HUC_CODE              HUC_NAME REG
1  6413577966  454290.2      904        916 02050306     Lower Susquehanna  02
2  1982478663  292729.7      916        927 02040205  Brandywine-Christina  02
3  5910074657  503796.5      938        948 02070004 Conococheague-Opequon  02
4  3159193443  506765.4      957        968 02060002     Chester-Sassafras  02
5  4580816836  433034.1      967        978 05020006          Youghiogheny  05
6  2502118608  252945.8      976        987 02070009              Monocacy  02
7  3483549988  415851.4      988        999 02060003    Gunpowder-Patapsco  02
8  3582821909  935625.3      993       1004 02060001  Upper Chesapeake Bay  02
9  3117956776  378807.0      999       1009 02070003          Cacapon-Town  02
10 3481485179  373451.5     1003       1013 02070002  North Branch Potomac  02
    SUB    ACC      CAT                       geometry         modal_lc
1  0205 020503 02050306 MULTIPOLYGON (((1683575 203... Deciduous Forest
2  0204 020402 02040205 MULTIPOLYGON (((1707075 202...      Hay/Pasture
3  0207 020700 02070004 POLYGON ((1563403 2008455, ... Deciduous Forest
4  0206 020600 02060002 POLYGON ((1701439 2037188, ... Cultivated Crops
5  0502 050200 05020006 POLYGON ((1441528 1985664, ... Deciduous Forest
6  0207 020700 02070009 POLYGON ((1610557 2016043, ... Cultivated Crops
7  0206 020600 02060003 POLYGON ((1610557 2016043, ... Deciduous Forest
8  0206 020600 02060001 MULTIPOLYGON (((1691021 201...       Open Water
9  0207 020700 02070003 POLYGON ((1496410 1995810, ... Deciduous Forest
10 0207 020700 02070002 POLYGON ((1468299 1990565, ... Deciduous Forest
~~~
{:.output}

