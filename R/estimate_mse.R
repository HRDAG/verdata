# ============================================
# Authors:     MG, MJ
# Maintainers: MG, MJ
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Determine valid sources for estimation of a stratum of interest.
#'
#' @param stratum_data_prepped A data frame with all records in a stratum of interest.
#' Columns indicating sources should be prefixed with `in_` and should be numeric
#' with 1 indicating that an individual was documented in the source and 0
#' indicating that an individual was not documented in the source.
#' @param min_n The minimum number of records that must appear in a source to be
#' considered valid for estimation. `min_n` should never be less than or equal
#' to 0; the default value is 1.
#'
#' @return A character vector containing the names of the valid sources.
#' @export
#' @importFrom dplyr "%>%"
#'
#' @examples
#' set.seed(19481210)
#' in_A <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.45, 0.65))
#' in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))
#' in_C <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.75, 0.25))
#' in_D <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(1, 0))
#'
#' my_stratum <- tibble::tibble(in_A, in_B, in_C, in_D)
#' get_valid_sources(my_stratum)
get_valid_sources <- function(stratum_data_prepped, min_n = 1) {

    if (!is.numeric(min_n)) { stop("min_n value should be numeric") }
    if (min_n <= 0) { stop("min_n value should be greater than 0") }

    stratum_data_prepped %>%
        dplyr::select(tidyselect::starts_with("in_")) %>%
        assertr::verify(all(rowSums(.) <= ncol(.))) %>%
        dplyr::summarize(dplyr::across(tidyselect::everything(), sum)) %>%
        tidyr::pivot_longer(cols = tidyselect::everything(.),
                            names_to = "source",
                            values_to = "n") %>%
        dplyr::filter(n >= min_n) %>%
        dplyr::pull(source)

}


#' @title run_lcmcr
#'
#' @description Calculate multiple systems estimation estimates using the Bayesian
#' Non-Parametric Latent-Class Capture-Recapture model developed by Daniel
#' Manrique-Vallier (2016).
#'
#' @param stratum_data_prepped A data frame with all records in the stratum of interest
#' documented by sources considered valid for estimation (i.e., there should be
#' no rows with all 0's). Columns indicating sources should be prefixed with
#' `in_` and should be numeric with 1 indicating that an individual was
#' documented in the source and 0 indicating that an individual was not
#' documented in the source.
#' @param stratum_name An identifier for the stratum.
#' @param min_n The minimum number of records that must appear in a source to be
#' considered valid for estimation. `min_n` should never be less than or equal to
#' 0; the default value is 1.
#' @param K The maximum number of latent classes to fit.
#' @param buffer_size Size of the tracing buffer.
#' @param sampler_thinning Thinning interval for the tracing buffer.
#' @param seed Integer seed for the internal random number generator.
#' @param burnin Number of burn in iterations.
#' @param n_samples Number of samples to be generated. Samples are taken one
#' every `posterior_thinning` iterations of the sampler. Final number of samples
#' from the posterior is `n_samples` divided by 1,000.
#' @param posterior_thinning Thinning interval for the sampler.
#'
#' @return A data frame with four columns and `n_samples` divided by 1,000 rows.
#' `N` is the draws from the posterior distribution, `valid_sources` is a string
#' indicating which sources were used in the estimation, `n_obs` is the number of
#' observations in the stratum of interest, and  `stratum_name` is the stratum
#' identifier.
#' @export
#' @import LCMCR
#' @importFrom dplyr "%>%"
#' @importFrom tibble tibble
#' @importFrom Rdpack reprompt
#'
#' @references
#' \insertRef{manriquevallier2016}{verdata}
#'
#' @examples
#' \dontrun{
#' set.seed(19481210)
#' library(dplyr)
#'
#' in_A <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.45, 0.65))
#' in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))
#' in_C <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.75, 0.25))
#' in_D <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(1, 0))
#'
#' my_stratum <- tibble::tibble(in_A, in_B, in_C, in_D) %>%
#'     dplyr::mutate(rs = rowSums(.)) %>%
#'     dplyr::filter(rs >= 1) %>%
#'     dplyr::select(-rs)
#' run_lcmcr(stratum_data_prepped = my_stratum, stratum_name = "my_stratum",
#'           K = 4, buffer_size = 10000, sampler_thinning = 1000, seed = 19481210,
#'           burnin = 10000, n_samples = 10000, posterior_thinning = 500)
#' }
run_lcmcr <- function(stratum_data_prepped, stratum_name, min_n = 1,
                      K, buffer_size, sampler_thinning, seed,
                      burnin, n_samples, posterior_thinning) {

    valid_sources <- get_valid_sources(stratum_data_prepped, min_n)

    if (length(valid_sources) < 3) {

        stop("Stratum not estimable because it has fewer than 3 valid sources")

    }

    # prep data according to LCMCR specs
    stratum_data_prepped <- stratum_data_prepped %>%
        dplyr::mutate(dplyr::across(tidyselect::everything(),
                                    ~factor(.x, levels = c(0, 1)))) %>%
        as.data.frame()

    options(warn = -1)
    sampler <- lcmCR(captures = stratum_data_prepped,
                     K = K,
                     tabular = FALSE,
                     seed = seed,
                     buffer_size = buffer_size,
                     thinning = sampler_thinning,
                     in_list_label = "1",
                     not_in_list_label = "0",
                     verbose = FALSE)

    N <- lcmCR_PostSampl(sampler,
                         burnin = burnin,
                         samples = n_samples,
                         thinning = posterior_thinning,
                         output = FALSE)
    options(warn = 0)

    N <- N[seq(1, length(N), n_samples / 1000)] # thin again

    return(tibble::tibble(N = N,
                          valid_sources = paste(names(stratum_data_prepped), collapse = ","),
                          stratum_name = stratum_name))

}

