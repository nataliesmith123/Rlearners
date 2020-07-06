

library(readxl)
library(tidylog)

# links character name to short abbreviation
id <- read_excel(here("data", "hp", "ids.xlsx"))

# contains lots of information on characters, like wand length etc.
characters <- read_excel(here("data", "hp", "characters.xlsx"))

# dataset just containing patronus forms for the characters who produced a 'corporeal' patronus
patronus <- read_excel(here("data", "hp", "patronus.xlsx"))



characterIDleft <- left_join(characters, id, 
                             by="Name", 
                             suffix = c("_character", "_ID"))
#characterIDfull <- full_join(characters, id, by="Name")
#identical(characterIDleft, characterIDfull)


# keeps all 140 rows 
addPatronus <- left_join(characterIDleft, patronus, 
                         by = c("abbrev" = "character"))

# say we only wanted the characters in the patronus dataset
# two ways to keep only 21 in patronus dataset
# there are also other ways with more pre-processing (like filtering, etc.)
# but I think this is the most straightforward way
addPatronusv2 <- right_join(characterIDleft, patronus, 
                            by = c("abbrev" = "character"))
# same result can be achieved by left_join and switching datasets
addPatronusv3 <- left_join(patronus, characterIDleft, 
                            by = c("character" = "abbrev"))
#identical(addPatronusv2, addPatronusv3)
#note they are not technically 'identical' because the columns are not in the same order, reflecting the different merge order

# using the pipe operator to chain all of this together
addPatronusv4 <- characters %>%
  
  left_join(id, 
            by = "Name", 
            suffix = c("_character", "_ID")) %>%
  
  left_join(patronus, 
            by = c("abbrev" = "character")) %>%
  
  filter(House %in% c("Gryffindor", "Hufflepuff", "Ravenclaw", "Slytherin")) %>%
  
  mutate(gender01 = if_else(Gender=="Female", 1, 0))


# can continue with pipe operator in the above statement, but I prefer to keep grouped things separate
# splitting up the pipe pieces can help with debugging and code flow
grouped <- addPatronusv4 %>%
  
  group_by(House) %>%
  
  summarise(numberInHouse = n(), 
            propFemale = round(mean(gender01, na.rm = TRUE), digits=2), 
            numFemale = sum(gender01, na.rm = TRUE), 
            numNAGender = sum(is.na(gender01)),
            .groups="drop") # can specify "keep" if you want the data to remain 'grouped' in R's memory



# transposing
longCharacters <- pivot_longer(data = (characters %>% select(Name, Gender, Wand)), 
                               cols = c(Gender, Wand), 
                               names_to = "characteristic")
# will match to all rows
longPlusAbbrev <- left_join(longCharacters, (id %>% select(Name, abbrev)), 
                            by = "Name")

# let's take this data and go wider now
wider <- pivot_wider(longPlusAbbrev, 
                     id_cols = c(Name, abbrev), 
                     names_from = characteristic)




# descriptives

library(tableone)

contVar <- c("Id_character")
catVar <- c("Gender", "House", "Loyalty")

# use addPatronusv4 - restricted to just 4 hogwarts houses

CreateTableOne(vars = c(contVar, catVar), 
               data=addPatronusv4, 
               factorVars = catVar)

tmp <- CreateTableOne(vars = c(contVar, catVar), 
               data=addPatronusv4, 
               factorVars = catVar, 
               strata="House", 
               test = FALSE)
tmp1 <- print(tmp)

xlsx::write.xlsx(tmp1, file=here("output", "t1HP.xlsx"))











