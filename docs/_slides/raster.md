---
---

## Working with raster data

Raster data is a matrix or cube with additional spatial metadata (e.g. extent, resolution, and projection) that allow its values to be mapped onto geographical space. The **raster** package provides the eponymous `raster()` function for reading the many formats for such data.

===

The [National Land Cover Database](http://www.mrlc.gov/nlcd2011.php) is '.GRD' format data, a lot of it. The file provided in this lesson is cropped and reduced to a lower resolution in order to speed processing.


~~~r
library(raster)

nlcd <- raster("data/nlcd_agg.grd")
~~~
{:.text-document title="{{ site.handouts }}"}

By default, the whole raster is *not* loaded into working memory, as you can confirm by checking the R object size with `object.size(nlcd)`. This means that unlike most analyses in R, you can actually process raster datasets larger than the RAM available on your computer; the raster package automatically loads pieces of the data and computes on each of them in sequence.
{:.aside}

===


~~~r
nlcd
~~~
{:.input}
~~~
class       : RasterLayer 
dimensions  : 2514, 3004, 7552056  (nrow, ncol, ncell)
resolution  : 150, 150  (x, y)
extent      : 1394535, 1845135, 1724415, 2101515  (xmin, xmax, ymin, ymax)
coord. ref. : +proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs 
data source : /Users/icarroll/training/sesync-ci.github/geospatial-packages-in-R-lesson/data/nlcd_agg.grd 
names       : nlcd_2011_landcover_2011_edition_2014_03_31 
values      : 0, 95  (min, max)
attributes  :
        ID      COUNT Red Green Blue Land.Cover.Class Opacity
 from:   0 7854240512   0     0    0     Unclassified       1
 to  : 255          0   0     0    0                        0
~~~
{:.output}

===


~~~r
plot(nlcd)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk show_raster]({{ site.baseurl }}/images/show_raster-1.png)

===

The `crop()` function crops a raster layer to a given spatial *extent* (range of *x* and *y* values). The extent can be extracted from another spatial object with `extent`. Here, we crop the *nlcd* raster to the extent of the *huc_md* polygons, then display both layers on the same map. 


~~~r
nlcd <- crop(nlcd, extent(huc_md))
plot(nlcd)
plot(huc_md, add = TRUE)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk crop_raster]({{ site.baseurl }}/images/crop_raster-1.png)

Note that the transformed raster is now loaded in R memory, as indicated by the size of `nlcd`. We could have also saved the output to disk by specifying an optional `filename` argument to `crop`; the same is true for othe raster transformation functions.
{:.notes}

===

A raster is fundamentally a data matrix, and individual pixel values can be extracted by regular matrix subscripting. For example, this returns the value of the bottom-left corner pixel:


~~~r
nlcd[1, 1]
~~~
{:.input}
~~~
   
41 
~~~
{:.output}

===

The meaning of this number is not immediately clear. For this particular dataset, the mapping of values to land cover classes is described in the data attributes:


~~~r
str(nlcd@data@attributes[[1]])
~~~
{:.input}
~~~
'data.frame':	256 obs. of  7 variables:
 $ ID              : int  0 1 2 3 4 5 6 7 8 9 ...
 $ COUNT           : num  7.85e+09 0.00 0.00 0.00 0.00 ...
 $ Red             : num  0 0 0 0 0 0 0 0 0 0 ...
 $ Green           : num  0 0.976 0 0 0 ...
 $ Blue            : num  0 0 0 0 0 0 0 0 0 0 ...
 $ Land.Cover.Class: Factor w/ 18 levels "","Barren Land",..: 17 1 1 1 1 1 1 1 1 1 ...
 $ Opacity         : num  1 1 1 1 1 1 1 1 1 1 ...
~~~
{:.output}

===

The `Land.Cover.Class` vector gives string names for the land cover type corresponding to the matrix values. Note that we need to add 1 to the raster value, since these go from 0 to 255, whereas the indexing in R begins at 1.


~~~r
lc_types <- nlcd@data@attributes[[1]]$Land.Cover.Class
levels(lc_types)
~~~
{:.input}
~~~
 [1] ""                              "Barren Land"                  
 [3] "Cultivated Crops"              "Deciduous Forest"             
 [5] "Developed, High Intensity"     "Developed, Low Intensity"     
 [7] "Developed, Medium Intensity"   "Developed, Open Space"        
 [9] "Emergent Herbaceuous Wetlands" "Evergreen Forest"             
[11] "Hay/Pasture"                   "Herbaceuous"                  
[13] "Mixed Forest"                  "Open Water"                   
[15] "Perennial Snow/Ice"            "Shrub/Scrub"                  
[17] "Unclassified"                  "Woody Wetlands"               
~~~
{:.output}

===

## Raster math

A mathematical function called on a raster gets applied to each pixel. For a raster `r1`, the function `log(r1)` returns a new raster where each pixel's value is the log of the corresponding pixel in `r1`. The addition of `r1 + r2` creates a raster where each pixel is the sum of the values from `r1` and `r2`, provided their spatial attributes (e.g. extent, resolution, and projection) are the same.

===

Logical operations work too: `r1 > 5` returns a raster with pixel values `TRUE` or `FALSE` and is often used in combination with the `mask()` function. A pasture raster results from unsetting pixel values where the mask (`nlcd == 81`) is false (`maskvalue = FALSE`).


~~~r
pasture <- mask(nlcd, nlcd == 81, maskvalue = FALSE)
plot(pasture)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk mask]({{ site.baseurl }}/images/mask-1.png)

===

To further reduce the resolution of the `nlcd` raster, the `aggregate()` function combines values in a block of a given size using a given function.


~~~r
nlcd_agg <- aggregate(nlcd, fact = 25, fun = modal)
nlcd_agg@legend <- nlcd@legend
plot(nlcd_agg)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk agg_raster]({{ site.baseurl }}/images/agg_raster-1.png)

Here, `fact = 25` means that we are aggregating blocks 25 x 25 pixels and `fun = modal` indicates that the aggregate value is the mode of the original pixels (averaging would not work since land cover is a categorical variable).
{:.notes}

===

## Exercise 3

The function `cellStats` aggregates accross an entire raster. Use it to figure out the  proportion of `nlcd` pixels that are covered by deciduous forest (value = 41).

[View solution](#solution-3)
