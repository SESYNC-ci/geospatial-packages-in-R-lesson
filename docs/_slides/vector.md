---
---

## Importing vector data

We start by importing a layer of polygons corresponding to US counties. The data is available from the [US Census website](http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_county_500k.zip), but we will load a local copy.

- Necessary R packages:
  - **sp**: defines spatial data classes in R and is thus a prerequisite for most other spatial analyses packages
  - **rgdal**: an interface to the Geospatial Data Abstraction Library and OGR (collectively GDAL), enabling R to import spatial data stored in different file formats.

Note that in order to use rgdal in a Linux/UNIX environment, you need to first [install GDAL](http://trac.osgeo.org/gdal/wiki/DownloadingGdalBinaries).
{:.notes}

===

To import a .shp shapefile, we call the `readOGR` function from rgdal. This function takes at minimum two arguments, corresponding to the file location (`dsn`) and layer name (`layer`); in general, the layer name should match the filename without its extension.


~~~r
library(sp)
library(rgdal)

shp <- 'data/cb_2016_us_county_5m'
counties <- readOGR(dsn = shp,
                    layer = "cb_2016_us_county_5m",
                    stringsAsFactors = FALSE)
~~~
{:.text-document title="{{ site.handouts }}"}

===

Because each polygon in the shapefile has attached data, the resulting object is a *SpatialPolygonsDataFrame*.

By exploring its structure in the RStudio Environment tab, we see that it contains a data frame (`counties@data`) and a list of polygons (`counties@polygons`). A *SpatialPolygons* object is a polygon layer with the same components, but no attached `@data`. Analogous classes exist for point (*SpatialPoints*, *SpatialPointsDataFrame*) and line (*SpatialLines*, *SpatialLinesDataFrame*) layers. Note that the `stringsAsFactors` argument we specified works the same as for regular data frames. 
{:.notes}

We can print the bounding box for the entire set of polgygons:


~~~r
counties@bbox
~~~
{:.input}
~~~
         min       max
x -179.14734 179.77847
y  -14.55255  71.35256
~~~
{:.output}

Or the proj4 string:


~~~r
counties@proj4string
~~~
{:.input}
~~~
CRS arguments:
 +proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0 
~~~
{:.output}

Note the use of "@" rather than "$" to access parts of this object.

The use of "@" has to do with object-oriented programming systems in R and is beyond the scope of this lesson. However, you can always look at the structure of an object, either with the `str()` function or in the RStudio Environment tab, to know which of the two characters applies.
{:.notes}

===

A *SpatialPolygons* object, or *SpatialPolygonsDataFrame*, contains one or more *Polygons* objects, which are simple polygons in the geometric sense. A *Polygons* object can combine many polygons that represent both "islands" and "holes".

![]({{ site.baseurl }}/images/bivand_fig2_4.png)  
*Credit: Bivand et al. (2013)*
{:.captioned}

The diagram above summarizes the hierarchical structure of *SpatialPolygons* (and *SpatialLines*) objects. Although we will only deal with the full spatial objects in this lesson, understanding this structure is useful for more complex operations, e.g. when you need to apply a custom function on each individual polygon. The `@coords` slot of a *Polygon* is a matrix with the (*x*,*y*) coordinates of each vertex, with the first and last vertices being identical to form a "closed" shape.
{:.notes}

===

Spatial objects defined by the sp package are compatible with the base R `plot` function. Specify `xlim` and `ylim` arguments display only the continental US.


~~~r
plot(counties, xlim = c(-125, -65), ylim = c(24, 50))
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk plot_counties]({{ site.baseurl }}/images/plot_counties-1.png)

===

Instead of importing a shapefile, we can build spatial objects from coordinate matrices in R. Here's a *SpatialPoints* object with a single point, corresponding to SESYNC's coordinates in decimal degrees. Note that coordinates must be in a two-column matrix. 


~~~r
sesync <- SpatialPoints(matrix(c(-76.505206, 38.9767231), ncol=2), 
                        proj4string = CRS(proj4string(counties)))
~~~
{:.text-document title="{{ site.handouts }}"}

We set the new object's coordinate system to match that of *counties*. Note that the `CRS()` function (for Coordinate Reference System) is required to assign the proj4string of one object to another object.
{:.notes}

===

When two spatial layers share the same coordinate system, they can be superposed on the same plot. The spatial version of `plot` accepts an `add` parameter to add a layer to the last plot.


~~~r
plot(counties, xlim = c(-125, -65), ylim = c(20, 50))
plot(sesync, col = "green", pch = 20, add = TRUE)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk plot_point]({{ site.baseurl }}/images/plot_point-1.png)

The arguments `col` and `pch` are graphical parameters used in base R, see `?par`.

===

## Subsetting vector layers

A *Spatial\*DataFrame* can be **subset** with expressions in brackets, just like a regular R data frame.


~~~r
counties_md <- counties[counties$STATEFP == "24", ]
plot(counties_md)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk subset_md]({{ site.baseurl }}/images/subset_md-1.png)

The code above selects specific rows (corresponding to counties in Maryland, a.k.a. FIPS code 24) along with the polygons corresponding to those rows. Subsetting by columns would only affect the data frame component.
{:.notes}

===

A spatial **overlay** operation can be seen as a type of subset based on spatial (rather than data) matching. It is implemented with the `over()` function in `sp`.


