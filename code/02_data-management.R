
library(tidyverse)

data(diamonds)

diamondsLess <- diamonds %>%
  filter(carat<1) %>%
  filter(price < 2000) %>%
  sample_n(size=1000)

cleaned <- diamondsLess %>%
  mutate(cutF = factor(cut, ordered=FALSE), 
         cutIdeal = if_else(cut=="Ideal", "Ideal", "Not ideal"),
         colorF = factor(color, ordered=FALSE), 
         colorBest = if_else(color %in% c("D", "E", "F"), "D/E/F (best)", "G/H/I/J (not best)"))

xtabs(~cut + cutIdeal, data=cleaned, addNA = TRUE)
xtabs(~color + colorBest, data=cleaned, addNA = TRUE)



base <- ggplot(data=cleaned, 
               aes(x=carat, 
                   colour=colorBest, 
                   y=reg$fitted.values)) + 
  geom_line(size=2) + 
  labs(y = "Predicted Price", 
       x = "Carats") + 
  theme(legend.position = "bottom")

reg <- lm(price ~ colorBest + carat, data=cleaned)
base + labs(title = "price = color + carats", 
            subtitle = "main effects only")

reg <- lm(price ~ colorBest*carat, data=cleaned)
base + labs(title = "price = color + carats + color*carats", 
            subtitle = "allowing effect of carats to vary by color")

reg <- lm(price ~ colorBest + carat + I(carat^2), data=cleaned)
base + labs(title = "price = color + carat + carat2", 
            subtitle = "allowing for non-linear (quadratic) effect of carats on price")

reg <- lm(price ~ colorBest*(carat + I(carat^2)), data=cleaned)
base + labs(title = "price = color + carat + carat2 + color*carat + color*carat2", 
            subtitle = "allowing that quadratic effect to vary by color")
