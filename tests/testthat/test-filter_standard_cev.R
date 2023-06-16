# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 1)
expected <- filter_standard_cev(replicates_data, "reclutamiento")

testthat::test_that("Function CEV works", {

    d1 <- 16378
    testthat::expect_equal(nrow(expected), d1)

})

testthat::test_that("This function filter the correct years for Reclutamiento", {

    years <- c(1990:2017)

    years_unique <- expected %>%
        dplyr::select(yy_hecho) %>%
        dplyr::arrange(yy_hecho) %>%
        base::unique()

    testthat::expect_equal(unique(years_unique$yy_hecho), years)

})

# --- Done
