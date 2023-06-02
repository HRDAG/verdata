# ============================================
# Authors:     MJ
# Maintainers: MJ, MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "verdata")
replicates <- read_replicates(local_dir, "reclutamiento", 1, 1, "csv")

estimates_dir <- system.file("extdata", "estimates", package = "verdata")

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

# --- Done
