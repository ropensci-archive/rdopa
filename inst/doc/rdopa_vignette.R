## ----setup, echo=FALSE----------------------------------------------------------------------------------------------------------------------------------------
options(width=160)

## ----country-list, message=FALSE------------------------------------------------------------------------------------------------------------------------------
library(rdopa)
# We'll also be using package dplyr for data manipulation
library(dplyr)

cl <- country_list()
head(cl)

## ----species-list-1, message=FALSE----------------------------------------------------------------------------------------------------------------------------
threatened.fin <- country_species_list('Finland', status=c("CR", "EN", "VU"))
# Select only part of the columns (using dplyr)
select(threatened.fin, iucn_species_id, taxon, class, status, commonname)

## ----species-count-1, message=FALSE---------------------------------------------------------------------------------------------------------------------------
country_species_count('Brazil', rlstatus=c("CR", "EN", "VU"))

## ----species-list-2, message=FALSE----------------------------------------------------------------------------------------------------------------------------
threatened.bra <- country_species_list('Brazil', status=c("CR", "EN", "VU"))
# Total number
nrow(threatened.bra)
# Per category (using dplyr)
threatened.bra %>%
  group_by(status) %>%
  summarise(count = n()) 

## ----country-stats, message=FALSE-----------------------------------------------------------------------------------------------------------------------------
country_stats("Sweden")

## ----country-pa_stats, message=FALSE--------------------------------------------------------------------------------------------------------------------------
uganda_pa_stats <- pa_country_stats("Uganda")
nrow(uganda_pa_stats)

