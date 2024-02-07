# ============================================
# Authors:     PA
# Maintainers: PA
# Copyright:   2022, HRDAG, GPL v2 or later
# ============================================

local_dir <- system.file("extdata", "right", package = "verdata")

replicates_data <- read_replicates(local_dir, "reclutamiento", c(1, 2))

expected <- verdata::filter_standard_cev(replicates_data,
                                "reclutamiento",
                                perp_change = TRUE)

testthat::test_that("Function CEV works", {

  d1 <- 32643
  testthat::expect_equal(nrow(filter_standard_cev(replicates_data,
                                                  "reclutamiento",
                                                  perp_change = TRUE)), d1)

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

testthat::test_that("The function must return an error if the user put
                    information that is not a data frame", {

                      not_data_frame <- expected %>%
                        as.list()

                      testthat::expect_error(
                        replicates_test <- filter_standard_cev(not_data_frame,
                                                               "reclutamiento",
                                                               perp_change = TRUE))
                    })


testthat::test_that("The function must return an error if the user put another
                    violation that is different to: 'reclutamiento', 'desaparicion',
                    'homicidio' or 'secuestro'", {

                      testthat::expect_error(
                        replicates_test <- filter_standard_cev(expected,
                                                               "desplazamiento",
                                                               perp_change = TRUE))
                    })

testthat::test_that("The function filter correct all periods in reclutamiento", {

  periods_expected <- c("1990_1993", "1994_1997", "1998_2001", "2002_2005", 
                        "2006_2009", "2010_2013", "2014_2017")

  periods_correct <- all(expected$periodo_pres %in% periods_expected)
  testthat::expect_true(periods_correct)

})


testthat::test_that("The function filter correct the age in reclutamiento", {
  
  ages_correct <- all(expected$edad_jep %in% c("INFANCIA", "ADOLESCENCIA"))
  testthat::expect_true(ages_correct)
  
})

# Test desaparicion

desaparicion_data <- data.frame(
  replica = c("R1", "R1", "R2", "R2"), 
  match_group_id = c("82294f9f7658711a56000977c65b8584ce91d7eb", 
                     "74b133b3bac281bdcc8f4d8bbba7577a6261cc15", 
                     "8d9421b878d7ca90766c3ba428acde0323aa05d8", 
                     "95fbb67c05da4b928b9a40c75d9126b16aea1219"), 
  in_1 = c(0, 1, 0, 0), 
  in_6 = c(0, 1, 0, 0),
  dept_code_hecho = c("50", "81", "11", "11"), 
  edad_categoria = c("10-14", "20-24", "15-19", "25-29"), 
  edad_categoria_imputed = c(FALSE, FALSE, FALSE, FALSE), 
  edad_jep = c("INFANCIA", "ADULTEZ", "ADULTEZ", "ADULTEZ"), 
  edad_jep_imputed = c(FALSE, FALSE, FALSE, FALSE), 
  etnia = c("INDIGENA", "MESTIZO", "NARP", "ROM"), 
  etnia_imputed = c(TRUE, FALSE, TRUE, TRUE), 
  is_conflict = c(TRUE, TRUE, TRUE, TRUE), 
  is_conflict_imputed = c(FALSE, FALSE, TRUE, FALSE), 
  is_forced_dis = c(TRUE, TRUE, FALSE, TRUE), 
  is_forced_dis_imputed = c(FALSE, FALSE, FALSE, FALSE), 
  muni_code_hecho = c("50001", "81794", "11001", "11001"), 
  muni_code_hecho_imputed = c(FALSE, FALSE, FALSE, FALSE), 
  p_str = c("EST", "GUE-ELN", "GUE-FARC", "GUE-OTRO"),
  p_str_imputed = c(TRUE, FALSE, TRUE, TRUE),
  sexo = c("HOMBRE", "MUJER"),
  sexo_imputed = c(FALSE, FALSE, FALSE, FALSE), 
  yy_hecho = c("2010", "2002", "2013", "2011"), 
  yymm_hecho = c("201007", "200201", "201305", "201107")
)

testthat::test_that("The variables is_forced_dis and is_conflict are type 
                    integer after applying the function", {

  data_dis <- filter_standard_cev(desaparicion_data, 
                                  "desaparicion",
                                  perp_change = TRUE)

  testthat::expect_is(data_dis$is_forced_dis, "integer")
  testthat::expect_is(data_dis$is_conflict, "integer")
  
})

testthat::test_that("The function generated correctly the variables 
          related to desaparicion", {

  data_dis <- filter_standard_cev(desaparicion_data,
                                  "desaparicion",
                                  perp_change = TRUE)
  
  testthat::expect_true("is_conflict_dis" %in% names(data_dis))
  testthat::expect_true("is_conflict_dis_imputed" %in% names(data_dis))
  testthat::expect_true("is_conflict_dis_rep" %in% names(data_dis))
  
          })

# Done...