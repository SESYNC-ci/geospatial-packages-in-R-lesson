---
---

## Mixing raster and vectors: prelude

The creation of geospatial tools in R has been a community effort, but not necessarilly a well-organized one. One current stumbling block is that the [raster](){:.rlib} package, which is tightly integrated with the [sp](){:.rlib} package, has not caught up to the [sf](){:.rlib} package.

Presently, to mix raster and vectors, we must convert the desired `sfc` objects to their counterpart `Spatial*` objects:


~~~r
sesync <- as(sesync, "Spatial")
~~~

~~~
Error in .class1(object): object 'sesync' not found
~~~

~~~r
huc_md <- as(huc_md, "Spatial")
~~~

~~~
Error in .class1(object): object 'huc_md' not found
~~~

~~~r
counties_md <- as(counties_md, "Spatial")
~~~

~~~
Error in .class1(object): object 'counties_md' not found
~~~
{:.text-document title="{{ site.handouts }}"}

===

## Mixing rasters and vectors

The `extract` function allows subsetting and aggregation of raster values based on a vector spatial object.


~~~r
plot(nlcd)
~~~

~~~
Error in plot(nlcd): object 'nlcd' not found
~~~

~~~r
plot(sesync, col = 'green', pch = 16, cex = 2, add = TRUE)
~~~

~~~
Error in plot(sesync, col = "green", pch = 16, cex = 2, add = TRUE): object 'sesync' not found
~~~
{:.text-document title="{{ site.handouts }}"}

===

When extracting by point locations (i.e. a *SpatialPoints* object), the result is a vector of values corresponding to each point.


~~~r
sesync_lc <- extract(nlcd, sesync)
~~~

~~~
Error in extract(nlcd, sesync): could not find function "extract"
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
lc_types[sesync_lc + 1]
~~~
{:.input}
~~~
Error in eval(expr, envir, enclos): object 'lc_types' not found
~~~
{:.output}

===

When extracting with a polygon, the output is a vector of all raster values for pixels falling within that polygon.


~~~r
county_nlcd <- extract(nlcd_agg, counties_md[1,])
~~~

~~~
Error in extract(nlcd_agg, counties_md[1, ]): could not find function "extract"
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
Error in extract(nlcd_agg, huc_md, fun = modal): could not find function "extract"
~~~

~~~r
huc_md$modal_lc <- lc_types[modal_lc + 1]
~~~

~~~
Error in eval(expr, envir, enclos): object 'lc_types' not found
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
head(huc_md)
~~~
{:.input}
~~~
Error in head(huc_md): object 'huc_md' not found
~~~
{:.output}
