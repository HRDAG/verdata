# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

right_dir <- system.file("extdata", "right", package = "verdata", "verdata-reclutamiento-R1.parquet")
wrong_dir <- system.file("extdata", "wrong", package = "verdata", "verdata-reclutamiento-R1.parquet")
csv_right <- system.file("extdata", "right", package = "verdata", "verdata-reclutamiento-R1.csv.zip")

testthat::test_that("Hashing content", {

    testthat::expect_s3_class(read_replicate(right_dir), "data.frame")

})

testthat::test_that("Hashing csv content", {

    testthat::expect_s3_class(read_replicate(csv_right), "data.frame")

})

testthat::test_that("Hashing wrong content with default crash", {

    testthat::expect_error(read_replicate(wrong_dir))

})

testthat::test_that("Hashing wrong content with crash set to F", {

    testthat::expect_s3_class(read_replicate(wrong_dir, FALSE),
                              "data.frame")
    testthat::expect_warning(read_replicate(wrong_dir, FALSE), "The content of the files is not identical to the ones published.
                The results of the analysis may be inconsistent.")

})

right_dir <- system.file("extdata", "right", package = "verdata")
wrong_dir <- system.file("extdata", "wrong", package = "verdata")

testthat::test_that("Hashing content of files", {

    testthat::expect_s3_class(read_replicates(right_dir, "reclutamiento", 1, 2), "data.frame")

})

testthat::test_that("Hashing content of wrong files with default crash", {

    testthat::expect_error(read_replicates(wrong_dir, "reclutamiento", 1, 2))

})

testthat::test_that("Hashing content of wrong with crash set to F", {
    testthat::expect_warning(read_replicates(wrong_dir, "reclutamiento", 1, 2, FALSE))
    testthat::expect_s3_class(read_replicates(wrong_dir, "reclutamiento", 1, 2, FALSE), "data.frame")

})

testthat::test_that("Function should return an error if the violation type is incorrect", {
  
  testthat::expect_error(read_replicates(right_dir, "desplazamiento", 1, 2))
  
})

testthat::test_that("Expect message when number of replicates exceed available replicates", {
  
  testthat::expect_message(read_replicates(right_dir, "reclutamiento", 90, 110), 
                           "There are only 100 replicates available. Authenticated and loaded replicates 90 to 100")
  
})

testthat::test_that("Expect message when first replicate is less than 1", {
  
  testthat::expect_message(read_replicates(right_dir, "reclutamiento", 0, 2), 
                           "First replicate available is replicate 1. Authenticated and loaded replicates 1 to 2")
  
})

testthat::test_that("Expect message when first replicate is less than 1 and last is more than 100", {
  
  testthat::expect_message(read_replicates(right_dir, "reclutamiento", 0, 101), 
                           "Replicates available go from 1 to 100. Authenticated and loaded replicates 1 to 100")
})

testthat::test_that("Function should return an error if the first_rep argument dos not have the correct format", {
  
  testthat::expect_error(read_replicates(right_dir, "reclutamiento", "1", 2))
  
})

testthat::test_that("Function should return an error if the last_rep argument dos not have the correct format", {
  
  testthat::expect_error(read_replicates(right_dir, "RECLUTAMIENTO", 1, "dos"))
  
})


# --- Done
