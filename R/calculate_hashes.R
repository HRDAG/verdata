# ------- Functions

hashes_file <- function(replicate_path) {
  
  violacion <- stringr::str_extract(pattern = "homicidio|desaparicion|secuestro|reclutamiento",
                                    replicate_path)
  
  file_extension <- stringr::str_extract(pattern = "parquet|csv", replicate_path)
  
  hash_file <- dplyr::tibble(violacion = violacion,
                             replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                            replicate_path),
                             hash = purrr::map_chr(replicate_path,
                                                   ~digest::digest(.x,
                                                                   algo = "sha1",
                                                                   file = TRUE))) %>% 
    filter(!is.na(violacion))
}

hashes_content <- function(replicate_path) {
  
  violacion <- stringr::str_extract(pattern = "homicidio|desaparicion|secuestro|reclutamiento",
                                    replicate_path)
  
  file_extension <- stringr::str_extract(pattern = "parquet|csv", replicate_path)
  
  if (file_extension == "parquet") {
    
    replicate_data <- arrow::read_parquet(replicate_path)
    
    hash_intor <- dplyr::tibble(violacion = violacion,
                                replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                               replicate_path),
                                hash = digest::digest(replicate_data, algo = "sha1")) %>% 
      filter(!is.na(violacion))
    
  } else {
    
    replicate_data <- readr::read_csv(replicate_path)
    
    hash_intor <- dplyr::tibble(violacion = violacion,
                                replica = stringr::str_extract(pattern = ("(?:R)\\d+"),
                                                               replicate_path),
                                hash = digest::digest(replicate_data, algo = "sha1")) %>% 
      filter(!is.na(violacion))
    
  }
}

medidas <- function(replicate_path) {
  
  ext <- tools::file_ext(replicate_path)
  
  if (ext == "parquet") {
    
    replicate_data <- arrow::read_parquet(replicate_path)
    
  }
  
  else {
    
    replicate_data <- readr::read_csv(replicate_path)
    
  }
  
  replicate <- unique(replicate_data$replica)
  
  dpto <- replicate_data %>%
    dplyr::group_by(dept_code_hecho) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::filter(dept_code_hecho == 5 | dept_code_hecho == 20) %>%
    dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                           "5" = "antioquia",
                                           "20" = "cesar")) %>%
    dplyr::select(variable,valor)
  
  etnia <- replicate_data %>%
    dplyr::group_by(etnia) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::filter(etnia == "NARP" | etnia == "INDIGENA") %>%
    dplyr::rename(variable = etnia) %>%
    dplyr::select(variable,valor)
  
  edad <- replicate_data %>%
    dplyr::group_by(edad_categoria) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::filter(edad_categoria == "50-54") %>%
    dplyr::mutate(edad_categoria = as.character(edad_categoria)) %>%
    dplyr::rename(variable = edad_categoria) %>%
    dplyr::select(variable, valor)
  
  year_2002_2007 <- replicate_data %>%
    dplyr::filter(yy_hecho >= 2002 & yy_hecho <= 2007) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = "2002-2007") %>%
    dplyr::select(variable, valor)
  
  year_1990_1994 <- replicate_data %>%
    dplyr::filter(yy_hecho >= 1990 & yy_hecho <= 1994) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = "1990-1994") %>%
    dplyr::select(variable, valor)
  
  sexo <- replicate_data %>%
    dplyr::group_by(sexo) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::rename(variable = sexo) %>%
    dplyr::select(variable, valor)
  
  perp <- replicate_data %>%
    dplyr::group_by(p_str) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::rename(variable = p_str) %>%
    dplyr::select(variable, valor)
  
  w_minor <- replicate_data %>%
    dplyr::filter(sexo == "MUJER" & edad_categoria == "10-14") %>%
    dplyr::group_by(sexo) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = dplyr::recode(sexo,
                                           "MUJER" = "mujer menor de edad")) %>%
    dplyr::select(variable, valor)
  
  caq_89_93 <- replicate_data %>%
    dplyr::filter(yy_hecho >= 1989 & yy_hecho <= 1993 & dept_code_hecho == 18) %>%
    dplyr::group_by(dept_code_hecho) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                           "18" = "caqueta entre 1989 y 1993")) %>%
    dplyr::select(variable, valor)
  
  may <- replicate_data %>%
    dplyr::filter(yymm_hecho == 199005) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = "mayo de 1999") %>%
    dplyr::select(variable, valor)
  
  paras_bog <- replicate_data %>%
    dplyr::filter(p_str == "PARA" & dept_code_hecho == 11) %>%
    dplyr::group_by(dept_code_hecho) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = dplyr::recode(dept_code_hecho,
                                           "11" = "paramilitares en bogota")) %>%
    dplyr::select(variable, valor)
  
  paras_2016 <- replicate_data %>%
    dplyr::filter(p_str == "PARA" & yy_hecho == 2016) %>%
    dplyr::group_by(yy_hecho) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = dplyr::recode(yy_hecho,
                                           "2016" = "paramilitares en 2016")) %>%
    dplyr::select(variable, valor)
  
  mestizo_2000 <- replicate_data %>%
    dplyr::filter(yy_hecho == 2000 & etnia == "MESTIZO") %>%
    dplyr::group_by(etnia) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = dplyr::recode(etnia,
                                           "MESTIZO" = "mestizos en el 2000")) %>%
    dplyr::select(variable, valor)
  
  farc_2007 <- replicate_data %>%
    dplyr::filter(yy_hecho == 2007 & p_str == "GUE-FARC") %>%
    dplyr::group_by(yy_hecho) %>%
    dplyr::summarise(valor = dplyr::n()) %>%
    dplyr::mutate(variable = dplyr::recode(yy_hecho,
                                           "2007" = "farc en 2007")) %>%
    dplyr::select(variable, valor)
  
  comparar <- dplyr::bind_rows(dpto, etnia, edad, year_2002_2007, year_1990_1994,
                               sexo, perp, w_minor, caq_89_93, may, paras_bog,
                               paras_2016, mestizo_2000, farc_2007)
  
  replicate <- rep(replicate, each = nrow(comparar)) %>%
    as.data.frame()
  
  names(replicate) <- "replica"
  
  comparar <- dplyr::bind_cols(replicate, comparar)
  
  comparar$valor <- as.numeric(comparar$valor)
  
  return(comparar)
  
}