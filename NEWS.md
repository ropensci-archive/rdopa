## rdopa 0.1.5

+ Map plotting example using WKT removed from the vignette since DOPA doesn't
provide that data anymore.
+ Switch using the ibex database in the following functions: 
`country_species_list()`.
+ Change `country_species_list()` parameter `rlstatus` to `status`.

#### New features

#### Bug fixes

## rdopa 0.1.4

#### Bug fixes

+ Fix changed REST URLs.

## rdopa 0.1.3

+ Change license to MIT

#### New features

+ `country_list()` has new column, `gec`.
+ `pa_country_stats()` implemented.
+ New utility function `wktdf2sp()` that can be used to convert DOPA
responses with WKT column into sp-objects.

#### Bug fixes

+ Tests updated

## rdopa 0.1.2

#### New features

+ `country_stats()` implemented, see [here](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_stats)

#### Bug fixes

+ `resolve_country()` accepts an argument `full.name=TRUE` to return the full
name of the country.
+ `country_species_list()` now returns country information (name and ISO code)
in the dataframe.

## rdopa 0.1.1

+ Package README now includes a up-to-date table of those DOPA services that 
have a corresponding client function in `rdopa`.
+ Add package vignette.

#### New features

+ `country_list()` implemented, see [here](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_list)
+ `country_species_list()` implemented, see [here](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_list) 
+ Caching mechanism based on package `R.cache`
  - Use `R.cache::clearCache()` to clear the whole cache

## rdopa 0.1.0

#### New features

+ `country_species_count()` implemented, see [here](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_count) 
for documentation of the method.
+ `resolve_country()` can be used to resolve country names into ISO 3166-1 
country codes.
+ `check_iucn_status()` is a utility function for checking whether inputs are valid IUCN status codes.
