# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", c(1, 2), version = "v1")

replicates_data_filter <- filter_standard_cev(replicates_data,
                                              "reclutamiento",
                                              perp_change = TRUE)

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 conflict_filter = TRUE,
                                 forced_dis_filter = FALSE,
                                 edad_minors_filter = TRUE,
                                 include_props = FALSE)

testthat::test_that("The imp_lo can't be less from observed and
                    can't be bigger than imp_mean" , {

                      tab_combine <- combine_replicates("reclutamiento",
                                                        tab_observed,
                                                        replicates_data_filter,
                                                        strata_vars = "sexo",
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
                                 include_props = FALSE)

testthat::test_that("The function works to one strata" , {

    testthat::expect_no_error(
      tab_combine <- combine_replicates("reclutamiento",
                                        tab_observed,
                                        replicates_data_filter,
                                        strata_vars = "sexo",
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
                                 include_props = FALSE)

testthat::test_that("The function works to more than one strata" , {

    testthat::expect_no_error(
        tab_combine <- combine_replicates("reclutamiento",
                                          tab_observed,
                                          replicates_data_filter,
                                          strata_vars = c("sexo", "yy_hecho"),
                                          conflict_filter = TRUE,
                                          forced_dis_filter = FALSE,
                                          edad_minors_filter = TRUE,
                                          include_props = FALSE))
})

tab_observed <- summary_observed("reclutamiento",
                                 replicates_data_filter,
                                 strata_vars = "sexo",
                                 conflict_filter = TRUE,
                                 forced_dis_filter = FALSE,
                                 edad_minors_filter = TRUE,
                                 include_props = FALSE)

testthat::test_that("The function must return an error if the user put another
                    violation that is different to: 'reclutamiento', 'desaparicion',
                    'homicidio' or 'secuestro'", {

                      testthat::expect_error(
                        tab_combine <- combine_replicates("desplazamiento_forzado",
                                                          tab_observed,
                                                          replicates_data,
                                                          strata_vars = "sexo",
                                                          conflict_filter = TRUE,
                                                          forced_dis_filter = FALSE,
                                                          edad_minors_filter = TRUE,
                                                          include_props = FALSE))
                    })

testthat::test_that("The function must return an error if the user put
                    information that is not a data frame", {

                      not_data_frame <- replicates_data_filter %>%
                        as.list()

                      testthat::expect_error(
                        tab_combine <- combine_replicates("reclutamiento",
                                                          tab_observed,
                                                          not_data_frame,
                                                          strata_vars = "sexo",
                                                          conflict_filter = TRUE,
                                                          forced_dis_filter = FALSE,
                                                          edad_minors_filter = TRUE,
                                                          include_props = FALSE))
                    })


testthat::test_that("The function must return an error if the user put
                    information that is not a data frame (observed data)", {

                      not_data_frame <- tab_observed %>%
                        as.list()

                      testthat::expect_error(
                        tab_combine <- combine_replicates("reclutamiento",
                                                          not_data_frame,
                                                          replicates_data_filter,
                                                          strata_vars = "sexo",
                                                          conflict_filter = TRUE,
                                                          forced_dis_filter = FALSE,
                                                          edad_minors_filter = TRUE,
                                                          include_props = FALSE))
                    })


testthat::test_that("The function must return an error if the user put a variable
                    that does not exist in the currently data frame", {

                      testthat::expect_error(
                        tab_combine <- combine_replicates("reclutamiento",
                                                          tab_observed,
                                                          replicates_data_filter,
                                                          strata_vars = "municipios_santander",
                                                          conflict_filter = TRUE,
                                                          forced_dis_filter = FALSE,
                                                          edad_minors_filter = TRUE,
                                                          include_props = FALSE))
                    })

testthat::test_that("The function must return an error if the user put
                    forced_dis_filter = TRUE and the violation is different to
                    desaparicion", {

                      testthat::expect_error(
                        tab_combine <- combine_replicates("reclutamiento",
                                                          tab_observed,
                                                          replicates_data_filter,
                                                          strata_vars = "etnia",
                                                          conflict_filter = TRUE,
                                                          forced_dis_filter = TRUE,
                                                          edad_minors_filter = TRUE,
                                                          include_props = FALSE))
                    })

testthat::test_that("The function must return an error if the user try to work with
                    only 1 replicate", {

                      replicate_data <- replicates_data_filter %>%
                        filter(replica == "R1")

                      testthat::expect_error(
                        tab_combine <- combine_replicates("reclutamiento",
                                                          tab_observed,
                                                          replicate_data,
                                                          strata_vars = "sexo",
                                                          conflict_filter = TRUE,
                                                          forced_dis_filter = FALSE,
                                                          edad_minors_filter = TRUE,
                                                          include_props = FALSE))
                    })

tab_combine <- combine_replicates("reclutamiento",
                                  tab_observed,
                                  replicates_data_filter,
                                  strata_vars = "sexo",
                                  conflict_filter = TRUE,
                                  forced_dis_filter = FALSE,
                                  edad_minors_filter = TRUE,
                                  include_props = FALSE)


testthat::test_that("The function should run if more than two decimal places are specified,
                    but it should fail if negative decimal places are specified", {

                      testthat::expect_no_error(
                        proportions_table <- proportions_imputed(tab_combine,
                                                                 strata_vars = "sexo",
                                                                 digits = 3))

                        testthat::expect_error(
                            proportions_table <- proportions_imputed(tab_combine,
                                                                     strata_vars = "sexo",
                                                                     digits = -3))
                    })

testthat::test_that("The function must return an error if the user put
                    information that is not a data frame in prop's function", {

                      not_data_frame <- tab_combine %>%
                        as.list()

                      testthat::expect_error(
                        proportions_table <- proportions_imputed(not_data_frame,
                                                                  strata_vars = "sexo",
                                                                  digits = 2))
                    })

# --- Done
