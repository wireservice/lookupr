library(lookupr)
context("source.R tests")

test_that("make_table_path generates paths", {
  expect_equal(make_table_path("a", "b"), "a/b.csv")
  expect_equal(make_table_path("a", "b", "c"), "a/b.c.csv")
  expect_equal(make_table_path(c("a", "c"), "b"), "a/c/b.csv")
  expect_equal(make_table_path(c("a", "c"), "b", "d"), "a/c/b.d.csv")
})

test_that("make_metadata_path generates paths", {
  expect_equal(make_metadata_path("a", "b"), "a/b.csv.yml")
  expect_equal(make_metadata_path("a", "b", "c"), "a/b.c.csv.yml")
  expect_equal(make_metadata_path(c("a", "c"), "b"), "a/c/b.csv.yml")
  expect_equal(make_metadata_path(c("a", "c"), "b", "d"), "a/c/b.d.csv.yml")
})

test_that("lookup_source creates a source", {
  expect_is(lookup_source(), "lookup_source")
  expect_equal(lookup_source()$root, "http://wireservice.github.io/lookup")
  expect_equal(lookup_source("test")$root, "test")
})