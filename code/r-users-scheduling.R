
library(tidyverse)

rusersOrig <- readxl::read_excel("../Downloads/R users group list 0527_136PM.xlsx")

rusers <- rusersOrig %>%
  
  filter(Q3 != "Your name") %>%
  
  select(morning = Q2_1, 
         midday = Q2_2, 
         afternoon = Q2_3, 
         evening = Q2_4) %>%
  
  rownames_to_column(var="ID") %>%
  
  pivot_longer(cols=c(morning, midday, afternoon, evening), 
               names_to = "time", 
               values_to = "days") %>%
  
  filter(!is.na(days)) %>%
  
  mutate(mon = str_detect(days, "Monday"), 
         tues = str_detect(days, "Tuesday"), 
         wed = str_detect(days, "Wednesday"), 
         thurs = str_detect(days, "Thursday"), 
         fri = str_detect(days, "Friday")) %>%
  
  select(-ID, -days) %>%
  
  pivot_longer(cols=c(mon, tues, wed, thurs, fri), 
               names_to = "day", 
               values_to = "tf") %>%
  
  filter(tf==TRUE) %>%
  
  select(-tf) %>%
  
  group_by(time, day) %>%
  
  summarise(count = n()) %>%
  
  ungroup() %>%
  
  mutate(time = factor(time, 
                       levels = c("morning", "midday", "afternoon", "evening")), 
         day = factor(day, 
                      levels = c("mon", "tues", "wed", "thurs", "fri"))) %>%
  
  arrange(time, day)





