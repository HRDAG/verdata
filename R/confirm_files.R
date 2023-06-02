# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

#' Confirm the file is the same as the one published
#'
#' @param where_replicate File path to the replicates. The name
#' of the files must include the violation in spanish and lower case letters
#' (homicidio, secuestro, reclutamiento, desaparicion)
#' @param file_extension Extension of the file to be read. Available options are
#' "parquet" or "csv".
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
#' "codata-reclutamiento-R1.csv.zip", package = "verdata")
#' confirm_file(local_dir_csv, "csv")
#'
#' @noRd
confirm_file <- function(where_replicate, file_extension) {

    violacion <- stringr::str_extract(pattern = "homicidio|desaparicion|secuestro|reclutamiento",
                                      where_replicate)

    hash_file <- dplyr::tibble(violacion = violacion,
                               replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                              where_replicate),
                               hash = purrr::map_chr(where_replicate,
                                                     ~digest::digest(.x,
                                                                     algo = "sha1",
                                                                     file = TRUE)))

    if (file_extension == "parquet") {

        file_test <- file %>%
            dplyr::filter(replica %in% hash_file$replica &
                              violacion %in% hash_file$violacion)


    } else {

        file_test <- file_csv %>%
            dplyr::filter(replica %in% hash_file$replica &
                              violacion %in% hash_file$violacion)

    }

    is_eq <- all.equal(file_test, hash_file)

    if (isTRUE(is_eq)) {
        message("You have the right file!")

        }

     else {


    final <- medidas(where_replicate)

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


#' Confirm the files in a path are identical to the ones published
#'
#' @param where_replicate File path for the folder containing the replicates.
#' The name of the files must include the violation in spanish and lower case
#' letters (homicidio, secuestro, reclutamiento, desaparicion)
#' @param violacion Violation being analyzed (homicidio, secuestro, reclutamiento,
#' desaparicion)
#' @param first_rep First replicate in the range of replicates to be analyzed
#' @param last_rep Last replicate in the range of replicates to be analyzed.
#' @param file_extension Extension of the file to be read. Available options are
#' "parquet" or "csv".
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
#' confirm_files(local_dir, "reclutamiento", 1, 2, "parquet")
confirm_files <- function(where_replicate, violacion, first_rep, last_rep,
                          file_extension) {

    files <- build_path(where_replicate, violacion, first_rep, last_rep,
                        file_extension)
    purrr::walk(files, confirm_file, file_extension)

}

# --- Done
