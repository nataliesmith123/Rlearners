
library(readxl)

id <- read_excel(here("data", "hp", "ids.xlsx"))
characters <- read_excel(here("data", "hp", "characters.xlsx"))
patronus <- read_excel(here("data", "hp", "patronus.xlsx"))


characterIDleft <- left_join(characters, id, 
                             by = "Name", 
                             suffix = c("_character", "_id"))

addPatronus <- left_join(characterIDleft, patronus, 
                         by = c("abbrev" = "character"))



housesAllowed <- c("Gryffindor", "Hufflepuff", "Ravenclaw", "Slytherin")

addPatronusv2 <- characters %>%
  
  left_join(id, 
            by = "Name", 
            suffix = c("_character", "_id")) %>%
  
  left_join(patronus, 
            by = c("abbrev" = "character")) %>%
  
  filter(House %in% housesAllowed) %>%
  
  mutate(gender01 = if_else(Gender == "Female", 1, 0))


houseDescriptives <- addPatronusv2 %>%
  
  group_by(House) %>%
  
  summarise(numberInHouse = n(), 
            propFemale = round(mean(gender01, na.rm = TRUE), digits=2), 
            numNAgender = sum(is.na(gender01)))





## now transposing - just use characters dataset (original)

longCharacters <- characters %>%
  
  pivot_longer(cols = Gender:Death, 
               names_to = "characteristic", 
               values_to = "somethingElse") %>%
  
  mutate(Id = as.numeric(Id)) %>%
  
  left_join(id, 
            by = "Name") %>%
  
  left_join(patronus, by = c("abbrev" = "character"))


backToWide <- pivot_wider(longCharacters, 
                          id_cols = c(Id, Name), 
                          names_from = "characteristic", 
                          values_from = "somethingElse")








