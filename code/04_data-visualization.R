
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
  geom_point(aes(colour = cutIdeal)) + 
  scale_colour_manual(values = c("Ideal" = "red", 
                                 "Not ideal" = "blue"))


# exercise 3
ggplot(data=diamondsLess) + 
  geom_density(aes(x=price), fill="lightblue", color = "darkblue", size = 3)


# exercise 4
ggplot(data=diamondsLess) + 
  geom_histogram(aes(x=carat, 
                     y = ..density..),
                 color = "black", 
                 fill = "lightgray", 
                 bins=50)
  
# exercise 5
ggplot(data=diamondsLess) + 
  geom_histogram(aes(x=carat, 
                     y = ..density..),
                 color = "black", 
                 fill = "lightgray", 
                 bins=50) + 
geom_density(aes(x=carat), 
             color = "darkblue", 
             size = 1) 


# exercise 6
diamondsMean <- diamondsLess %>%
  mutate(carat10pct = ntile(carat, 10)) %>%
  group_by(carat10pct, cutIdeal) %>%
  summarize(priceMean = mean(price), 
            priceSD = sd(price), 
            priceN = n(), 
            priceSE = priceSD/priceN) %>%
  ungroup()

ggplot(data=diamondsMean, 
       aes(x=carat10pct, 
           y=priceMean, 
           group=cutIdeal, 
           color=cutIdeal)) +
  geom_line(size=1) + 
  geom_point(size=3)












  