#
# Authors:     MG
# Maintainers: MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

library(dplyr)

set.seed(19481210)

in_A <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.45, 0.65))
in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))
in_C <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.75, 0.25))
in_D <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(1, 0))


testthat::test_that("get_valid_sources returns correct results", {

    testthat::skip_on_cran()

    stratum_1 <- tibble::tibble(in_A, in_B, in_C, in_D)
    testthat::expect_true(setequal(get_valid_sources(stratum_1),
                                   c("in_A", "in_B", "in_C")))
    testthat::expect_error(get_valid_sources(stratum_1, min_n = "X"))
    testthat::expect_error(get_valid_sources(stratum_1, min_n = -1))

    stratum_2 <- tibble::tibble(in_D)
    testthat::expect_true(setequal(get_valid_sources(stratum_2), c()))

})


testthat::test_that("internal run_lcmcr function returns correct results for
                    estimable and non-estimable strata", {

                        testthat::skip_on_cran()

                        stratum_1 <- tibble::tibble(in_A, in_B, in_C, in_D) %>%
                            dplyr::mutate(rs = rowSums(.)) %>%
                            dplyr::filter(rs >= 1) %>%
                            dplyr::select(-rs)
                        r1 <- run_lcmcr(stratum_data_prepped = stratum_1, stratum_name = "stratum 1",
                                        K = 4, buffer_size = 10000, sampler_thinning = 1000,
                                        seed = 19481210, burnin = 10000, n_samples = 10000,
                                        posterior_thinning = 500)

                        testthat::expect_equal(nrow(r1), 1000)
                        testthat::expect_named(r1, c("N", "valid_sources", "stratum_name"))
                        testthat::expect_equal(round(mean(r1$N), 0), 106)
                        testthat::expect_equal(round(var(r1$N), 0), 46)

                        stratum_2 <- tibble::tibble(in_A, in_B) %>%
                            dplyr::mutate(rs = rowSums(.)) %>%
                            dplyr::filter(rs >= 1) %>%
                            dplyr::select(-rs)
                        testthat::expect_error({run_lcmcr(stratum_recs = stratum_2,
                                                          stratum_name = "stratum 2",
                                                          K = 4, buffer_size = 10000,
                                                          sampler_thinning = 1000,
                                                          seed = 19481210,
                                                          burnin = 10000,
                                                          n_samples = 10000,
                                                          posterior_thinning = 500)})


                    })


testthat::test_that("mse function returns correct results for estimable and non-estimable strata", {

    testthat::skip_on_cran()

    stratum_1 <- tibble::tibble(in_A, in_B, in_C, in_D)
    r1 <- mse(stratum_data = stratum_1,
              stratum_name = "stratum 1",
              K = 4,
              seed = 19481210)

    testthat::expect_equal(nrow(r1), 1000)
    testthat::expect_named(r1, c("validated", "N", "valid_sources", "n_obs", "stratum_name"))
    testthat::expect_equal(round(mean(r1$N), 0), 105)
    testthat::expect_equal(round(var(r1$N), 0), 82)
    testthat::expect_true(all(r1$N >= r1$n_obs))

    stratum_2 <- tibble::tibble(in_A, in_B)
    r2 <- mse(stratum_data = stratum_2,
              stratum_name = "stratum 2",
              K = 4,
              seed = 19481210)

    testthat::expect_equal(nrow(r2), 1)
    testthat::expect_named(r2, c("validated", "N", "valid_sources", "n_obs", "stratum_name"))
    testthat::expect_equal(r2$validated, FALSE)
    testthat::expect_equal(r2$N, NA_real_)
    testthat::expect_equal(r2$valid_sources, "in_A,in_B")
    testthat::expect_equal(r2$n_obs, NA_real_)
    testthat::expect_equal(r2$stratum_name, "stratum 2")

})


