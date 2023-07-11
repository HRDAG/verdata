# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2)

replicates_data_filter <- filter_standard_cev(replicates_data, 
                                              "reclutamiento", 
                                              perp_change = TRUE)

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 conflict_filter = TRUE,
                                 forced_dis_filter = FALSE,
                                 edad_minors_filter = TRUE,
                                 include_props = TRUE,
                                 include_props_na = TRUE)

testthat::test_that("The imp_lo can't be less from observed and
                    can't be bigger than imp_mean" , {

                      tab_combine <- combine_replicates("reclutamiento",
                                                        tab_observed,
                                                        replicates_data_filter, 
                                                        "sexo",
                                                        conflict_filter = TRUE,
                                                        forced_dis_filter = FALSE,
                                                        edad_minors_filter = FALSE,
                                                        include_props = TRUE)

                        testthat::expect_error(stop(tab_combine$imp_lo < tab_combine$observed))
                        testthat::expect_error(stop(tab_combine$imp_lo > tab_combine$imp_mean))


                    })

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 conflict_filter = TRUE,
                                 forced_dis_filter = FALSE,
                                 edad_minors_filter = TRUE,
                                 include_props = FALSE,
                                 include_props_na = FALSE)

testthat::test_that("The function works to one strata" , {

    testthat::expect_no_error(
      tab_combine <- combine_replicates("reclutamiento",
                                        tab_observed,
                                        replicates_data_filter, 
                                        "sexo",
                                        conflict_filter = TRUE,
                                        forced_dis_filter = FALSE,
                                        edad_minors_filter = FALSE,
                                        include_props = FALSE))
})

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = c("sexo", "yy_hecho"),
                                 conflict_filter = TRUE,
                                 forced_dis_filter = FALSE,
                                 edad_minors_filter = TRUE,
                                 include_props = FALSE,
                                 include_props_na = FALSE)

testthat::test_that("The function works to more than one strata" , {

    testthat::expect_no_error(
        tab_combine <- combine_replicates("reclutamiento",
                                          tab_observed,
                                          replicates_data,
                                          strata_vars = c("sexo", "yy_hecho"),
                                          conflict_filter = TRUE,
                                          forced_dis_filter = FALSE,
                                          edad_minors_filter = TRUE))
})


tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 conflict_filter = TRUE,
                                 forced_dis_filter = FALSE,
                                 edad_minors_filter = TRUE,
                                 include_props = FALSE,
                                 include_props_na = FALSE)

tab_combine <- combine_replicates("reclutamiento",
                                  tab_observed,
                                  replicates_data_filter, 
                                  strata_vars = "sexo",
                                  conflict_filter = TRUE,
                                  forced_dis_filter = FALSE,
                                  edad_minors_filter = FALSE,
                                  include_props = FALSE)

testthat::test_that("The proportions' function does not work with a different digit (2)", {
  
  testthat::expect_error(
    tab_proportions <- verdata::proportions_imputed(tab_combine, 
                                                    strata_vars = "sexo",
                                                    digits = 4)
    
  )
  
})

# --- Done
