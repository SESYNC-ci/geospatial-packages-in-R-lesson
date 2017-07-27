# Data Directory

The data used for SESYNC training events is freely available online. The note following each group of files below describes the data and where to access it online. Not all files listed are likely to be present in this folder, depending on the training event.


## Portal Teaching Database

`plots.csv`, `animals.csv`, `species.csv`, `portal.xlsx`, `portal.sqlite`

The Portal Project Teaching Database is a simplified version of the Portal Project Database designed for teaching. It provides a real world example of life-history, population, and ecological data, with sufficient complexity to teach many aspects of data analysis and management, but with many complexities removed to allow students to focus on the core ideas and skills being taught.

The database is currently available in csv, xlsx, and sqlite files, and possibly within a PostgreSQL database called 'portal' presented in the lesson.

Use of this dataset should cite: http://dx.doi.org/10.6084/m9.figshare.1314459

This database is not designed for research as it intentionally removes some of the real-world complexities. The [original database is published at Ecological Archives](http://esapubs.org/archive/ecol/E090/118/) and that version should be used for research purposes.


## National Land Cover Database

`nlcd_agg.*`, `nlcd_proj.*`

A portion of the [National Land Cover Database](http://www.mrlc.gov/nlcd2011.php) 
that has been cropped and reduced to a lower resolution in order to speed up processing
time for this tutorial. The *nlcd_agg* raster is in the original Albers equal-area
projection, whereas the *nlcd_proj* raster has been reprojected to Web Mercator
for use with the `leaflet` package.


## County Shapefile

`cb_500k_maryland/*`

Maryland county boundaries extracted from the US Census [county boundaries
shapefile](http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_county_500k.zip).


## Hydrologic Unit Shapefile

`huc250k/*`

1:250,000-scale Hydrologic Units of the United States published by the U.S. Geological Survey as a [shapefile with associated metadata](https://water.usgs.gov/GIS/metadata/usgswrd/XML/huc250k.xml).
