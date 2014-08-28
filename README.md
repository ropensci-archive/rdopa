[![Build Status](https://travis-ci.org/jlehtoma/rdopa.svg?branch=master)](https://travis-ci.org/jlehtoma/respecies)

## rdopa

rdopa is a R package for accessing data from the DOPA ([Digital Observatory for Protected Areas](http://dopa.jrc.ec.europa.eu/)) REST API.

**Warning** The DOPA API is still very much in development as is this package. Expect things to break.

[DOPA REST Services Directory](http://dopa-services.jrc.ec.europa.eu/rest/) lists all the available services grouped by thematic tags. Currently (in version 0.1.0), the following services are wrapped by `rdopa`:

| DOPA Service                       | DOPA tag                           | Function                           |
|------------------------------------|------------------------------------|------------------------------------|
| [`get_country_species_count`](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_count) | eAdmin | `country_species_count()` |
| [`get_country_species_list`](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_list)| eAdmin | `country_species_list()` |
| [`get_country_list`](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_list)| eAdmin | `country_list()` |
 
## Quick start

### Installation

Install `rdopa` from GitHub using `devtools`.

```r
install.packages(devtools)
install_github("jlehtoma/rdopa")
```

## Contributors

+ [Joona Lehtomäki](https://github.com/jlehtoma) <joona.lehtomaki@gmail.com>
