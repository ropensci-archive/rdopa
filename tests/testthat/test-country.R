context("get_country_species_count")

test_that("returns the correct class", {
  # China
  expect_is(get_country_species_count(country="156"), "numeric")
  expect_is(get_country_species_count(country="Finland"), "numeric")
})
