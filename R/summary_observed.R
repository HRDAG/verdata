# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Summary statistics for observed data.
#'
#' @param violation Violation to be analyzed. Options are "homicidio", "secuestro",
#' "reclutamiento", and "desaparicion".
#' @param data_rep Data frame containing replicate data.
#' @param strata_vars Variable to be analyzed. Before imputation
#' this variable may have missing values.
#' @param conflict_filter Filter that indicates if the data is filtered by
#' the rule "is_conflict" or not.
#' @param forced_dis Filter that indicates if the data is filter by
#' the rule "is_forced_dis" or not.
#' @param strata_vars_com Variable that will be analyzed and does not have
#' missing values (before imputation).
#' @param edad_minors Optional filter by age ("edad") < 18.
#' @param edad_na Filter that indicates if the data is filtered by observations
#' (in age "edad") that was not imputed (original in the data) = TRUE, or if shows
#' all observations (FALSE).
#' @param perp_na Filter that indicates if the data is filtered by observations
#' (in "p_str") that was not imputed (original in the data) = TRUE, or if shows
#' all observations (FALSE).
#' @param sexo_na Filter that indicates if the data is filtered by observations
#' (in "sexo") that was not imputed (original in the data) = TRUE, or if shows
#' all observations (FALSE).
#' @param municipio_na Filter that indicates if the data is filtered by observations
#' (in "muni_code_hecho") that was not imputed (original in the data) = TRUE, or if shows
#' all observations (FALSE).
#' @param etnia_na Filter that indicates if the data is filtered by observations
#' (in "etnia") that was not imputed (original in the data) = TRUE, or if shows
#' all observations (FALSE).
#' @param is_conflict_na Filter that indicates if the data is filtered by observations
#' (in "is_conflict") that was not imputed (original in the data) = TRUE, or if shows
#' all observations (FALSE).
#' @param is_forced_dis_na Filter that indicates if the data is filtered by observations
#' (in "is_forced_dis") that was not imputed (original in the data) = TRUE, or if shows
#' all observations (FALSE).
#'
#' @return Data frame with two or more columns, (1) name of variable(s) and (2)
#' the number of observations in each variable's category.
#' @export
#' @importFrom dplyr if_else
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", strata_vars_com = "yy_hecho",
#' conflict_filter = TRUE, is_conflict_na = TRUE, forced_dis = FALSE,
#' is_forced_dis_na = TRUE, edad_minors = TRUE, edad_na = FALSE, perp_na = FALSE,
#' sexo_na = FALSE, municipio_na = FALSE, etnia_na = FALSE)
summary_observed <- function(violation, data_rep, strata_vars_com = NULL,
                             strata_vars = NULL, conflict_filter = TRUE,
                             is_conflict_na = TRUE, forced_dis = FALSE,
                             is_forced_dis_na = FALSE, edad_minors = FALSE,
                             edad_na = FALSE, perp_na = FALSE,
                             sexo_na = FALSE, municipio_na = FALSE,
                             etnia_na = FALSE) {

    if (conflict_filter == TRUE) {
        obs_tab <- data_rep %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict)) %>%
            dplyr::filter(is_conflict == 1)
    } else {
        print("Not filter is_conflict = 1 in the data")
        obs_tab <- data_rep %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict))
    }
    if (edad_minors == TRUE) {

        logger::log_info("Filtering minors (< 18 years old)")
        obs_tab <- obs_tab %>%
          dplyr::filter(edad_jep == "INFANCIA" |
                        edad_jep == "ADOLESCENCIA")

    } else {

        logger::log_info("Not filtering minors (< 18 years old)")

    }

    if (forced_dis == TRUE & violation == "desaparicion") {

        obs_tab <- obs_tab %>%
            dplyr::mutate(is_forced_dis = as.integer(is_forced_dis)) %>%
            dplyr::filter(is_forced_dis == 1)

    } else {

        print("This violation does not have is_forced_dis")

    }

    if (is_conflict_na == TRUE) {

        obs_tab <- obs_tab %>%
            dplyr::mutate(is_conflict_imputed = as.logical(is_conflict_imputed)) %>%
            dplyr::filter(!is_conflict_imputed)
    }

    if (is_forced_dis_na == TRUE & violation == "desaparicion") {

        obs_tab <- obs_tab %>%
            dplyr::mutate(is_forced_dis_imputed = as.logical(is_forced_dis_imputed)) %>%
            dplyr::filter(!is_forced_dis_imputed)
    }

    if (edad_na == TRUE) {

        obs_tab <- obs_tab %>%
            dplyr::mutate(edad_categoria_imputed = as.logical(edad_categoria_imputed)) %>%
            dplyr::filter(!edad_categoria_imputed)

    }

    if (perp_na == TRUE) {

        obs_tab <- obs_tab %>%
            dplyr::mutate(p_str_imputed = as.logical(p_str_imputed)) %>%
            dplyr::filter(!p_str_imputed)

    }

    if (sexo_na == TRUE) {

        obs_tab <- obs_tab %>%
            dplyr::mutate(sexo_imputed = as.logical(sexo_imputed)) %>%
            dplyr::filter(!sexo_imputed)

    }

    if (municipio_na == TRUE) {

        obs_tab <- obs_tab %>%
            dplyr::mutate(muni_code_hecho_imputed = as.logical(muni_code_hecho_imputed)) %>%
            dplyr::filter(!muni_code_hecho_imputed)
    }

    if (etnia_na == TRUE) {

        obs_tab <- obs_tab %>%
            dplyr::mutate(etnia_imputed = as.logical(etnia_imputed)) %>%
            dplyr::filter(!etnia_imputed)

    }

    mutate_imputed <- function(data, strata_vars, strata_vars_com) {
        impute_vars <- function(data, var) {
            var_imputed <- paste0(var, "_imputed")
            data %>% dplyr::mutate(!!rlang::sym(var) := if_else(as.logical(!!rlang::sym(var_imputed)),
                                                                NA_character_, as.character(!!rlang::sym(var))))
        }

        for (var in strata_vars) {
            data <- impute_vars(data, var)
        }

        obs_tab <- data %>%
            dplyr::mutate(dplyr::across(any_of({{strata_vars_com}}), as.character)) %>%
            dplyr::group_by(replica,
                            dplyr::across(any_of({{strata_vars}})),
                            dplyr::across(any_of({{strata_vars_com}}))) %>%
            dplyr::summarize(N = dplyr::n(), .groups = 'drop') %>%
            dplyr::group_by(dplyr::across(any_of({{strata_vars}})),
                            dplyr::across(any_of({{strata_vars_com}}))) %>%
            dplyr::summarise(observed = round(mean(N), 0), .groups = 'drop') %>%
            dplyr::ungroup()

        return(obs_tab)

    }

    if (base::missing(strata_vars_com))  {

        obs_tab <- obs_tab %>%
            mutate_imputed(strata_vars)

    } else if (base::missing(strata_vars))  {

        obs_tab <- obs_tab %>%
            dplyr::mutate(dplyr::across(any_of({{strata_vars_com}}), as.character)) %>%
            dplyr::group_by(replica, dplyr::across(any_of({{strata_vars_com}}))) %>%
            dplyr::summarize(N = dplyr::n(), .groups = 'drop') %>%
            dplyr::group_by(dplyr::across(any_of({{strata_vars_com}}))) %>%
            dplyr::summarise(observed = round(mean(N), 0), .groups = 'drop') %>%
            dplyr::ungroup()

    } else {

        obs_tab <- obs_tab %>%
            mutate_imputed(strata_vars, strata_vars_com) %>%
            dplyr::select(all_of({{strata_vars_com}}), all_of({{strata_vars}}), observed)
    }

    return(obs_tab)

}

# --- Done
