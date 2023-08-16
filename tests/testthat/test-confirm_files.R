t# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

right_dir <- system.file("extdata", "right", package = "verdata", "verdata-reclutamiento-R1.parquet")
wrong_dir <- system.file("extdata", "wrong", package = "verdata", "verdata-reclutamiento-R1.parquet")
csv_right <- system.file("extdata", "right", package = "verdata", "verdata-reclutamiento-R1.csv.zip")

testthat::test_that("Hashing file", {

    testthat::expect_true(confirm_file(right_dir)$confirmed)

})

testthat::test_that("Hashing wrong file", {

    testthat::expect_false(confirm_file(wrong_dir)$confirmed)

})

testthat::test_that("Hashing right csv file", {

    testthat::expect_true(confirm_file(csv_right)$confirmed)

})

right_dir <- system.file("extdata", "right", package = "verdata")
wrong_dir <- system.file("extdata", "wrong", package = "verdata")

testthat::test_that("Hashing files", {

    testthat::expect_true(all(confirm_files(right_dir, "reclutamiento", c(1, 2))$confirmed))

})

testthat::test_that("Hashing wrong files", {

    testthat::expect_false(all(confirm_files(wrong_dir, "reclutamiento", c(1, 2))$confirmed))

})

testthat::test_that("Function should return an error if the violation type is incorrect", {

  testthat::expect_error(confirm_files(right_dir, "RECLUTAMIENTO", c(1, 2)))

})

testthat::test_that("Expect message when number of replicates exceed available replicates", {

  testthat::expect_error(confirm_files(right_dir, "reclutamiento", 90:110))

})

testthat::test_that("Expect message when first replicate is less than 1", {

  testthat::expect_error(confirm_files(right_dir, "reclutamiento", 0:2))

})

testthat::test_that("Expect message when first replicate is less than 1 and last is more than 100", {

  testthat::expect_error(confirm_files(right_dir, "reclutamiento", 0:101))

})

testthat::test_that("Function should return an error if replicate numbers are misspecified", {

  testthat::expect_error(confirm_files(right_dir, "reclutamiento", c("1", 2)))

})

testthat::test_that("Function should return an error if replicate numbers are misspecified", {

  testthat::expect_error(confirm_files(right_dir, "RECLUTAMIENTO", c(1, "dos")))

})

testthat::test_that("Function should return an error if one or more of the replicates is not in the directory, but within the plausible bounds", {

    testthat::expect_error(confirm_files(right_dir, "reclutamiento", 1:10))

})

# --- Done