#' @title estimates_exist
#'
#' @description Check whether stratum estimates already exist in pre-calculated files.
#'
#' @param stratum_data_prepped A data frame including all records in a stratum of
#' interest. The data frame should only include the source columns prefixed with
#' `in_` and all columns should only contain 1's and 0's.
#' @param estimates_dir Directory containing pre-calculated estimates, if you
#' would like to use pre-calculated results.
#'
#' #' @return A list with two entries, `estimates_exist` and `estimates_path`.
#' `estimates_exist` is a logical value indicating whether calculations for the
#' stratum of interest are available in the directory containing the pre-calculated
#' estimates. If `estimates_exist` is `TRUE`, `estimates_path` will contain the
#' full file path to the JSON file containing the estimates, otherwise it will
#' be `NA`.
#' @export

estimates_exist <- function(stratum_data_prepped, estimates_dir) {

    valid_sources <- get_valid_sources(stratum_data_prepped)

    lettersplus <- c(letters, paste0(letters, "1"))
    stopifnot(length(lettersplus) >= length(valid_sources))
    anon_sources <- as.character(glue::glue("in_{lettersplus[1:length(valid_sources)]}"))

    options(dplyr.summarise.inform = FALSE)
    summary_table <- stratum_data_prepped %>%
        dplyr::mutate(rs = rowSums(.)) %>%
        dplyr::filter(rs >= 1) %>%
        dplyr::select(-rs) %>%
        dplyr::mutate(dplyr::across(dplyr::everything(),
                                    ~factor(.x, levels = c(0, 1)))) %>%
        dplyr::group_by_all() %>%
        dplyr::summarize(Freq = dplyr::n()) %>%
        as.data.frame()

    if (length(valid_sources) > 0) {

        summary_table <- summary_table %>%
            dplyr::select(dplyr::all_of(valid_sources), Freq) %>%
            purrr::set_names(c(anon_sources, "Freq")) %>%
            dplyr::arrange(dplyr::across(dplyr::all_of(anon_sources)))

    }

    stratum_hash <- digest::digest(summary_table, algo = "sha1")
    stratum_dir <- stringr::str_sub(stratum_hash, 1, 2)
    estimate_file <- glue::glue("{estimates_dir}/{stratum_dir}/{stratum_hash}.json")

    if (file.exists(estimate_file)) {

        return(list(estimates_exist = TRUE,
                    estimates_path = estimate_file))

    } else {

        return(list(estimates_exist = FALSE,
                    estimates_path = NA_character_))

    }

}

