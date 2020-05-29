
## @knitr timeGraph

library(tidyverse)

rusersOrig <- readxl::read_excel("../data/R users group list 0527_136PM.xlsx")


# I promise I will annotate this soon!

rusers <- rusersOrig %>%
  
  filter(StartDate != "Start Date") %>%
  
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
                       levels = c("morning", "midday", "afternoon", "evening"), 
                       labels = c("morning" = "Morning \n 8a-11a", 
                                  "midday" = "Midday \n 11a-1p", 
                                  "afternoon" = "Afternoon \n 1p-4p", 
                                  "evening" = "Evening \n 4p-6p")), 
         day = factor(day, 
                      levels = c("mon", "tues", "wed", "thurs", "fri"), 
                      labels = c("mon" = "Monday", 
                                 "tues" = "Tuesday", 
                                 "wed" = "Wednesday", 
                                 "thurs" = "Thursday", 
                                 "fri" = "Friday")), 
         
         gt14 = if_else(count>=14, 1, 0)) %>%
  
  arrange(time, day)



ggplot(data=rusers, 
       aes(x=time, 
           y=count)) +
  
  geom_bar(aes(fill=time, alpha=factor(gt14)), 
           stat="identity") + 
  
  scale_alpha_discrete(range=c(0.3, 1)) + 
  
  scale_fill_viridis_d(direction=-1) + 
  
  facet_wrap(~day, 
             nrow=1) + 
  
  theme_minimal() + 
  
  theme(legend.position = "bottom", 
        legend.title = element_blank(), 
        axis.text.x = element_blank(), 
        axis.title.x = element_blank(), 
        axis.title.y = element_blank(), 
        strip.text = element_text(size=12), 
        plot.title = element_text(size=16), 
        plot.subtitle = element_text(size=10), 
        legend.text = element_text(size=10), 
        legend.spacing.x = unit(0.7, 'cm')) + 
  
  guides(alpha=FALSE, 
         fill = guide_legend(override.aes = list(size = 12))) + 
  
  labs(title = "Meeting times for R group", 
       subtitle = "Times with at least 14 positive responses are bolded")





