#' Get ISO 3166-1 country code.
#' 
#' Country identity can be provided as a number or as country name. If the 
#' provided number is a valid ISO 3166-1 country code it is returned directly.
#' 
#' @details Package \code{\link{countrycode}} is used to resolve the value of argument
#' \code{country} which can be either a country name (\code{country.name}) or a 
#' ISO 3166-1 country code (\code{iso3n}).
#' 
#' @param country_id Character country name or numeric country code.

#' @return Numeric count of the species whose range intersects with the country.
#' 
#' @import countrycode
#' 
#' @export
#' 
#' @seealso \code{\link{countrycode}} 
#' 
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 
#' @examples
#' 
#' # Using country name
#' code <- resolve_country("Finland")
#'   
#' # Using country code (156 is China)
#' code <- resolve_country(156)
#' 
#' # Country code can be provided as a character string as well
#' code <- resolve_country("156")
#'  
#'
resolve_country <- function(country) {
  
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
