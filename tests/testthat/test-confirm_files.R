t# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

right_dir <- system.file("extdata", "right", package = "verdata", "codata-reclutamiento-R1.parquet")
wrong_dir <- system.file("extdata", "wrong", package = "verdata", "codata-reclutamiento-R1.parquet")
csv_right <- system.file("extdata", "right", package = "verdata", "codata-reclutamiento-R1.csv.zip")

testthat::test_that("Hashing file", {

    testthat::expect_message(confirm_file(right_dir, "parquet"), "You have the right file!")

})

testthat::test_that("Hashing wrong file", {

    testthat::expect_error(confirm_file(wrong_dir, "parquet"))

})

testthat::test_that("Hashing right csv file", {

    testthat::expect_message(confirm_file(csv_right, "csv"), "You have the right file!")

})

right_dir <- system.file("extdata", "right", package = "verdata")
wrong_dir <- system.file("extdata", "wrong", package = "verdata")

testthat::test_that("Hashing files", {

    testthat::expect_message(confirm_files(right_dir, "reclutamiento", 1, 2, "parquet"), "You have the right file!")

})

testthat::test_that("Hashing wrong files", {

    testthat::expect_error(confirm_files(wrong_dir, "reclutamiento", 1, 2, "parquet"))

})

# --- Done
