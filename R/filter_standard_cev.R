# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Filter to obtain the CEV's results - methodological document
#'
#' @param replicates Data frame with the replicates
#' @param violation Violation to be analyzed
#'
#' @return Data frame filter
#' @export
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")
#' filter_standard_cev(replicates_data, "reclutamiento")
#'
filter_standard_cev <- function(replicates, violation) {

    data_filter <- replicates %>%
        dplyr::mutate(p_str = as.character(p_str)) %>%
        dplyr::mutate(p_str = base::ifelse(yy_hecho > 2016 & p_str == "GUE-FARC",
                              "GUE-OTRO", p_str)) %>%
        dplyr::mutate(edad_c = dplyr::case_when(edad_jep == "INFANCIA" ~ "MENOR",
                                                edad_jep == "ADOLESCENCIA" ~ "MENOR",
                                                edad_jep == "ADULTEZ" ~ "ADULTO",
                                                TRUE ~ NA_character_)) %>%
        dplyr::mutate(edad_c_imputed = dplyr::if_else(edad_categoria_imputed == FALSE, FALSE, TRUE))

    if (violation == "desaparicion") {

        data_filter <- data_filter %>%
            dplyr::mutate(is_forced_dis = as.integer(is_forced_dis)) %>%
            dplyr::mutate(is_conflict = as.integer(is_conflict))

        data_filter$is_conflict_dis <- ifelse(
            (data_filter$is_conflict == 1 & data_filter$is_conflict_imputed == FALSE &
                 data_filter$is_forced_dis == 1 & data_filter$is_forced_dis_imputed == FALSE),
            1,
            ifelse(
                (data_filter$is_conflict == 0 & data_filter$is_conflict_imputed == FALSE) |
                    (data_filter$is_forced_dis == 0 & data_filter$is_forced_dis_imputed == FALSE),
                0,
                NA
            )
        )

        data_filter$is_conflict_dis_imputed <- ifelse(
            is.na(data_filter$is_conflict_dis), TRUE, FALSE
        )

        data_filter$is_conflict_dis <- dplyr::case_when(
            is.na(data_filter$is_conflict_dis) ~ 1,
            data_filter$is_conflict_dis == 0 ~ 0,
            data_filter$is_conflict_dis == 1 ~ 1
        )

        data_filter <- data_filter %>%
            dplyr::mutate(is_conflict_dis_rep = NA) %>%
            dplyr::mutate(is_conflict_dis_rep = dplyr::case_when(
                is_forced_dis==0 | is_conflict==0 ~ 0,
                is_forced_dis==1 & is_conflict==1 ~ 1))

    } else if (violation == "reclutamiento") {
        data_filter <- data_filter %>%
            dplyr::filter(edad_jep == "INFANCIA" |
                          edad_jep == "ADOLESCENCIA")
    } else {

        stop("There are no more violations")
    }

    return(data_filter)

}

# Done
