#### Preamble ####
# Purpose: simulating the data
# Author: Jueun Kang
# Email: jueun.kang@mail.utoronto.ca
# Date: 29 January 2023

#### simulation ####

set.seed(3434343)
#simulate data number of accidents from alcohol consumption between 2006-2021

simulate_alc_accidents <-
  tibble(
    year = 
      rep(c(2006:2021),1),
    number_of_accidents = 
      runif(
        n=16, min = 0, max = 100
        )
    )

#simulate data fatal and non-fatal accidents from 2006-2021

simulate_fatal_nonfatal <- 
  tibble(
    year =
      rep(c(2006:2021),1),
    nonfatal = 
      runif(
        n=16, min = 0, max = 1500
        ),
    fatal =
      runif(
        n=16, min = 0, max = 1500
        )
  )

#simulate data total accidents from 2006-2021
simulate_accident_total <- simulate_fatal_nonfatal |> group_by(year) |> summarize(sum=sum(nonfatal+fatal))

#### tests ####

#test that “year” is no smaller than 2006 and no larger than 2021
simulate_alc_accidents$year |> min() == 2006
simulate_alc_accidents$year |> max() == 2021

#test that sum of fatal and non-fatal is total 
simulate_fatal_nonfatal |> group_by(year) |> summarize(sum=sum(nonfatal+fatal)) |>
  rename(
    Year = year,
    Total = sum
  )

#test that “year” is no smaller than 2006 and no larger than 2021
simulate_fatal_nonfatal$year |> min() == 2006
simulate_fatal_nonfatal$year |> max() == 2021

#test that "fatal" and "nonfatal" is an integer, and not a letter
simulate_fatal_nonfatal$fatal |> class() == "numeric"
simulate_fatal_nonfatal$nonfatal |> class() == "numeric"
