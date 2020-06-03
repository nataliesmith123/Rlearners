

# Dataframes / tibbles ----------------------------------------------------

data(diamonds)

# class() tells you what it is
class(diamonds)
# this is a tibble - type of dataframe

# str() gives you the internal structure of a given object
str(diamonds)
# there are 10 variables here - numeric, integer, and ordered factor variables

# Factor variables these are perhaps the most different from other softwares. Check out the forcats cheat sheet from R studio for more info: https://rstudio.com/resources/cheatsheets/
# we'll do more on factors within data management
# this actually shows us the ORDERING of the levels
str(diamonds$cut)
xtabs(~cut, data=diamonds)



# Lists -------------------------------------------------------------------

