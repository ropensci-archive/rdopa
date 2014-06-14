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
