# ============================================
# Authors:     PA
# Maintainers: PA, MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================
#
local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", c(1, 2), version = "v1")

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
                                     include_props = FALSE)

    testthat::has_names(c("sexo", "observed")) # should not have proportion columns
    testthat::expect_identical(tab_observed$observed, tab_cev$observed)

})


testthat::test_that("This function works with more than one stratification variable", {

    testthat::expect_no_error(
      tab_observed <- summary_observed("reclutamiento",
                                       replicates_data_filter,
                                       strata_vars = c("sexo", "yy_hecho"),
                                       conflict_filter = TRUE,
                                       forced_dis_filter = FALSE,
                                       edad_minors_filter = TRUE,
                                       include_props = FALSE))

})


testthat::test_that("This function works with stratification variables that do not have missing values", {

    testthat::expect_no_error(
        tab_observed <- summary_observed("reclutamiento",
                                          replicates_data_filter,
                                          strata_vars = "dept_code_hecho",
                                          conflict_filter = TRUE,
                                          forced_dis_filter = FALSE,
                                          edad_minors_filter = TRUE,
                                          include_props = FALSE))
})



testthat::test_that("This function works with more than one stratification variable that has missing values", {

    testthat::expect_no_error(
        tab_observed <- summary_observed("reclutamiento",
                                         replicates_data_filter,
                                         strata_vars = c("p_str", "etnia"),
                                         conflict_filter = TRUE,
                                         forced_dis_filter = FALSE,
                                         edad_minors_filter = TRUE,
                                         include_props = FALSE))
})

testthat::test_that("This function works with more than one stratification variable that does not have missing values", {

    testthat::expect_no_error(
        strata_tab_observed <- summary_observed("reclutamiento",
                                                replicates_data_filter,
                                                strata_vars = c("yy_hecho", "dept_code_hecho"),
                                                conflict_filter = TRUE,
                                                forced_dis_filter = FALSE,
                                                edad_minors_filter = TRUE,
                                                include_props = FALSE))
})

testthat::test_that("Confirm sum = 1 in observed and output has desired structure", {

  tab_observed <- summary_observed("reclutamiento",
                                   replicates_data_filter,
                                   strata_vars = "etnia",
                                   conflict_filter = TRUE,
                                   forced_dis_filter = FALSE,
                                   edad_minors_filter = TRUE,
                                   include_props = TRUE)

testthat::has_names(c("etnia", "observed", "obs_prop_no", "obs_prop"))
testthat::expect_equal(sum(tab_observed$obs_prop_na), 1)

})

testthat::test_that("The function must return an error if the user put another
                    violation that is different to: 'reclutamiento', 'desaparicion',
                    'homicidio' or 'secuestro'", {

                      testthat::expect_error(
                        tab_observed <- summary_observed("exilio",
                                                         replicates_data_filter,
                                                         strata_vars = "sexo",
                                                         conflict_filter = TRUE,
                                                         forced_dis_filter = FALSE,
                                                         edad_minors_filter = TRUE,
                                                         include_props = TRUE))
})

testthat::test_that("The function must return an error if the user put
                    information that is not a data frame", {

  not_data_frame <- replicates_data_filter %>%
    as.list()
                      testthat::expect_error(
                        tab_observed <- summary_observed("reclutamiento",
                                                         not_data_frame,
                                                         strata_vars = "sexo",
                                                         conflict_filter = TRUE,
                                                         forced_dis_filter = FALSE,
                                                         edad_minors_filter = TRUE,
                                                         include_props = TRUE))
})


testthat::test_that("The function must return an error if the user put a variable
                    that does not exist in the currently data frame", {

                      testthat::expect_error(
                        tab_observed <- summary_observed("reclutamiento",
                                                         replicates_data_filter,
                                                         strata_vars = "regiones_naturales",
                                                         conflict_filter = TRUE,
                                                         forced_dis_filter = FALSE,
                                                         edad_minors_filter = TRUE,
                                                         include_props = TRUE))
})

testthat::test_that("The function must return an error if the user put
                    forced_dis_filter = TRUE and the violation is different to
                    desaparicion", {

                      testthat::expect_error(
                        tab_observed <- summary_observed("reclutamiento",
                                                         replicates_data_filter,
                                                         strata_vars = "sexo",
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
                        tab_observed <- summary_observed("reclutamiento",
                                                         replicate_data,
                                                         strata_vars = "sexo",
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
                                 include_props = TRUE)

testthat::test_that("The function must return an error if the user input
                    information that is not a data frame in prop's function", {

                      not_data_frame <- tab_observed %>%
                        as.list()

                      testthat::expect_error(
                          proportions_table <- proportions_observed(not_data_frame,
                                                                    strata_vars = "sexo",
                                                                    digits = 3))
                    })

# --- Done
