#' Get basic countries data
#' 
#' Returns all countries listed in DOPA.
#' 
#' @param cache Sets the cachce mode: \code{TRUE} = Use cache if available and 
#' save to cache, \code{FALSE} = Ignore cache if available and do not save to 
#' cache, \code{"flush"} = Ignore cache if available and save to cache.
#' 
#' @return data.frame of countries with the following columns:
#' 
#' \tabular{ll}{
#'  \code{iso2} \tab The 2 character ISO code. \cr
#'  \code{iso3} \tab The 3 character ISO code. \cr
#'  \code{name} \tab The name of the country (english). \cr
#'  \code{gec} \tab The GEC code (deprecated) used by the CIA World Factbook. \cr
#'  \code{minx} \tab Minimum X of extent of the country. \cr
#'  \code{miny} \tab Minimum Y of extent of the country. \cr
#'  \code{maxx} \tab Maximum X of extent of the country. \cr
#'  \code{maxy} \tab Maximum Y of extent of the country. \cr
#' }
#' 
#' @import httr
#' @import R.cache
#' 
#' @export
#' 
#' @seealso \url{http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_list}
#' 
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 
#' @examples \dontrun{
#' 
#' # Get all countries
#' country_list()
#'  
#' }
country_list <- function(cache=TRUE) {
  
  key <- list("country_list")
  r_content <- NULL
  
  if (cache == TRUE) {
    r_content <- R.cache::loadCache(key, suffix=.options$cache)
  }
  if (!is.null(r_content)) {
    message("Loaded cached data")
  } else {
    
    # Construct the REST parameters, note that we must use an optional 
    # did=1 parameter
    r <- GET("http://dopa-services.jrc.ec.europa.eu",
             path = "rest/eAdmin/get_country_list",
             query = list(
               did = 1
             ))
    
    # Check the request succeeded
    stop_for_status(r)
    
    r_content <- content(r)
    
    if (cache == TRUE || cache == 'flush') {
      R.cache::saveCache(r_content, key=key, suffix=.options$cache)
    }
  }
  
  country_list <- parse_dopa_response(r_content$records)
  # Extent coordinates into separate columns
  extent <- strsplit(country_list$extent, ",")
  extent <- do.call(rbind, extent)
  colnames(extent) <- c("minx", "miny", "maxx", "maxy")
  # Leave out the original extent column
  country_list <- cbind(country_list[, 1:ncol(country_list) - 1], extent)
  
  return(country_list)
  
}

#' Get species count for a country
#' 
#' Returns a count of the species whose range intersects with the country. This 
#' intersection on the species range includes the Exclusive Economic Zone 
#' boundary for the country which extends out to 200 nautical miles from the 
#' coastline. The EEZ boundary was derived from the Flanders Marine Institute 
#' (see \url{http://www.vliz.be/vmdcdata/marbound/} for more information).
#' 
#' For more information see \url{http://www.iucnredlist.org/technical-documents/categories-and-criteria}.
#' 
#' @param country Character country name or numeric country code.
#' @param rlstatus A character vector of the IUCN Conservation Status for the 
#'   species. Default is \code{NULL} in which case species of all statuses are 
#'   requested.
#' @param cache Sets the cache mode: \code{TRUE} = Use cache if available and 
#' save to cache, \code{FALSE} = Ignore cache if available and do not save to 
#' cache, \code{"flush"} = Ignore cache if available and save to cache.
#' 
#' @return Numeric count of the species whose range intersects with the country.
#' 
#' @import httr
#' @import R.cache
#' 
#' @export
#' 
#' @seealso \url{http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_count}
#' @seealso \code{\link{resolve_country}} \code{\link{check_iucn_status}} 
#' 
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 
#' @examples \dontrun{
#' 
#' # Using country name
#' country_species_count(country="Finland")
#'   
#' # Using country code (156 is China)
#' country_species_count(country=156)
#' 
#' # Get only critically endangered and endangered species
#' country_species_count(country=156, rlstatus=c("CR", "EN"))
#'  
#' }
country_species_count <- function(country, rlstatus=NULL, cache=TRUE) {
  
  code <- resolve_country(country)
  
  key <- list("country_species_count", code, rlstatus)
  r_content <- NULL
  
  if (cache == TRUE) {
    r_content <- R.cache::loadCache(key, suffix=.options$cache)
  }
  if (!is.null(r_content)) {
    message("Loaded cached data")
  } else {
  
    # Construct the REST parameters
    if (is.null(rlstatus)) {
      r <- GET("http://dopa-services.jrc.ec.europa.eu",
               path = "rest/eAdmin/get_country_species_count",
               query = list(
                country_id = code
               ))
    } else {
      rlstatus <- check_iucn_status(rlstatus)
      r <- GET("http://dopa-services.jrc.ec.europa.eu",
               path = "rest/eAdmin/get_country_species_count",
               query = list(
                 country_id = code,
                 rlstatus = paste(rlstatus, collapse=",")
               ))
    }
    # Check the request succeeded
    stop_for_status(r)
    
    r_content <- content(r)
    
    if (cache == TRUE || cache == 'flush') {
      R.cache::saveCache(r_content, key=key, suffix=.options$cache)
    }
  }
  
  # Only one record should be returned
  if (length(r_content$records) > 1) {
    warning("More than one response records received, something might be wrong")
  }
  spp_count <- r_content$records[[1]]$get_country_species_count
  
  return(spp_count)
}

