#### Preamble ####
# Purpose: getting the package
# Author: Jueun Kang
# Email: jueun.kang@mail.utoronto.ca
# Date: 29 January 2023

library(opendatatoronto)
library(dplyr)

# get package
package <- show_package("0b6d3a00-7de1-440b-b47c-7252fd13929f")
package

# get all resources for this package
resources <- list_package_resources("0b6d3a00-7de1-440b-b47c-7252fd13929f")

# identify datastore resources; by default, Toronto Open Data sets datastore resource format to CSV for non-geospatial and GeoJSON for geospatial resources
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))

# load the first datastore resource as a sample
raw_data <- filter(datastore_resources, row_number()==1) %>% get_resource()
data

# Saving the data in our inputs folder
write_csv(
  x = raw_data,
  file = "~/Documents/Project/Project_Folder/Inputs/data/raw_data.csv"
)