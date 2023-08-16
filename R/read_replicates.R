# ============================================
# Authors:     MJ
# Maintainers: MJ, MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Read a replicate and hash its contents to make sure it's identical to the one published.
#'
#' @param replicate_path Path to the replicate. The name of the file must include
#' the violation in Spanish and lower case letters (homicidio, secuestro,
#' reclutamiento, desaparicion).
#'
#' @return A data frame with the data from the indicated replicate and a column
#' `match` indicating whether the file hash matches the expected hash.
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir <- system.file("extdata", "right",
#' package = "verdata", "verdata-reclutamiento-R1.csv.zip")
#' read_replicate(local_dir)
#'
#' local_dir <- system.file("extdata", "right",
#' package = "verdata", "verdata-reclutamiento-R1.parquet")
#' read_replicate(local_dir)
#'
#' @noRd
read_replicate <- function(replicate_path) {

    violacion <- stringr::str_extract(pattern = "homicidio|desaparicion|secuestro|reclutamiento",
                                      replicate_path)

    file_extension <- stringr::str_extract(pattern = "parquet|csv", replicate_path)

    if (file_extension == "parquet") {

        replicate_data <- arrow::read_parquet(replicate_path)

        hash_intor <- dplyr::tibble(violacion = violacion,
                                    replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                                   replicate_path),
                                    hash = digest::digest(replicate_data, algo = "sha1"))

        content_test <- content %>%
            dplyr::filter(replica %in% hash_intor$replica,
                          violacion == hash_intor$violacion)

    } else {

        replicate_data <- readr::read_csv(replicate_path)

        hash_intor <- dplyr::tibble(violacion = violacion,
                                    replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                                   replicate_path),
                                    hash = digest::digest(replicate_data, algo = "sha1"))

        content_test <- content_csv %>%
            dplyr::filter(replica %in% hash_intor$replica)

    }

    is_eq <- all.equal(content_test, hash_intor)

    if (isTRUE(is_eq)) {

        return(replicate_data %>% dplyr::mutate(match = TRUE))

    } else {

        final <- medidas(replicate_path)

        summary_table <- get(violacion) %>%
            dplyr::filter(replica %in% final$replica)

        final <- final[order(final$variable), ]

        summary_table <- summary_table[order(summary_table$variable), ]

        mea_eq <- all.equal(summary_table, final, check.attributes = FALSE)

        if (isTRUE(mea_eq)) {

            return(replicate_data %>% dplyr::mutate(match = TRUE))

        } else {

            return(replicate_data %>% dplyr::mutate(match = FALSE))

        }

    }

}

#' Read replicates in a directory and verify they are identical to the ones published.
#'
#' @param replicates_dir Adirectory to the replicates.
#' Then file name of each replicate must contain at least the name of the violation
#' in Spanish and lower case letters (homicidio, secuestro, reclutamiento, desaparicion),
#' and the replicate number preceded by "R", (e.g., "R1" for replicate 1).
#' @param violation A string indicating the violation being analyzed. Options are
#' "homicidio", "secuestro", "reclutamiento", and "desaparicion".
#' @param replicate_nums A numeric vector containing the replicates to be analyzed.
#' Values in the vector should be between 1 and 100 inclusive.
#' @param crash A parameter to define whether the function should crash if the
#' content of the file is not identical to the one published. If crash = TRUE
#' (default), it will return error and not read the data, if crash = FALSE, the
#' function will return a warning but still read the data.
#'
#' @return A data frame with the data from all indicated replicates.
#' @export
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' read_replicates(local_dir, "reclutamiento", 1, 2)
read_replicates <- function(replicates_dir, violation, replicate_nums,
                            crash = TRUE) {

    files <- build_path(replicates_dir, violation, replicate_nums)
    replicate_data <- purrr::map_dfr(files, read_replicate)

    corrupted_replicates <- replicate_data %>%
        dplyr::filter(!match) %>%
        dplyr::distinct(replica) %>%
        dplyr::pull(replica)

    if (crash) {

        if (all(replicate_data$match)) {

            return(replicate_data %>% dplyr::select(-match))

        } else {

            stop(glue::glue("The content of the files is not identical to the ones published.\nThe following replicates have incorrect content:\n{paste0(corrupted_replicates, collapse = '\n')}"))

        }

    } else {

        warning(glue::glue("The content of the files is not identical to the ones published.\nThe results of the analysis may be inconsistent.\nThe following replicates have incorrect content:\n{paste0(corrupted_replicates, collapse = '\n')}"))
        return(replicate_data %>% dplyr::select(-match))

    }

}


# done.