#' Get species list for a country
#' 
#' Returns a list of the species whose range intersects with the country. This 
#' intersection on the species range includes the Exclusive Economic Zone
#' boundary for the country which extends out to 200 nautical miles from the 
#' coastline. The EEZ boundary was derived from the Flanders Marine Institute 
#' (see \href{http://www.vliz.be/vmdcdata/marbound/}{here} for more information).
#' 
#' 
#' @param country Character country name or numeric country code.
#' @param rlstatus A character vector of the IUCN Conservation Status for the 
#'   species. Default is \code{NULL} in which case species of all statuses are 
#'   requested.  For more information see 
#'   \href{http://www.iucnredlist.org/technical-documents/categories-and-criteria}{here}.
#' @param cache Sets the cache mode: \code{TRUE} = Use cache if available and 
#' save to cache, \code{FALSE} = Ignore cache if available and do not save to 
#' cache, \code{"flush"} = Ignore cache if available and save to cache.
#' 
#' @return A data.frame of species whose range intersects with the country. Each 
#' species has the following information associated to it:
#'
#' \tabular{ll}{
#'  \code{iucn_species_id} \tab IUCN Species Identifier from the Red List 
#'  website. To find the IUCN Species Identifier, search for a species and then 
#'  look for the number in the URL, e.g. Orang Utan is 17975 \cr
#'  \code{taxon} \tab The taxonomic name for the species \cr
#'  \code{min_presence_id} \tab The min_presence_id indicates the minimum 
#'  species presence according to the following values: 0-Unknown, 1-Extant, 
#'  2-Probably Extant, 3-Possibly Extant, 4-Possibly Extinct, 5-Extinct 
#'  (post 1500), 6-Presence Uncertain. The protected area may intersect the 
#'  species with more than one presence type, so this is an indication of the 
#'  minimum presence. For more information see the IUCN Red List Metadata 
#'  Document \href{http://goo.gl/OfET66}{here}. \cr
#'  \code{kingdom} \tab The kingdom for the species \cr
#'  \code{phylum} \tab The phylum for the species \cr
#'  \code{class} \tab The class for the species \cr
#'  \code{order} \tab The order for the species \cr
#'  \code{family} \tab The family for the species \cr
#'  \code{status} \tab The IUCN Conservation Status for the species according to 
#'  the following values: CR-Critically Endangered, EN-Endangered, 
#'  VU-Vulnerable, NT-Near Threatened, LC-Least Concern, EX-Extinct, EW-Extinct 
#'  in the Wild, DD-Data Deficient. For more information see 
#'  \href{http://goo.gl/wfnuHl}{here} \cr
#'  \code{assessed} \tab The date the conservation status of the species was 
#'  last assessed \cr
#'  \code{commonname} \tab No description \cr
#'  \code{language} \tab No description \cr
#'  \code{country_id} \tab Country ISO code \cr
#'  \code{country_name} \tab Country name \cr
#' }
#' 
#' @import httr
#' @import R.cache
#' 
#' @export
#' 
#' @seealso \url{http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_species_list}
#' @seealso \code{\link{resolve_country}} \code{\link{check_iucn_status}} 
#' 
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 
#' @examples \dontrun{
#' # Get species for New Zealand
#' kiwi.species <- country_species_list(country="New Zealand")
#' 
#' # Get only endangered species for New Zealand
#' endangered.kiwi.species <- country_species_list(country="New Zealand",
#'                                                 rlstatus=c("CR", "EN", "VU"))
#'  
#' }
country_species_list <- function(country, rlstatus=NULL, cache=TRUE) {
  
  code <- resolve_country(country)
  
  key <- list("country_species_list", code, rlstatus)
  r_content <- NULL
  
  if (cache == TRUE) {
    r_content <- R.cache::loadCache(key, suffix=.options$cache)
  }
  if (!is.null(r_content)) {
    message("Loaded cached data")
  } else {
  
    # Construct the REST parameters
    if (is.null(rlstatus)) {
      r <- GET("http://dopa-services.jrc.ec.europa.eu",
               path = "rest/eAdmin/get_country_species_list",
               query = list(
                 country_id = code
               ))
    } else {
      rlstatus <- check_iucn_status(rlstatus)
      r <- GET("http://dopa-services.jrc.ec.europa.eu",
               path = "rest/eAdmin/get_country_species_list",
               query = list(
                 country_id = code,
                 rlstatus = paste(rlstatus, collapse=",")
               ))
    }
    # Check the request succeeded
    stop_for_status(r)
    
    r_content <- content(r)
    
    if (cache == TRUE || cache == 'flush') {
      R.cache::saveCache(r_content, key=key, suffix=.options$cache)
    }
  }
  
  dat <- parse_dopa_response(r_content$records)
  # Add country information
  dat$country_id <- resolve_country(country)
  dat$country_name <- resolve_country(country, full.name=TRUE)
  
  return(dat)
}

