## rdopa 0.1.0

#### New features

+ `country_list()` implemented, see [here](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_list)
+ `country_species_list()` implemented, see [here](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_list) 
+ Caching mechanism based on package `R.cache`
  - Use `R.cache::clearCache()` to clear the whole cache
+ `country_species_count()` implemented, see [here](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_count) 
for documentation of the method.
+ `resolve_country()` can be used to resolve country names into ISO 3166-1 
country codes.
+ `check_iucn_status()` is a utility function for checking whether inputs are valid IUCN status codes.