#' @title lookup_estimates
#'
#' @description Look up and read in existing estimates from pre-calculated files.
#'
#' @param stratum_data_prepped A data frame including all records in a stratum of interest.
#' The data frame should only include the source columns prefixed with `in_` and
#' all columns should only contain 1's and 0's.
#' @param estimates_dir Directory containing pre-calculated
#' estimates, if you would like to use pre-calculated results. Note, setting this
#' option forces the model specification parameters to be identical to those used
#' to calculate the pre-calculated estimates. Do not specify a file path If you
#' would like to use a custom model specification.
#'
#' @return A data frame with one column, `N`, indicating the results. If the
#' stratum was not found in the pre-calculated files, `N` will be `NA` and the
#' data frame will have one row. If the stratum was found in the pre-calculated
#' files, `N` will contain draws from the posterior distribution of the model
#' and the data frame will contain 1,000 rows.
#' @export
#' @importFrom dplyr "%>%"
#'
#' @examples
#' \dontrun{
#' in_A <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.45, 0.65))
#' in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))
#' in_C <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.75, 0.25))
#' in_D <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(1, 0))
#'
#' my_stratum <- tibble::tibble(in_A, in_B, in_C, in_D) %>%
#'     dplyr::mutate(rs = rowSums(.)) %>%
#'     dplyr::filter(rs >= 1) %>%
#'     dplyr::select(-rs)
#'
#' lookup_estimates(stratum_data_prepped = my_stratum, estimates_dir = "path_to_estimates")
#'
#' }
lookup_estimates <- function(stratum_data_prepped, estimates_dir) {

    testing_columns <- stratum_data_prepped %>%
        dplyr::select(tidyselect::starts_with("in_"))

    right_columns <- isTRUE(all.equal(stratum_data_prepped, testing_columns))

    if (!right_columns) {

        stop("Your data frame should only include the source columns prefixed with `in_`")

    }

    valid_values <- any(stratum_data_prepped < 0 | stratum_data_prepped > 1)

    if (valid_values) {

        stop("Your stratification should only contain 0 and 1 values")

    }

    if (!isTRUE(length(list.files(estimates_dir)) == 257)) {

        warning("Your estimates directory does not contain the same amount of files published. You might not be able to find estimates for your stratum")

    }

    lookup_results <- estimates_exist(stratum_data_prepped, estimates_dir)

    if (lookup_results$estimates_exist) {

        estimates <- tibble::tibble(N = rjson::fromJSON(file = lookup_results$estimates_path))
        return(estimates)

    } else {

        no_estimates <- tibble::tibble(N = NA_real_)
        return(no_estimates)

    }

}


