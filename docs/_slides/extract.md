---
excerpt: Mixing Data Types
---

## Crossing Rasters with Vectors

Raster and vector geospatial data in R require different packages. 
The creation of geospatial tools in R has been a community effort, and not
necessarily a well-organized one. Development is still ongoing on many packages
dealing with raster and vector data.
The [stars][stars] package has not yet released a "version 1.0" 
(it's at 0.5 as of this writing). Developers are working hard on improving the package but
if you notice any issues or bugs, report them on their [GitHub repo](https://github.com/r-spatial/stars).
{:.notes}

Although not needed in this lesson, you may notice when using some older geospatial packages that it is necessary to
convert a vector object from [sf][sf] (class beginning with `sfc*`) to [sp](){:.rlib}
(class beginning with `Spatial*`). [sp](){:.rlib} is an older package that was replaced
by [sf][sf], and many geospatial packages still work with [sp](){:.rlib} objects.
You can do this by calling `sp_object <- as(sf_object, 'Spatial')`. You may also
need to convert a `stars` object to a `Raster*` class object, which you can do
by calling `stars_object <- as(sf_object, 'Raster')`.
{:.notes}

The `st_extract()` function allows subsetting and aggregation of raster values based
on a vector spatial object. For example we might want to extract the NLCD land cover 
class at SESYNC's location.



~~~r
plot(nlcd, reset = FALSE)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
downsample set to c(3,3)
~~~
{:.output}


~~~r
plot(sesync, col = 'green',
     pch = 16, cex = 2, add = TRUE)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/extract/unnamed-chunk-1-1.png" %})
{:.captioned}

When we use `plot()` to combine raster and vector layers we need to set `reset = FALSE` on 
the first layer we plot so that additional objects can be added to the plot.
{:.notes}

===

Call `st_extract()` on the `nlcd` raster and the `sfc` object containing SESYNC's point location.
When extracting by point locations, the result is another `sfc` with `POINT` geometry and
a column containing the pixel values from the raster at each point.



~~~r
sesync_lc <- st_extract(nlcd, sesync)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> sesync_lc
~~~
{:title="Console" .input}


~~~
Simple feature collection with 1 feature and 1 field
Geometry type: POINT
Dimension:     XY
Bounding box:  xmin: 1661671 ymin: 1943332 xmax: 1661671 ymax: 1943332
CRS:           +proj=aea +lat_1=29.5 +lat_2=45.5 
        +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 
        +datum=WGS84 +units=m +no_defs
                 nlcd_agg.tif                geometry
1 Developed, Medium Intensity POINT (1661671 1943332)
~~~
{:.output}


===

Instead of returning a point geometry, you might want to mask a raster by a point geometry instead. 
You can use the indexing operator `[]` to do this. This will set
all pixels in the raster not overlapping the point geometry to `NA`.



~~~r
> nlcd[sesync]
~~~
{:title="Console" .input}


~~~
stars object with 2 dimensions and 1 attribute
attribute(s):
                     nlcd_agg.tif 
 Developed, Medium Intensity:1    
 Unclassified               :0    
 Open Water                 :0    
 Developed, Open Space      :0    
 Developed, Low Intensity   :0    
 Developed, High Intensity  :0    
 (Other)                    :0    
dimension(s):
  from   to  offset delta                       refsys point values x/y
x 1781 1781 1394535   150 PROJCS["Albers_Conical_Eq... FALSE   NULL [x]
y 1055 1055 2101515  -150 PROJCS["Albers_Conical_Eq... FALSE   NULL [y]
~~~
{:.output}


===

To extract with a polygon, first subset the raster by the polygon geometry. For example
here we subset the NLCD raster by the first row of `counties_md` 
(Baltimore City), resulting in a raster with smaller dimensions that we can plot.



~~~r
baltimore <- nlcd[counties_md[1, ]]
plot(baltimore)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/extract/unnamed-chunk-5-1.png" %})
{:.captioned}

===

The expression `nlcd[counties_md[1, ]]` is equivalent to `st_crop(nlcd, counties_md[1, ])`.
The version with `st_crop()` is a bit easier to use with pipes.

===

Here we use a pipe to crop the NLCD raster to the boundaries of Baltimore City,
pull the values as a matrix, and tabulate them.



~~~r
nlcd %>%
  st_crop(counties_md[1, ]) %>%
  pull %>%
  table
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
.
                 Unclassified                    Open Water 
                            0                           580 
        Developed, Open Space      Developed, Low Intensity 
                         1784                          2274 
  Developed, Medium Intensity     Developed, High Intensity 
                         2414                          2067 
                  Barren Land              Deciduous Forest 
                           62                           563 
             Evergreen Forest                  Mixed Forest 
                            8                            78 
                  Shrub/Scrub                   Herbaceuous 
                            3                             8 
                  Hay/Pasture              Cultivated Crops 
                           26                            22 
               Woody Wetlands Emergent Herbaceuous Wetlands 
                           26                             2 
~~~
{:.output}


===

To get a summary of raster values for **each** polygon in an `sfc`
object, use `aggregate()` and specify an aggregation function `FUN`. This
example gives the most common land cover type for each polygon in `huc_md`.



~~~r
mymode <- function(x) names(which.max(table(x)))

modal_lc <- aggregate(nlcd_agg, huc_md, FUN = mymode) 
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


The [stars][stars] package (and base R for that matter) currently have no built-in mode function
so we define a simple one here and pass it to `aggregate()`.
{:.notes}

===

The result is a `stars` object. We can convert it to an `sfc` object containing polygon
geometry.



~~~r
> st_as_sf(modal_lc)
~~~
{:title="Console" .input}


~~~
Simple feature collection with 30 features and 1 field
Geometry type: GEOMETRY
Dimension:     XY
Bounding box:  xmin: 1396621 ymin: 1837626 xmax: 1797029 ymax: 2037741
CRS:           +proj=aea +lat_1=29.5 +lat_2=45.5 
        +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 
        +datum=WGS84 +units=m +no_defs
First 10 features:
   fileea3a5b6a8934.tif                       geometry
1      Deciduous Forest MULTIPOLYGON (((1683575 203...
2           Hay/Pasture MULTIPOLYGON (((1707075 202...
3      Deciduous Forest POLYGON ((1563403 2008455, ...
4      Cultivated Crops POLYGON ((1701439 2037188, ...
5      Deciduous Forest POLYGON ((1441528 1985664, ...
6           Hay/Pasture POLYGON ((1610557 2016043, ...
7      Deciduous Forest POLYGON ((1610557 2016043, ...
8            Open Water MULTIPOLYGON (((1691021 201...
9      Deciduous Forest POLYGON ((1496410 1995810, ...
10     Deciduous Forest POLYGON ((1468299 1990565, ...
~~~
{:.output}


===

Alternatively, we can extract the values from the `stars` object, add them as a new
column to `huc_md`, and plot:



~~~r
huc_md <- huc_md %>% 
  mutate(modal_lc = modal_lc[[1]])

ggplot(huc_md, aes(fill = modal_lc)) + 
  geom_sf()
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/extract/unnamed-chunk-9-1.png" %})
{:.captioned}

[sf]: https://r-spatial.github.io/sf/
[stars]: https://r-spatial.github.io/stars/

