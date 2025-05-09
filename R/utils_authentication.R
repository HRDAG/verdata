# ============================================
# Authors:     MJ
# Maintainers: MJ, MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Calculate measurements in order to make sure each replicate file has the correct
#' content.
#'
#' @param replicate_path A string that contains a path to the replicate to be checked.
#'
#' @return A data frame with the results.
#'
#' @noRd
medidas <- function(replicate_path) {

    ext <- tools::file_ext(replicate_path)

    if (ext == "parquet") {

        replicate_data <- arrow::read_parquet(replicate_path)

    }

    else {

        replicate_data <- readr::read_csv(replicate_path)

    }

    replicate <- unique(replicate_data$replica)

    dpto <- replicate_data %>%
        dplyr::group_by(dept_code_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::filter(dept_code_hecho == 5 | dept_code_hecho == 20) %>%
        dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                               "5" = "antioquia",
                                               "20" = "cesar")) %>%
        dplyr::select(variable,valor)

    etnia <- replicate_data %>%
        dplyr::group_by(etnia) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::filter(etnia == "NARP" | etnia == "INDIGENA") %>%
        dplyr::rename(variable = etnia) %>%
        dplyr::select(variable,valor)

    edad <- replicate_data %>%
        dplyr::group_by(edad_categoria) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::filter(edad_categoria == "50-54") %>%
        dplyr::mutate(edad_categoria = as.character(edad_categoria)) %>%
        dplyr::rename(variable = edad_categoria) %>%
        dplyr::select(variable, valor)

    year_2002_2007 <- replicate_data %>%
        dplyr::filter(yy_hecho >= 2002 & yy_hecho <= 2007) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = "2002-2007") %>%
        dplyr::select(variable, valor)

    year_1990_1994 <- replicate_data %>%
        dplyr::filter(yy_hecho >= 1990 & yy_hecho <= 1994) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = "1990-1994") %>%
        dplyr::select(variable, valor)

    sexo <- replicate_data %>%
        dplyr::group_by(sexo) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::rename(variable = sexo) %>%
        dplyr::select(variable, valor)

    perp <- replicate_data %>%
        dplyr::group_by(p_str) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::rename(variable = p_str) %>%
        dplyr::select(variable, valor)

    w_minor <- replicate_data %>%
        dplyr::filter(sexo == "MUJER" & edad_categoria == "10-14") %>%
        dplyr::group_by(sexo) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(sexo,
                                               "MUJER" = "mujer menor de edad")) %>%
        dplyr::select(variable, valor)

    caq_89_93 <- replicate_data %>%
        dplyr::filter(yy_hecho >= 1989 & yy_hecho <= 1993 & dept_code_hecho == 18) %>%
        dplyr::group_by(dept_code_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                               "18" = "caqueta entre 1989 y 1993")) %>%
        dplyr::select(variable, valor)

    may <- replicate_data %>%
        dplyr::filter(yymm_hecho == 199005) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = "mayo de 1999") %>%
        dplyr::select(variable, valor)

    paras_bog <- replicate_data %>%
        dplyr::filter(p_str == "PARA" & dept_code_hecho == 11) %>%
        dplyr::group_by(dept_code_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                               "11" = "paramilitares en bogota")) %>%
        dplyr::select(variable, valor)

    paras_2016 <- replicate_data %>%
        dplyr::filter(p_str == "PARA" & yy_hecho == 2016) %>%
        dplyr::group_by(yy_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(yy_hecho,
                                               "2016" = "paramilitares en 2016")) %>%
        dplyr::select(variable, valor)

    mestizo_2000 <- replicate_data %>%
        dplyr::filter(yy_hecho == 2000 & etnia == "MESTIZO") %>%
        dplyr::group_by(etnia) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(etnia,
                                               "MESTIZO" = "mestizos en el 2000")) %>%
        dplyr::select(variable, valor)

    farc_2007 <- replicate_data %>%
        dplyr::filter(yy_hecho == 2007 & p_str == "GUE-FARC") %>%
        dplyr::group_by(yy_hecho) %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = dplyr::recode(yy_hecho,
                                               "2007" = "farc en 2007")) %>%
        dplyr::select(variable, valor)

    N_rows <- replicate_data %>%
        dplyr::summarise(valor = dplyr::n()) %>%
        dplyr::mutate(variable = "N rows") %>%
        dplyr::select(variable, valor)

    N_in_24 <- replicate_data %>%
        dplyr::summarise(valor = sum(in_24)) %>%
        dplyr::mutate(variable = "N in_24") %>%
        dplyr::select(variable, valor)

    comparar <- dplyr::bind_rows(dpto, etnia, edad, year_2002_2007, year_1990_1994,
                                 sexo, perp, w_minor, caq_89_93, may, paras_bog,
                                 paras_2016, mestizo_2000, farc_2007, N_rows, N_in_24)

    replicate <- rep(replicate, each = nrow(comparar)) %>%
        as.data.frame()

    names(replicate) <- "replica"

    comparar <- dplyr::bind_cols(replicate, comparar)

    comparar$valor <- as.numeric(comparar$valor)

    return(comparar)

}

