# ============================================
# Authors:     MG
# Maintainers: MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' @title combine_estimates
#'
#' @description Combine MSE estimations results for a given stratum calculated
#' using multiple replicate files created using multiple imputation. Combination
#' is done using the standard approach that makes use of the laws of total
#' expectation and total variance.
#'
#' @param stratum_estimates A data frame of estimates for a stratum of interest
#' calculated using `mse` for all replicates being used for the analysis. The
#' data frame should have columns `N` and `n_obs` from the `mse` function and an
#' additional column `replicate` indicating which replicate the estimates were
#' calculated on.
#'
#' @return A data frame row with the point estimate (`N_mean`) and the
#' associated 95% uncertainty interval (lower bound is `N_025`, upper bound is
#' `N_975`).
#' @export
#' @importFrom dplyr "%>%"
#' @importFrom Rdpack reprompt
#'
#' @references
#' \insertRef{BDA3}{verdata}
#'
#' @examples
#' \dontrun{
#' set.seed(19481210)
#'
#' library(dplyr)
#' library(purrr)
#' library(glue)
#'
#'
#' simulate_estimates <- function(stratum_data, replicate_num) {
#'
#'     # simulate an imputed stratification variable to determine whether a record
#'     # should be considered part of the stratum for estimation
#'     stratification_var <- sample(c(0, 1), size = 100,
#'                                  replace = TRUE, prob = c(0.1, 0.9))
#'
#'     my_stratum <- bind_cols(my_stratum, tibble::tibble(stratification_var)) %>%
#'         filter(stratification_var == 1)
#'
#'     results <- mse(my_stratum, "my_stratum", K = 4) %>%
#'         mutate(replicate = replicate_num)
#'
#'     return(results)
#'
#' }
#'
#'
#' in_A <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.45, 0.65))
#' in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))
#' in_C <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.75, 0.25))
#'
#' my_stratum <- tibble::tibble(in_A, in_B, in_C)
#'
#' replicate_nums <- glue("R{1:20}")
#'
#' estimates <- map_dfr(.x = replicate_nums,
#'              .f = ~simulate_estimates(stratum_data = my_stratum, replicate_num = .x))
#'
#' combine_estimates(estimates)
#'
#' }
combine_estimates <- function(stratum_estimates) {

    # prep replicate data
    estimates_df <- stratum_estimates %>%
        assertr::verify(assertr::has_all_names("N", "replicate", "n_obs")) %>%
        dplyr::mutate(n_0 = N - n_obs) %>%
        assertr::verify(all(n_0 >= 0))

    # calculate number of replicates
    num_replicates <- dplyr::n_distinct(estimates_df$replicate)

    if (num_replicates == 1) {

        warning("encountered stratum estimated using only one replicate; setting results to NA")

        return(tibble::tibble(N_025 = NA_integer_,
                              N_mean = NA_integer_,
                              N_975 = NA_integer_))

    }

    if (num_replicates < 10) {

        warning("stratum estimated with fewer than 10 replicates, results may be unreliable")

    }

    # calculate mean n_obs to be used for CI construction
    n_obs <- estimates_df %>%
        dplyr::select(n_obs, replicate) %>%
        dplyr::distinct() %>%
        dplyr::pull(n_obs) %>%
        mean() %>%
        round(0)

    # mean - law of total expectation
    total_mean <- estimates_df %>%
        dplyr::group_by(replicate) %>%
        dplyr::summarize(within_mean = mean(n_0)) %>%
        dplyr::summarize(total_mean = round(mean(within_mean), 0)) %>%
        dplyr::pull(total_mean)

    # log transform data for variance calculation
    log_df <- estimates_df %>%
        dplyr::mutate(n_0 = if_else(n_0 == 0, 0.1, n_0)) %>%
        dplyr::mutate(log_n_0 = log(n_0)) %>%
        dplyr::select(log_n_0, replicate)

    # total mean of log
    total_mean_log <- log_df %>%
        dplyr::group_by(replicate) %>%
        dplyr::summarize(within_mean = mean(log_n_0)) %>%
        dplyr::summarize(total_mean = mean(within_mean)) %>%
        dplyr::pull(total_mean)

    # calculate within replicate variance
    within_variance_log <- log_df %>%
        dplyr::group_by(replicate) %>%
        dplyr::summarize(within_variance = stats::var(log_n_0)) %>%
        dplyr::summarize(total_within_variance = mean(within_variance)) %>%
        dplyr::pull(total_within_variance)

    # calculate between replicate variances
    between_variance_log <- log_df %>%
        dplyr::group_by(replicate) %>%
        dplyr::summarize(within_mean = mean(log_n_0)) %>%
        dplyr::summarize(total_between_variance = stats::var(within_mean)) %>%
        dplyr::pull(total_between_variance)

    # calculate total variance
    total_variance_log <- (within_variance_log + ((num_replicates + 1) / num_replicates) * between_variance_log)
    sd_log <- sqrt(total_variance_log)

    # construct approximate 95% CI
    degrees_freedom <- (num_replicates - 1) * (1 + 1 / (num_replicates + 1) * within_variance_log / between_variance_log)^2
    t_statistic <- abs(stats::qt(0.025, degrees_freedom))

    n_0_975 <- round(exp(total_mean_log + t_statistic * sd_log), 0)
    n_0_025 <- round(exp(total_mean_log - t_statistic * sd_log), 0)

    return(tibble::tibble(N_025 = n_obs + n_0_025,
                          N_mean = n_obs + total_mean,
                          N_975 = n_obs + n_0_975))

}

# done.
