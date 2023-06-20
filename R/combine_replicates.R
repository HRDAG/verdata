# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' @title proportions_imputed
#' 
#' @description Calculate the proportions of each level of a variable after 
#' to calculate using `combine_replicates` on completed data (that includes
#' imputed values).
#'
#' @param complete_tab A dataframe containing the output from `combine_replicates`.
#' @param strata_vars A vector of column names identifying the variables to be
#' used for stratification.
#' @param digits Number of decimal places to round the results to.
#' 
#' @return A dataframe that contains the proportions after to apply 
#' `combine_replicates` 
#' @export
#' @examples
#' \dontrun{
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", conflict_filter = FALSE, forced_dis_filter = FALSE, 
#' edad_minors_filter = FALSE, include_props = FALSE, prop_obs_na = FALSE, 
#' digits = 2)
#' tab_combine <- combine_replicates("reclutamiento", tab_observed,
#' replicates_data, strata_vars = 'sexo', conflict_filter = TRUE,
#' forced_dis_filter = FALSE, edad_minors_filter = FALSE)
#' prop_data_complete <- proportions_imputed(tab_combine, strata_vars, 
#' na_obs = TRUE, digits = 2)
#' }
proportions_imputed <- function(complete_tab, 
                                strata_vars, 
                                digits = NULL) {
  
  if (is.null(digits)) {
    digits <- 2
  }
  
  proportions_tab <- complete_tab %>%
    dplyr::mutate(imp_lo_p = round(imp_lo / sum(imp_mean, na.rm = TRUE), digits = digits),
                  imp_mean_p = round(imp_mean / sum(imp_mean, na.rm = TRUE), digits = digits),
                  imp_hi_p = round(imp_hi / sum(imp_mean, na.rm = TRUE), digits = digits))
  
  proportions_tab <- proportions_tab %>% 
    dplyr::select(all_of({{strata_vars}}), 
                  imp_lo, imp_mean, imp_hi, 
                  imp_lo_p, imp_mean_p, imp_hi_p)
  
  return(proportions_tab)

}

#' Combine replicates according to the Normal approximation using the laws of total expectation and variance.
#'
#' @param tab_observed Dataframe that results from applying `summary_observed`.
#' @param replicates_df Data frame containing replicates data.
#' @param strata_vars Variable with all observations (without missing values).
#' @param conflict_filter Filter that indicates if the data is filtered using
#' the "is_conflict" rule.
#' @param violation Violation to be analyzed. Options are "homicidio", "secuestro",
#' "reclutamiento" and "desaparicion".
#' @param forced_dis_filter Filter that indicates if the data is filtered using the
#' "is_forced_dis" rule.
#' @param edad_minors_filter Optional filter by age ("edad") < 18.
#' @param include_props A logical value indicating whether or not to include
#'  the proportions from the calculations before to merge with summary_observed's output
#' @param digits Number of decimal places to round the results to.
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
#' strata_vars = "sexo", conflict_filter = FALSE, forced_dis_filter = FALSE, 
#' edad_minors_filter = FALSE, include_props = FALSE, prop_obs_na = FALSE, 
#' digits = 2)
#' tab_combine <- combine_replicates("reclutamiento", tab_observed,
#' replicates_data, strata_vars = 'sexo', conflict_filter = TRUE,
#' forced_dis_filter = FALSE, edad_minors_filter = FALSE, include_props = TRUE)
combine_replicates <- function(violation,
                               tab_observed,
                               replicates_df,
                               strata_vars,
                               conflict_filter = TRUE,
                               forced_dis_filter = FALSE,
                               edad_minors_filter = FALSE,
                               include_props = FALSE,
                               digits = NULL) {

    num_replicates <- dplyr::n_distinct(replicates_df$replica)

    if (num_replicates == 1) {

        stop("You should work with more than one replicate")

        }

    else {

        logger::log_info("You are working to {num_replicates}
                     replicates according to filter")

        }

    if (conflict_filter == TRUE) {
  
      logger::log_info("Analyzing victims related to armed conflict")
      
        prep_data <- replicates_df %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict)) %>%
            dplyr::filter(is_conflict == 1)
        
    } else {
      
      logger::log_info("You are working with all victims (related and not related to is_conflict)")
      
        pre_data <- replicates_df %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict))
    }
    

    if (edad_minors_filter == TRUE) {
      
      logger::log_info("Analyzing victims under 18 years of age")
      
      prep_data <- prep_data %>%
        dplyr::filter(edad_jep == "INFANCIA" | 
                      edad_jep == "ADOLESCENCIA")

    } else {

      logger::log_info("Analyzing victims of all ages")

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

      rep_data <- proportions_imputed(rep_data, strata_vars, digits)
      
    } else {
      
      logger::log_info("Didn't include the proportions")
      
    }

    final_data <- rep_data %>% 
        dplyr::mutate(dplyr::across(all_of(strata_vars), as.character)) 
    
    final_data <- dplyr::full_join(rep_data, tab_observed, by = {{strata_vars}}) %>%
        dplyr::mutate(imp_lo = dplyr::if_else(imp_lo < observed,
                                              observed, imp_lo))

    final_data <- final_data %>%
        dplyr::select(all_of({{strata_vars}}), observed,
                      dplyr::everything())

    return(final_data)

    }

# --- Done
