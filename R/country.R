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
#' @param country_id Character country name or numeric country code.
#' @param rlstatus A character vector of the IUCN Conservation Status for the 
#'   species. Default is \code{NULL} in which case species of all statuses are 
#'   requested.
#' 
#' @return Numeric count of the species whose range intersects with the country.
#' 
#' @import httr
#' 
#' @export
#' 
#' @seealso \url{http://dopa-services.jrc.ec.europa.eu/services/especies/get_country_species_count}
#' @seealso \code{\link{resolve_country}} \code{\link{check_iucn_status}} 
#' 
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 
#' @examples \dontrun{
#' 
#' # Using country name
#' get_country_species_count(country="Finland")
#'   
#' # Using country code (156 is China)
#' get_country_species_count(country=156)
#' 
#' # Get only critically endangered and endangered species
#' get_country_species_count(country=156, rlstatus=c("CR", "EN"))
#'  
#' }
get_country_species_count <- function(country, rlstatus=NULL) {
  
  code <- resolve_country(country)
  
  # Construct the REST parameters
  if (is.null(rlstatus)) {
    r <- GET("http://dopa-services.jrc.ec.europa.eu",
             path = "services/especies/get_country_species_count",
             query = list(
              country_id = code
             ))
  } else {
    rlstatus <- check_iucn_status(rlstatus)
    r <- GET("http://dopa-services.jrc.ec.europa.eu",
             path = "services/especies/get_country_species_count",
             query = list(
               country_id = code,
               rlstatus = paste(rlstatus, collapse=",")
             ))
  }
  # Check the request succeeded
  stop_for_status(r)
  
  r_content <- content(r)
  
  # Only one record should be returned
  if (length(r_content$records) > 1) {
    warning("More than one response records received, something might be wrong")
  }
  spp_count <- r_content$records[[1]]$get_country_species_count
  
  return(spp_count)
}
