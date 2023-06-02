# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Combine replicates according to the Normal approximation using the laws of total expectation and variance
#'
#' @param data_obs Data frame that come from summary_observed's function
#' @param data_rep Original data, not filter for is_conflict.
#' @param strata_vars_rep variable with all observations (without missing values)
#' @param conflict_filter Filter that indicates if the data is filter for
#' the rule "is_conflict" or not.
#' @param violation type of violation
#' @param forced_dis Filter that indicates if the data is filter for
#' the rule "is_forced_dis" or not.
#' @param edad_minors Optional filter by "edad" < 18.
#'
#' @return Data frame with 5 o more columns:
#' 1.  Name of variable(s);
#' 2.# Observations that shows each variable's category;
#' 3.  Confidence intervals (lower and upper) and median value imputed.
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", strata_vars_com = "yy_hecho",
#' conflict_filter = TRUE, forced_dis = FALSE, edad_minors = TRUE,
#' edad_na = TRUE)
#' tab_combine <- combine_replicates("reclutamiento", tab_observed,
#' replicates_data, strata_vars_rep = 'sexo', conflict_filter = TRUE,
#' forced_dis = FALSE, edad_minors = TRUE)
combine_replicates <- function(violation,
                               data_obs,
                               data_rep,
                               strata_vars_rep,
                               conflict_filter = TRUE,
                               forced_dis = FALSE,
                               edad_minors = FALSE) {

    num_replicates <- dplyr::n_distinct(data_rep$replica)

    if (num_replicates == 1) {

        stop("You should work with more than one replicate")

        }

    else {

        logger::log_info("You are working to {num_replicates}
                     replicates according to filter")

        }

    if (conflict_filter == TRUE) {

        prep_data <- data_rep %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict)) %>%
            dplyr::filter(is_conflict == 1)

        } else {

            print("Not filter is_conflict = 1 in data_rep")

            prep_data <- data_rep

        }


    if (edad_minors == TRUE) {

        logger::log_info("Filtering minors (< 18 years old)")
        prep_data <- prep_data %>%
            dplyr::filter(edad_categoria == "De 0 a 4" | 
                          edad_categoria == "De 5 a 9" |
                          edad_categoria == "De 10 a 14" |
                          edad_categoria == "De 15 a 17")

    } else {

        logger::log_info("Not filtering minors (< 18 years old)")

    }

    if (violation == "desaparicion" & forced_dis == TRUE) {

        prep_data <- prep_data %>%
            dplyr::mutate(is_forced_dis = as.integer(is_forced_dis)) %>%
            dplyr::filter(is_forced_dis == 1)

        } else {

            print("This violation does not need filter: is_forced_dis")

            }

    prep_data <- prep_data  %>%
        dplyr::mutate(dplyr::across(all_of(strata_vars_rep), as.character)) %>%
        dplyr::group_by(replica, dplyr::across(all_of({{strata_vars_rep}}))) %>%
        dplyr::summarise(Freq = dplyr::n()) %>%
        dplyr::ungroup()

    theta <- prep_data %>%
        dplyr::group_by(dplyr::across(all_of({{strata_vars_rep}}))) %>%
        dplyr::summarize(theta = round(mean(Freq), 0)) %>%
        dplyr::ungroup()

    rep_data <- prep_data %>%
        dplyr::left_join(theta) %>%
        dplyr::mutate(vb1 = (Freq - theta)^2) %>%
        dplyr::group_by(dplyr::across(all_of({{strata_vars_rep}}))) %>%
        dplyr::summarize(between_variance = (1 / (num_replicates - 1)) * sum(vb1)) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(total_variance = 0 + ((num_replicates + 1) / num_replicates) * between_variance) %>%
        dplyr::mutate(se_b = sqrt(total_variance)) %>%
        dplyr::select(-total_variance) %>%
        dplyr::inner_join(theta) %>%
        dplyr::mutate(lower_ci = round(theta - (1.96 * se_b), 0)) %>%
        dplyr::mutate(upper_ci = round(theta + (1.96 * se_b), 0)) %>%
        dplyr::select(all_of({{strata_vars_rep}}), lower_ci, theta, upper_ci) %>%
        dplyr::rename(imp_mean = theta, imp_lo = lower_ci, imp_hi = upper_ci)

    final_data <- dplyr::full_join(rep_data, data_obs, by = {{strata_vars_rep}}) %>%
        dplyr::mutate(imp_lo = dplyr::if_else(imp_lo < observed,
                                              observed, imp_lo))

    final_data <- final_data %>%
        dplyr::select(all_of({{strata_vars_rep}}), observed, imp_lo,
                      imp_mean, imp_hi)

    return(final_data)

    }

# --- Done
