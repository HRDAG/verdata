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
        dplyr::filter(dplyr::between(yy_hecho, 1985, 2019)) %>%
        dplyr::mutate(p_str = as.character(p_str)) %>%
        dplyr::mutate(p_str = base::ifelse(yy_hecho > 2016 & p_str == "GUE-FARC",
                              "GUE-OTRO", p_str)) %>%
        dplyr::mutate(edad_c = dplyr::case_when(edad_categoria == "De 0 a 4" ~ "MENOR",
                                                edad_categoria == "De 5 a 9" ~ "MENOR",
                                                edad_categoria == "De 10 a 14" ~ "MENOR",
                                                edad_categoria == "De 15 a 17" ~ "MENOR",
                                                edad_categoria == "De 18 a 22" ~ "ADULTO",
                                                edad_categoria == "De 23 a 27" ~ "ADULTO",
                                                edad_categoria == "De 28 a 32" ~ "ADULTO",
                                                edad_categoria == "De 33 a 37" ~ "ADULTO",
                                                edad_categoria == "De 38 a 42" ~ "ADULTO",
                                                edad_categoria == "De 43 a 47" ~ "ADULTO",
                                                edad_categoria == "De 48 a 52" ~ "ADULTO",
                                                edad_categoria == "De 53 a 57" ~ "ADULTO",
                                                edad_categoria == "De 58 a 62" ~ "ADULTO",
                                                edad_categoria == "De 63 a 67" ~ "ADULTO",
                                                edad_categoria == "De 68 a 72" ~ "ADULTO",
                                                edad_categoria == "De 73 a 77" ~ "ADULTO",
                                                edad_categoria == "De 78 a 82" ~ "ADULTO",
                                                edad_categoria == "De 83 a 87" ~ "ADULTO",
                                                edad_categoria == "De 88 a 92" ~ "ADULTO",
                                                edad_categoria == "De 93 a 97" ~ "ADULTO",
                                                edad_categoria == "De 98 a 100" ~ "ADULTO",
                                                TRUE ~ NA_character_)) %>%
        dplyr::mutate(edad_c_imputed = dplyr::if_else(edad_categoria_imputed == FALSE, FALSE, TRUE))

    if (violation == "desaparicion") {

        data_filter <- data_filter %>%
            dplyr::filter(dplyr::between(yy_hecho, 1985, 2016)) %>%
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


    } else if (violation == "reclutamiento") {
        data_filter <- data_filter %>%
            dplyr::filter(dplyr::between(yy_hecho, 1990, 2017)) %>%
            dplyr::filter(edad_categoria == "De 0 a 4" |
                          edad_categoria == "De 5 a 9" |
                          edad_categoria == "De 10 a 14" |
                          edad_categoria == "De 15 a 17")

    } else if (violation == "secuestro") {
        data_filter <- data_filter %>%
            dplyr::filter(dplyr::between(yy_hecho, 1990, 2018))

    } else if (violation == "homicidio") {
        data_filter <- data_filter %>%
            dplyr::filter(dplyr::between(yy_hecho, 1985, 2018))

    } else {

        stop("There is not more violations")
    }

    return(data_filter)

}

# Done
