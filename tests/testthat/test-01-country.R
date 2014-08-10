context("country_species_count")

test_that("Arguments are handled correctly", {
  # Argument country
  expect_error(country_species_count(country=NA),
               info="Using NA for country code should raise an error")
  expect_error(country_species_count(country=NULL),
               info="Using NULL for country code should raise an error")
})

test_that("API values sane", {
  # Slightly pointless check since we don't (and don't want to) check 
  # all the possible country/rlstatus combinations
  expect_equal(country_species_count(country="Finland", rlstatus="DD"), 4)
  expect_equal(country_species_count(country="Finland", rlstatus="EW"), 0)
  expect_equal(country_species_count(country="Finland", rlstatus="EX"), 0)
  expect_equal(country_species_count(country="Finland", rlstatus="DD"), 4)
  expect_equal(country_species_count(country="Finland", rlstatus="LC"), 318)
  expect_equal(country_species_count(country="Finland", rlstatus="NT"), 13)
  expect_equal(country_species_count(country="Finland", rlstatus="VU"), 7)
  expect_equal(country_species_count(country="Finland", rlstatus="EN"), 0)
  expect_equal(country_species_count(country="Finland", rlstatus="CR"), 1)
})