testthat::test_that("mse function returns correct results when using lookup functionality", {

    testthat::skip_on_cran()

    local_dir <- system.file("extdata", "right", package = "verdata")
    replicates <- read_replicates(local_dir, "reclutamiento", replicate_nums = 1,
                                  version = "v1", crash = 1)

    estimates_dir <- system.file("extdata", "estimates", package = "verdata")

    # pre-calculated stratum
    stratum_3 <- replicates %>%
        dplyr::filter(sexo == "HOMBRE",
                      yy_hecho == 1999,
                      replica == "R1") %>%
        dplyr::select(tidyselect::starts_with("in_"))

    # there are warnings here because our toy estimates directory does not contain
    # the same number of files as the real estimates directory would
    r3 <- mse(stratum_data = stratum_3,
              stratum_name = "stratum 3",
              estimates_dir = estimates_dir)

    testthat::expect_equal(nrow(r3), 1000)
    testthat::expect_named(r3, c("validated", "N", "valid_sources", "n_obs", "stratum_name"))
    testthat::expect_equal(round(mean(r3$N), 0), 2066)

    # not pre-calculated
    stratum_4 <- replicates %>%
        dplyr::filter(sexo == "HOMBRE",
                      yy_hecho == 1998,
                      dept_code_hecho == 81,
                      replica == "R1") %>%
        dplyr::select(tidyselect::starts_with("in_"))

    # there are warnings here because our toy estimates directory does not contain
    # the same number of files as the real estimates directory would
    r4 <- mse(stratum_data = stratum_4,
              stratum_name = "stratum 4",
              estimates_dir = estimates_dir)

    testthat::expect_equal(nrow(r4), 1000)
    testthat::expect_named(r4, c("validated", "N", "valid_sources", "n_obs", "stratum_name"))

})

testthat::test_that("mse function returns errors when inputs are misspecified", {

    testthat::skip_on_cran()

    local_dir <- system.file("extdata", "right", package = "verdata")
    replicates <- read_replicates(local_dir, "reclutamiento", replicate_nums = 1,
                                  version = "v1", crash = 1)

    stratum_5 <- replicates %>%
        dplyr::select(-tidyselect::starts_with("in_"))

    testthat::expect_error(mse(stratum_data = stratum_5,
                               stratum_name = "stratum 5"))

    stratum_6 <- replicates%>%
        dplyr::filter(sexo == "HOMBRE",
                      yy_hecho == 1998,
                      dept_code_hecho == 81,
                      replica == "R1")

    testthat::expect_error(mse(stratum_data = stratum_6,
                               stratum_name = "stratum 6",
                               posterior_thinning = "X"))

})

testthat::test_that("lookup function correctly finds strata that have and have not been estimated", {

    testthat::skip_on_cran()

    local_dir <- system.file("extdata", "right", package = "verdata")
    replicates <- read_replicates(local_dir, "reclutamiento", replicate_nums = 1,
                                  version = "v1", crash = 1)

    estimates_dir <- system.file("extdata", "estimates", package = "verdata")

    # pre-calculated stratum; same as from earlier test
    stratum_7 <- replicates %>%
        dplyr::filter(sexo == "HOMBRE",
                      yy_hecho == 1999,
                      replica == "R1") %>%
        dplyr::select(tidyselect::starts_with("in_"))

    r7 <- estimates_exist(stratum_data = stratum_7,
                          estimates_dir = estimates_dir)

    testthat::expect_named(r7, c("estimates_exist", "estimates_path"))
    testthat::expect_equal(r7$estimates_exist, TRUE)

    # not pre-calculated; from previous example
    stratum_8 <- replicates %>%
        dplyr::filter(sexo == "HOMBRE",
                      yy_hecho == 1998,
                      dept_code_hecho == 81,
                      replica == "R1") %>%
        dplyr::select(tidyselect::starts_with("in_"))

    r8 <- estimates_exist(stratum_data = stratum_8,
                          estimates_dir = estimates_dir)

    testthat::expect_named(r8, c("estimates_exist", "estimates_path"))
    testthat::expect_equal(r8$estimates_exist, FALSE)
    testthat::expect_equal(r8$estimates_path, NA_character_)

})


# done.
