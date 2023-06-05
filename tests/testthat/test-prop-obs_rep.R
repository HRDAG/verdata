# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")

replicates_data_filter <- filter_standard_cev(replicates_data, "reclutamiento")

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 conflict_filter = TRUE,
                                 is_conflict_na = TRUE,
                                 forced_dis = FALSE,
                                 is_forced_dis_na = TRUE,
                                 edad_minors = TRUE,
                                 edad_na = TRUE,
                                 perp_na = FALSE,
                                 sexo_na = FALSE,
                                 municipio_na = FALSE,
                                 etnia_na = FALSE)

tab_combine <- combine_replicates("reclutamiento", tab_observed,
                                  replicates_data_filter, "sexo",
                                  conflict_filter = TRUE,
                                  forced_dis = FALSE,
                                  edad_minors = TRUE)

testthat::test_that("Confirm sum in observed", {

    prop_data <- prop_obs_rep(tab_combine, "sexo", na_obs = TRUE, digits = 2)

    testthat::expect_equal(sum(prop_data$obs_prop_na), 1)

})

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars_com = "dept_code_hecho",
                                 strata_vars = "sexo",
                                 conflict_filter = TRUE,
                                 is_conflict_na = TRUE,
                                 forced_dis = FALSE,
                                 is_forced_dis_na = TRUE,
                                 edad_minors = TRUE,
                                 edad_na = TRUE,
                                 perp_na = FALSE,
                                 sexo_na = FALSE,
                                 municipio_na = FALSE,
                                 etnia_na = FALSE)

strata_vars_rep <- c("dept_code_hecho", "sexo")

tab_combine <- combine_replicates("reclutamiento", tab_observed,
                                  replicates_data_filter, strata_vars_rep,
                                  conflict_filter = TRUE,
                                  forced_dis = FALSE,
                                  edad_minors = FALSE)

testthat::test_that("Works with any digit", {

    prop_data <- prop_obs_rep(tab_combine, strata_vars_rep, na_obs = TRUE,
                              digits = 9)

    testthat::expect_equal(round(sum(prop_data$obs_prop_na), 9), round(1, 9))

})

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars_com = "yy_hecho",
                                 strata_vars = "etnia",
                                 conflict_filter = TRUE,
                                 is_conflict_na = TRUE,
                                 forced_dis = FALSE,
                                 is_forced_dis_na = TRUE,
                                 edad_minors = TRUE,
                                 edad_na = TRUE,
                                 perp_na = FALSE,
                                 sexo_na = FALSE,
                                 municipio_na = FALSE,
                                 etnia_na = FALSE)


strata_vars_rep <- c("yy_hecho", "etnia")
tab_combine <- combine_replicates("reclutamiento", tab_observed,
                                  replicates_data_filter, strata_vars_rep,
                                  conflict_filter = TRUE,
                                  forced_dis = FALSE,
                                  edad_minors = TRUE)

testthat::test_that("Confirm sum in observed", {

    prop_data <- prop_obs_rep(tab_combine,  strata_vars_rep, na_obs = TRUE, digits = 9)

    testthat::expect_equal(round(sum(prop_data$obs_prop_na, na.rm = TRUE), 9), round(1, 9))

})

testthat::test_that("The function works without digist", {

testthat::expect_no_error(

    prop_data <- prop_obs_rep(tab_combine,  strata_vars_rep, na_obs = TRUE))

})
