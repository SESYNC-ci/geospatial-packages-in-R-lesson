---
excerpt: Vector Data
---

## R Packages

The key R packages for this lesson are

- [sf](){:.rlib}
- [stars](){:.rlib}

===

### OSGeo Dependencies

Most R packages depend on other R packages. The [sf](){:.rlib} and  [stars](){:.rlib}
packages also depend on system libraries.

- [GDAL](https://www.gdal.org) for read/write in geospatial data formats
- [GEOS](https://trac.osgeo.org/geos) for geometry operations
- [PROJ.4](http://proj4.org/) for cartographic projections

System libraries cannot be installed by R's `install.packages()`, but can be
bundled with these packages and for private use by them. Either way, the
necessary libraries are maintained by the good people at the [Open Source
Geospatial Foundation](https://github.com/OSGeo) for free and easy distribution. When
you load [sf](){:.rlib}, it will return an error if any dependencies are not found. 
{:.notes}

===

### Vector Data

The [US Census
website](http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_county_5m.zip)
distributes county polygons (and much more) that are provided with the handouts.
The [sf](){:.rlib} package reads shapefiles (".shp") and most other vector data:



~~~r
library(sf)

shp <- 'data/cb_2016_us_county_5m'
counties <- st_read(shp)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


The object `shp` is a character string with the location of a folder that contains
the collection of individual files that make up a shapefile. The second argument
ensures that text columns in the data frame are strings, not factors.
{:.notes}

===

The `counties` object is a `data.frame` that includes a `sfc`, which stands for
"simple feature column". This special column is usually called "geometry."



~~~r
> head(counties)
~~~
{:title="Console" .input}


~~~
Simple feature collection with 6 features and 9 fields
Geometry type: MULTIPOLYGON
Dimension:     XY
Bounding box:  xmin: -114.7556 ymin: 29.26116 xmax: -81.10192 ymax: 38.77443
CRS:           4269
  STATEFP COUNTYFP COUNTYNS       AFFGEOID GEOID      NAME LSAD       ALAND
1      04      015 00025445 0500000US04015 04015    Mohave   06 34475567011
2      12      035 00308547 0500000US12035 12035   Flagler   06  1257365642
3      20      129 00485135 0500000US20129 20129    Morton   06  1889993251
4      28      093 00695770 0500000US28093 28093  Marshall   06  1828989833
5      29      510 00767557 0500000US29510 29510 St. Louis   25   160458044
6      35      031 00929107 0500000US35031 35031  McKinley   06 14116799068
     AWATER                       geometry
1 387344307 MULTIPOLYGON (((-114.7556 3...
2 221047161 MULTIPOLYGON (((-81.52366 2...
3    507796 MULTIPOLYGON (((-102.042 37...
4   9195190 MULTIPOLYGON (((-89.72432 3...
5  10670040 MULTIPOLYGON (((-90.31821 3...
6  14078537 MULTIPOLYGON (((-109.0465 3...
~~~
{:.output}


In this case, we have a `MULTIPOLYGON` object which means that each row
has a column with information about the boundaries of a county polygon.
{:.notes}

===

### Geometry Types

Like any `data.frame` column, the `geometry` column is comprised of a single
data type. The "MULTIPOLYGON" is just one of several standard geometric data
types.

=== 

| Common Types | Description |
|--------------|-------------|
| POINT        | zero-dimensional geometry containing a single point |
| LINESTRING   | sequence of points connected by straight, non-self intersecting line pieces; one-dimensional geometry |
| POLYGON      | sequence of points in closed, non-intersecting rings; the first denotes the exterior ring, any subsequent rings denote holes |
| MULTI*       | set of * (POINT, LINESTRING, or POLYGON) |

The spatial data types are built upon each other in a logical way: lines are
built from points, polygons are built from lines, and so on.
{:.notes}

===

We can create any of these spatial objects from coordinates.
Here's an `sfc` object with a single "POINT", corresponding to SESYNC's position
in degrees latitude and degrees longitude, with the same coordinate
reference system as the `counties` object.



~~~r
sesync <- st_sfc(st_point(
    c(-76.503394, 38.976546)),
    crs = st_crs(counties))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

### Coordinate Reference Systems

A key feature of a **geo**spatial data type is its associated CRS, stored as an
EPSG ID and an equivalent PROJ.4 string. We can print the CRS of a spatial 
object with `st_crs()`.



~~~r
> st_crs(counties)
~~~
{:title="Console" .input}


~~~
Coordinate Reference System:
  User input: 4269 
  wkt:
GEOGCS["GCS_North_American_1983",
    DATUM["North_American_Datum_1983",
        SPHEROID["GRS_1980",6378137,298.257222101]],
    PRIMEM["Greenwich",0],
    UNIT["Degree",0.017453292519943295],
    AUTHORITY["EPSG","4269"]]
~~~
{:.output}


The EPSG ID is a numerical code indicating the coordinate reference system, and
the PROJ.4 string contains parameters of the projection.
{:.notes}

===

In order for two spatial objects to be comparable, they must be represented in the same coordinate reference system. 
This can be a geographic coordinate system or a projected coordinate system.
{:.notes}

**Geographic coordinate systems**, like the one we saw when we called `st_crs(counties)`, represent locations as degrees of latitude and longitude on the surface of the Earth, modeled as an ellipsoid (a slightly flattened sphere). The *datum* of a geographic coordinate system is the set of parameters representing the exact shape of the ellipsoid. The `counties` object uses the 1983 North American Datum, or NAD83 for short. Most world maps use the WGS84 datum.
{:.notes}

A **projected coordinate system** converts geographical coordinates into Cartesian or rectangular (X, Y) coordinates for making two-dimensional maps. Since it is impossible to provide an exact two-dimensional representation of a three-dimensional object like Earth without losing some information, specialized projections were developed for different regions of the world and different analytical applications. For example, the Mercator projection (left) preserves shapes and angles, which is useful for navigation, but it greatly inflates areas at the poles. The Lambert equal-area projection (right) preserves areas at the cost of shape distortion away from its center.
{:.notes}

![Projections]({% include asset.html path="images/proj.png" %})  
*Projections can preserve shapes or areas, but not both.* 

[Source](http://www.perrygeo.com/tissot-indicatrix-examining-the-distortion-of-map-projections.html)

===

### Bounding Box

A bounding box for all features in an `sf` data frame is generated by `st_bbox()`.



~~~r
> st_bbox(counties)
~~~
{:title="Console" .input}


~~~
      xmin       ymin       xmax       ymax 
-179.14734  -14.55255  179.77847   71.35256 
~~~
{:.output}


===

The bounding box is not a static attribute---it is determined on-the-fly for the
entire table or any subset of features. In this example, we subset the United States
counties by state ID 24 (Maryland). 

Because the `counties` object is a kind of `data.frame`, we can use [dplyr](){:.rlib}
verbs such as `filter` on it, just as we would with a non-spatial data frame. After
filtering, you can see that the bounding box is now much smaller.
{:.notes}



~~~r
library(dplyr)
counties_md <- filter(
  counties,
  STATEFP == '24')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> st_bbox(counties_md)
~~~
{:title="Console" .input}


~~~
     xmin      ymin      xmax      ymax 
-79.48765  37.91172 -75.04894  39.72312 
~~~
{:.output}


===

### Grid

A bounding box summarizes the limits, but is not itself a geometry (not a POINT
or POLYGON), even though it has a CRS attribute.



~~~r
> st_crs(st_bbox(counties_md))
~~~
{:title="Console" .input}


~~~
Coordinate Reference System:
  User input: 4269 
  wkt:
GEOGCS["GCS_North_American_1983",
    DATUM["North_American_Datum_1983",
        SPHEROID["GRS_1980",6378137,298.257222101]],
    PRIMEM["Greenwich",0],
    UNIT["Degree",0.017453292519943295],
    AUTHORITY["EPSG","4269"]]
~~~
{:.output}


===

We can use `st_make_grid()` to make a rectangular grid over a `sf` object.
The grid is a geometry---by default, a POLYGON.



~~~r
grid_md <- st_make_grid(counties_md,
                        n = 4)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Question
: What was the message issued by the last command all about?

Answer
: {:.fragment} It is a reminder that all geometric calculations are performed as
if the coordinates (in this case longitude and latitude) are Cartesian x,y
coordinates. This is OK because we are working at a small scale where the Earth's
curvature can be ignored.

===



~~~r
> grid_md
~~~
{:title="Console" .input}


~~~
Geometry set for 16 features 
Geometry type: POLYGON
Dimension:     XY
Bounding box:  xmin: -79.48765 ymin: 37.91172 xmax: -75.04894 ymax: 39.72312
CRS:           4269
First 5 geometries:
~~~
{:.output}


~~~
POLYGON ((-79.48765 37.91172, -78.37797 37.9117...
~~~
{:.output}


~~~
POLYGON ((-78.37797 37.91172, -77.26829 37.9117...
~~~
{:.output}


~~~
POLYGON ((-77.26829 37.91172, -76.15862 37.9117...
~~~
{:.output}


~~~
POLYGON ((-76.15862 37.91172, -75.04894 37.9117...
~~~
{:.output}


~~~
POLYGON ((-79.48765 38.36457, -78.37797 38.3645...
~~~
{:.output}


===

### Plot Layers

Spatial objects defined by [sf](){:.rlib} are compatible with the `plot`
function. Setting the `plot` parameter `add = TRUE` allows an existing plot to
serve as a layer underneath the new one. The two layers should have the same
coordinate reference system.

The following code plots the grid first, then the `ALAND` (land area) column of `counties_md`. 
This plots the county boundaries with the fill color of the polygons corresponding to the
area of the polygon.
The default color scheme means that larger counties appear yellow. Finally, we 
overlay the point location of SESYNC.
{:.notes}



~~~r
plot(grid_md)
plot(counties_md['ALAND'],
     add = TRUE)
plot(sesync, col = "green",
     pch = 20, add = TRUE)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/vector/unnamed-chunk-11-1.png" %})
{:.captioned}

But note that the `plot` function won't prevent you from layering up geometries
with different coordinate systems: you must safeguard your own plots from this
mistake. The arguments `col` and `pch`, by the way, are graphical parameters
used in base R, see `?par`.
{:.notes}

===

### Customizing maps with ggplot2

The `plot` function is great for quick visualizations but the [ggplot2](){:.rlib} 
package gives you much more flexibility to customize your plots.

For those not familiar with [ggplot2](){:.rlib}, a comprehensive introduction can be found in 
the [Data Visualisation][r4ds] chapter of *R for Data Science* by Wickham and Grolemund,
or check out SESYNC's [introductory ggplot2 lesson][introggplot2]. 
{:.notes}

===

Producing any type of graph with [ggplot2](){:.rlib} requires a similar sequence of steps:

* Begin by calling `ggplot()` and add any further plot elements by "adding" them with `+`;
* Specify the dataset as well as aesthetic mappings (`aes`), which associate variables in the data to graphical elements (`x` and `y` axes, color, size and shape of points, etc.);
* Add `geom_` layers, which specify the type of graph;
* Optionally, specify additional customization options such as axis names and limits, color themes, and more.

===

Let's plot the Maryland county map with `ggplot()`. 

All `sf` objects can be plotted by adding `geom_sf()` layers to the plot,
which automatically associates the `geometry` column with the `x` and `y` coordinates of the features
in the correct projection. If there are multiple `geom_sf()` layers, `ggplot()` will
transform all layers to the projection system of the first layer added to the plot.
{:.notes}




~~~r
library(ggplot2)

ggplot() +
  geom_sf(data = counties_md, 
          aes(fill = ALAND)) +
  geom_sf(data = sesync, 
          size = 3, color = 'red') 
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/vector/unnamed-chunk-12-1.png" %})
{:.captioned}

===

You can customize the plot theme and color scales, among other things.



~~~r
theme_set(theme_bw())

ggplot() +
  geom_sf(data = counties_md, 
          aes(fill = ALAND/1e6), color = NA) +
  geom_sf(data = sesync, 
          size = 3, color = 'red') +
  scale_fill_viridis_c(name = 'Land area (sq. km)') +
  theme(legend.position = c(0.3, 0.3))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/vector/unnamed-chunk-13-1.png" %})
{:.captioned}

Here, we first set the plot theme for all other `ggplot()` plots we create in this 
session to a black-and-white theme to get rid of the gray background.
Next, we divide the land area value by `1e6` to convert it to square km, then
specify `color = NA` for the county polygons so there is no border drawn around them.
We add a colorblind-friendly `viridis` fill scale for the polygons and add an
understandable legend title with the `name` argument to the fill scale. Finally
we move the legend to coordinates `c(0.3, 0.3)` in the panel (the legend position
can range from 0 to 1 on both axes). In all cases we add additional customization 
elements to the base plot using `+`.
{:.notes}

===

### Spatial Subsetting

An object created with `st_read()` is a `data.frame`, which is why the `dplyr`
function `filter` used above on the **non**-geospatial column named `STATEFP`
worked normally. The function `st_filter()` does the equivalent of a filtering 
operation on the `geometry` column, known as a spatial "overlay."



~~~r
> st_filter(counties_md, sesync)
~~~
{:title="Console" .input}


~~~
Simple feature collection with 1 feature and 9 fields
Geometry type: MULTIPOLYGON
Dimension:     XY
Bounding box:  xmin: -76.84036 ymin: 38.71356 xmax: -76.39408 ymax: 39.2374
CRS:           4269
  STATEFP COUNTYFP COUNTYNS       AFFGEOID GEOID         NAME LSAD      ALAND
1      24      003 01710958 0500000US24003 24003 Anne Arundel   06 1074553083
     AWATER                       geometry
1 447833714 MULTIPOLYGON (((-76.84036 3...
~~~
{:.output}


`st_filter` subsets the features of a `sf` object based on spatial (rather than numeric or
string) matching. Matching is implemented with functions like `st_within(x, y)`. Here we
filtered the `counties_md` object to retain only the features that intersect with the 
single point contained in the `sesync` object. Because `sesync` is a single point, this 
results in a `sfc` with a single row.
{:.notes}

===

The overlay functions in the [sf](){:.rlib} package follow the pattern
`st_predicate(x, y)` and perform the test "x [is] predicate y". Some key
examples are:

| st_intersects | boundary or interior of x intersects boundary or interior of y |
| st_within     | interior and boundary of x do not intersect exterior of y      |
| st_contains   | y is within x                                                  |
| st_overlaps   | interior of x intersects interior of y                         |
| st_equals     | x has the same interior and boundary as y                      |

===

### Coordinate Transforms

For the next part of this lesson, we import a new polygon layer corresponding to
the 1:250k [map of US hydrological units (HUC)](http://water.usgs.gov/GIS/dsdl/huc250k_shp.zip)
downloaded from the United States Geological Survey.



~~~r
shp <- 'data/huc250k'
huc <- st_read(shp)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Compare the coordinate reference systems of `counties` and `huc`, as given by
their PROJ.4 strings.



~~~r
> st_crs(counties_md)$proj4string
~~~
{:title="Console" .input}


~~~
[1] "+proj=longlat +datum=NAD83 +no_defs "
~~~
{:.output}




~~~r
> st_crs(huc)$proj4string
~~~
{:title="Console" .input}


~~~
[1] "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +datum=NAD27 +units=m +no_defs "
~~~
{:.output}


The Census data uses unprojected (longitude, latitude) coordinates, but `huc` is
in an Albers equal-area projection (indicated as `"+proj=aea"`). The set of parameters
for the `huc` object are commonly used to create maps of the continental United States.
{:.notes}

===

The function `st_transform()` converts an `sfc` between coordinate reference
systems, specified with the parameter `crs = x`. A numeric `x` must be a valid
EPSG code; a character `x` is interpreted as a PROJ.4 string.

For example, the unprojected CRS of `counties` can be represented as the 
PROJ.4 string `"+proj=longlat +datum=NAD83 +no_defs"`. This character string
is a list of parameters that correspond to the [EPSG code 4269](https://epsg.io/4269).
You can transform objects to that projection using the PROJ.4 string as the argument
to `crs`, or by typing `crs = 4269`. Not all projections have an EPSG code.
The projection in the PROJ.4 string below does not have an 
EPSG code, for example. We'll transform all the `sfc` objects to this 
projection because it is the one used by the NLCD raster layer we'll 
introduce later in this lesson.
{:.notes}



~~~r
prj <- '+proj=aea +lat_1=29.5 +lat_2=45.5 \
        +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 \
        +datum=WGS84 +units=m +no_defs'
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


PROJ.4 strings contain a reference to the type of projection---this one is another
Albers equal-area---along with numeric parameters associated with that
projection. An additional important parameter that may differ between two
coordinate systems is the "datum", which indicates the standard by which the
irregular surface of the Earth is approximated by an ellipsoid in the
coordinates themselves.
{:.notes}

===

Use `st_transform()` to assign the two layers and SESYNC's location
to a common projection string (`prj`). 
This takes a few moments, as it recalculates coordinates for
every vertex in the `sfc`.



~~~r
counties_md <- st_transform(
  counties_md,
  crs = prj)
huc <- st_transform(
  huc,
  crs = prj)
sesync <- st_transform(
  sesync,
  crs = prj)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Now that the three objects share a projection, we can plot the county boundaries, 
watershed boundaries, and SESYNC's location on a single map.



~~~r
plot(st_geometry(counties_md))
plot(st_geometry(huc),
     border = 'blue', add = TRUE)
plot(sesync, col = 'green',
     pch = 20, add = TRUE)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/vector/unnamed-chunk-20-1.png" %})
{:.captioned}

We use the `st_geometry()` function on the two polygon layers we plot, which 
only plots the polygon boundaries (the `geometry` column) rather than filling
the areas with colors.
{:.notes}

===

### Geometric Operations

The data for a map of watershed boundaries within the state of MD is all here:
in the country-wide `huc` and in the state boundary "surrounding" all of
`counties_md`. To get just the HUCs inside Maryland's borders:

- remove the internal county boundaries within the state
- clip the hydrological areas to their intersection with the state

===

The first step is a spatial **union** operation: we want the resulting object to
combine the area covered by all the multipolygons in `counties_md`.



~~~r
state_md <- st_union(counties_md)
plot(state_md)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/vector/unnamed-chunk-21-1.png" %})
{:.captioned}

To perform a union of all sub-geometries in a single `sfc`, we use the
`st_union()` function with a single argument. The output, `state_md`, is a new
`sfc` that is no longer a column of a data frame. Tabular data can't safely
survive a spatial union because the polygons corresponding to the attributes
in the table have been combined into a single larger polygon. So the data frame
columns are discarded.
{:.notes}

===

The second step is a spatial **intersection**, since we want to limit the
polygons to areas covered by both `huc` and `state_md`.



~~~r
huc_md <- st_intersection(
  huc,
  state_md)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Warning: attribute variables are assumed to be spatially constant throughout all
geometries
~~~
{:.output}


===



~~~r
plot(state_md)
plot(huc_md, border = 'blue',
     col = NA, add = TRUE)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}
![ ]({% include asset.html path="images/vector/unnamed-chunk-23-1.png" %})
{:.captioned}

The `st_intersection()` function intersects its first argument with the second.
The individual hydrological units are preserved but any part of them (or any
whole polygon) lying outside the `state_md` polygon is cut from the output. The
attribute data remains in the corresponding records of the `data.frame`, but (as
warned) has not been updated. For example, the "AREA" attribute of any clipped
HUC does not reflect the area of the new, smaller polygon.
{:.notes}

===

The GEOS library provides many functions dealing with distances and areas. Many
of these are accessible through the [sf](){:.rlib} package, including:

- `st_buffer`: to create a buffer of specific width around a geometry
- `st_distance`: to calculate the shortest distance between geometries
- `st_area`: to calculate the area of polygons

Keep in mind that all these functions use **planar** geometry equations and thus
become less precise over larger distances, where the Earth's curvature is
noticeable. To calculate geodesic distances that account for that curvature,
check out the [geosphere](){:.rlib} package.
{:.notes}

[r4ds]: https://r4ds.had.co.nz/data-visualisation.html
[introggplot2]: https://cyberhelp.sesync.org/graphics-with-ggplot2-lesson/
