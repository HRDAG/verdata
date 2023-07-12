# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

#' Confirm a file is the same as the published version.
#'
#' @param replicate_path Path to the replicate to be confirmed. The name
#' of the files must include the violation in Spanish and lower case letters
#' (homicidio, secuestro, reclutamiento, desaparicion).
#
#' @return "You have the right file!" message if the files are identical to the
#' files published or error and "This file is not identical to the one published.
#' This means the results of the analysis may potentially be inconsistent." if
#' they are not.
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir_csv <- system.file("extdata", "right",
#' "verdata-reclutamiento-R1.csv.zip", package = "verdata")
#' confirm_file(local_dir_csv)
#'
#' @noRd
confirm_file <- function(replicate_path) {

    violacion <- stringr::str_extract(pattern = "homicidio|desaparicion|secuestro|reclutamiento",
                                      replicate_path)
    
    file_extension <- stringr::str_extract(pattern = "parquet|csv",
                                           replicate_path)

    hash_file <- dplyr::tibble(violacion = violacion,
                               replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                              replicate_path),
                               hash = purrr::map_chr(replicate_path,
                                                     ~digest::digest(.x,
                                                                     algo = "sha1",
                                                                     file = TRUE)))

    if (file_extension == "parquet") {

        file_test <- file %>%
            dplyr::filter(replica %in% hash_file$replica &
                              violacion %in% hash_file$violacion)


    } else if (file_extension == "csv") {

        file_test <- file_csv %>%
            dplyr::filter(replica %in% hash_file$replica &
                              violacion %in% hash_file$violacion)

    }

    is_eq <- all.equal(file_test, hash_file)

    if (isTRUE(is_eq)) {
        message("You have the right file!")

        }

     else {


    final <- medidas(replicate_path)

    summary_table <- get(violacion) %>%
            dplyr::filter(replica %in% final$replica)

    final <- final[order(final$variable), ]

    summary_table <- summary_table[order(summary_table$variable), ]

    mea_eq <- all.equal(summary_table, final, check.attributes = FALSE)

    if (isTRUE(mea_eq)) {

        message("You have the right file!")

        }

    else {

    stop("This file is not identical to the one published. This means the results of the
    analysis may potentially be inconsistent.")

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
#' @param first_rep First replicate in the range of replicates to be analyzed
#' @param last_rep Last replicate in the range of replicates to be analyzed.
#'
#' @return "You have the right file!" message if the files are identical to the
#' files published or error and "This file is not identical to the one published.
#' This means the results of the analysis may potentially be inconsistent." if
#' they are not.
#' @export
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' confirm_files(local_dir, "reclutamiento", 1, 2)
confirm_files <- function(replicates_dir, violation, first_rep, last_rep) {

    files <- build_path(replicates_dir, violation, first_rep, last_rep)
    purrr::walk(files, confirm_file)

}

# --- Done
