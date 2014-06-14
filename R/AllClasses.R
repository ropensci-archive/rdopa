#' REST service object
#'
#' Manager class for REST service related informations such as URLs and
#' resources.
#'
#' @section Slots: 
#'  \describe{
#'    \item{\code{base_url}:}{Character URI pointing to service base url.}
#'    \item{\code{schemas}:}{List of schemas and their resources.}
#'  }
#'
#' @name RESTservice
#' @docType class
#' @rdname RESTservice-class
#' @aliases RESTservice-class
#' @exportClass RESTservice
#' @author Joona Lehtomaki <joona.lehtomaki@@gmail.com>
#' 

setClass('RESTservice', representation(base_url='character',
                                       schemas='list'))
