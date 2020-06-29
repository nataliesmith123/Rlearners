
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
  #scale_color_viridis_d()
  scale_color_manual(values = c("Ideal" = "red", 
                                "Not ideal" = "blue"))
  

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
str(diamondsLess)
diamondsLess <- ungroup(diamondsLess)


diamondsMean <- diamondsLess %>%
  arrange(carat) %>%
  mutate(carat10pct = ntile(x = carat, n=10)) %>%
  group_by(carat10pct, cutIdeal) %>%
  summarise(priceMean = mean(price), 
            priceSD = sd(price), 
            priceN = n(), 
            priceSE = priceSD/priceN, 
            
            .groups = "keep") %>%
  ungroup()


ggplot(data=diamondsMean, 
       aes(x=carat10pct, 
           y=priceMean, 
           group=cutIdeal, 
           color=cutIdeal)) +
  geom_line(size=1) + 
  geom_point(size=3)












  