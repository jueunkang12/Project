#### Preamble ####
# Purpose: cleaning the data
# Author: Jueun Kang
# Email: jueun.kang@mail.utoronto.ca
# Date: 29 January 2023

#### cleaning the data to show accidents related to alcohol consumption ####

# cleaning the data to show accidents from alcohol consumption between 2006-2021
library(janitor)
clean_alcohol_data <-
  clean_names(raw_data) |>
  select(
    year, 
    alcohol
  ) |>
  filter(alcohol == "Yes") |>
  group_by(year) |>
  count(alcohol)

# dropping the geometry 
library (sf)
clean_alcohol_data <- st_drop_geometry(clean_alcohol_data) |> select(year, n)

# renaming variables
clean_alcohol_data <-
  clean_alcohol_data |>
  rename(
    Year = year,
    Number_of_accidents = n
  )

# creating the table and adding column names
knitr::kable(
  clean_alcohol_data,
  col.names = c("Year", "Collisions with Alcohol")
)

# Saving the data in our inputs folder
write_csv(
  x = clean_alcohol_data,
  file = "~/Documents/Project/Project_Folder/Inputs/data/clean_alcohol_data.csv"
)

#### cleaning the data to show number of accidents by classification, with and without alcohol ####

#cleaning the data to select year, accidents related to alcohol consumption, and accident class
accident_alcohol <-
  clean_names(raw_data) |>
  select(
    year, 
    alcohol,
    acclass
  ) |>
  filter(alcohol=="Yes")|>
  group_by(year)|>
  count(acclass == "Fatal")

#renaming the variables 
accident_alcohol <-
  accident_alcohol |>
  rename(
    Year = year,
    Injury = `acclass == "Fatal"`,
    Nonfatal = n
  )

#using the shift function 
shift<- function(x,n){
  c(x[-seq(n)], rep(NA,n))
}

#adding new columns for fatal and nonfatal 
accident_alcohol$x <- 
  ifelse(accident_alcohol$Injury == TRUE, "Fatal", "Nonfatal")
accident_alcohol$y <- 
  ("Fatal")
accident_alcohol$Fatal <- 
  shift(accident_alcohol$Nonfatal,1)

#removing the repeat of rows
accident_alcohol <- 
  subset(accident_alcohol, x != y)

#selecting for accident classification 
accident_alcohol <- 
  accident_alcohol |> 
  select(Year, Nonfatal, Fatal)

#total number of accidents 
accident_alcohol$Total = accident_alcohol$Fatal +
  accident_alcohol$Nonfatal

sum(accident_alcohol$Fatal)
sum(accident_alcohol$Nonfatal)

#add everything to one table 
accident_noalcohol$AlcNonfatal = accident_alcohol$Nonfatal
accident_noalcohol$AlcFatal = accident_alcohol$Fatal
accident_noalcohol$AlcTotal = accident_alcohol$Total

#renaming the data
accident_alc_comparison <- accident_noalcohol

#re-ordering the columns
accident_alc_comparison <- accident_alc_comparison |>
  select(Year, Nonfatal, Fatal, Total, AlcNonfatal, AlcFatal, AlcTotal)

#creating the table
knitr::kable(accident_alc_comparison)

# Saving the data in our inputs folder
write_csv(
  x = accident_alc_comparison,
  file = "~/Documents/Project/Project_Folder/Inputs/data/accident_alc_comparison.csv"
)