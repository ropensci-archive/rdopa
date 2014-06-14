#' Get species count for a country
#' 
#' Returns a count of the species whose range intersects with the country. This 
#' intersection on the species range includes the Exclusive Economic Zone 
#' boundary for the country which extends out to 200 nautical miles from the 
#' coastline. The EEZ boundary was derived from the Flanders Marine Institute 
#' (see \url{http://www.vliz.be/vmdcdata/marbound/} for more information).
#' 
#' @details Package \code{\link{countrycode}} is used to resolve the value of argument
#' \code{country} which can be either a country name (\code{country.name}) or a 
#' ISO 3166-1 country code (\code{iso3n}).
#' 
#' Argument \code{rlstatus} is a vector containing one or several of the 
#' following:
#' \tabular{rl}{
#'  \code{"CR"} \tab Critically Endangered \cr
#'  \code{"EN"} \tab Endangered \cr
#'  \code{"VU"} \tab Vulnerable \cr
#'  \code{"NT"} \tab Near Threatened \cr
#'  \code{"LC"} \tab Least Concern \cr
#'  \code{"EX"} \tab Extinct \cr
#'  \code{"EW"} \tab Extinct in the Wild \cr
#'  \code{"DD"} \tab Data Deficient \cr
#' }
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
#' @import countrycode
#' 
#' @export
#' 
#' @seealso \url{http://dopa-services.jrc.ec.europa.eu/services/especies/get_country_species_count}
#' @seealso \code{\link{countrycode}} 
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
  
  # Check if country is string that can be coerced to a numeric
  if (suppressWarnings(!is.na(as.numeric(country)))) {
    country <- as.numeric(country)
  }
  
  # If country is provided as a country name, try to convert it to a ISO code
  if (is.character(country)) {
    origin <- "country.name"
    destination <- "iso3n"
    # Must coerce to numeric, will give integer otherwise
    code <- as.numeric(countrycode(country, "country.name", "iso3n"))
    if (is.na(code)) {
      stop("Country name ", country, " was not matched to an ISO code.")
    }
  } else if (is.numeric(country)) {
    # Check that the ISO code exists
    if (!country %in% countrycode_data$iso3n) {
      stop("Country code ", country, " not a valid ISO 3166-1 code")
    } else {
      code  <- country
    }
  } else {
    stop("country must be either string country name of numeric country code")
  }
  
  # Construct the REST parameters
  if (is.null(rlstatus)) {
    r <- GET("http://dopa-services.jrc.ec.europa.eu",
             path = "services/especies/get_country_species_count",
             query = list(
              country_id = code
             ))
  } else {
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
