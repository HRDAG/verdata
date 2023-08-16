# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

right_dir <- system.file("extdata", "right", package = "verdata", "verdata-reclutamiento-R1.parquet")
wrong_dir <- system.file("extdata", "wrong", package = "verdata", "verdata-reclutamiento-R1.parquet")
csv_right <- system.file("extdata", "right", package = "verdata", "verdata-reclutamiento-R1.csv.zip")

testthat::test_that("Hashing content", {

    testthat::expect_true(all(read_replicate(right_dir)$match))
    testthat::expect_s3_class(read_replicate(right_dir), "data.frame")

})

testthat::test_that("Hashing csv content", {

    testthat::expect_s3_class(read_replicate(csv_right), "data.frame")
    testthat::expect_true(all(read_replicate(csv_right)$match))

})

testthat::test_that("Hashing wrong content with default crash", {

    testthat::expect_s3_class(read_replicate(wrong_dir), "data.frame")
    testthat::expect_false(all(read_replicate(wrong_dir)$match))

})

right_dir <- system.file("extdata", "right", package = "verdata")
wrong_dir <- system.file("extdata", "wrong", package = "verdata")

testthat::test_that("Hashing content of files", {

    testthat::expect_s3_class(read_replicates(right_dir, "reclutamiento", c(1, 2)), "data.frame")

})

testthat::test_that("Hashing content of wrong files with default crash", {

    testthat::expect_error(read_replicates(wrong_dir, "reclutamiento", c(1, 2)))

})

testthat::test_that("Hashing content of wrong with crash set to F", {
    testthat::expect_warning(read_replicates(wrong_dir, "reclutamiento", c(1, 2), FALSE))
    testthat::expect_s3_class(read_replicates(wrong_dir, "reclutamiento", c(1, 2), FALSE), "data.frame")

})

testthat::test_that("Function should return an error if the violation type is incorrect", {

  testthat::expect_error(read_replicates(right_dir, "desplazamiento", c(1, 2)))

})

testthat::test_that("Expect message when number of replicates exceed available replicates", {

  testthat::expect_error(read_replicates(right_dir, "reclutamiento", 90:110))

})

testthat::test_that("Expect message when first replicate is less than 1", {

  testthat::expect_error(read_replicates(right_dir, "reclutamiento", 0:2))

})

testthat::test_that("Expect message when first replicate is less than 1 and last is more than 100", {

  testthat::expect_error(read_replicates(right_dir, "reclutamiento", 0:101))
})

testthat::test_that("Function should return an error if replicate numbers are misspecified", {

  testthat::expect_error(read_replicates(right_dir, "reclutamiento", c("1", 2)))

})

testthat::test_that("Function should return an error if replicate numbers are misspecified", {

  testthat::expect_error(read_replicates(right_dir, "RECLUTAMIENTO", c(1, "dos")))

})

testthat::test_that("Function should return an error if one or more of the replicates is not in the directory, but within the plausible bounds", {

    testthat::expect_error(read_replicates(right_dir, "reclutamiento", 1:10))

})

# --- Done
