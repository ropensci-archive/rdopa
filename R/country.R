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
#' @param cache Sets the cachce mode: \code{TRUE} = Use cache if available and 
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
#' @param cache Sets the cachce mode: \code{TRUE} = Use cache if available and 
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
  
  return(parse_dopa_response(r_content$records))
}
