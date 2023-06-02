# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

#' Calculate measurements in order to make sure each replicate has the correct
#' content
#'
#' @param path A string that contains a path to the replicate to be checked
#'
#' @return A dataframe with the results
#'
#' @noRd
medidas <- function(path) {

    ext <- tools::file_ext(path)

    if (ext == "parquet") {

        df <- arrow::read_parquet(path)

        }

    else {

        df <- readr::read_csv(path)

        }

    replicate <- unique(df$replica)

    dpto <- df %>%
        dplyr::group_by(dept_code_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::filter(dept_code_hecho == 5 | dept_code_hecho == 20) %>%
        dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                 "5" = "antioquia",
                                 "20" = "cesar")) %>%
        dplyr::select(variable,valor)

    etnia <- df %>%
        dplyr::group_by(etnia) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::filter(etnia == "NARP" | etnia == "INDIGENA") %>%
        dplyr::rename(variable = etnia) %>%
        dplyr::select(variable,valor)

    edad <- df %>%
        dplyr::group_by(edad_categoria) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::filter(edad_categoria == "De 48 a 52 años") %>%
        dplyr::mutate(edad_categoria = as.character(edad_categoria)) %>%
        dplyr::rename(variable = edad_categoria) %>%
        dplyr::select(variable, valor)

    year_2002_2007 <- df %>%
        dplyr::filter(yy_hecho >= 2002 & yy_hecho <= 2007) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = "2002-2007") %>%
        dplyr::select(variable, valor)

    year_1990_1994 <- df %>%
        dplyr::filter(yy_hecho >= 1990 & yy_hecho <= 1994) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = "1990-1994") %>%
        dplyr::select(variable, valor)

    sexo <- df %>%
        dplyr::group_by(sexo) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::rename(variable = sexo) %>%
        dplyr::select(variable, valor)

    perp <- df %>%
        dplyr::group_by(p_str) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::rename(variable = p_str) %>%
        dplyr::select(variable, valor)

    w_minor <- df %>%
        dplyr::filter(sexo == "MUJER" & edad_categoria == "De 10 a 14 años") %>%
        dplyr::group_by(sexo) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(sexo,
                                        "MUJER" = "mujer menor de edad")) %>%
        dplyr::select(variable, valor)

    caq_89_93 <- df %>%
        dplyr::filter(yy_hecho >= 1989 & yy_hecho <= 1993 & dept_code_hecho == 18) %>%
        dplyr::group_by(dept_code_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                               "18" = "caqueta entre 1989 y 1993")) %>%
        dplyr::select(variable, valor)

    may <- df %>%
        dplyr::filter(yymm_hecho == 199005) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = "mayo de 1999") %>%
        dplyr::select(variable, valor)

    paras_bog <- df %>%
        dplyr::filter(p_str == "PARA" & dept_code_hecho == 11) %>%
        dplyr::group_by(dept_code_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                               "11" = "paramilitares en bogota")) %>%
        dplyr::select(variable, valor)

    paras_2016 <- df %>%
        dplyr::filter(p_str == "PARA" & yy_hecho == 2016) %>%
        dplyr::group_by(yy_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(yy_hecho,
                                               "2016" = "paramilitares en 2016")) %>%
        dplyr::select(variable, valor)

    mestizo_2000 <- df %>%
        dplyr::filter(yy_hecho == 2000 & etnia == "MESTIZO") %>%
        dplyr::group_by(etnia) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(etnia,
                                               "MESTIZO" = "mestizos en el 2000")) %>%
        dplyr::select(variable, valor)

    farc_2007 <- df %>%
        dplyr::filter(yy_hecho == 2007 & p_str == "GUE-FARC") %>%
        dplyr::group_by(yy_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(yy_hecho,
                                               "2007" = "farc en 2007")) %>%
        dplyr::select(variable, valor)

    comparar <- dplyr::bind_rows(dpto, etnia, edad, year_2002_2007, year_1990_1994,
                                 sexo, perp, w_minor, caq_89_93, may, paras_bog,
                                 paras_2016, mestizo_2000, farc_2007)

    replicate <- rep(replicate, each = nrow(comparar)) %>%
        as.data.frame()

    names(replicate) <- "replica"

    comparar <- dplyr::bind_cols(replicate, comparar)

    comparar$valor <- as.numeric(comparar$valor)

    return(comparar)

}

#' Calculate measurements in order to make sure each replicate has the correct
#' content
#'
#' @param rep_directory A string that contains a path to the replicates to be checked
#' @param violacion Violation being analyzed (homicidio, secuestro, reclutamiento,
#' desaparicion)
#' @param first_rep First replicate in the range of replicates to be analyzed
#' @param last_rep Last replicate in the range of replicates to be analyzed
#' @param file_extension Extension of the file to be read. Available options are
#' "parquet" or "csv".
#
#'
#' @return A dataframe with the path to the replicates, the replicate number
#' and violation
#'
#' @noRd
build_path <- function(rep_directory, violacion, first_rep, last_rep,
                       file_extension) {

    path <- list.files(path = rep_directory, full.names = TRUE)

    if (file_extension == "parquet") {

    matchpattern <- "([^-]+)\\-R([0-9]+).parquet"

    matches <- stringr::str_match(path, matchpattern) %>%
        tibble::as_tibble(.name_repair = ~c("full_match", "violation", "rep_number"))

    rep_lista <- tibble::tibble(full_path = path, matches) %>%
        dplyr::mutate(rep_number = as.integer(rep_number)) %>%
        dplyr::filter(violation == violacion,
                      dplyr::between(rep_number, first_rep, last_rep)) %>%
        purrr::pluck("full_path")

    } else {

        matchpattern <- "([^-]+)\\-R([0-9]+).csv"

        matches <- stringr::str_match(path, matchpattern) %>%
            tibble::as_tibble(.name_repair = ~c("full_match", "violation", "rep_number"))

        rep_lista <- tibble::tibble(full_path = path, matches) %>%
            dplyr::mutate(rep_number = as.integer(rep_number)) %>%
            dplyr::filter(violation == violacion,
                          dplyr::between(rep_number, first_rep, last_rep)) %>%
            purrr::pluck("full_path")
    }

    return(rep_lista)
}


