# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", 1, 2)
expected <- filter_standard_cev(replicates_data, 
                                "reclutamiento", 
                                perp_change = TRUE)

testthat::test_that("Function CEV works", {

    d1 <- 32643
    testthat::expect_equal(nrow(expected), d1)

})

testthat::test_that("This function applying correctly the argument perp_change", {
  
  data_before <- replicates_data %>% 
    mutate(p_str = as.character(p_str))
  
  data_unique_before <- unique(data_before$p_str)
  
  data_after <- expected %>% 
    filter(yy_hecho > 2016)
    
  data_unique_after <- unique(data_after$p_str)

  testthat::expect_error({
    testthat::expect_equal(data_unique_before, data_unique_after)
  })

})

# --- Done
