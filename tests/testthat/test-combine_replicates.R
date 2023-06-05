# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "rcodata")

replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")

replicates_data_filter <- filter_standard_cev(replicates_data, "reclutamiento")

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 strata_vars_com = "yy_hecho",
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

testthat::test_that("The imp_lo can't be less from observed and
                    can't be bigger than imp_mean" , {

                        strata_vars_rep <- c("yy_hecho", "sexo")

                        tab_combine <- combine_replicates("reclutamiento", tab_observed,
                                                          replicates_data_filter, strata_vars_rep,
                                                          conflict_filter = TRUE,
                                                          forced_dis = FALSE,
                                                          edad_minors = TRUE)

                        testthat::expect_error(stop(tab_combine$imp_lo < tab_combine$observed))
                        testthat::expect_error(stop(tab_combine$imp_lo > tab_combine$imp_mean))


                    })

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

testthat::test_that("The function works to one strata" , {

    testthat::expect_no_error(
        tab_combine <- combine_replicates("reclutamiento",
                                          tab_observed,
                                          replicates_data,
                                          strata_vars_rep = "sexo",
                                          conflict_filter = TRUE,
                                          forced_dis = FALSE,
                                          edad_minors = TRUE))
})

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 strata_vars_com = "yy_hecho",
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

testthat::test_that("The function works to more than one strata" , {

    testthat::expect_no_error(
        tab_combine <- combine_replicates("reclutamiento",
                                          tab_observed,
                                          replicates_data,
                                          strata_vars_rep = c("sexo", "yy_hecho"),
                                          conflict_filter = TRUE,
                                          forced_dis = FALSE,
                                          edad_minors = TRUE))
})

# --- Done
