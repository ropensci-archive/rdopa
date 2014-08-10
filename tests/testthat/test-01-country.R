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
  expect_equal(country_species_count(country="Finland", rlstatus="DD",
                                     cache=FALSE), 4)
  expect_equal(country_species_count(country="Finland", rlstatus="EW",
                                     cache=FALSE), 0)
  expect_equal(country_species_count(country="Finland", rlstatus="EX",
                                     cache=FALSE), 0)
  expect_equal(country_species_count(country="Finland", rlstatus="DD",
                                     cache=FALSE), 4)
  expect_equal(country_species_count(country="Finland", rlstatus="LC",
                                     cache=FALSE), 318)
  expect_equal(country_species_count(country="Finland", rlstatus="NT",
                                     cache=FALSE), 13)
  expect_equal(country_species_count(country="Finland", rlstatus="VU",
                                     cache=FALSE), 7)
  expect_equal(country_species_count(country="Finland", rlstatus="EN",
                                     cache=FALSE), 0)
  expect_equal(country_species_count(country="Finland", rlstatus="CR",
                                     cache=FALSE), 1)
  # All species
  expect_equal(country_species_count(country="Finland"), 343)
})

test_that("Cache works", {
  
  # Cache the response
  cached_1 <- country_species_count(country="Finland", rlstatus="LC",
                                   cache=TRUE)
  # Ignore the cache
  fresh_data <- country_species_count(country="Finland", rlstatus="LC",
                                      cache=FALSE)
  # Load from cache and compare to the previous data
  cached_2 <- country_species_count(country="Finland", rlstatus="LC",
                                    cache=TRUE)
  expect_identical(cached_1, cached_2,
                   "Cached values should be the same")
  # Compare to the fresh data
  expect_identical(cached_1, fresh_data,
                   "Cached and fresh values should be the same")
})

context("country_species_list")

test_that("Arguments are handled correctly", {
  # Argument country
  expect_error(country_species_list(country=NA),
               info="Using NA for country code should raise an error")
  expect_error(country_species_list(country=NULL),
               info="Using NULL for country code should raise an error")
})

test_that("API values sane", {
    
  # Use New Zealand (country code = 554).
  # First get all species and check the number
  expect_equal(length(country_species_list(country="New Zealand", cache=FALSE)), 
               463)
  
})
