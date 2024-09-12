# ============================================
# Authors:     MJ
# Maintainers: MJ, MG
# Copyright:   2023, HRDAG, GPL v2 or later
# ============================================

#' Confirm a file is the same as the published version.
#'
#' @param replicate_path Path to the replicate to be confirmed. The name
#' of the files must include the violation in Spanish and lower case letters
#' (homicidio, secuestro, reclutamiento, desaparicion).
#' @param version Version of the data being read in. Options are "v1" or "v2".
#' "v1" is appropriate for replicating the replicating the results of the joint
#' JEP-CEV-HRDAG project. "v2" is appropriate for conducting your new analyses
#' of the conflict in Colombia.
#
#' @return A data frame row with two columns: `replicate_path`, a string indicating the
#' path to the replicate checked and `confirmed`, a boolean values indicating
#' whether the replicate contents match the published version.
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir_csv <- system.file("extdata", "right",
#' "verdata-reclutamiento-R1.csv.zip", package = "verdata")
#' confirm_file(local_dir_csv, version = "v1")
#'
#' @noRd
confirm_file <- function(replicate_path, version) {

    if (is.null(version) | !version %in% c("v1", "v2")) {

        stop("Data version not properly specified. Options are 'v1' or 'v2'.")

    }

    violacion <- stringr::str_extract(pattern = "homicidio|desaparicion|secuestro|reclutamiento",
                                      replicate_path)

    file_extension <- stringr::str_extract(pattern = "parquet|csv", replicate_path)

    hash_file <- dplyr::tibble(violacion = violacion,
                               replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                              replicate_path),
                               hash = purrr::map_chr(replicate_path,
                                                     ~digest::digest(.x,
                                                                     algo = "sha1",
                                                                     file = TRUE)))

    if (version == "v1" & file_extension == "parquet") {

        file_test <- file_parquet_v1 %>%
            dplyr::filter(replica %in% hash_file$replica &
                              violacion %in% hash_file$violacion)

    } else if (version == "v2" & file_extension == "parquet") {

        file_test <- file_parquet_v2 %>%
            dplyr::filter(replica %in% hash_file$replica &
                              violacion %in% hash_file$violacion)

    } else if (version == "v1" & file_extension == "csv") {

        file_test <- file_csv_v1 %>%
            dplyr::filter(replica %in% hash_file$replica &
                              violacion %in% hash_file$violacion)

    } else if (version == "v1" & file_extension == "csv") {

        file_test <- file_csv_v2 %>%
            dplyr::filter(replica %in% hash_file$replica &
                              violacion %in% hash_file$violacion) # TODO: check

    }

    is_eq <- all.equal(file_test, hash_file)

    if (isTRUE(is_eq)) {

        results <- tibble::tibble(replicte_path = replicate_path,
                                  confirmed = TRUE)
        return(results)

    }

    else {

        final <- medidas(replicate_path)

        violacion_file <- paste0(violacion, "_", version)

        summary_table <- get(violacion_file) %>%
            dplyr::filter(replica %in% final$replica)

        final <- final[order(final$variable), ]

        summary_table <- summary_table[order(summary_table$variable), ]

        mea_eq <- all.equal(summary_table, final, check.attributes = FALSE)

        if (isTRUE(mea_eq)) {

            results <- tibble::tibble(replicte_path = replicate_path,
                                      confirmed = TRUE)
            return(results)

        }

        else {

            results <- tibble::tibble(replicte_path = replicate_path,
                                      confirmed = FALSE)
            return(results)

        }

    }

}


#' Confirm files are identical to the ones published.
#'
#' @param replicates_dir Directory containing the replicates.
#' The name of the files must include the violation in Spanish and lower case
#' letters (homicidio, secuestro, reclutamiento, desaparicion).
#' @param violation Violation being analyzed. Options are "homicidio", "secuestro",
#' "reclutamiento", and "desaparicion".
#' @param replicate_nums A numeric vector containing the replicates to be analyzed.
#' Values in the vector should be between 1 and 100 inclusive.
#' @param version Version of the data being read in. Options are "v1" or "v2".
#' "v1" is appropriate for replicating the replicating the results of the joint
#' JEP-CEV-HRDAG project. "v2" is appropriate for conducting your new analyses
#' of the conflict in Colombia.
#'
#' @return A data frame row with `replicate_num` rows and two columns:
#' `replicate_path`, a string indicating the path to the replicate checked and
#' `confirmed`, a boolean values indicating whether the replicate contents match
#' the published version.
#' @export
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' confirm_files(local_dir, "reclutamiento", c(1, 2), version = "v1")
confirm_files <- function(replicates_dir, violation, replicate_nums, version) {

    files <- build_path(replicates_dir, violation, replicate_nums)

    results <- purrr::map_dfr(files, confirm_file, version = version)

    if (any(!results$confirmed)) {

        warning("Some replicate file contents do not match the published versions")

    } else if (version == "v1") {

        message("You are using v1 of the data. This version is appropriate for
                replicating the results of the joint JEP-CEV-HRDAG project. If you
                would like to conduct your own analysis of the conflict in Colombia,
                please use v2 of the data.")

    } else if (version == "v2") {

        message("You are using v2 of the data. This version is appropriate for
                conducting your own analysis of the conflict in Colombia. If you
                would like to repliate the results of the joint JEP-CEV-HRDAG project,
                please use v1 of the data.")

    } else if (is.null(version) | !version %in% c("v1", "v2")) {

        stop("Data version not properly specified. Options are 'v1' or 'v2'.")

    }

    return(results)

}


# done.