~~~r
over(sesync, counties_md)
~~~
{:.input}
~~~
  STATEFP COUNTYFP COUNTYNS       AFFGEOID GEOID         NAME LSAD
1      24      003 01710958 0500000US24003 24003 Anne Arundel   06
       ALAND    AWATER
1 1074553083 447833714
~~~
{:.output}

The exact output depends on the type of layers being matched by `over(sp1, sp2)`. In this case with *sp1* a *SpatialPoints* layer and *sp2* a *SpatialPolygonsDataFrame*, the function finds the polygon(s) containing each point in *sp1* and returns the corresponding rows of *sp2*.
{:.notes}

===

## Exercise 1

Produce a map of Maryland counties with the county named "Frederick" colored in red.

[View solution](#solution-1)
{:.notes}

===

## Coordinate transformations

For the next part of this lesson, we import a new polygon layer corresponding to the 1:250k map of US hydrological units (HUC) [downloaded](http://water.usgs.gov/GIS/dsdl/huc250k_shp.zip) from the United States Geological Survey .


~~~r
shp <- "data/huc250k"
huc <- readOGR(dsn = shp,
               layer = "huc250k",
               stringsAsFactors = FALSE)
~~~
{:.text-document title="{{ site.handouts }}"}

===

Compare the coordinate reference systems of `counties` and `huc`, as given by their Proj4 strings.


~~~r
proj4string(counties_md)
~~~
{:.input}
~~~
[1] "+proj=longlat +datum=NAD83 +no_defs +ellps=GRS80 +towgs84=0,0,0"
~~~
{:.output}


~~~r
proj4string(huc)
~~~
{:.input}
~~~
[1] "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD27 +units=m +no_defs +ellps=clrk66 +nadgrids=@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat"
~~~
{:.output}

The counties data uses unprojected (longitude, latitude) coordinates, but `huc` is in an Albers equal-area projection (indicated as "+proj=aea").

===

Other parameters differ between the two projections, such as the "datum", which indicates the standard by which the irregular surface of the Earth is approximated by an ellipsoid. The rgdal function `spTransform()` converts spatial objects between coordinate reference systems, so long as you know the input and output Proj4 strings.

Here is another Albers equal-area projection:


~~~r
proj1 <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
~~~
{:.text-document title="{{ site.handouts }}"}

===

To plot two vector layers on one map, the projections must match. So we use `spTransform()` to assign each a common projection string (`proj1`), which re-calculates new coordinates for every polygon.


~~~r
counties_md <- spTransform(counties_md, proj1)
huc <- spTransform(huc, proj1)
plot(counties_md)
plot(huc, add = TRUE, border = "blue")
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk plot_over]({{ site.baseurl }}/images/plot_over-1.png)

===

## Geometric operations on vector layers

Like `sp`, the `rgeos` package provides functions to process geometric objects in one or more vector layers. In this case, by interfacing with the open source geometry engine [GEOS](http://trac.osgeo.org/geos/). The `rgeos` package brings capabilities like intersecting, buffering and dissolving polygons.

===

The map of MD counties and hydrological units has the data we need to draw a much simpler map: watershed boundaries within the state of MD.

- remove the county boundaries within the state
- crop the `huc` layer at the edge of the state boundary

===

The first step is a spatial **union** operation: we want the resulting object to combine the area covered by all the *Polygons* in `counties_md`. To perform a union of all sub-geometries in a single spatial object, we use the rgeos `gUnaryUnion()` function. This differs from the `gUnion()` function which returns the union of two spatial objects.


~~~r
library(rgeos)

state_md <- gUnaryUnion(counties_md)
plot(state_md)
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk gUnion]({{ site.baseurl }}/images/gUnion-1.png)

===

The second step is a spatial **intersection**, since we want to limit the polygons to areas covered by both `huc` and `state_md`. The `gIntersection()` function will intersect its first argument with its second, producing a new **SpatialPolygons** object (tabular data can't safely survive a spatial intersection, and is discarded).


~~~r
huc_md <- gIntersection(huc, state_md, byid = TRUE)
plot(huc_md, border = "blue")
~~~
{:.text-document title="{{ site.handouts }}"}

![plot of chunk gIntersect]({{ site.baseurl }}/images/gIntersect-1.png)

The `byid = TRUE` argument indicates that the intersection should be performed separately for each polygon within `huc`. The individual hydrological units are preserved but any part of them (or any whole polygon) lying outside the `state_md` polygon is cut from the output. The `id` argument could be used to specify meaningful labels for each resulting polygon, by pasting a unique number to the name of each hydrological unit from the original `huc` data.
{:.notes}

===

The `rgeos` package has many functions dealing with distances and areas, such as:

- `gBuffer`: to create a buffer of specific width around a geometry
- `gDistance`: to calculate the shortest distance between geometries
- `gArea`: to calculate the area of polygons

Keep in mind that all these functions use **planar** geometry equations and thus become less precise over larger distances, as the effect of the Earth's curvature become non-negligible. To calculate geodesic distances that account for that curvature, checkout the **geosphere** package.

===

## Exercise 2

Create a 5km buffer around the `state_md` borders and plot it as a dotted line (`plot(..., lty = "dotted")`) on the same map. **Hint**: check the layer's units with `proj4string()` and express any distance in those units.

[View solution](#solution-2)
{:.notes}
