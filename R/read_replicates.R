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
#' @param version Version of the data being read in. Options are "v1" or "v2".
#' "v1" is appropriate for replicating the replicating the results of the joint
#' JEP-CEV-HRDAG project. "v2" is appropriate for conducting your new analyses
#' of the conflict in Colombia.
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
#' read_replicate(local_dir, version = "v1")
#'
#' @noRd
read_replicate <- function(replicate_path, version) {

    if (is.null(version) | !version %in% c("v1", "v2")) {

        stop("Data version not properly specified. Options are 'v1' or 'v2'.")

    }

    violacion <- stringr::str_extract(pattern = "homicidio|desaparicion|secuestro|reclutamiento",
                                      replicate_path)

    file_extension <- stringr::str_extract(pattern = "parquet|csv", replicate_path)


    if (version == "v1" & file_extension == "parquet") {

        replicate_data <- arrow::read_parquet(replicate_path)

        hash_intor <- dplyr::tibble(violacion = violacion,
                                    replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                                   replicate_path),
                                    hash = digest::digest(replicate_data, algo = "sha1"))

        content_test <- content_parquet_v1 %>%
            dplyr::filter(replica %in% hash_intor$replica,
                          violacion == hash_intor$violacion)


    } else if (version == "v2" & file_extension == "parquet") {

        replicate_data <- arrow::read_parquet(replicate_path)

        hash_intor <- dplyr::tibble(violacion = violacion,
                                    replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                                   replicate_path),
                                    hash = digest::digest(replicate_data, algo = "sha1"))

        content_test <- content_parquet_v2 %>%
            dplyr::filter(replica %in% hash_intor$replica,
                          violacion == hash_intor$violacion)

    } else if (version == "v1" & file_extension == "csv") {

        replicate_data <- readr::read_csv(replicate_path)

        hash_intor <- dplyr::tibble(violacion = violacion,
                                    replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                                   replicate_path),
                                    hash = digest::digest(replicate_data, algo = "sha1"))

        content_test <- content_csv_v1 %>%
            dplyr::filter(replica %in% hash_intor$replica)


    } else if (version == "v2" & file_extension == "csv") {

        replicate_data <- readr::read_csv(replicate_path)

        hash_intor <- dplyr::tibble(violacion = violacion,
                                    replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                                   replicate_path),
                                    hash = digest::digest(replicate_data, algo = "sha1"))

        content_test <- content_csv_v2 %>%
            dplyr::filter(replica %in% hash_intor$replica)

    }

    is_eq <- all.equal(content_test, hash_intor)

    if (isTRUE(is_eq)) {

        return(replicate_data %>% dplyr::mutate(match = TRUE))

    } else {

        final <- medidas(replicate_path)

        violacion_file <- paste0(violacion, "_", version)

        summary_table <- get(violacion_file) %>%
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
#' @param replicates_dir A path to the directory containing the replicates.
#' Then file name of each replicate must contain at least the name of the violation
#' in Spanish and lower case letters (homicidio, secuestro, reclutamiento, desaparicion),
#' and the replicate number preceded by "R", (e.g., "R1" for replicate 1).
#' @param violation A string indicating the violation being analyzed. Options are
#' "homicidio", "secuestro", "reclutamiento", and "desaparicion".
#' @param replicate_nums A numeric vector containing the replicates to be analyzed.
#' Values in the vector should be between 1 and 100 inclusive.
#' @param version Version of the data being read in. Options are "v1" or "v2".
#' "v1" is appropriate for replicating the replicating the results of the joint
#' JEP-CEV-HRDAG project. "v2" is appropriate for conducting your new analyses
#' of the conflict in Colombia.
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
#' read_replicates(local_dir, "reclutamiento", 1, 2, version = "v1")
read_replicates <- function(replicates_dir, violation, replicate_nums,
                            version, crash = TRUE) {

    if (is.null(version) | !version %in% c("v1", "v2")) {

        stop("Data version not properly specified. Options are 'v1' or 'v2'.")

    }

    files <- build_path(replicates_dir, violation, replicate_nums)
    replicate_data <- purrr::map_dfr(files, read_replicate, version = version)

    corrupted_replicates <- replicate_data %>%
        dplyr::filter(!match) %>%
        dplyr::distinct(replica) %>%
        dplyr::pull(replica)

    hashes_match <- all(replicate_data$match)

    if (hashes_match) {

        if (version == "v1") {

            message("You are using v1 of the data. This version is appropriate for
                replicating the results of the joint JEP-CEV-HRDAG project. If you
                would like to conduct your own analysis of the conflict in Colombia,
                please use v2 of the data.")

        } else if (version == "v2") {

            message("You are using v2 of the data. This version is appropriate for
                conducting your own analysis of the conflict in Colombia. If you
                would like to repliate the results of the joint JEP-CEV-HRDAG project,
                please use v1 of the data.")

        }

        return(replicate_data %>% dplyr::select(-match))

    } else if (!hashes_match & !crash) {

        warning(glue::glue("The content of the files is not identical to the ones published.\nThe results of the analysis may be inconsistent.\nThe following replicates have incorrect content:\n{paste0(corrupted_replicates, collapse = '\n')}"))

        return(replicate_data %>% dplyr::select(-match))

    } else if (!hashes_match & crash) {

        stop(glue::glue("The content of the files is not identical to the ones published.\nThe results of the analysis may be inconsistent.\nThe following replicates have incorrect content:\n{paste0(corrupted_replicates, collapse = '\n')}"))

    }

}

# done.
