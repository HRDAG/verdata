# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' @title proportions_imputed
#'
#' @description Calculate the proportions of each level of a variable after
#' applying `combine_replicates` to complete data (that includes
#' imputed values).
#'
#' @param complete_data A dataframe containing the output from `combine_replicates`.
#' @param strata_vars A vector of column names identifying the variables to be
#' used for stratification.
#' @param digits Number of decimal places to round the results to. Default value
#' is 2.
#'
#' @return A dataframe that contains the proportions after applying
#' `combine_replicates`.
#' @export
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")
#' replicates_obs_data <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", conflict_filter = FALSE, forced_dis_filter = FALSE,
#' edad_minors_filter = FALSE, include_props = FALSE, include_props_na  = FALSE)
#' tab_combine <- combine_replicates("reclutamiento", replicates_obs_data,
#' replicates_data, strata_vars = 'sexo', conflict_filter = TRUE,
#' forced_dis_filter = FALSE, edad_minors_filter = FALSE,include_props = FALSE)
#' prop_data_complete <- proportions_imputed(tab_combine, strata_vars = "sexo",
#' digits = 2)
proportions_imputed <- function(complete_data,
                                strata_vars,
                                digits = 2) {

  if (!is.data.frame(complete_data)) {
    stop("This argument must be a data.frame")
  }

  if (digits != 2) {
    stop("The number of digits should not be different from 2")
  }

  proportions_data <- complete_data %>%
    dplyr::mutate(imp_lo_p = round(imp_lo / sum(imp_mean, na.rm = TRUE), digits = 2),
                  imp_mean_p = round(imp_mean / sum(imp_mean, na.rm = TRUE), digits = 2),
                  imp_hi_p = round(imp_hi / sum(imp_mean, na.rm = TRUE), digits = 2))

  proportions_data <- proportions_data %>%
    dplyr::select(all_of({{strata_vars}}),
                  imp_lo, imp_mean, imp_hi,
                  imp_lo_p, imp_mean_p, imp_hi_p)

  return(proportions_data)

}

