context("Package utility functions")

test_that("Country codes are handled correctly", {  
  # China, country code should work as a string and numeric
  expect_identical(resolve_country(country="156"), 156,
               "Contry code as character is not resolved correctly")
  expect_identical(resolve_country(country=156), 156,
               "Contry code as numeric is not resolved correctly")
  expect_identical(resolve_country(country="Finland"), 246,
               "Contry name is not resolved correctly")
})

test_that("Non-existing country names and codes raise an error", {
  expect_error(resolve_country(country="99999"),
               info="Non-existant country code should raise an error")
  expect_error(resolve_country(country=99999),
               info="Non-existant country code should raise an error")
  expect_error(resolve_country(country="FooBaristan"),
               info="Non-existant country name should raise an error")
})

test_that("Check that the conservation status codes are handled correctly", {
  expect_equal(check_iucn_status("CR"), "CR", 
              "Valid IUCN status code CR causes problems.")
  all_codes <- c("CR", "EN", "VU", "NT", "LC", "EX", "EW", "DD")
  expect_equal(check_iucn_status(all_codes), all_codes, 
              "Using all valid IUCN status codes causes problems")
  suppressWarnings(expect_warning(check_iucn_status(c("CR", "EN", "VU", "Foo", 
                                                      "LC", "EX", "EW", "DD")),
                   info="Invalid item should cause an error"))
  suppressWarnings(expect_equal(check_iucn_status(c("CR", "EN", "VU", "Foo", 
                                                    "LC", "EX", "EW", "DD")), 
                                                  c("CR", "EN", "VU", 
                                                    "LC", "EX", "EW", "DD"),
                            "Invalid item is not removed from the vector"))
  suppressWarnings(expect_error(check_iucn_status("Foo"),
               info="All IUCN status codes being incorrect should cause an error"))
  suppressWarnings(expect_error(check_iucn_status(c("Foo", "Bar")),
               info="All IUCN status codes being incorrect should cause an error"))
})
