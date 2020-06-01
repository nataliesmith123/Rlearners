
# this is a comment. 

# to install packages
install.packages('tidyverse')

# load package
library(tidyverse)


tmp_dataset <- tibble::tribble(~var1, ~var2, 
                               "hi", 1, 
                               "hello", 2, 
                               "bonjour", 3)


mean(tmp_dataset$var2)
