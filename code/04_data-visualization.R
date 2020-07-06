
## @knitr viz1


# data(diamonds)

# use the diamondsLess dataset from last week as review of commands, and cut down on number of points we have to plot 


# these two things look exactly the same. 
# some people prefer base R for speed
# but I don't think it can beat ggplot for customizability
# (some people might argue)
# I use base plotting sometimes for 1) quick-and-dirty plots, or 2) network visualization
plot(x = diamondsLess$carat, 
     y = diamondsLess$price)

ggplot(data=diamondsLess, 
       aes(x=carat, 
           y=price)) + 
  geom_point()

ggsave(filename = here("output", "testSave.png"), 
       plot = last_plot(), 
       device = "png", 
       dpi = 500, 
       width = 8, 
       height = 7, 
       units = "in")


# exercise 1
ggplot(data=diamondsLess, 
       aes(x=carat, 
           y=price)) + 
  geom_point(aes(color = cutIdeal))


# exercise 2
ggplot(data=diamondsLess, 
       aes(x=carat, 
           y=price)) + 
  geom_point(aes(color = cutIdeal)) + 
  #scale_color_nejm()
  #scale_color_viridis_d()
  scale_color_manual(values = c("Ideal" = "#00FFFF", 
                                "Not ideal" = "#FF5733"))
  

# exercise 3
ggplot(data=diamondsLess, 
       aes(x=price)) + 
  geom_density(color = "darkblue", 
               size=2, 
               fill = "lightblue", 
               alpha = 0.5)


# exercise 4 & 5
ggplot(data=diamondsLess) + 
  geom_histogram(aes(x=carat, 
                     y=..density..), 
                 bins = 50, 
                 color = "black", 
                 fill = "lightgray") + 
  geom_density(aes(x=carat), color = "darkblue", size=2)




# exercise 6
diamondsLess <- ungroup(diamondsLess)


diamondsMean <- diamondsLess %>%
  arrange(carat) %>%
  mutate(carat10pct = ntile(x = carat, n=10)) %>%
  group_by(carat10pct, cutIdeal) %>%
  summarise(priceMean = mean(price), 
            priceSD = sd(price), 
            priceN = n(),  
            
            .groups = "keep") %>%
  ungroup() %>%
  mutate(priceMean = round(priceMean, digits=0), 
         priceSE = priceSD/priceN, 
         priceLL = priceMean - (50*priceSE), 
         priceUL = priceMean + (50*priceSE))
  


ggplot(data=diamondsMean, 
       aes(x=carat10pct, 
           y=priceMean, 
           group=cutIdeal, 
           color=cutIdeal)) +
  geom_line(size=1) + 
  geom_point(size=3) + 
  geom_errorbar(aes(ymin = priceLL, 
                    ymax = priceUL), 
                color = "darkgray") + 
  geom_label(aes(label = priceMean), show.legend = FALSE, position = position_dodge(width=1.5)) + 
  scale_x_continuous(breaks = c(1,2,3,4,5,6,7,8,9,10)) + 
  labs(title = "Plot of price by carats", 
       subtitle = "Colored by ideal cut", 
       caption = "using diamonds data from tidyverse") + 
  xlab("Percentile of carat") + 
  ylab("Average price") + 
  theme_bw() + 
  theme(legend.position = c(0.1,0.9),
        legend.background = element_rect(linetype = "solid", colour = "black"),
        legend.title = element_blank(), 
        panel.grid = element_blank(), 
        axis.text.x = element_text(size=16), 
        axis.title.x = element_text(size=20), 
        legend.text = element_text(size=12), 
        plot.title = element_text(size=28, face="bold", hjust = 0.5), 
        plot.subtitle = element_text(size=20, hjust=0.5), 
        axis.text.y = element_text(angle=45))












  