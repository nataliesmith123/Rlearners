
## @knitr dm_exercises

# today we'll use the diamonds dataset again

data(diamonds)

# I have been loving the 'skim' function from the skimr packages lately
# super easy and super high-level overview of your dataset
skimr::skim(diamonds)


#library(tidylog)
diamondsLess <- diamonds %>%
  rownames_to_column(var="DiamondID") %>%
  arrange(DiamondID) %>%
  filter(carat<=1 & price < 1000) %>%
  mutate(cutF = factor(cut, ordered=FALSE), 
         colorF = factor(color, ordered=FALSE), 
         
         colorBest = if_else(condition = color %in% c("D", "E", "F"), 
                             true = 1, 
                             false = 0),
         colorBestF = factor(colorBest, 
                             levels = c("0", "1"), 
                             labels = c("0" = "0: not D/E/F", 
                                        "1" = "1: best D/E/F")), 
         
         cutIdeal = if_else(condition = cut=="Ideal", 
                            true = "Ideal", 
                            false = "Not ideal"))

xtabs(~cut + cutIdeal, data=diamondsLess, addNA = TRUE)
xtabs(~color + colorBestF, data=diamondsLess, addNA = TRUE)




diamondsLess <- diamondsLess %>%
  
  mutate(meanCheck = (x+y)/2,
         depthCheck = (z/meanCheck)*100)
# this is a meh approach. i don't want to create intermediate variables
# and potentially make errors. why can't I just say mean(x,y)??? :(

# here's how you can!! 
diamondsLess <- diamondsLess %>%
  rowwise() %>%
  mutate(depthCheck2 = (z/mean(c(x, y)))*100) %>%
  ungroup() #make sure to ungroup/unrowwise you data

# this may not look helpful now because we all know how to take an average manually
# but with more complex functions can be fantastic! 

skimr::skim_without_charts(diamondsLess, depth, depthCheck, depthCheck2)

# one caution: don't use rowwise() when you want to do something like making new factor variables

diamondsLess <- mutate(diamondsLess, clarityF1 = factor(clarity, ordered = FALSE))
str(diamondsLess$clarityF1)

diamondsLess <- diamondsLess %>%
  rowwise() %>%
  mutate(clarityF2 = factor(clarity, ordered = FALSE))
str(diamondsLess$clarityF2)
# it tried to make a factor variable *within each row* -- not what we wanted!! 


#detach(package:tidylog)

# an aside on piping
# these are the same thing
# the first one is easier to read, yes? 

# diamondsLess <- diamondsLess %>% 
#   mutate(clarityF1 = factor(clarity, ordered = FALSE))
# 
# diamondsLess <- mutate(diamondsLess, 
#                        clarityF1 = factor(clarity, ordered = FALSE))



## @knitr importExport

# Importing / Exporting ---------------------------------------------------------------

ugly <- read.csv(here("data", "import-csv.csv"))
ugly

# janitor package is worth checking out
# "janitor has simple little tools for examining and cleaning dirty data."
pretty <- janitor::clean_names(ugly, case = "small_camel")
# case should be one of “snake”, “small_camel”, “big_camel”, “screaming_snake”, “parsed”, “mixed”, 
# “lower_upper”, “upper_lower”, “swap”, “all_caps”, “lower_camel”, “upper_camel”, “internal_parsing”, 
# “none”, “flip”, “sentence”, “random”, “title”


# this is the basic read excel format
rusersOrig <- readxl::read_excel(here("data", "R users group list 0527_136PM.xlsx"))
# add skip=# to skip the first # rows before reading in data


# can handle multiple sheets
sheets <- readxl::excel_sheets(here("data", "import-excel.xlsx"))

sheetsAsList <- lapply(sheets, 
                       function(X) readxl::read_excel(here("data", "import-excel.xlsx"), 
                                                      sheet = X))
names(sheetsAsList) <- sheets


# really only useful if yo uhave harmonized column names
fullResults <- bind_rows(sheetsAsList, .id = "column_label")

# extract individual results using the list syntax we learned earlier
teaTime <- sheetsAsList[["tea time"]]
tv <- sheetsAsList[["shows"]]
# tv's names look prettier, but they are still weird and need ``. for example: 
names(tv)
tv <- janitor::clean_names(tv, case="lower_camel")
names(tv)



# to import stata, best to use haven library
stataHaven <- haven::read_dta(here("data", "stata-nlsw.dta"))

# foreign requires stata 5-12 only :(
# stataForeign <- foreign::read.dta(here("data", "stata-nlsw.dta"))
# new package for 13-current
# https://cran.r-project.org/web/packages/readstata13/readme/README.html

# you can also write stata/SAS data directly

# this does not seem to work very well with the TV dataset because it has some characters with spaces
# probably best for those kinds of data to use a CSV file so you can wrap strings in quotations
foreign::write.foreign(teaTime,
                       datafile = here("data", "stata-data.txt"),
                       codefile = here("data", "stata-import.do"),
                       package = "Stata")


foreign::write.foreign(df = teaTime,
                       datafile = here("data", "sas-data.txt"),
                       codefile = here("data", "sas-import.sas"),
                       package = "SAS",
                       dataname = "rlearners")







