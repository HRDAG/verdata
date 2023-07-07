# ============================================
# Authors:     PA
# Maintainers: PA, MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Filter records to replicate results presented in the CEV methodology report.
#'
#' @param replicates Dataframe with data from all replicates to be filtered.
#' @param violation Violation to be analyzed. Options are "homicidio", "secuestro",
#' "reclutamiento", and "desaparicion"
#' @param perp_change Change option: if there are victims in years after 2016 and 
#' if the perpetrator "p_str" is "GUE-FARC", these victims become victims of 
#' other guerrillas "GUE-OTRO"
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
filter_standard_cev <- function(replicates, violation, perp_change = TRUE) {

    if (!(violation %in% c("homicidio", "secuestro", "reclutamiento", "desaparicion"))) {

        stop("violation argument incorrectly specified")

    }
  
    data_filter <- replicates %>%
        dplyr::mutate(edad_c = dplyr::case_when(edad_jep == "INFANCIA" ~ "MENOR",
                                                edad_jep == "ADOLESCENCIA" ~ "MENOR",
                                                edad_jep == "ADULTEZ" ~ "ADULTO",
                                                TRUE ~ NA_character_)) %>%
      dplyr::mutate(edad_c_imputed = dplyr::if_else(edad_categoria_imputed == FALSE, FALSE, TRUE)) %>% 
      dplyr::mutate(etnia2 = case_when(etnia %in% c('MESTIZO') ~ "MESTIZO", 
                                       etnia %in% c('INDIGENA','NARP','ROM') ~ "ETNICO", 
                                       TRUE ~ NA_character_)) %>% 
      dplyr::mutate(etnia2_imputed = dplyr::if_else(etnia_imputed == FALSE, FALSE, TRUE)) %>% 
      dplyr::mutate(quinquenio = case_when(yy_hecho >= 1985 & yy_hecho <= 1989 ~ "1985_1989",
                                           yy_hecho >= 1990 & yy_hecho <= 1994 ~ "1990_1994",
                                           yy_hecho >= 1995 & yy_hecho <= 1999 ~ "1995_1999",
                                           yy_hecho >= 2000 & yy_hecho <= 2004 ~ "2000_2004",
                                           yy_hecho >= 2005 & yy_hecho <= 2009 ~ "2005_2009",
                                           yy_hecho >= 2010 & yy_hecho <= 2014 ~ "2010_2014",
                                           yy_hecho >= 2015 & yy_hecho <= 2019 ~ "2015_2019",
                                           TRUE ~ NA_character_)) %>%
      dplyr::mutate(muni_code_hecho = as.character(muni_code_hecho)) %>%
      dplyr::mutate_at(vars(muni_code_hecho),
                ~case_when(. == "91236" ~ "91263",
                           TRUE ~ .)) %>% 
      dplyr::mutate(muni_code_hecho = as.numeric(muni_code_hecho)) %>%
      assertr::verify(!is.na(quinquenio))

    if (perp_change == TRUE) {
      
      data_filter <- data_filter %>% 
      dplyr::mutate(p_str = as.character(p_str)) %>%
        dplyr::mutate(p_str = base::ifelse(yy_hecho > 2016 & p_str == "GUE-FARC",
                                           "GUE-OTRO", p_str))
        
    } else {
      
      logger::log_info("Not change in perp")
      
    }

    if (violation == "desaparicion") {
        # apply additional filters for desaparicion
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
        # apply additional filters for reclutamiento
        data_filter <- data_filter %>%
            dplyr::filter(edad_jep == "INFANCIA" |
                          edad_jep == "ADOLESCENCIA")
    }

    return(data_filter)
    
}

# --- Done
