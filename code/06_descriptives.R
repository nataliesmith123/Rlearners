
## @knitr descriptives

data(diamonds)

descriptiveDiamonds <- diamonds %>% 
  dplyr::slice_sample(n=150) %>%
  rownames_to_column(var="number") %>%
  
  # introducing some NA's to make this more realistic
  mutate(carat = if_else(number %in% c(1,2,3,56,34,89,65,22,31,124,118), 
                         as.numeric(NA), 
                         carat), 
         colorBest = if_else(condition = color %in% c("D", "E", "F"), 
                             true = 1, 
                             false = 0),
         colorBestF = factor(colorBest, 
                             levels = c("0", "1"), 
                             labels = c("0" = "0: not D/E/F", 
                                        "1" = "1: best D/E/F"))
         )

rm(diamonds)




# PACKAGE #1: SKIMR
library(skimr)
skim(descriptiveDiamonds)

# no histograms
skim_without_charts(descriptiveDiamonds)

# just a few variables
skim_without_charts(descriptiveDiamonds %>% select(carat, cut, price))





# PACKAGE #2: TABLEONE
library(tableone)

catVars <- c("cut")
contVars <- c("carat", "price")
descriptiveVariables <- c(catVars, contVars)

t1 <- CreateTableOne(vars = descriptiveVariables, 
                     data = descriptiveDiamonds, 
                     factorVars = catVars, 
                     includeNA = TRUE)
print(t1)


# stratification is pretty easy
t1strata <- CreateTableOne(vars = descriptiveVariables, 
                           data = descriptiveDiamonds, 
                           factorVars = catVars, 
                           strata = "colorBestF")
print(t1strata)


t1strata <- CreateTableOne(vars = descriptiveVariables, 
                           data = descriptiveDiamonds, 
                           factorVars = catVars, 
                           strata = "colorBestF", 
                           smd = FALSE, 
                           addOverall = TRUE, 
                           test = FALSE)
tmp <- print(t1strata)

xlsx::write.xlsx(tmp, 
                 file = here("output", "table1diamonds.xlsx"), 
                 sheetName = "Raw Output")




# PACKAGE #3: DESCTABLE
# I don't know this package very well
# but it seems like the most promising and I'm working on using it more

library(desctable)

descriptiveDiamonds %>%
  desctable()

descOutput <- 
  descriptiveDiamonds %>%
  group_by(colorBestF) %>%
  select(cut, carat, price) %>%
  desctable() 

cbind(descOutput[[1]], descOutput[[2]], descOutput[[3]])



naniar::miss_var_summary(descriptiveDiamonds)
# so much more in the naniar package! 




