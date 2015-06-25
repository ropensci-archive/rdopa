---
output:
  html_document:
    theme: flatly
---
<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Tutorial for the JRC's eSpecies API}
-->




### Basic information and statistics

DOPA provides an array of information on species and protected area (PA) 
occurrence within the borders (or in some cases the Exclusive Economic Zone 
boundary)  of a given country. `country_list()` can be used to list all the 
countries available in the DOPA database:


```r
library(rdopa)
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
threatened.fin <- country_species_list('Finland', status=c("CR", "EN", "VU"))
# Select only part of the columns (using dplyr)
select(threatened.fin, iucn_species_id, taxon, class, status, commonname)
```

```
##    iucn_species_id                taxon          class status                 commonname
## 1           161817  Alisma wahlenbergii     Liliopsida     VU                       <NA>
## 2            60344    Anguilla anguilla Actinopterygii     CR                       <NA>
## 3         22679886     Anser erythropus           Aves     VU Lesser White fronted Goose
## 4             2191      Astacus astacus   Malacostraca     VU      Broad clawed Crayfish
## 5         13152906       Bombus alpinus        Insecta     VU                       <NA>
## 6         22696027        Clanga clanga           Aves     VU                       <NA>
## 7         22680427    Clangula hyemalis           Aves     VU           Long tailed Duck
## 8           135672    Coregonus maraena Actinopterygii     VU         European whitefish
## 9             5383    Coregonus trybomi Actinopterygii     CR      Spring spawning cisco
## 10        22720966     Emberiza aureola           Aves     EN    Yellow breasted Bunting
## 11           11200          Lamna nasus Chondrichthyes     VU            Beaumaris shark
## 12        22724836      Melanitta fusca           Aves     EN              Velvet Scoter
## 13          161870 Papaver laestadianum  Magnoliopsida     VU                       <NA>
## 14        22680415  Polysticta stelleri           Aves     VU            Steller s Eider
## 15           39326    Squalus acanthias Chondrichthyes     VU                   Blue dog
## 16           39332    Squatina squatina Chondrichthyes     CR                      Angel
## 17           21860      Thunnus thynnus Actinopterygii     EN      Atlantic Bluefin Tuna
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
threatened.bra <- country_species_list('Brazil', status=c("CR", "EN", "VU"))
# Total number
nrow(threatened.bra)
```

```
## [1] 380
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
## 1     CR    60
## 2     EN   105
## 3     VU   215
```

### Protected areas

Protected area (PA) statistics are available per country according to 
[IUCN PA categories](http://www.iucn.org/about/work/programmes/gpap_home/gpap_quality/gpap_pacategories/):


```r
country_stats("Sweden")
```

```
##    category area_protected area_protected_perc area_total countryiso   name       iucn_cat
## 1         0          78753               13.02      78753        752 Sweden              0
## 2         1           5644                7.17       5644        752 Sweden             Ia
## 3         2          30974               39.33      30974        752 Sweden             Ib
## 4         3           7386                9.38       7386        752 Sweden             II
## 5         4             NA                  NA      78753        752 Sweden            III
## 6         5           1425                1.81       1425        752 Sweden             IV
## 7         6           6791                8.62       6791        752 Sweden              V
## 8         7             NA                  NA      78753        752 Sweden             VI
## 9         8          24379               30.96      24379        752 Sweden   Not Reported
## 10        9           1816                2.31       1816        752 Sweden   Not Assigned
## 11        9             NA                  NA      78753        752 Sweden Not Applicable
```

Within a given country, statistics for individual PAs can be retrieved using
`pa_country_stats()`. Let's find out all the PAs within Uganda:


```r
uganda_pa_stats <- pa_country_stats("Uganda")
nrow(uganda_pa_stats)
```

```
## [1] 58
```

So Uganda has 28 individual PAs in the WDPA. 
