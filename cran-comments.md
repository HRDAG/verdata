## `devtools::check()` results

0 errors  | 0 warnings  | 0 notes

─  using R version 4.4.0 (2024-04-24)
─  using platform: x86_64-apple-darwin20
─  R was compiled by
       Apple clang version 14.0.0 (clang-1400.0.29.202)
       GNU Fortran (GCC) 12.2.0
─  running under: macOS Sonoma 14.5

## `R CMD CHECK` results
* using R version 4.4.0 (2024-04-24)
* using platform: x86_64-apple-darwin20
* R was compiled by
    Apple clang version 14.0.0 (clang-1400.0.29.202)
    GNU Fortran (GCC) 12.2.0
* running under: macOS Sonoma 14.5
* using session charset: UTF-8
* checking for file ‘verdata/DESCRIPTION’ ... OK
* this is package ‘verdata’ version ‘0.9.2’
* package encoding: UTF-8
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking for sufficient/correct file permissions ... OK
* checking whether package ‘verdata’ can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking code files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
* checking whether the namespace can be unloaded cleanly ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking contents of ‘data’ directory ... OK
* checking data for non-ASCII characters ... NOTE
  Note: found 148 marked UTF-8 strings
* checking LazyData ... OK
* checking data for ASCII and uncompressed saves ... OK
* checking R/sysdata.rda ... OK
* checking examples ... OK
* checking for unstated dependencies in ‘tests’ ... OK
* checking tests ... OK
  Running ‘spelling.R’
  Running ‘testthat.R’
* checking PDF version of manual ... OK
* DONE
Status: 1 NOTE

We are aware of the non-ASCII characters (e.g., in the README, authors names, etc.)
and our intended and declared coding is UTF-8

## `rhub::check()` results

- Tested on: linux (R-devel), m1-san (R-devel), macos-arm64 (R-devel), macos (R-devel) and windows (R-devel)
- log files returned no errors or notes

## `devtools::check_win_devel()` results
* using R version 4.4.0 (2024-04-24)
* using platform: x86_64-apple-darwin20
* R was compiled by
    Apple clang version 14.0.0 (clang-1400.0.29.202)
    GNU Fortran (GCC) 12.2.0
* running under: macOS Sonoma 14.5
* using session charset: UTF-8
* checking for file ‘verdata/DESCRIPTION’ ... OK
* this is package ‘verdata’ version ‘0.9.2’
* package encoding: UTF-8
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking for sufficient/correct file permissions ... OK
* checking whether package ‘verdata’ can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking code files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
* checking whether the namespace can be unloaded cleanly ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking contents of ‘data’ directory ... OK
* checking data for non-ASCII characters ... NOTE
  Note: found 148 marked UTF-8 strings
* checking LazyData ... OK
* checking data for ASCII and uncompressed saves ... OK
* checking R/sysdata.rda ... OK
* checking examples ... OK
* checking for unstated dependencies in ‘tests’ ... OK
* checking tests ... OK
  Running ‘spelling.R’
  Running ‘testthat.R’
* checking PDF version of manual ... OK
* DONE
Status: 1 NOTE

This is a new submission. An earlier version of the package was previously 
submitted to CRAN in February 2024, but was not published. I have not previously
published a package on CRAN.

The words and links flagged by the check are correct and do not need to be
changed.

<!-- done. -->
