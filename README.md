[![Build Status](https://travis-ci.org/jlehtoma/rdopa.svg?branch=master)](https://travis-ci.org/jlehtoma/respecies)

## rdopa

rdopa is a R package for accessing data from the DOPA ([Digital Observatory for Protected Areas](http://dopa.jrc.ec.europa.eu/)) REST API.

**Warning** The DOPA API is still very much in development as is this package. Expect things to break.

[DOPA REST Services Directory](http://dopa-services.jrc.ec.europa.eu/rest/) lists all the available services grouped by thematic tags. Currently, the following services are wrapped by `rdopa`:

| DOPA Service                       | DOPA tag                           | Function                           |
|------------------------------------|------------------------------------|------------------------------------|
| [get_country_species_count](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_count) | eAdmin | `country_species_count()` |
| [get_country_species_list](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_list)| eAdmin | `country_species_list()` |
| [get_country_list](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_list)| eAdmin | `country_list()` |
| [get_country_stats](http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_stats)| eAdmin | `country_stats()` |
 
## Quick start

### Installation

Install `rdopa` from GitHub using `devtools`.

```r
install.packages(devtools)
install_github("jlehtoma/rdopa")
```

### Usage

Check out examples in the package [vignette](https://github.com/jlehtoma/rdopa/blob/master/vignettes/rdopa_vignette.md).

## Contributors

+ [Joona Lehtomäki](https://github.com/jlehtoma) <joona.lehtomaki@gmail.com>
