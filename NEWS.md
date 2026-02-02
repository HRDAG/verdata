# verdata 1.0.2

* Removing a test of `mse()` when `lookup_estimates = TRUE`. This was a timing based test that was too flaky to be a reliable indicator of function performance across all test environment. Increasing the time tolerance in update 1.0.1 did not meaningfully resolve this issue as hoped.

# verdata 1.0.1

* Timing test for `mse()` using `lookup_estimates` option uses more generous comparison to ensure that test doesn't fail unnecessarily when estimates are correctly looked up.

# verdata 1.0.0

* Submitted to CRAN
