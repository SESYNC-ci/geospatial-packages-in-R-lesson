---
---

## Mixing rasters and vectors

The `extract` function allows subsetting and aggregation of raster values based on a vector spatial object. When extracting by point locations (i.e. a *SpatialPoints* object), the result is a vector of values corresponding to each point.


~~~r
sesync <- spTransform(sesync, proj1)
plot(nlcd)
plot(sesync, col = 'green', pch = 16, cex = 2, add = TRUE)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk extract_pt]({{ site.baseurl }}/images/extract_pt-1.png)

===


~~~r
sesync_lc <- extract(nlcd, sesync)
~~~
{:.input}


~~~r
lc_types[sesync_lc + 1]
~~~
{:.input}
~~~
[1] Developed, Open Space
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
modal_lc <- extract(nlcd_agg, counties_md, fun = modal)
counties_md$modal_lc <- lc_types[modal_lc + 1]
~~~
{:.text-document title="{{ site.handouts }}"}


~~~r
head(counties_md)
~~~
{:.input}
~~~
     STATEFP COUNTYFP COUNTYNS       AFFGEOID GEOID         NAME LSAD
941       24      510 01702381 0500000US24510 24510    Baltimore   25
1034      24      035 00596089 0500000US24035 24035 Queen Anne's   06
1035      24      037 01697853 0500000US24037 24037   St. Mary's   06
1120      24      015 00596115 0500000US24015 24015        Cecil   06
1206      24      003 01710958 0500000US24003 24003 Anne Arundel   06
1279      24      009 01676636 0500000US24009 24009      Calvert   06
          ALAND     AWATER                    modal_lc
941   209643557   28767622 Developed, Medium Intensity
1034  962645492  360048470            Cultivated Crops
1035  925665243 1053737256            Deciduous Forest
1120  896852795  185340903            Deciduous Forest
1206 1074553083  447833714            Deciduous Forest
1279  552178304  341560888            Deciduous Forest
~~~
{:.output}
