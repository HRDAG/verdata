# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

right_dir <- system.file("extdata", "right", package = "verdata", "verdata-reclutamiento-R1.parquet")
wrong_dir <- system.file("extdata", "wrong", package = "verdata", "verdata-reclutamiento-R1.parquet")
csv_right <- system.file("extdata", "right", package = "verdata", "verdata-reclutamiento-R1.csv.zip")

testthat::test_that("Hashing content", {

    testthat::expect_s3_class(read_replicate(right_dir, "parquet"), "data.frame")

})

testthat::test_that("Hashing csv content", {

    testthat::expect_s3_class(read_replicate(csv_right, "csv"), "data.frame")

})

testthat::test_that("Hashing wrong content with default crash", {

    testthat::expect_error(read_replicate(wrong_dir, "parquet"))

})

testthat::test_that("Hashing wrong content with crash set to F", {

    testthat::expect_s3_class(read_replicate(wrong_dir, "parquet", F),
                              "data.frame")
    testthat::expect_warning(read_replicate(wrong_dir, "parquet", F), "The content of the files is not identical to the ones published.
                This means the results of the analysis may potentially be inconsistent.")

})

right_dir <- system.file("extdata", "right", package = "verdata")
wrong_dir <- system.file("extdata", "wrong", package = "verdata")

testthat::test_that("Hashing content of files", {

    testthat::expect_s3_class(read_replicates(right_dir, "reclutamiento", 1, 2,
                                              "parquet"), "data.frame")

})

testthat::test_that("Hashing content of wrong files with default crash", {

    testthat::expect_error(read_replicates(wrong_dir, "reclutamiento", 1, 2,
                                           "parquet"))

})

testthat::test_that("Hashing content of wrong with crash set to F", {
    testthat::expect_warning(read_replicates(wrong_dir, "reclutamiento", 1, 2,
                                             "parquet", F))
    testthat::expect_s3_class(read_replicates(wrong_dir, "reclutamiento", 1, 2,
                                              "parquet", F), "data.frame")

})

# --- Done
