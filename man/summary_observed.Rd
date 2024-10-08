% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary_observed.R
\name{summary_observed}
\alias{summary_observed}
\title{Summary statistics for observed data.}
\usage{
summary_observed(
  violation,
  replicates_data,
  strata_vars = NULL,
  conflict_filter = FALSE,
  forced_dis_filter = FALSE,
  edad_minors_filter = FALSE,
  include_props = FALSE,
  digits = 2
)
}
\arguments{
\item{violation}{Violation to be analyzed. Options are
"homicidio", "secuestro", "reclutamiento", and "desaparicion".}

\item{replicates_data}{Data frame containing replicate data.}

\item{strata_vars}{Variable to be analyzed. Before imputation
this variable may have missing values.}

\item{conflict_filter}{Filter that indicates if the data is filtered by
the rule "is_conflict" or not.}

\item{forced_dis_filter}{Filter that indicates if the data is filter by
the rule "is_forced_dis" or not.}

\item{edad_minors_filter}{Optional filter by age ("edad") < 18.}

\item{include_props}{A logical value indicating whether or not to include
the proportions from the calculations.}

\item{digits}{Number of decimal places to round the results to. Default is 2.}
}
\value{
A data frame with two or more columns, (1) name of variable(s) and (2)
the number of observations in each of the variable's categories.
}
\description{
Summary statistics for observed data.
}
\examples{
local_dir <- system.file("extdata", "right", package = "verdata")
replicates_data <- read_replicates(local_dir, "reclutamiento", c(1, 2), version = "v1")
tab_observed <- summary_observed("reclutamiento", replicates_data,
strata_vars = "sexo", conflict_filter = FALSE, forced_dis_filter = FALSE,
edad_minors_filter = FALSE, include_props = FALSE, digits = 2)
}
