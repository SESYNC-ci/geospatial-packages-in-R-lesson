---
---

## Raster Data

Raster data is a matrix or cube with additional spatial metadata (e.g. extent,
resolution, and projection) that allows its values to be mapped onto geographical
space. The [stars][stars] package provides the `read_stars()` function
for reading the many formats of such data.

In the past (from 2010 to 2020), the [raster](){:.rlib} package was the primary R package 
for reading and working with raster data. Recently, the developers of [sf][sf]
released [stars][stars] (**S**patio-**T**emporal **AR**ray**S**). It is integrated
more closely with [sf][sf] and related packages, as well as with the "tidyverse"
family of packages, and has significant performance advantages. Another new alternative
is [terra](){:.rlib}, created by the developer of [raster](){:.rlib}. Older versions of this lesson
use [raster](){:.rlib}, and you may come across the [raster](){:.rlib} package when searching for help on
geospatial data analysis in R. Nevertheless we recommend [terra](){:.rlib} or [stars][stars] 
because of their simplicity and speed advantages, and also because they are more likely 
to be updated and maintained in the future.
{:.notes}

===

The [National Land Cover Database](http://www.mrlc.gov) is a 30m resolution grid
of cells classified as forest, crops, wetland, developed, etc., across the continental
United States.
The file provided in this lesson is cropped and reduced to a lower resolution in
order to speed processing.



~~~r
library(stars)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Warning: package 'abind' was built under R version 4.0.4
~~~
{:.output}


~~~r
nlcd <- read_stars("data/nlcd_agg.tif", proxy = FALSE)
nlcd <- droplevels(nlcd)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


Here we set `proxy = FALSE` because this is a small example raster that we can
load into working memory. 
If `proxy = TRUE`, raster data is *not* loaded into working memory, as you can confirm
by checking the R object size with `object.size(nlcd)`. This means that unlike
most analyses in R, you can actually process raster datasets larger than the RAM
available on your computer; `stars` automatically loads pieces of the
data and computes on each of them in sequence. By default, `stars` will load small
rasters into working memory and large rasters as proxies unless you specify otherwise.
{:.notes}

Also note that the `nlcd_agg.tif` file is accompanied by a metadata file called
`nlcd_agg.tif.aux.xml` that stores information including descriptive names for the different
land cover classes.
We need to call `droplevels(nlcd)` to remove empty factor levels. The 
[NLCD 2016 legend](https://www.mrlc.gov/data/legends/national-land-cover-database-2016-nlcd2016-legend)
classification codes are not sequential and begin with 11, but factor levels in R begin with 1. 
Using `droplevels` gets rid of the empty levels so that the legends on the plots 
we will make in a moment do not include blank levels. 
{:.notes}

===

The default `print` method for a `stars` raster object is a summary of metadata contained
in the raster file.



~~~r
> nlcd
~~~
{:title="Console" .input}


~~~
stars object with 2 dimensions and 1 attribute
attribute(s), summary of first 1e+05 cells:
                  nlcd_agg.tif   
 Deciduous Forest        :32576  
 Cultivated Crops        :13014  
 Developed, Open Space   :11063  
 Hay/Pasture             :10729  
 Mixed Forest            : 9260  
 Developed, Low Intensity: 8034  
 (Other)                 :15324  
dimension(s):
  from   to  offset delta                       refsys point values x/y
x    1 3004 1394535   150 PROJCS["Albers_Conical_Eq... FALSE   NULL [x]
y    1 2514 2101515  -150 PROJCS["Albers_Conical_Eq... FALSE   NULL [y]
~~~
{:.output}


===

The `plot` method interprets the pixel values of the raster matrix according to a
pre-defined color scheme.



~~~r
> plot(nlcd)
~~~
{:title="Console" .input}


~~~
downsample set to c(5,5)
~~~
{:.output}
![ ]({% include asset.html path="images/raster/unnamed-chunk-3-1.png" %})
{:.captioned}

===

The `st_crop()` function trims a `stars` raster object to the dimensions of a given
spatial object or bounding box.

Here we crop the NLCD raster
to the bounding box of the `huc_md` polygon, then display both layers on the same map.
(We can plot polygon and raster layers together on the same map, just like we can plot
multiple polygon layers---as long as they have the same coordinate reference system!) 
Because `ggplot2` does not automagically recognize the predefined color scheme from the 
original image file, we have to extract the color scheme using
`attr(nlcd[[1]], 'colors')` and use it as an argument to `scale_fill_manual()`.
{:.notes}



~~~r
md_bbox <- st_bbox(huc_md)
nlcd <- st_crop(nlcd, md_bbox)

ggplot() +
  geom_stars(data = nlcd) +
  geom_sf(data = huc_md, fill = NA) +
  scale_fill_manual(values = attr(nlcd[[1]], 'colors'))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/raster/unnamed-chunk-4-1.png" %})
{:.captioned}

===

A raster is fundamentally a data matrix, and individual pixel values can be
extracted by regular matrix subscripting. The matrix of pixel values is found
in list element `[[1]]` of a `stars` object. For example, the value of
the _bottom_-left corner pixel:



~~~r
> nlcd[[1]][1, 1]
~~~
{:title="Console" .input}


~~~
[1] Herbaceuous
16 Levels: Unclassified Open Water ... Emergent Herbaceuous Wetlands
~~~
{:.output}


The index `[1, 1]` corresponds to the bottom left pixel because the raster
represents a two-dimensional image with `x` and `y` coordinates. The origin
of the axes is at the bottom left.
{:.notes}

===

For this particular dataset, land cover class is represented as a factor
variable. We can display the factor levels of `nlcd[[1]]`:



~~~r
> levels(nlcd[[1]])
~~~
{:title="Console" .input}


~~~
 [1] "Unclassified"                  "Open Water"                   
 [3] "Developed, Open Space"         "Developed, Low Intensity"     
 [5] "Developed, Medium Intensity"   "Developed, High Intensity"    
 [7] "Barren Land"                   "Deciduous Forest"             
 [9] "Evergreen Forest"              "Mixed Forest"                 
[11] "Shrub/Scrub"                   "Herbaceuous"                  
[13] "Hay/Pasture"                   "Cultivated Crops"             
[15] "Woody Wetlands"                "Emergent Herbaceuous Wetlands"
~~~
{:.output}


Writing `pull(nlcd)` is equivalent to `nlcd[[1]]`. This can be useful if 
you are extracting values from a raster as part of a "pipe." For example,
`nlcd %>% pull %>% levels` would give the same result as the code above.
{:.notes}

===

### Raster Math

Mathematical functions called on a raster get applied to each pixel. For a
single raster `r`, the function `log(r)` returns a new raster where each pixel's
value is the log of the corresponding pixel in `r`.

Likewise, addition with `r1 + r2` creates a raster where each pixel is the sum of the
values from `r1` and `r2`, and so on. Naturally, spatial attributes of rasters
(e.g. extent, resolution, and projection) must match for functions that operate
pixel-wise on multiple rasters.
{:.notes}

===

Logical operations work too: `r1 > 5` returns a raster with pixel values `TRUE`
or `FALSE` and is often used to "mask" a raster, or remove pixels that don't
meet a certain logical condition.

===



~~~r
forest_types <- c('Evergreen Forest', 'Deciduous Forest', 'Mixed Forest')
forest <- nlcd
forest[!(forest %in% forest_types)] <- NA
plot(forest)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
downsample set to c(3,3)
~~~
{:.output}
![ ]({% include asset.html path="images/raster/unnamed-chunk-7-1.png" %})
{:.captioned}

We define a vector including the levels of `nlcd` representing three types of forest and
create a copy of `nlcd` called `forest`. We "mask out" all pixels in `forest` that do not meet
the logical condition `forest %in% forest_types`, setting them to `NA`. (The `!` negates a
logical condition.) This results in a raster 
where all pixels that are not classified as forest are removed.
{:.notes}

===

To further reduce the resolution of the `nlcd` raster, the `st_warp()`
function combines values in a block of a given size using a given method.



~~~r
nlcd_agg <- st_warp(nlcd,
                    cellsize = 1500, 
                    method = 'mode', 
                    use_gdal = TRUE)

nlcd_agg <- droplevels(nlcd_agg) 
levels(nlcd_agg[[1]]) <- levels(nlcd[[1]]) 

plot(nlcd_agg)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/raster/unnamed-chunk-8-1.png" %})
{:.captioned}

Here, `cellsize = 1500` specifies that the raster should be downsampled to 1500-meter
pixel size. The input raster has 150-meter resolution, so this will convert
10-by-10 blocks of pixels to single pixels.
The argument `method = 'mode'` indicates that the aggregated value is the 
mode of the input pixels making up each output pixel
(averaging would not work since land cover is a categorical variable). 
`use_gdal = TRUE` specifies to use the GDAL system library "behind the scenes" to
do the aggregation, which is needed for aggregation methods including `mode`.
Unfortunately, the call to GDAL strips away the land cover class names so we 
replace them by dropping unused levels with `droplevels()` and then replacing the names
with `levels()`.
{:.notes}

[sf]: https://r-spatial.github.io/sf/
[stars]: https://r-spatial.github.io/stars/