#' Get country statistics
#' 
#' Returns the country core statistics associated to the amount of PAs in 
#' different IUCN categories.
#' 
#' If a country has no area designated to a particulart IUCN category, 
#' The DOPA API will leave the category out of the response. 
#' \code{country_stats()} returns all categories, populationg 
#' non-existant with NAs.
#' 
#' @param country Character country name or numeric country code.
#' @param cache Sets the cache mode: \code{TRUE} = Use cache if available and 
#' save to cache, \code{FALSE} = Ignore cache if available and do not save to 
#' cache, \code{"flush"} = Ignore cache if available and save to cache.
#' 
#' @return A data.frame of country PA statistics. Each 
#' PA has the following information associated to it:
#'
#' \tabular{ll}{
#'  \code{category} \tab IThe category for the iucn protection level \cr
#'  \code{area_protected} \tab The protected area of the country \cr
#'  \code{area_protected_perc} \tab The protected area percentage of the 
#'  country \cr
#'  \code{area_total} \tab The total area of the country \cr
#'  \code{countryiso} \tab The ISO numeric code of the country \cr
#'  \code{name} \tab The name of the country \cr
#'  \code{iucn_cat} \tab The numeric id for the iucn protection level \cr
#' }
#' 
#' @import httr
#' @import R.cache
#' 
#' @export
#' 
#' @seealso \url{http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_country_stats}
#' @seealso \code{\link{resolve_country}}
#' 
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 
#' @examples \dontrun{
#' # Get PA statistics for Sweden
#' country_stats(country="Sweden")
#' }
country_stats <- function(country, cache=FALSE){
  code <- resolve_country(country)
  
  key <- list("country_stats", code)
  r_content <- NULL
  
  if (cache == TRUE) {
    r_content <- R.cache::loadCache(key, suffix=.options$cache)
  }
  if (!is.null(r_content)) {
    message("Loaded cached data")
  } else {
    
    # Construct the REST parameters
    r <- GET("http://dopa-services.jrc.ec.europa.eu",
             path = "rest/eAdmin/get_country_stats",
             query = list(
               country_id = code
             ))
   
    # Check the request succeeded
    stop_for_status(r)
    
    r_content <- content(r)
    
    if (cache == TRUE || cache == 'flush') {
      R.cache::saveCache(r_content, key=key, suffix=.options$cache)
    }
  }
  
  dat <- parse_dopa_response(r_content$records)

  # Check that all categories are there. If not, fill in the missing rows.
  cats <- get_iucn_pa_categories()
  if (nrow(dat) != nrow(cats)){
    # Which categories are missing?
    missing <- cats[!cats$iucn_cat %in% dat$iucn_cat,]
    # Fill in the data
    missing_cats <- data.frame(category=missing$category,
                               area_protected=NA,
                               area_protected_perc=NA,
                               area_total=dat[1,]$area_total,
                               countryiso=dat[1,]$countryiso,
                               name=dat[1,]$name,
                               iucn_cat=missing$iucn_cat)
    dat <- rbind(dat, missing_cats)
    # Sort by category
    dat <- dat[with(dat, order(category)), ]
    row.names(dat) <- NULL
  }
  
  return(dat)
}

