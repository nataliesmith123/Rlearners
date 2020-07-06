

library(readxl)

# links character name to short abbreviation
id <- read_excel(here("data", "hp", "ids.xlsx"))

# contains lots of information on characters, like wand length etc.
characters <- read_excel(here("data", "hp", "characters.xlsx"))

# dataset just containing patronus forms for the characters who produced a 'corporeal' patronus
patronus <- read_excel(here("data", "hp", "patronus.xlsx"))






