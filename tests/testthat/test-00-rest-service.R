context("REST service definition")
library(jsonlite)

test_that("RESTservice object inputs are handled correctly", {

  # Read the content of the REST definition JSON file
  json_file <- system.file("extdata/", "dopa_schemas.json",
                           package="respecies")
  
  # Create faulty path
  faulty_json_file <- system.file("extdata/", "FGADHGLDF.json",
                                  package="respecies")
  
  # JSON file does exist
  especies_REST <- new("RESTservice", json_file)
  expect_is(especies_REST, "RESTservice",
            "RESTservice should be an instance of class RESTservice")
  
  # JSON file does not exist
  expect_error(especies_REST <- new("RESTservice", faulty_json_file),
               info="Faulty JSON file should raise an error")
  
})

test_that("RESTservice mehtods work correctly", {
  json_file <- system.file("extdata/", "dopa_schemas.json",
                           package="respecies")
  especies_REST <- new("RESTservice", json_file)
  json_data <- fromJSON(json_file)
  
  expect_identical(baseurl(especies_REST), json_data$base_url,
                   "RESTservice base URL not returned correctly")
  
})
