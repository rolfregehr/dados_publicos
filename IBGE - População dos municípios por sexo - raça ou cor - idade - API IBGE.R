df_base_ibge_api <- tibble(expand.grid(
  idade = idades,
  sexo = sexos,
  raca_cor = racas_cores))

library(foreach)
library(doParallel)

n_cores <- detectCores() - 1  # Deixa um núcleo livre
cl <- makeCluster(n_cores)
registerDoParallel(cl)


foreach(i = 24:nrow(df_base_ibge_api),  .packages = ('tidyverse')) %dopar% { 
  
  #  df_base_ibge_api <- get("df_base_ibge_api", envir = .GlobalEnv)
  #  info_pop_racacor_idade_sexo <- get('info_pop_racacor_idade_sexo', envir = .GlobalEnv)
  
  url <- paste0(
    "https://servicodados.ibge.gov.br/api/v3/agregados/9606/periodos/2010|2022/variaveis/93?localidades=N6[all]&classificacao=86[",
    df_base_ibge_api$raca_cor[i],
    "]|2[",
    df_base_ibge_api$sexo[i],
    "]|287[",
    df_base_ibge_api$idade[i],
    "]"
  )
  
  temp <- httr::GET(url)
  temp <- jsonlite::fromJSON(httr::content(temp, 'text', encoding = 'UTF-8'))
  
  temp <-  cbind(tibble(temp[[4]][[1]])[[2]][[1]]) |> 
    dplyr::mutate(idade = df_base_ibge_api$idade[i],
                  raca_cor = df_base_ibge_api$raca_cor[i],        
                  sexo = df_base_ibge_api$sexo[i])
  
  
  
  info_pop_racacor_idade_sexo <- dplyr::bind_rows(info_pop_racacor_idade_sexo, temp)
  
}
stopCluster(cl)