#' Combine replicates according to the Normal approximation using the laws of total expectation and variance.
#'
#' @param replicates_obs_data The dataframe that results from applying `summary_observed`.
#' @param replicates_data A dataframe containing replicates data.
#' @param strata_vars Variable with all observations (without missing values).
#' @param conflict_filter Filter that indicates if the data is filtered using
#' the "is_conflict" rule.
#' @param violation Violation to be analyzed. Options are "homicidio", "secuestro",
#' "reclutamiento" and "desaparicion".
#' @param forced_dis_filter Filter that indicates if the data is filtered using the
#' "is_forced_dis" rule.
#' @param edad_minors_filter Optional filter by age ("edad") < 18.
#' @param include_props A logical value indicating whether or not to include
#'  the proportions from the calculations before to merge with summary_observed's output.
#' @return A dataframe with 5 or more columns: name of variable(s), `observed`
#' the number of observations in each category for every variable, `imp_lo` the
#' lower bound of the 95% confidence interval, `imp_hi` the upper bound of the
#' 95% confidence interval, and `imp_mean` the point estimate of the mean value.
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2)
#' replicates_obs_data <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", conflict_filter = FALSE, forced_dis_filter = FALSE,
#' edad_minors_filter = FALSE, include_props = FALSE, include_props_na = FALSE)
#' tab_combine <- combine_replicates("reclutamiento", replicates_obs_data,
#' replicates_data, strata_vars = 'sexo', conflict_filter = TRUE,
#' forced_dis_filter = FALSE, edad_minors_filter = FALSE, include_props = FALSE)
combine_replicates <- function(violation,
                               replicates_obs_data,
                               replicates_data,
                               strata_vars = NULL,
                               conflict_filter = TRUE,
                               forced_dis_filter = FALSE,
                               edad_minors_filter = FALSE,
                               include_props = FALSE) {

  if (!(violation %in% c("homicidio", "secuestro", "reclutamiento", "desaparicion"))) {

    stop("Violation argument incorrectly specified. Please put any of the following
         violations (in quotes and in lower case): homicidio, secuestro,
         reclutamiento or desaparicion")
  }

  if (!is.data.frame(replicates_obs_data)) {
    stop("The argument 'replicates_obs_data' must be a data frame")
  }

  if (!is.data.frame(replicates_data)) {
    stop("The argument 'replicates_data' must be a data frame")
  }

  if (!is.null(strata_vars)) {

    strata_vars_missing <- setdiff(strata_vars, names(replicates_data))

    if (length(strata_vars_missing) > 0) {
      stop("This variable is not found in the replicates. Please check if
           it exists or if it has another name.")
    }
  }

  if (forced_dis_filter == TRUE && violation != "desaparicion") {
    stop("This argument only applies to 'desaparicion'. Please change the
         TRUE option to FALSE")
  }

  num_replicates <- dplyr::n_distinct(replicates_data$replica)

    if (num_replicates == 1) {

      stop("Results cannot be calculated using only 1 replicate. For more
           consistent results please work with more replicates.")

        }

    else {

        logger::log_info("You are working with {num_replicates} replicates according to filter")

        }

    if (conflict_filter == TRUE) {

      logger::log_info("Analyzing victims related to armed conflict")

        prep_data <- replicates_data %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict)) %>%
            dplyr::filter(is_conflict == 1)

    } else {

      logger::log_info("You are working with all victims (related and not related to is_conflict)")

        prep_data <- replicates_data %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict))
    }


    if (edad_minors_filter == TRUE) {

      logger::log_info("Analyzing victims under 18 years of age")

      prep_data <- prep_data %>%
        dplyr::filter(edad_jep == "INFANCIA" |
                      edad_jep == "ADOLESCENCIA")

    } else {

      logger::log_info("Analyzing victims of all ages")
      prep_data <- prep_data

    }

    if (violation == "desaparicion" & forced_dis_filter == TRUE) {

      logger::log_info("Analyzing the documented victims who were victims of forced disappearance")

        prep_data <- prep_data %>%
            dplyr::mutate(is_forced_dis = as.integer(is_forced_dis)) %>%
            dplyr::filter(is_forced_dis == 1)

        } else {

          logger::log_info("Not filtering in is_forced_dis")

            }

    prep_data <- prep_data  %>%
        dplyr::mutate(dplyr::across(all_of({{strata_vars}}), as.character)) %>%
        dplyr::group_by(replica, dplyr::across(all_of({{strata_vars}}))) %>%
        dplyr::summarise(Freq = dplyr::n()) %>%
        dplyr::ungroup()

    theta <- prep_data %>%
        dplyr::group_by(dplyr::across(all_of({{strata_vars}}))) %>%
        dplyr::summarize(theta = round(mean(Freq), 0)) %>%
        dplyr::ungroup()

    rep_data <- prep_data %>%
        dplyr::left_join(theta) %>%
        dplyr::mutate(vb1 = (Freq - theta)^2) %>%
        dplyr::group_by(dplyr::across(all_of({{strata_vars}}))) %>%
        dplyr::summarize(between_variance = (1 / (num_replicates - 1)) * sum(vb1)) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(total_variance = 0 + ((num_replicates + 1) / num_replicates) * between_variance) %>%
        dplyr::mutate(se_b = sqrt(total_variance)) %>%
        dplyr::select(-total_variance) %>%
        dplyr::inner_join(theta) %>%
        dplyr::mutate(lower_ci = round(theta - (1.96 * se_b), 0)) %>%
        dplyr::mutate(upper_ci = round(theta + (1.96 * se_b), 0)) %>%
        dplyr::select(all_of({{strata_vars}}), lower_ci, theta, upper_ci) %>%
        dplyr::rename(imp_mean = theta, imp_lo = lower_ci, imp_hi = upper_ci)

    if (include_props == TRUE) {

      logger::log_info("Including the proportions")

      rep_data <- proportions_imputed(rep_data, strata_vars, digits = 2)

      rep_data <- rep_data %>%
        dplyr::mutate(imp_lo_p = dplyr::if_else(imp_lo_p < 0, 0, imp_lo_p))

    } else {

      logger::log_info("Don't include the proportions")

    }

    final_data <- rep_data %>%
        dplyr::mutate(dplyr::across(all_of(strata_vars), as.character))

    replicates_obs_data <- replicates_obs_data %>%
      dplyr::mutate(dplyr::across(all_of(strata_vars), as.character))

    final_data <- dplyr::full_join(rep_data, replicates_obs_data, by = {{strata_vars}}) %>%
        dplyr::mutate(imp_lo = dplyr::if_else(imp_lo < observed,
                                              observed, imp_lo))

    final_data <- final_data %>%
        dplyr::select(all_of({{strata_vars}}), observed,
                      dplyr::everything()) %>%
      dplyr::arrange(dplyr::desc(imp_mean))

    return(final_data)

    }

# --- Done
