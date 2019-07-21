---
---

## Raster Data

Raster data is a matrix or cube with additional spatial metadata (e.g. extent,
resolution, and projection) that allow its values to be mapped onto geographical
space. The [raster](){:.rlib} package provides the eponymous `raster()` function
for reading the many formats of such data.

===

The [National Land Cover Database](http://www.mrlc.gov) is a 30m resolution grid
of cells classified as forest, crops, wetland, developed, etc across the CONUS.
The file provided in this lesson is cropped and reduced to a lower resolution in
order to speed processing.



~~~r
library(raster)
nlcd <- raster("data/nlcd_agg.grd")
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


By default, raster data is *not* loaded into working memory, as you can confirm
by checking the R object size with `object.size(nlcd)`. This means that unlike
most analyses in R, you can actually process raster datasets larger than the RAM
available on your computer; the raster package automatically loads pieces of the
data and computes on each of them in sequence.
{:.notes}

===

The default print method for a raster object is a summary of metadata contained
in the raster file.



~~~r
> nlcd
~~~
{:title="Console" .input}


~~~
class      : RasterLayer 
dimensions : 2514, 3004, 7552056  (nrow, ncol, ncell)
resolution : 150, 150  (x, y)
extent     : 1394535, 1845135, 1724415, 2101515  (xmin, xmax, ymin, ymax)
crs        : +proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs 
source     : /nfs/public-data/training/nlcd_agg.grd 
names      : nlcd_2011_landcover_2011_edition_2014_03_31 
values     : 0, 95  (min, max)
attributes :
        ID      COUNT Red Green Blue Land.Cover.Class Opacity
 from:   0 7854240512   0     0    0     Unclassified       1
  to : 255          0   0     0    0                        0
~~~
{:.output}


===

The plot method interprets the pixel values of the raster matrix according to a
pre-defined color scheme.



~~~r
> plot(nlcd)
~~~
{:title="Console" .input}
![ ]({% include asset.html path="images/raster/unnamed-chunk-3-1.png" %})
{:.captioned}

===

The `crop()` function trims a raster object to a given spatial "extent" (or
range of x and y values).



~~~r
extent <- matrix(st_bbox(huc_md), nrow=2)
nlcd <- crop(nlcd, extent)
plot(nlcd)
plot(huc_md, col = NA, add = TRUE)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/raster/unnamed-chunk-4-1.png" %})
{:.captioned}

The extent can be extracted from [sp](){:.rlib} package objects with `extent`,
but must be created "from scratch" for an `sfc`. Here, we crop the `nlcd` raster
to the extent of the `huc_md` polygon, then display both layers on the same map.
Also note that the transformed raster is now loaded in R memory, as indicated by
the size of `nlcd`. We could have also saved the output to disk by specifying an
optional `filename` argument to `crop`; the same is true for many other
functions in the [raster](){:.rlib} package.
{:.notes}

===

A raster is fundamentally a data matrix, and individual pixel values can be
extracted by regular matrix subscripting. For example, the value of
the _bottom_-left corner pixel:



~~~r
> nlcd[1, 1]
~~~
{:title="Console" .input}


~~~
[1] 41
~~~
{:.output}


===

The meaning of this number is not immediately clear. For this particular
dataset, the mapping of values to land cover classes is described in the data
attributes:



~~~r
> head(nlcd@data@attributes[[1]])
~~~
{:title="Console" .input}


~~~
  ID      COUNT Red     Green Blue Land.Cover.Class Opacity
1  0 7854240512   0 0.0000000    0     Unclassified       1
2  1          0   0 0.9764706    0                        1
3  2          0   0 0.0000000    0                        1
4  3          0   0 0.0000000    0                        1
5  4          0   0 0.0000000    0                        1
6  5          0   0 0.0000000    0                        1
~~~
{:.output}


===

The `Land.Cover.Class` vector gives string names for the land cover type
corresponding to the matrix values. Note that we need to add 1 to the raster
value, since these go from 0 to 255, whereas the indexing in R begins at 1.



~~~r
nlcd_attr <- nlcd@data@attributes 
lc_types <- nlcd_attr[[1]]$Land.Cover.Class
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



~~~r
> levels(lc_types)
~~~
{:title="Console" .input}


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

### Raster Math

Mathematical functions called on a raster gets applied to each pixel. For a
single raster `r`, the function `log(r)` returns a new raster where each pixel's
value is the log of the corresponding pixel in `r`.

Likewise, addition with `r1 + r2` creates a raster where each pixel is the sum of the
values from `r1` and `r2`, and so on. Naturally, spatial attributes of rasters
(e.g. extent, resolution, and projection) must match for functions that operate
pixel-wise on multiple rasters.
{:.notes}

===

Logical operations work too: `r1 > 5` returns a raster with pixel values `TRUE`
or `FALSE` and is often used in combination with the `mask()` function.



~~~r
pasture <- mask(nlcd, nlcd == 81,
    maskvalue = FALSE)
plot(pasture)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/raster/unnamed-chunk-9-1.png" %})
{:.captioned}

A pasture raster results from unsetting pixel values where the mask (`nlcd == 81`)
is false (`maskvalue = FALSE`).
{:.notes}

===

To further reduce the resolution of the `nlcd` raster, the `aggregate()`
function combines values in a block of a given size using a given function.



~~~r
nlcd_agg <- aggregate(nlcd,
    fact = 25, fun = modal)
nlcd_agg@legend <- nlcd@legend
plot(nlcd_agg)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/raster/unnamed-chunk-10-1.png" %})
{:.captioned}

Here, `fact = 25` means that we are aggregating blocks 25 x 25 pixels and `fun =
modal` indicates that the aggregate value is the mode of the original pixels
(averaging would not work since land cover is a categorical variable).
{:.notes}
