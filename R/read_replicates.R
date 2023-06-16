# ============================================
# Authors:     MJ
# Maintainers: MJ
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

#' Read a replicate and hash its contents to make sure it's identical to the one published.
#'
#' @param where_replicate Path to the replicate. The name of the file must include
#' the violation in Spanish and lower case letters (homicidio, secuestro,
#' reclutamiento, desaparicion).
#' @param crash A parameter to define whether the function should crash if the file
#' is not identical to the one published. If crash = TRUE (default), the data won't
#' be loaded. If crash = FALSE, the data will be loaded with a warning.
#'
#' @return A dataframe with the data from the indicated replicate.
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
read_replicate <- function(where_replicate, crash = TRUE) {

    violacion <- stringr::str_extract(pattern = "homicidio|desaparicion|secuestro|reclutamiento",
                                      where_replicate)
    
    file_extension <- stringr::str_extract(pattern = "parquet|csv",
                                           where_replicate)

    if (file_extension == "parquet") {

        df <- arrow::read_parquet(where_replicate)

        hash_intor <- dplyr::tibble(violacion = violacion,
                                    replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                                   where_replicate),
                                    hash = digest::digest(df, algo = "sha1"))

        content_test <- content %>%
            dplyr::filter(replica %in% hash_intor$replica,
                          violacion == hash_intor$violacion)

        } else {

        df <- readr::read_csv(where_replicate)

        hash_intor <- dplyr::tibble(violacion = violacion,
                                    replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                                   where_replicate),
                                    hash = digest::digest(df, algo = "sha1"))

        content_test <- content_csv %>%
            dplyr::filter(replica %in% hash_intor$replica)

        }

    is_eq <- all.equal(content_test, hash_intor)

    if (isTRUE(is_eq)) {

        return(df)

    } else {

    final <- medidas(where_replicate)

    summary_table <- get(violacion) %>%
            dplyr::filter(replica %in% final$replica)

    final <- final[order(final$variable), ]

    summary_table <- summary_table[order(summary_table$variable), ]

    mea_eq <- all.equal(summary_table, final, check.attributes = FALSE)

    if (isTRUE(mea_eq)) {

        return(df)

    }

     else if (crash) {

        stop("The content of the files is not identical to the ones published.")

        } else {

        warning("The content of the files is not identical to the ones published.
                The results of the analysis may be inconsistent.")
        return(df)

        }

    }

}

#' Read replicates in a directory and verify they are identical to the ones published.
#'
#' @param rep_directory A file path for the directory where the replicates are stored.
#' Then file name of each replicate must contain at least the name of the violation
#' in Spanish and lower case letters (homicidio, secuestro, reclutamiento, desaparicion),
#' and the replicate number preceded by "R", (e.g., "R1" for replicate 1).
#' @param violacion A string indicating the violation being analyzed. Options are
#' "homicidio", "secuestro", "reclutamiento", and "desaparicion".
#' @param first_rep First replicate in the range of replicates to be analyzed.
#' @param last_rep Last replicate in the range of replicates to be analyzed.
#' @param crash A parameter to define whether the function should crash if the
#' content of the file is not identical to the one published. If crash = TRUE
#' (default), it will return error and not read the data, if crash = FALSE, the
#' function will return a warning but still read the data.
#'
#' @return A dataframe with the data from all indicated replicates.
#' @export
#'
#' @importFrom dplyr %>%
#'
#' @examples
#' local_dir <- system.file("extdata", "right", package = "verdata")
#' read_replicates(local_dir, "reclutamiento", 1, 2)
read_replicates <- function(rep_directory, violacion, first_rep, last_rep,
                            crash = TRUE) {

    files <- build_path(rep_directory, violacion, first_rep, last_rep)
    df <- purrr::map_dfr(files, read_replicate, crash)

    return(df)

}

# --- Done
