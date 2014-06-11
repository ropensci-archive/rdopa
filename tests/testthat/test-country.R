context("get_country_species_count")

test_that("Arguments are handled correctly", {
  # Argument country
  expect_error(get_country_species_count(country=NA),
               info="Using NA for country code should raise an error")
  expect_error(get_country_species_count(country=NULL),
               info="Using NULL for country code should raise an error")
})

test_that("Returns the correct class", {  
  # China, country code should work as a string and numeric
  expect_is(get_country_species_count(country="156"), "numeric")
  expect_is(get_country_species_count(country=156), "numeric")
  expect_is(get_country_species_count(country="Finland"), "numeric")
})

test_that("Non-existing country names and codes raise an error", {
  expect_error(get_country_species_count(country="99999"),
               info="Non-existant country code should raise an error")
  expect_error(get_country_species_count(country=99999),
               info="Non-existant country code should raise an error")
  expect_error(get_country_species_count(country="FooBaristan"),
               info="Non-existant country name should raise an error")
})
