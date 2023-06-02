#
# Authors:     MG
# Maintainers: MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

library(rjson)
library(stringr)
library(dplyr)
library(purrr)

local_dir <- system.file("extdata", "right", package = "verdata")
estimates_dir <- system.file("extdata", "estimates", package = "verdata")
estimates_files <- list.files(estimates_dir, "json", recursive = TRUE, full.names = TRUE)

# manually log additional stratum info necessary for combination
strata_data <- tibble::tribble(~stratum_id, ~replicate, ~n_obs,
                               "5743e3434235299ef53ed840b2578e666663f69d",       "R1",   982,
                               "a069cdd0891259cd718098cc887c04ed08a1e0b2",       "R2",  1045,
                               "1dc716c454eced873e4666c1c9f90625815f971b",       "R3",  1026,
                               "c4a39d1cd8a3c4acd09c183d0362700d822794cc",       "R4",  1125,
                               "5e8aad5db295dc2f76ae3cf1c0f2d5ace36214bd",       "R5",  1040,
                               "b3d988f582d586c5627e923a474311b454592c13",       "R6",  1073,
                               "e984307405829f4d1b61bca97518091c94adec1c",       "R7",  1056,
                               "1e924439f85f77f16ba122a7555a5d2d368fcb4c",       "R8",  1025,
                               "558bc2e574a8c0a213e6739445eec3dd2be09876",       "R9",  1088,
                               "6a2bf305204d2cfce094d1eb3dfb4aa9c3e96f25",      "R10",  1025,
                               "8045fff8e390ab07211c034c535ed4f8f9c3972a",      "R11",   921,
                               "a85d55121914165aa0f698a52f6e8d7e5291a92b",      "R12",   931,
                               "2f8e9725587984f14102aaa7fd6aa3d3cf4f6cd6",      "R13",   934,
                               "275a59d4a8447ac589faa4b7e50616f7d9ad21ae",      "R14",   937,
                               "b3202d259f0717e003fc061a09c93282594c4255",      "R15",   942,
                               "e741c6568a1b5b88326449fce845ee993e605ab7",      "R16",   932,
                               "1762abe42f1b9eaa80b09d6acb936235df1bbd16",      "R17",   927,
                               "6b80e485b31141b3a986c785784da3eb0e4a1eca",      "R18",   937,
                               "9cf5a8772da806058e09727fb6f68caa807a03a1",      "R19",   936,
                               "1122e37172ef875c7272fd11b679739eb1e7e485",      "R20",   938)


read_and_format <- function(file_path) {

    tibble(N = fromJSON(file = file_path)) %>%
        mutate(stratum_id = str_remove(str_extract(file_path, "([a-z0-9]+)\\.json"), "\\.json"))

}


replicate_nums <- paste0("R", 1:20)
estimates <- map_dfr(.x = estimates_files,
                     ~read_and_format(file_path = .x)) %>%
    left_join(strata_data, by = "stratum_id")

testthat::test_that("Testing estimate done using only one replicate", {

    testthat::expect_warning(estimates %>% filter(replicate == "R1") %>%
                                 combine_estimates(.))

    options(warn = -1)
    r1 <- estimates %>% filter(replicate == "R1") %>%
        combine_estimates(.)
    options(warn = 0)

    testthat::expect_equal(nrow(r1), 1)
    testthat::expect_named(r1, c("N_025", "N_mean", "N_975"))
    testthat::expect_equal(r1$N_025, NA_real_)
    testthat::expect_equal(r1$N_mean, NA_real_)
    testthat::expect_equal(r1$N_975, NA_real_)

})


testthat::test_that("Testing combination", {

    r3 <- combine_estimates(estimates)

    testthat::expect_equal(nrow(r3), 1)
    testthat::expect_named(r3, c("N_025", "N_mean", "N_975"))
    testthat::expect_equal(r3$N_025, 1266)
    testthat::expect_equal(r3$N_mean, 1593)
    testthat::expect_equal(r3$N_975, 2148)

})

# done.
