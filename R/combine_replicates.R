# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Combine replicates according to the Normal approximation using the laws of total expectation and variance.
#'
#' @param data_obs Dataframe that results from applying summary_observed.
#' @param data_rep Original data, not filtered by is_conflict.
#' @param strata_vars_rep Variable with all observations (without missing values).
#' @param conflict_filter Filter that indicates if the data is filtered using
#' the "is_conflict" rule.
#' @param violation Violation to be analyzed. Options are "homicidio", "secuestro",
#' "reclutamiento", and "desaparicion".
#' @param forced_dis Filter that indicates if the data is filtered using the
#' "is_forced_dis" rule.
#' @param edad_minors Optional filter by age ("edad") < 18.
#'
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
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", strata_vars_com = "yy_hecho",
#' conflict_filter = TRUE, is_conflict_na = TRUE, forced_dis = FALSE,
#' is_forced_dis_na = TRUE, edad_minors = TRUE, edad_na = FALSE, perp_na = FALSE,
#' sexo_na = FALSE, municipio_na = FALSE, etnia_na = FALSE)
#' tab_combine <- combine_replicates("reclutamiento", tab_observed,
#' replicates_data, strata_vars_rep = 'sexo', conflict_filter = TRUE,
#' forced_dis = FALSE, edad_minors = FALSE)
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
        print("Not filter is_conflict = 1 in the data")
        pre_data <- data_rep %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict))
    }
    

    if (edad_minors == TRUE) {

        logger::log_info("Filtering minors (< 18 years old)")
        prep_data <- prep_data %>%
            dplyr::filter(edad_jep == "INFANCIA" | edad_jep == "ADOLESCENCIA")

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

    data_obs <- data_obs %>% 
        dplyr::mutate(dplyr::across(all_of(strata_vars_rep), as.character)) 
    
    final_data <- dplyr::full_join(rep_data, data_obs, by = {{strata_vars_rep}}) %>%
        dplyr::mutate(imp_lo = dplyr::if_else(imp_lo < observed,
                                              observed, imp_lo))

    final_data <- final_data %>%
        dplyr::select(all_of({{strata_vars_rep}}), observed, imp_lo,
                      imp_mean, imp_hi)

    return(final_data)

    }

# --- Done