#' Calculate measurements in order to ensure that each replicate file has the
#' correct content.
#'
#' @param replicates_dir A string that contains a path to the directory containing
#' the replicates to be checked
#' @param violation Violation to be analyzed. Options are "homicidio", "secuestro",
#' "reclutamiento", and "desaparicion".
#' @param replicate_nums A numeric vector containing the replicates to be analyzed.
#' Values in the vector should be between 1 and 100 inclusive.
#' @return A data frame with the path to the replicates, the replicate number,
#' and violation type.
#'
#' @noRd
build_path <- function(replicates_dir, violation, replicate_nums) {

    if (length(replicate_nums) == 0) {
        stop("replicate_nums is empty, please specifify which replicates to use")
    }

    if (!all(is.numeric(replicate_nums))) {
        stop("replicate_nums should contain only numeric values")
    }

    if (any(replicate_nums < 1 | replicate_nums > 100)) {
        stop("All values of replicate_nums should be between 1 and 100 inclusive")
    }

    valid_violations <- c("secuestro",
                          "reclutamiento",
                          "homicidio",
                          "desaparicion")

    if (violation %in% valid_violations) {

        path <- list.files(path = replicates_dir, full.names = TRUE)

        if (rlang::is_empty(path)) {

            stop("This directory does not contain any files")

        }

        parquet_check <- list.files(replicates_dir, pattern = "parquet")

        csv_check <- list.files(replicates_dir, pattern = "csv")

        if (rlang::is_empty(parquet_check) & rlang::is_empty(csv_check)) {

            stop("No parquet or csv files were found in this directory")

        }

        if (!rlang::is_empty(parquet_check) & rlang::is_empty(csv_check)) {

            file_extension <- "parquet"

        }

        if (rlang::is_empty(parquet_check) & !rlang::is_empty(csv_check)) {

            file_extension <- "csv"

        }

        if (!rlang::is_empty(parquet_check) & !rlang::is_empty(csv_check)) {

            file_extension <- "parquet"

        }

        if (file_extension == "parquet") {

            matchpattern <- "([^-]+)\\-R([0-9]+).parquet"

            matches <- stringr::str_match(path, matchpattern) %>%
                tibble::as_tibble(.name_repair = ~c("full_match",
                                                    "violation",
                                                    "rep_number"))

            rep_lista <- tibble::tibble(full_path = path, matches) %>%
                dplyr::mutate(rep_number = as.integer(rep_number)) %>%
                dplyr::filter(violation == violation & rep_number %in% replicate_nums)

        } else {

            matchpattern <- "([^-]+)\\-R([0-9]+).csv"

            matches <- stringr::str_match(path, matchpattern) %>%
                tibble::as_tibble(.name_repair = ~c("full_match",
                                                    "violation",
                                                    "rep_number"))

            rep_lista <- tibble::tibble(full_path = path, matches) %>%
                dplyr::mutate(rep_number = as.integer(rep_number)) %>%
                dplyr::filter(violation == violation & rep_number %in% replicate_nums)
        }

        if (nrow(rep_lista) < length(replicate_nums)) {

            missing_reps <- setdiff(replicate_nums, rep_lista$rep_number)
            stop(glue::glue("replicates_dir missing replicates:\n{paste0(missing_reps, collapse = '\n')}"))

        }

        return(rep_lista %>% purrr::pluck("full_path"))
    }

    else {

        stop("Violation argument incorrectly specified. Please enter one of the following valid violation types: reclutamiento, secuestro, homicidio, desaparicion")

    }

}

# done.
