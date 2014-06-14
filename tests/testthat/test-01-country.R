context("get_country_species_count")

test_that("Arguments are handled correctly", {
  # Argument country
  expect_error(get_country_species_count(country=NA),
               info="Using NA for country code should raise an error")
  expect_error(get_country_species_count(country=NULL),
               info="Using NULL for country code should raise an error")
})

