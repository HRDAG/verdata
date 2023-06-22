# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' @title proportions_observed
#' 
#' @description Calculate the proportions of each level of a variable after 
#' to calculate using `summary_observed` on observed values.
#'
#' @param obs_tab A dataframe containing the output from `summary_observed`.
#' @param strata_vars A vector of column names identifying the variables to be
#' used for stratification.
#' @param prop_obs_na A logical value indicating whether or not to include missing
#' observations in the calculations.
#' @param digits Number of decimal places to round the results to.
#'
#' @return A dataframe that contains the proportions after to apply 
#' `summary_observed` 
#' @export
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2)
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", conflict_filter = TRUE, forced_dis_filter = FALSE, 
#' edad_minors_filter = TRUE, include_props = TRUE, prop_obs_na = TRUE)
#' prop_data <- proportions_observed(tab_observed, strata_vars = "sexo", 
#' prop_obs_na = TRUE, digits = 2)
proportions_observed <- function(obs_tab, strata_vars, prop_obs_na = TRUE, 
                                 digits = NULL){
  
  if (is.null(digits)) {
    digits <- 2
  }
  
  if (prop_obs_na == FALSE)  {
    
    tab_na <- obs_tab %>%
      dplyr::mutate(obs_prop = round(observed / sum(observed, na.rm = TRUE),
                                     digits = digits))
    
    data_final_prop <- dplyr::left_join(obs_tab, tab_na) %>%
      dplyr::select(all_of({{strata_vars}}),
                    observed, obs_prop)
    
  } else {
    
    tab_com <- obs_tab %>%
      dplyr::mutate(obs_prop_na = round((observed / sum(observed, na.rm = TRUE)),
                                        digits = digits))
    
    tab_na <- tab_com %>%
      dplyr::filter(!is.na(observed)) %>%
      dplyr::filter(dplyr::if_any(all_of({{strata_vars}}), ~!is.na(.))) %>%
      dplyr::mutate(obs_prop = round(observed / sum(observed, na.rm = TRUE), 
                                     digits = digits))
    
    data_final_prop <- dplyr::left_join(tab_com, tab_na) %>%
      dplyr::select(all_of({{strata_vars}}), observed, obs_prop_na, obs_prop)
  }
  
  return(data_final_prop)
  
}

#' Summary statistics for observed data.
#'
#' @param violation Violation to be analyzed. Options are "homicidio", "secuestro",
#' "reclutamiento", and "desaparicion".
#' @param replicates_df Data frame containing replicate data.
#' @param strata_vars Variable to be analyzed. Before imputation
#' this variable may have missing values.
#' @param conflict_filter Filter that indicates if the data is filtered by
#' the rule "is_conflict" or not.
#' @param forced_dis_filter Filter that indicates if the data is filter by
#' the rule "is_forced_dis" or not.
#' @param edad_minors_filter Optional filter by age ("edad") < 18.
#' @param include_props A logical value indicating whether or not to include
#'  the proportions from the calculations.
#' @param prop_obs_na A logical value indicating whether or not to include missing
#' observations in the calculations.
#' @param digits Number of decimal places to round the results to.
#' @return Data frame with two or more columns, (1) name of variable(s) and (2)
#' the number of observations in each variable's category.
#' @export
#' @importFrom dplyr if_else
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2)
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", conflict_filter = FALSE, forced_dis_filter = FALSE, 
#' edad_minors_filter = FALSE, include_props = FALSE, prop_obs_na = FALSE, 
#' digits = 2)
summary_observed <- function(violation,
                             replicates_df, 
                             strata_vars = NULL, 
                             conflict_filter = FALSE,
                             forced_dis_filter = FALSE,
                             edad_minors_filter = FALSE,
                             include_props = TRUE,
                             prop_obs_na = FALSE,
                             digits = NULL) {
  
  if (!(violation %in% c("homicidio", "secuestro", "reclutamiento", "desaparicion"))) {
    
    stop("violation argument incorrectly specified")
    
  }

  num_replicates <- dplyr::n_distinct(replicates_df$replica)
  
  if (num_replicates == 1) {
    
    stop("You should work with more than one replicate")
    
  } else {
    
    logger::log_info("You are working to {num_replicates} replicates according to filter")
    
  } 
  
  if (conflict_filter == TRUE) {
    
    logger::log_info("Analyzing documented victims related to armed conflict")
    
    obs_tab <- replicates_df %>%
      dplyr::mutate(is_conflict = as.integer(is_conflict)) %>%
      dplyr::filter(is_conflict == 1) %>%
      dplyr::mutate(is_conflict_imputed = as.logical(is_conflict_imputed)) %>%
      dplyr::filter(!is_conflict_imputed)
    
  } else {
    
    print("You are working with all victims (related and not related to is_conflict)")
    
    obs_tab <- replicates_df %>%
      dplyr::mutate(is_conflict = as.integer(is_conflict))
    
  } 
  
  if (edad_minors_filter == TRUE) {
    
    logger::log_info("Analyzing documented victims under 18 years of age")
    
    obs_tab <- obs_tab %>%
      dplyr::filter(edad_jep == "INFANCIA" |
                    edad_jep == "ADOLESCENCIA") %>% 
      dplyr::mutate(edad_jep_imputed = as.logical(edad_jep_imputed)) %>%
      dplyr::filter(!edad_jep_imputed)
    
  } else {
    
    logger::log_info("Analyzing victims of all ages")
    obs_tab <- obs_tab 
    
  } 
  
  if (forced_dis_filter == TRUE & violation == "desaparicion") {
    
    logger::log_info("Analyzing the documented victims who were victims of forced disappearance")
    
    obs_tab <- obs_tab %>%
      dplyr::mutate(is_forced_dis = as.integer(is_forced_dis)) %>%
      dplyr::filter(is_forced_dis == 1) %>% 
      dplyr::mutate(is_forced_dis_imputed = as.logical(is_forced_dis_imputed)) %>%
      dplyr::filter(!is_forced_dis_imputed)

  } else {

    logger::log_info("Not filtering in is_forced_dis")

    obs_tab <- obs_tab

  }

  for (var_rep in strata_vars) {
    var_imputed <- paste0(var_rep, "_imputed")
    if (!(var_imputed %in% names(obs_tab))) {
      obs_tab[[var_imputed]] <- FALSE
    }
    obs_tab[[var_rep]][as.logical(obs_tab[[var_imputed]])] <- NA_character_
  } 

  obs_tab <- obs_tab %>%
    dplyr::mutate(dplyr::across(any_of({{strata_vars}}), as.character)) %>%
    dplyr::group_by(replica, dplyr::across(any_of({{strata_vars}}))) %>%
    dplyr::summarize(N = dplyr::n(), .groups = 'drop') %>%
    dplyr::group_by(dplyr::across(any_of({{strata_vars}}))) %>% 
    dplyr::summarise(observed = round(mean(N), 0), .groups = 'drop') %>%
    dplyr::ungroup()
  
  if (include_props == TRUE) {
    
    logger::log_info("Including the proportions")
    obs_tab <- proportions_observed(obs_tab, strata_vars, prop_obs_na, digits)

  } else {

    logger::log_info("Didn't include the proportions")

  }

  return(obs_tab)
}

# --- Done