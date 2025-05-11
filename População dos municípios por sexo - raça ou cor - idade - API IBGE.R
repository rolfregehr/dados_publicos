
info_10_22 <- info_10_22[0, ]


for (municipio in municipios) {
  
  url <- paste0(
    "https://servicodados.ibge.gov.br/api/v3/agregados/9606/periodos/2010|2022/variaveis/93?localidades=N6[",
    municipio,
    "]&classificacao=86[all]|2[all]|287[all]"
  )
  temp <- httr::GET(url)
  temp <- jsonlite::fromJSON(content(temp, 'text', encoding = 'UTF-8'))
  
  
  # $ municipio     : Factor w/ 5570 levels "1100015","1100023",..: 1 2 3 4 5 6 7 8 9 10 ...
  # $ idade         : Factor w/ 101 levels "6557","6558",..: 1 1 1 1 1 1 1 1 1 1 ...
  # $ sexo          : Factor w/ 2 levels "4","5": 1 1 1 1 1 1 1 1 1 1 ...
  # $ raca_cor      : Factor w/ 5 levels "2776","2777",..: 1 1 1 1 1 1 1 1 1 1 ...
  # $ populacao_2010: chr  "100" "346" "28" "305" ...
  # $ populacao_2022: chr  "65" "275" "16" "268" ...
  
  
  
  num_comb <- length(temp[[4]][[1]][[1]])
  
  
  for (j in 1:num_comb) {
    
    temp_df <- tibble(
      municipio = temp[[4]][[1]][[2]][[1]][[1]][, 1],
      idade = temp[[4]][[1]][[1]][[j]]$categoria[3, 3],
      sexo = temp[[4]][[1]][[1]][[j]]$categoria[2, 2],
      raca_cor = temp[[4]][[1]][[1]][[j]]$categoria[1, 1],
      populacao_2010  = temp[[4]][[1]][[2]][j][[1]][[2]][1, 1],
      populacao_2022 = temp[[4]][[1]][[2]][j][[1]][[2]][1, 2])
    
    
    info_10_22 <- bind_rows(info_10_22, temp_df)
    
    
  }
  cat(str_pad(which(municipio == municipios), pad = 0, width = 4), '/', "5570", "\n")

  }