#' Get PA statistics for a given country.
#' 
#' Returns the PA core statistics for a certain country generated by JRC.
#' 
#' @param country Character country name or numeric country code.
#' @param cache Sets the cache mode: \code{TRUE} = Use cache if available and 
#' save to cache, \code{FALSE} = Ignore cache if available and do not save to 
#' cache, \code{"flush"} = Ignore cache if available and save to cache.
#' 
#' @return A data.frame of PAs for a given country. Each 
#' PA has the following information associated to it:
#'
#' \tabular{ll}{
#'  \code{wdpaid} \tab The ID of the protected area, e.g. taken from WCMC 
#'  ProtectedPlanet.org website \cr
#'  \code{iucn_cat} \tab The IUCN protection level category \cr
#'  \code{name} \tab Name of the site \cr
#'  \code{extent} \tab The geographic extent as xmin,ymin,xmax,ymax string \cr
#'  \code{hriwdpaid} \tab The id of the PA corresponding to a computed HRI 
#'  similarity map \cr
#'  \code{hri} \tab The habitat replaceability index value \cr
#'  \code{area} \tab The reported area of the site \cr
#'  \code{sri} \tab The average species irreplacibility score for mammals, birds 
#'  and amphibians \cr
#'  \code{pi} \tab The population pressure indeces \cr
#'  \code{ap} \tab The reported area of the site \cr
#'  \code{wdpa_wkt} \tab A simplified WKT representation of the park boundary \cr
#'  \code{gis_area} \tab The area of the PA computed from the geometry \cr
#'  \code{numterrsegms} \tab The raw number of habitat segments computed from 
#'  biophysical variables \cr
#' }
#' 
#' @import httr
#' @import R.cache
#' 
#' @export
#' 
#' @seealso \url{http://dopa-services.jrc.ec.europa.eu/rest/eAdmin/get_pa_country_stats}
#' @seealso \code{\link{resolve_country}}
#' 
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 
#' @examples \dontrun{
#' # Get PA country statistics for Uganda
#' pa_country_stats(country="Uganda")
#' }
#' 
pa_country_stats <- function(country, cache=FALSE){
  code <- resolve_country(country)
  
  key <- list("country_stats", code)
  r_content <- NULL
  
  if (cache == TRUE) {
    r_content <- R.cache::loadCache(key, suffix=.options$cache)
  }
  if (!is.null(r_content)) {
    message("Loaded cached data")
  } else {
    
    # Construct the REST parameters
    r <- GET("http://dopa-services.jrc.ec.europa.eu",
             path = "rest/eAdmin/get_pa_country_stats",
             query = list(
               country_id = code
             ))
    
    # Check the request succeeded
    stop_for_status(r)
    
    r_content <- content(r)
    
    if (cache == TRUE || cache == 'flush') {
      R.cache::saveCache(r_content, key=key, suffix=.options$cache)
    }
  }
  
  dat <- parse_dopa_response(r_content$records)
}
