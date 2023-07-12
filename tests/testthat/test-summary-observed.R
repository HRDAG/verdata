# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================
#
local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2)
replicates_data_filter <- filter_standard_cev(replicates_data, 
                                              "reclutamiento", 
                                              perp_change = TRUE)

testthat::test_that("The table must have the same observations to CEV document", {

    sexo <- c("HOMBRE", "MUJER", NA_character_)
    observed <- c(8489, 3825, 2355)

    tab_cev <- cbind.data.frame(sexo, observed)

    tab_observed <- summary_observed("reclutamiento",
                                     replicates_data_filter,
                                     strata_vars = "sexo",
                                     conflict_filter = TRUE,
                                     forced_dis_filter = FALSE,
                                     edad_minors_filter = TRUE,
                                     include_props = FALSE,
                                     include_props_na = FALSE)

    testthat::expect_identical(tab_observed$observed, tab_cev$observed)

})


testthat::test_that("This function works with more than one strata", {

    testthat::expect_no_error(
      tab_observed <- summary_observed("reclutamiento",
                                       replicates_data_filter,
                                       strata_vars = c("sexo", "yy_hecho"),
                                       conflict_filter = TRUE,
                                       forced_dis_filter = FALSE,
                                       edad_minors_filter = TRUE,
                                       include_props = FALSE,
                                       include_props_na = FALSE))

})


testthat::test_that("This function works with strata does not have missing values", {

    testthat::expect_no_error(
        tab_observed <- summary_observed("reclutamiento",
                                          replicates_data_filter,
                                          strata_vars = "dept_code_hecho",
                                          conflict_filter = TRUE,
                                          forced_dis_filter = FALSE,
                                          edad_minors_filter = TRUE,
                                          include_props = FALSE,
                                          include_props_na = FALSE))
})



testthat::test_that("This function works with more than one strata that has missing values", {

    testthat::expect_no_error(
        tab_observed <- summary_observed("reclutamiento",
                                         replicates_data_filter,
                                         strata_vars = c("p_str", "etnia"),
                                         conflict_filter = TRUE,
                                         forced_dis_filter = FALSE,
                                         edad_minors_filter = TRUE,
                                         include_props = FALSE,
                                         include_props_na = FALSE))
})

testthat::test_that("This function works with more than one strata that does not has missing values", {

    testthat::expect_no_error(
        strata_tab_observed <- summary_observed("reclutamiento",
                                                replicates_data_filter,
                                                strata_vars = c("yy_hecho", "dept_code_hecho"),
                                                conflict_filter = TRUE,
                                                forced_dis_filter = FALSE,
                                                edad_minors_filter = TRUE,
                                                include_props = FALSE,
                                                include_props_na = FALSE))
})

testthat::test_that("Confirm sum = 1 in observed", {
  
  tab_observed <- summary_observed("reclutamiento",
                                   replicates_data_filter,
                                   strata_vars = "etnia",
                                   conflict_filter = TRUE,
                                   forced_dis_filter = FALSE,
                                   edad_minors_filter = TRUE,
                                   include_props = TRUE,
                                   include_props_na = TRUE)

testthat::expect_equal(sum(tab_observed$obs_prop_na), 1)

})

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 conflict_filter = TRUE,
                                 forced_dis_filter = FALSE,
                                 edad_minors_filter = TRUE,
                                 include_props = FALSE,
                                 include_props_na = FALSE)

# --- Done
