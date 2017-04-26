library(lookupr)
context("main.R tests")

sample_data <- data.frame(
  year = c("2005", "2006", "2007", "2008", "2009", "2010"),
  value_a = c(100, 100, 100, 100, 100, 100),
  value_b = c(200, 200, 200, 200, 200, 200)
)

test_that("lookup_cpi inflation adjusts data series", {
  result <- lookup_cpi(sample_data, "value_a")

  expect_equal(nrow(result), 6)
  expect_equal(ncol(result), 3)
  expect_equal(colnames(result), c("year", "value_a", "value_b"))

  result <- lookup_cpi(sample_data, "value_a", "year", "2010")

  expect_equal(nrow(result), 6)
  expect_equal(ncol(result), 3)
  expect_equal(colnames(result), c("year", "value_a", "value_b"))

  result <- lookup_cpi(sample_data, "value_a", "year", "2010", replace_columns = FALSE)

  expect_equal(nrow(result), 6)
  expect_equal(ncol(result), 4)
  expect_equal(colnames(result), c("year", "value_a", "value_b", "value_a_2010"))

  result <- lookup_cpi(sample_data, c("value_a", "value_b"), "year", "2010")

  expect_equal(nrow(result), 6)
  expect_equal(ncol(result), 3)
  expect_equal(colnames(result), c("year", "value_a", "value_b"))

  result <- lookup_cpi(sample_data, c("value_a", "value_b"), "year", "2010", replace_columns = FALSE)

  expect_equal(nrow(result), 6)
  expect_equal(ncol(result), 5)
  expect_equal(colnames(result), c("year", "value_a", "value_b", "value_a_2010", "value_b_2010"))
})