#' @title mse
#'
#' @description Prepare data for estimation and calculate estimates using `run_lcmcr`.
#'
#' @param stratum_data A data frame including all records in a stratum of interest.
#' Columns indicating sources should be prefixed with `in_` and should be numeric.
#' @param estimates_dir File path for the folder containing pre-calculated
#' estimates, if you would like to use pre-calculated results. Note, setting this
#' option forces the model specification parameters to be identical to those used
#' to calculate the pre-calculated estimates. Do not specify a file path If you
#' would like to use a custom model specification.
#' @param stratum_name An identifier for the stratum.
#' @param min_n The minimum number of records that must appear in a source to be
#' considered valid for estimation. `min_n` should never be less than or equal to
#' 0; the default value is 1.
#' @param K The maximum number of latent classes to fit. By default the function
#' will calculate `K` as the minimum value of 2^{number of valid sources} - 1 or 15.
#' @param buffer_size Size of the tracing buffer. Default value is 10,000.
#' @param sampler_thinning Thinning interval for the tracing buffer. Default value is 1,000.
#' @param seed Integer seed for the internal random number generator. Default value is 19481210.
#' @param burnin Number of burn in iterations. Default value is 10,000.
#' @param n_samples Number of samples to be generated. Samples are taken one
#' every `posterior_thinning` iterations of the sampler. Default value is 10,000.
#' The final number of samples from the posterior is `n_samples` divided by 1,000.
#' @param posterior_thinning Thinning interval for the sampler. Default value is 500.
#'
#' @return A data frame with five columns. `validated` is a logical value
#' indicating whether the stratum is estimable, `N` is the draws from the
#' posterior distribution (`NA` if the stratum is not estimable), `valid_sources`
#' is a string indicating which sources were used in the estimation, `n_obs` is
#' the number of observations on valid lists in the stratum of interest (`NA` if
#' the stratum is not estimable), and  `stratum_name` is a stratum identifier.
#' If the stratum is estimable the return will consist of `n_samples` divided by
#' 1,000 rows.
#' @export
#' @importFrom dplyr "%>%"
#'
#' @examples
#' \dontrun{
#' set.seed(19481210)
#' in_A <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.45, 0.65))
#' in_B <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.5, 0.5))
#' in_C <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(0.75, 0.25))
#' in_D <- sample(c(0, 1), size = 100, replace = TRUE, prob = c(1, 0))
#'
#' my_stratum <- tibble::tibble(in_A, in_B, in_C, in_D)
#' mse(stratum_data = my_stratum, stratum_name = "my_stratum")
#' }
mse <- function(stratum_data, stratum_name,
                estimates_dir = NULL, min_n = 1,
                K = NULL, buffer_size = 10000, sampler_thinning = 1000, seed = 19481210,
                burnin = 10000, n_samples = 10000, posterior_thinning = 500) {

    stratum_data_prepped <- stratum_data %>%
        dplyr::select(tidyselect::starts_with("in_")) %>%
        dplyr::mutate(dplyr::across(tidyselect::everything(), ~if_else(. >= 1, 1, 0)))

    if (ncol(stratum_data_prepped) < 1) {

        stop("Could not find any columns in 'stratum_data' prefixed with 'in_'")

    }

    valid_sources <- get_valid_sources(stratum_data_prepped, min_n)

    if (length(valid_sources) < 3) {

        return(tibble::tibble_row(validated = FALSE,
                                  N = NA_real_,
                                  valid_sources = paste(valid_sources, collapse = ","),
                                  n_obs = NA_real_,
                                  stratum_name = stratum_name))

    }

    # keep only records that appear on one or more valid source (i.e., no rows
    # with all 0 values)
    stratum_data_prepped <- stratum_data_prepped %>%
        dplyr::select(tidyselect::all_of(valid_sources)) %>%
        dplyr::mutate(rs = rowSums(.)) %>%
        dplyr::filter(rs >= 1) %>%
        dplyr::select(-rs)

    n_obs <- nrow(stratum_data_prepped)

    if (!is.null(estimates_dir)) {

        lookup_results <- lookup_estimates(stratum_data_prepped, estimates_dir)

        if (all(is.na(lookup_results$N))) {

            # fix model specification to be identical to that used to calculate
            # estimates

            K <- min((2 ** length(valid_sources)) - 1, 15)

            estimates <- run_lcmcr(stratum_data_prepped, stratum_name,
                                   min_n = 1,
                                   K = K,
                                   buffer_size = 10000,
                                   sampler_thinning = 1000,
                                   seed = 19481210,
                                   burnin = 10000,
                                   n_samples = 10000,
                                   posterior_thinning = 500) %>%
                dplyr::mutate(validated = TRUE,
                              n_obs = n_obs) %>%
                dplyr::select(validated, N, valid_sources, n_obs, stratum_name)

        } else {

            estimates <- lookup_results %>%
                dplyr::mutate(validated = TRUE,
                              valid_sources = paste(names(stratum_data_prepped), collapse = ","),
                              n_obs = n_obs,
                              stratum_name = stratum_name) %>%
                dplyr::select(validated, N, valid_sources, n_obs, stratum_name)

        }

    } else {

        # allow for custom model specification if not looking up existing
        # estimates

        if (is.null(K)) {
            K <- min((2 ** length(valid_sources)) - 1, 15)
        }

        if (!all(is.numeric(min_n),
                 is.numeric(K),
                 is.numeric(buffer_size),
                 is.numeric(sampler_thinning),
                 is.numeric(seed),
                 is.numeric(burnin),
                 is.numeric(n_samples),
                 is.numeric(posterior_thinning))) {

            stop("All model parameters should be numeric")

        }

        estimates <- run_lcmcr(stratum_data_prepped, stratum_name, min_n,
                               K, buffer_size, sampler_thinning, seed,
                               burnin, n_samples, posterior_thinning) %>%
            dplyr::mutate(validated = TRUE,
                          n_obs = n_obs) %>%
            dplyr::select(validated, N, valid_sources, n_obs, stratum_name)

    }

    return(estimates)

}


# done.
