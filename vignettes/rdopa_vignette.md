<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Tutorial for the JRC's eSpecies API}
-->



## Country-level information

### Basic information and statistics

DOPA provides an array of information on species and protected area (PA) 
occurrence within the borders (or in some cases the Exclusive Economic Zone 
boundary)  of a given country. `country_list()` can be used to list all the 
countries available in the DOPA database:


```r
library(rdopa)
# We'll also be using package dplyr for data manipulation
library(dplyr)

cl <- country_list()
head(cl)
```

```
##   cid iso2 iso3           name              minx              miny             maxx              maxy
## 1   4   AF  AFG    Afghanistan  60.4784431460001      29.377476867     74.878563529      38.483426111
## 2   8   AL  ALB        Albania  19.2767783890001      39.644562022 21.0572813000001  42.6607506710001
## 3  12   DZ  DZA        Algeria -8.67386722599994  18.9600276950001 11.9795484540001  37.0915184020001
## 4  16   AS  ASM American Samoa    -171.088394165      -14.38247776    -169.41607666 -11.0518255229999
## 5  20   AD  AND        Andorra  1.42387998100008      42.435089111 1.78038597100004      42.658706665
## 6  24   AO  AGO         Angola      11.680835724 -18.0417575839999 24.0821189880001 -4.37932348299994
```

### Species 

There are also few convience function to retrieve species information on 
conuntry-level. To list species included in a particular 
[IUCN status category](http://www.iucnredlist.org/technical-documents/categories-and-criteria)
within a given country, use function `country_species_list()`. For example, if 
you're interested in all (globally) threatened species (i.e. those in IUCN 
categories CR, EN, or VU) that occur in Finland, do the following:


```r
threatened.fin <- country_species_list('Finland', rlstatus=c("CR", "EN", "VU"))
# Select only part of the columns (using dplyr)
select(threatened.fin, iucn_species_id, taxon, class, status, assessed, commonname)
```

```
##   iucn_species_id               taxon          class status   assessed                 commonname
## 1          141446    Anser erythropus           Aves     VU 2008/01/01 Lesser White fronted Goose
## 2          144493       Aquila clanga           Aves     VU 2008/01/01      Greater Spotted Eagle
## 3            2191     Astacus astacus      Crustacea     VU 2010-06-08      Broad clawed Crayfish
## 4          149662    Emberiza aureola           Aves     VU 2008/01/01    Yellow breasted Bunting
## 5           11200         Lamna nasus Chondrichthyes     VU 2006-01-31            Beaumaris shark
## 6          141555 Polysticta stelleri           Aves     VU 2010-08-28            Steller s Eider
## 7           39326   Squalus acanthias Chondrichthyes     VU 2006-01-31                   Blue dog
## 8           39332   Squatina squatina Chondrichthyes     CR 2006-01-31                      Angel
```

Function `country_species_count()` returns the total number of species within
a given country that belong to a specific status categories. For example, to 
get the number of threatened species in Brazil:


```r
country_species_count('Brazil', rlstatus=c("CR", "EN", "VU"))
```

```
## [1] 285
```

This - and breakdown into individual categories - can of course be achieved by
working with the complete country-specific species list:


```r
threatened.bra <- country_species_list('Brazil', rlstatus=c("CR", "EN", "VU"))
# Total numbet
nrow(threatened.bra)
```

```
## [1] 285
```

```r
# Per category (using dplyr)
threatened.bra %>%
  group_by(status) %>%
  summarise(count = n()) 
```

```
## Source: local data frame [3 x 2]
## 
##   status count
## 1     CR    43
## 2     EN    86
## 3     VU   156
```
