source('f:/cabeçalho.r')
library(read.dbc)

obitos_2023 <- read.dbc('H:/sim/fonte/dobr2023.dbc')
# save(obitos_2023, file = 'h:/sim/rda/obitos_2023.rda')
# load('h:/sim/rda/obitos_2023.rda')
tabela_2023 <- obitos_2023 |> 
  mutate(cid_3d = toupper(str_sub(CAUSABAS, 1, 3)),
         DIC = if_else(cid_3d %in% c('I20', 'I21', "I22", "I23", "I24", "I25"), 1, 0),
         idade = if_else(str_sub(IDADE, 1, 1) == 4, as.numeric(str_sub(IDADE, 2, 3)), NA))


maiores_causas_25_26_anos <- tabela_2023 |> 
  filter(idade >=  25,
         idade <=  26) |> 
  group_by(cid_3d) |> 
  summarise(n=n()) |> 
  ungroup() |> 
  arrange(-n)


dic <- tabela_2023 |> 
  filter(DIC == 1,
         idade >=  25,
         idade <=  26)


# Número de mortes pequeno para avaliação
# explorar melhor idade


tabela_2023 |> 
  filter(DIC == 1) |> 
  group_by(SEXO, idade, RACACOR) |> 
  summarise(n=n()) |> 
  arrange(-n) |> 
  ungroup() |> 
  filter(!is.na(idade))
