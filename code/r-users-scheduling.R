
## @knitr dm

library(tidyverse)

rusersOrig <- readxl::read_excel("data/R users group list 0527_136PM.xlsx")

# I had already taken a manual look at the data before doing this
# also when I was building this code I was outputting new datasets in between steps
# so I could see how the sample size changed, etc.
# then I put it all together at the end into one big data step
# %>% is the pipe operator https://r4ds.had.co.nz/pipes.html
rusers <- rusersOrig %>%
  
  # Because of the way Qualtrics data imports, there is an extra row here with the variable labels
  # Get rid of it by saying 'keep all rows that have a StartDate NOT EQUAL to "Start Date"
  # filter() keeps rows that return TRUE for a given condition(s)
  filter(StartDate != "Start Date") %>%
  
  
  # select() keeps the variables that I want
  # you can rename on the fly newVar = oldVar
  # the other option is the rename() function
  select(morning = Q2_1, 
         midday = Q2_2, 
         afternoon = Q2_3, 
         evening = Q2_4) %>%
  
  # Since I deidentified the data, want to make an ID so I can transpose
  # rownames_to_column() takes the sequential rowname and makes an ID var
  # Lots of other ways to do this, could make a random number, etc.
  # This is really only necessary for the pivoting.
  rownames_to_column(var="ID") %>%

  # Now I want to pivot to long format for easier data processing
  # this takes the 4 time variables and transposes them
  # now I only have to work on one column, rather than 4
  
  # start: 
  # ID morning midday afternoon evening
  # end: 
  # ID morning mon/tues/etc.
  # ID midday mon/tues/etc.
  # ID afternoon mon/tues/etc.
  # ...
  pivot_longer(cols=c(morning, midday, afternoon, evening), 
               names_to = "time", 
               values_to = "days") %>%
  
  # Keep only the rows that have NON-MISSING data for the 'days' column. 
  # This exists because some people didn't check any days for a given time 
  # (i.e., someone who never wanted to meet in the morning)
  filter(!is.na(days)) %>%
  
  # mutate() is the wrapper for new variables
  # within the mutate() function, you can make lots of variables. 
  # newVar = thing to make newvar, 
  # str_detect() is part of the stringr package. It returns a Boolean TRUE/FALSE 
  # variable that is TRUE if the given string was detected, and FALSE if not
  # 5 new variables, each a boolean with info about whether or not that person can meet on that day
  mutate(mon = str_detect(days, "Monday"), 
         tues = str_detect(days, "Tuesday"), 
         wed = str_detect(days, "Wednesday"), 
         thurs = str_detect(days, "Thursday"), 
         fri = str_detect(days, "Friday")) %>%
  
  # select() can also drop variables if you put the - in front
  # dropping ID and the original 'days' variable. 
  # I now have info fromd ays in the mon/tues/wed/thurs/fri variables
  select(-ID, -days) %>%
  
  
  # Another transpose/pivot 
  # want to keep the 'day' information in one column
  # so now the columns of this data will be: 
  # time day tf
  pivot_longer(cols=c(mon, tues, wed, thurs, fri), 
               names_to = "day", 
               values_to = "tf") %>%
  
  # only keep the days that are TRUE 
  # this will allow us to count the total number of TRUEs per time/day
  filter(tf==TRUE) %>%
  
  # since we have kept TRUEs only, don't need that var anymore
  select(-tf) %>%
  
  # group_by() gets your data ready to calculate numbers by a given grouping
  # for every combination of time and day
  group_by(time, day) %>%
  
  # summarise() is used after group by to create summary stats
  # you can also use things like mean(), sum(), etc. 
  # count the number of times that combination occurs using n()
  summarise(count = n()) %>%
  
  # get rid of the grouping (other functions won't work if you keep it implicitly grouped)
  # our dataset now has one row for every time-day combination
  # and a count of how many times that combination occurred
  ungroup() %>%
  
  # making factor variables that look nicer for display purposes
  # factor() takes a given variable and allows you to define the levels 
  # and associate a label with each level
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
         
         # if_else() statement -- pretty standard
         gt14 = if_else(condition = count>=14, 
                        true = 1, 
                        false = 0)) %>%
  
  # arrange() arranges data according to vars
  # factors will be arranged in their order
  # just doing this here to demonstrate
  arrange(time, day)



## @knitr graph

# initialize our plot with the data, and what the x and y axes are
ggplot(data=rusers, 
       aes(x=time, 
           y=count)) +
  
  # make a bar chart
  # this will 'inherit' the aesthetics we defined above
  # so, y is the COUNT and x is the TIME
  # fill means that the color for each bar is defined by TIME
  # alpha is the transparency, since I want to bold the times that were given by >= 14 people
  # have to use factor() because ggplot needs to know that there are 2 levels to this variable
  # that's how it will assign transparencies
  # you'll see a little warning from R on using transparencies for a discrete variable
  # I don't get why it has a problem with this. I think it makes sense! 
  geom_bar(aes(fill=time, alpha=factor(gt14)), 
           stat="identity") + 
  
  # this sets the alpha to be within a given range
  # since there are two values, I think one will be at the low end and one at the high end
  # can tweak this to make it look how you want
  # am not as familiar with alpha
  # also lots of ggplot is tweaking until it looks right
  # just beware that the plot window in RStudio might look different than when you output to png or pdf
  scale_alpha_discrete(range=c(0.3, 1)) + 
  
  # change colors to be the viridis scale (regular ggplot colors are yucky)
  # the _d in the command means for discrete variables 
  # direction means that I want to reverse the default ordering of the colors
  scale_fill_viridis_d(direction=-1) + 
  
  # create this barplot separately for each DAY
  # display them in one row
  facet_wrap(~day, 
             nrow=1) + 
  
  # get rid of the usual ggplot theme
  # https://ggplot2.tidyverse.org/reference/ggtheme.html
  theme_minimal() + 
  
  # tweak lots of the little theme options
  # there are almost endless options here
  # lots of trial and error
  # help page for ?theme
  theme(legend.position = "bottom", # legend at bottom
        legend.title = element_blank(), # remove legend title
        axis.text.x = element_blank(), # remove axis text (labeled times -- pretty intuitive based on legend)
        axis.title.x = element_blank(), # remove x axis title ('time')
        axis.title.y = element_blank(),  # remove y axis title ('count')
        strip.text = element_text(size=12), # change the font size for the facet titles - Monday, etc.
        plot.title = element_text(size=16), # change the font size for the plot title
        plot.subtitle = element_text(size=10), # change the font size for the subtitle
        legend.text = element_text(size=10), # change the font size in the legend
        legend.spacing.x = unit(0.7, 'cm')) + # space out the legend so it can handle the increased font size and increased square sizes
  
  # I don't want a legend (guide) for the transparency - will put this in a subtitle
  # making the square boxes of the color legend larger
  guides(alpha=FALSE, 
         fill = guide_legend(override.aes = list(size = 12))) + 
  
  # add some informative labels
  labs(title = "Meeting times for R group", 
       subtitle = "Times with at least 14 positive responses are bolded")





