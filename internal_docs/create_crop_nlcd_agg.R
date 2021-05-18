# NOTE 02 APR 2021: we are now using the dev version of terra, installed with
# remotes::install_github("rspatial/terra")

library(terra)
nlcd <- rast('/nfs/public-data/NLCD/NLCD_2016_Land_Cover_L48_20190424/NLCD_2016_Land_Cover_L48_20190424.img')
# File consists of the .img file, a spillover .ige file, and .rrd and .rde files.

# View head of color table and attributes.
head(coltab(nlcd)[[1]], 12)
head(levels(nlcd)[[1]], 12)

# Crop to a specified extent and aggregate to a coarser resolution.
maryland_ext <- ext(c(xmin = 1394535, xmax = 1845135, ymin = 1724415, ymax = 2101515))
nlcd_maryland <- crop(nlcd, maryland_ext) 
nlcd_maryland_agg <- aggregate(nlcd_maryland, fact = 5, fun = 'modal')

# As of April 5, this now works without having to replace the color table and attributes.
head(coltab(nlcd_maryland_agg)[[1]], 12)
head(levels(nlcd_maryland_agg)[[1]], 12)

# Do not edit the projection at this point as it will cause issues later.
# Transform all sf objects into the raster's projection.

nlcd_maryland_agg_tif <- writeRaster(nlcd_maryland_agg, '/nfs/qread-data/temp/nlcd_agg.tif', overwrite = TRUE)
plot(nlcd_maryland_agg_tif) # Works!

# Now there is a .tif and a .tif.aux.xml file in the temp directory (need to manually move file to training directory due to permissions)

# Print CRS to use in lesson
crs(nlcd_maryland_agg_tif, proj4 = TRUE)
