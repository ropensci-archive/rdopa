#' @rdname RESTservice-methods
#' @aliases baseurl,RESTservice-method
#' 
setMethod("baseurl", "RESTservice", function(x) {
  return(x@base_url)
})
