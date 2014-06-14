#' Create an instance of the RESTservice class using new/initialize.
#'
#' @param json_file Character path to an existing JSON definition file of a REST 
#'   service.
#'
#' @keywords internal
#'
#'
#' @rdname initialize-methods
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 
setMethod("initialize", "RESTservice", function(.Object, json_file) {
  
  if (!file.exists(json_file)) {
    stop(paste0("JSON file ", json_file, " not found")) 
  }
  
  json_data <- fromJSON(json_file)
  
  .Object@base_url <- json_data$base_url
  
  .Object
})
