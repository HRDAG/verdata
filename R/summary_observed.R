# ============================================
# Authors:     PA
# Maintainers: PA, MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Calculate the proportions of each level of a variable after applying
#' `summary_observed` to observed values.
#'
#' @param obs_data A data frame containing the output from `summary_observed`.
#' @param strata_vars A vector of column names identifying the variables to be
#' used for stratification.
#' @param digits Number of decimal places to round the results to. Default is 2.
#'
#' @return A data frame that contains the proportions after applying
#' `summary_observed`.
#' @export
#' @examples
#' \dontrun{
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", c(1, 2), version = "v1")
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", conflict_filter = TRUE, forced_dis_filter = FALSE,
#' edad_minors_filter = TRUE, include_props = TRUE)
#' prop_data <- proportions_observed(tab_observed, strata_vars = "sexo",
#' digits = 2)
#' }
proportions_observed <- function(obs_data,
                                 strata_vars,
                                 digits = 2) {

    if (!is.data.frame(obs_data)) {
        stop("The input 'obs_data' must be a data frame")
    }

    if (digits < 0) {stop("Cannot round to negative decimal places")}

    tab_com <- obs_data %>%
        dplyr::mutate(obs_prop_na = round((observed / sum(observed, na.rm = TRUE)),
                                          digits = digits))

    tab_na <- tab_com %>%
        dplyr::filter(!is.na(observed)) %>%
        dplyr::filter(dplyr::if_any(all_of({{strata_vars}}), ~!is.na(.))) %>%
        dplyr::mutate(obs_prop = round(observed / sum(observed, na.rm = TRUE),
                                       digits = digits))

    data_final_prop <- dplyr::left_join(tab_com, tab_na) %>%
        dplyr::select(all_of({{strata_vars}}), observed, obs_prop_na, obs_prop)

    return(data_final_prop)

}

#' Summary statistics for observed data.
#'
#' @param violation Violation to be analyzed. Options are
#' "homicidio", "secuestro", "reclutamiento", and "desaparicion".
#' @param replicates_data Data frame containing replicate data.
#' @param strata_vars Variable to be analyzed. Before imputation
#' this variable may have missing values.
#' @param conflict_filter Filter that indicates if the data is filtered by
#' the rule "is_conflict" or not.
#' @param forced_dis_filter Filter that indicates if the data is filter by
#' the rule "is_forced_dis" or not.
#' @param edad_minors_filter Optional filter by age ("edad") < 18.
#' @param include_props A logical value indicating whether or not to include
#'  the proportions from the calculations.
#' @param digits Number of decimal places to round the results to. Default is 2.
#' @return A data frame with two or more columns, (1) name of variable(s) and (2)
#' the number of observations in each of the variable's categories.
#' @export
#' @importFrom dplyr if_else
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", c(1, 2), version = "v1")
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", conflict_filter = FALSE, forced_dis_filter = FALSE,
#' edad_minors_filter = FALSE, include_props = FALSE, digits = 2)
summary_observed <- function(violation,
                             replicates_data,
                             strata_vars = NULL,
                             conflict_filter = FALSE,
                             forced_dis_filter = FALSE,
                             edad_minors_filter = FALSE,
                             include_props = FALSE,
                             digits = 2) {

    if (!(violation %in% c("homicidio", "secuestro", "reclutamiento", "desaparicion"))) {

        stop("Violation argument incorrectly specified. Please put any of the following
         violations (in quotes and in lower case): homicidio, secuestro,
         reclutamiento or desaparicion")
    }

    if (!is.data.frame(replicates_data)) {
        stop("The input 'replicates_data' must be a data frame")
    }

    if (!is.null(strata_vars)) {

        strata_vars_missing <- setdiff(strata_vars, names(replicates_data))

        if (length(strata_vars_missing) > 0) {
            stop("This variable is not found in the replicates. Please check if
           it exists or if it has another name.")
        }
    }

    if (forced_dis_filter == TRUE & violation != "desaparicion") {
        stop("This argument only applies in 'desaparicion'. Please change the
         TRUE option to FALSE")
    }

    num_replicates <- dplyr::n_distinct(replicates_data$replica)

    if (num_replicates == 1) {

        stop("Results cannot be calculated using only 1 replicate. For more
           consistent results please work with more replicates")

    } else {

        logger::log_info("You are working to {num_replicates} replicates according to filter")

    }

    if (digits < 0) {stop("Cannot round to negative decimal places")}

    if (conflict_filter == TRUE) {

        logger::log_info("Analyzing documented victims related to armed conflict")

        obs_data <- replicates_data %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict)) %>%
            dplyr::filter(is_conflict == 1) %>%
            dplyr::mutate(is_conflict_imputed = as.logical(is_conflict_imputed)) %>%
            dplyr::filter(!is_conflict_imputed)

    } else {

        print("You are working with all victims (related and not related to is_conflict)")

        obs_data <- replicates_data
    }

    if (edad_minors_filter == TRUE) {

        logger::log_info("Analyzing documented victims under 18 years of age")

        obs_data <- obs_data %>%
            dplyr::filter(edad_jep == "INFANCIA" |
                              edad_jep == "ADOLESCENCIA") %>%
            dplyr::mutate(edad_jep_imputed = as.logical(edad_jep_imputed)) %>%
            dplyr::filter(!edad_jep_imputed)

    } else {

        logger::log_info("Analyzing victims of all ages")
        obs_data <- obs_data

    }

    if (forced_dis_filter == TRUE & violation == "desaparicion") {

        logger::log_info("Analyzing the documented victims who were victims of 'desaparicion forzada'")


        obs_data <- obs_data %>%
            dplyr::mutate(is_forced_dis = as.integer(is_forced_dis)) %>%
            dplyr::filter(is_forced_dis == 1) %>%
            dplyr::mutate(is_forced_dis_imputed = as.logical(is_forced_dis_imputed)) %>%
            dplyr::filter(!is_forced_dis_imputed)

    }

    for (var_rep in strata_vars) {
        var_imputed <- paste0(var_rep, "_imputed")
        if (!(var_imputed %in% names(obs_data))) {
            obs_data[[var_imputed]] <- FALSE
        }
        obs_data[[var_rep]][as.logical(obs_data[[var_imputed]])] <- NA_character_
    }

    obs_data <- obs_data %>%
        dplyr::mutate(dplyr::across(any_of({{strata_vars}}), as.character)) %>%
        dplyr::group_by(replica, dplyr::across(any_of({{strata_vars}}))) %>%
        dplyr::summarize(N = dplyr::n(), .groups = "drop") %>%
        dplyr::group_by(dplyr::across(any_of({{strata_vars}}))) %>%
        dplyr::summarise(observed = round(mean(N), 0), .groups = "drop") %>%
        dplyr::ungroup()

    if (include_props == TRUE) {

        logger::log_info("Including the proportions")
        obs_data <- proportions_observed(obs_data,
                                         strata_vars,
                                         digits = digits)

    } else {

        logger::log_info("Don't include the proportions")

    }

    return(obs_data)

}


# --- Done
