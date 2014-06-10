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
  NULL
}
