# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================
#
local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")
replicates_data_filter <- filter_standard_cev(replicates_data, "reclutamiento")

testthat::test_that("The table must have the same observations to CEV document", {

    sexo <- c("HOMBRE", "MUJER", NA_character_)
    observed <- c(8489, 3825, 2355)

    tab_cev <- cbind.data.frame(sexo, observed)

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

    testthat::expect_identical(tab_observed$observed, tab_cev$observed)

})


testthat::test_that("This function works with more than one strata", {

    testthat::expect_no_error(
        mtab_observed <- summary_observed("reclutamiento",
                                          replicates_data_filter,
                                          strata_vars = c("sexo", "etnia"),
                                          strata_vars_com = c("yy_hecho",
                                                              "dept_code_hecho"),
                                          conflict_filter = TRUE,
                                          is_conflict_na = TRUE,
                                          forced_dis = FALSE,
                                          is_forced_dis_na = TRUE,
                                          edad_minors = TRUE,
                                          edad_na = TRUE,
                                          perp_na = FALSE,
                                          sexo_na = FALSE,
                                          municipio_na = FALSE,
                                          etnia_na = FALSE))

})


testthat::test_that("This function works with strata does not have missing values", {

    testthat::expect_no_error(
        dtab_observed <- summary_observed("reclutamiento",
                                          replicates_data_filter,
                                          strata_vars_com = "dept_code_hecho",
                                          conflict_filter = TRUE,
                                          is_conflict_na = TRUE,
                                          forced_dis = FALSE,
                                          is_forced_dis_na = TRUE,
                                          edad_minors = TRUE,
                                          edad_na = TRUE,
                                          perp_na = FALSE,
                                          sexo_na = FALSE,
                                          municipio_na = FALSE,
                                          etnia_na = FALSE))
})



testthat::test_that("This function works with more than one strata that has missing values", {

    testthat::expect_no_error(
        strata_tab_observed <- summary_observed("reclutamiento",
                                                replicates_data_filter,
                                                strata_vars = c("p_str", "etnia"),
                                                conflict_filter = TRUE,
                                                is_conflict_na = TRUE,
                                                forced_dis = FALSE,
                                                is_forced_dis_na = TRUE,
                                                edad_minors = TRUE,
                                                edad_na = TRUE,
                                                perp_na = FALSE,
                                                sexo_na = FALSE,
                                                municipio_na = FALSE,
                                                etnia_na = FALSE))
})

testthat::test_that("This function works with more than one strata that does not has missing values", {

    testthat::expect_no_error(
        strata_tab_observed <- summary_observed("reclutamiento",
                                                replicates_data_filter,
                                                strata_vars_com = c("yy_hecho", "dept_code_hecho"),
                                                conflict_filter = TRUE,
                                                is_conflict_na = TRUE,
                                                forced_dis = FALSE,
                                                is_forced_dis_na = TRUE,
                                                edad_minors = TRUE,
                                                edad_na = TRUE,
                                                perp_na = FALSE,
                                                sexo_na = FALSE,
                                                municipio_na = FALSE,
                                                etnia_na = FALSE))
})

# --- Done
