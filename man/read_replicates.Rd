% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_replicates.R
\name{read_replicates}
\alias{read_replicates}
\title{Read replicates in a path and make sure they are identical to the ones published}
\usage{
read_replicates(
  rep_directory,
  violacion,
  first_rep,
  last_rep,
  file_extension,
  crash = TRUE
)
}
\arguments{
\item{rep_directory}{A file path for the folder in which the replicates are stored.
Then file name of each replicate must contain at least the name of the violation
in spanish and lower case letters (homicidio, secuestro, reclutamiento, desaparicion),
and the replicate number preceded by "R".}

\item{violacion}{Violation being analyzed (homicidio, secuestro, reclutamiento,
desaparicion).}

\item{first_rep}{First replicate in the range of replicates to be analyzed.}

\item{last_rep}{Last replicate in the range of replicates to be analyzed.}

\item{file_extension}{Extension of the file to be read. Available options are
"parquet" or "csv".}

\item{crash}{A parameter to define whether the function should crash if the content
of the file is not identical to the one published.
If crash = TRUE (default), it will return error and not read the data,
if crash = FALSE, the function will return a warning but still read the data.}
}
\value{
A data frame or an error or warning (depending on crash)
}
\description{
Read replicates in a path and make sure they are identical to the ones published
}
\examples{
local_dir <- system.file("extdata", "right", package = "verdata")
read_replicates(local_dir, "reclutamiento", 1, 2, "parquet")
}