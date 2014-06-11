#' Get species count for a country
#' 
#' Returns a count of the species whose range intersects with the country. This 
#' intersection on the species range includes the Exclusive Economic Zone 
#' boundary for the country which extends out to 200 nautical miles from the 
#' coastline. The EEZ boundary was derived from the Flanders Marine Institute 
#' (see \link{http://www.vliz.be/vmdcdata/marbound/} for more information).
#' 
#' Package \code{\link{countrycode}} is used to resolve the value of argument
#' \code{country} which can be either a country name (\code{country.name}) or a 
#' ISO 3166-1 country code (\code{iso3n}).
#' 
#' @param country character country name or numeric country code.
#' 
#' @import httr
#' @import countrycode
#' 
#' @export
#' 
#' @seealso \link{http://dopa-services.jrc.ec.europa.eu/services/especies/get_country_species_count}
#' @seealso \code{\link{countrycode}} 
#' 
#' @examples \dontrun{
#' 
#' # Using country name
#' get_country_species_count(country="Finland")
#'   
#' # Using conuntry code
#' get_country_species_count(country=156)
#'  
#' }
get_country_species_count <- function(country) {

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
  return(code)
}
