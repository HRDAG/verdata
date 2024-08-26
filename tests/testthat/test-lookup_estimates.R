# ============================================
# Authors:     MJ
# Maintainers: MJ, MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "verdata")
replicates <- read_replicates(local_dir, "reclutamiento", replicate_nums = 1,
                              version = "v1", crash = 1)

estimates_dir <- system.file("extdata", "estimates", package = "verdata")

in_A <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.45, 0.65))
in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))
in_C <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.75, 0.25))
in_D <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(1, 0))
not_in_E <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(1, 0))

bad_columns <- tibble::tibble(in_A, in_B, in_C, in_D, not_in_E) %>%
  dplyr::mutate(rs = rowSums(.)) %>%
  dplyr::filter(rs >= 1) %>%
  dplyr::select(-rs)

in_A <- sample(c(0, 2), size = 100, replace = TRUE, prob = c(0.45, 0.65))
in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))

wrong_stratum <- tibble::tibble(in_A, in_B) %>%
  dplyr::mutate(rs = rowSums(.)) %>%
  dplyr::select(-rs)

in_A <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.45, 0.65))
in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))

my_stratum <- tibble::tibble(in_A, in_B) %>%
  dplyr::mutate(rs = rowSums(.)) %>%
  dplyr::filter(rs >= 1) %>%
  dplyr::select(-rs)

testthat::test_that("Lookup existing estimates", {

    estrato <- replicates %>%
        dplyr::filter(sexo == "HOMBRE",
                      yy_hecho == 1999,
                      replica == "R1") %>%
        dplyr::select(tidyselect::starts_with("in_"))

    estimates <- lookup_estimates(estrato, estimates_dir)

    testthat::expect_equal(nrow(estimates), 1000)
    testthat::expect_named(estimates, "N")
    testthat::expect_equal(round(mean(estimates$N), 0), 2066)

})

testthat::test_that("Lookup non existing estimates", {

    estrato <- replicates %>%
        dplyr::filter(sexo == "HOMBRE",
                      yy_hecho == 1998,
                      replica == "R1") %>%
        dplyr::select(tidyselect::starts_with("in_"))

    no_estimates <- lookup_estimates(estrato, estimates_dir)

    testthat::expect_equal(nrow(no_estimates), 1)
    testthat::expect_named(no_estimates, "N")
    testthat::expect_equal(no_estimates$N, NA_real_)

})


testthat::test_that("Return error if the stratum cantains values different ti 0 and 1", {

  testthat::expect_error(lookup_estimates(wrong_stratum, estimates_dir))

})

testthat::test_that("Return error if the data frame includes columns different to `in_`", {

  testthat::expect_error(lookup_estimates(bad_columns, estimates_dir))

})

testthat::test_that("Return warning if the estimates directory does not have all files", {

  testthat::expect_warning(lookup_estimates(my_stratum, estimates_dir))

})

# --- Done
