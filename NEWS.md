# verdata 1.0.2

* Removing a test of `mse()` when `lookup_estimates = TRUE`. This was a timing based test that was too flaky to be a reliable indicator of function performance across all test environment. Increasing the time tolerance in update 1.0.1 did not meaningfully resolve this issue as hoped.

* Setting tests involving `lookup_estimates()` to `skip_on_cran` with `testthat` due to flaky behavior with Linux development environments on CRAN. These tests are working on all other testing environments.

* Setting tests involving `estimate_mse()` to `skip_on_cran` because they are resulting in long build times for Windows and Debian.

# verdata 1.0.1

* Timing test for `mse()` using `lookup_estimates` option uses more generous comparison to ensure that test doesn't fail unnecessarily when estimates are correctly looked up.

# verdata 1.0.0

* Submitted to CRAN
