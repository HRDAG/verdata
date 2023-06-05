# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Function to obtain proportions of each
#' variable after to use combine_replicates
#'
#' @param data_obs_rep a data frame containing the observed and
#' imputed values to be analyzed
#' @param strata_vars a vector of column names
#' identifying the variables to be used as strata in the analysis.
#' @param na_obs a logical value indicating whether or not to include missing
#' observations in the calculations (according to strata_vars).
#' @param digits Number of decimal places to round the proportion results to.
#'
#' @return Data frame that contains the proportions of each variable (from
#' summary_observed and combine_replicates)
#' @export
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")
#' tab_observed <- summary_observed("reclutamiento", replicates_data,
#' strata_vars = "sexo", strata_vars_com = "yy_hecho",
#' conflict_filter = TRUE, forced_dis = FALSE, edad_minors = TRUE)
#' tab_combine <- combine_replicates("reclutamiento", tab_observed,
#' replicates_data, strata_vars_rep = 'sexo', conflict_filter = TRUE,
#' forced_dis = FALSE, edad_minors = TRUE)
#' prop_data <- prop_obs_rep(tab_combine, "sexo", na_obs = TRUE, digits = 2)
prop_obs_rep <- function(data_obs_rep, strata_vars, na_obs = TRUE, digits = NULL){

    if (is.null(digits)) {
        digits <- 2
    }

    if (na_obs == FALSE)  {

        tab_na <- data_obs_rep %>%
            dplyr::mutate(obs_prop = round(observed / sum(observed, na.rm = TRUE), digits = digits),
                          imp_lo_p = round(imp_lo / sum(imp_mean, na.rm = TRUE), digits = digits),
                          imp_mean_p = round(imp_mean / sum(imp_mean, na.rm = TRUE), digits = digits),
                          imp_hi_p = round(imp_hi / sum(imp_mean, na.rm = TRUE), digits = digits))

        data_final_prop <- dplyr::left_join(data_obs_rep, tab_na) %>%
            dplyr::select(all_of({{strata_vars}}),
                                        observed, obs_prop, imp_lo,
                                        imp_mean, imp_hi, imp_lo_p,
                                        imp_mean_p, imp_hi_p)

    } else {

        tab_com <- data_obs_rep %>%
            dplyr::mutate(obs_prop_na = round((observed / sum(observed, na.rm = TRUE)), digits = digits))

        tab_na <- tab_com %>%
            dplyr::filter(!is.na(observed)) %>%
            dplyr::filter(dplyr::if_any(all_of({{strata_vars}}), ~!is.na(.))) %>%
            dplyr::mutate(obs_prop = round(observed / sum(observed, na.rm = TRUE), digits = digits),
                          imp_lo_p = round(imp_lo / sum(imp_mean, na.rm = TRUE), digits = digits),
                          imp_mean_p = round(imp_mean / sum(imp_mean, na.rm = TRUE), digits = digits),
                          imp_hi_p = round(imp_hi / sum(imp_mean, na.rm = TRUE), digits = digits))

        data_final_prop <- dplyr::left_join(tab_com, tab_na) %>%
            dplyr::select(all_of({{strata_vars}}),
                                        observed, obs_prop_na,
                                        obs_prop, imp_lo,
                                        imp_mean, imp_hi,
                                        imp_lo_p, imp_mean_p,
                                        imp_hi_p)
    }

    return(data_final_prop)

}

#--- Done.
