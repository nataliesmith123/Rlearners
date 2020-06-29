

## @knitr vectors

# Vectors -----------------------------------------------------------------
# also scalars/values

# I like to use scalars to make my code more readable
# for example: 
numerator <- 124
denominator <- 45

(ratio <- numerator/denominator) # enclosing in () just makes it print automatically
numerator/denominator


# I tend to do things like number of iterations, simulation size, etc. as scalars


# vectors include multiple things
people <- c("antoni", "karamo", "bobby", "tan", "jonathan")
names(people) <- c("first", "second", "third", "fourth", "fifth")
people

job <- c("food", "life", "home", "clothes", "hair")
age <- c(36, 39, 38, 37, 33)

# can combine them together using cbind()
queerEye <- cbind(people, job, age)
# rbind stacks by rows
# cbind appends columns
# take a look - note that the names are now rownames of the matrix! 
# personally i never rely on rownames
# in dataframes, whenever you reorder, the rownames get reset
# very dangerous
# ALWAYS better to use an explicit ID variable

## @knitr matrix

# Matrices ----------------------------------------------------------------

# here I am manually inputting the rows and columns of a matrix
# and i specify how many rows and columns that matrix has
# byrow means that i am inputting the data in row-wise order... 
# so once 4 numbers have been input, that's the end of the first row, etc. 
aMatrix <- matrix(c(1,2,3,4, 
                    5,6,7,8, 
                    9, 10, 11, 12), 
                  nrow=3, ncol=4,
                  byrow=TRUE)

# access things within a matrix using the indices
# first element is the rows, second is the columns
tmp <- aMatrix[1,1] # first row, first column
aMatrix[,2] # whole second column
aMatrix[c(1,3),] # first and third rows, all columns
# you can also assign these to new objects to use them again
names(aMatrix) # has no names :( 
colnames(aMatrix) <- c("v1", "v2", "v3", "v4")

# now I can use the names to ask for things
aMatrix[2, c("v3", "v4")]
# again, taking the time to name things makes code much more reasonable


# you can also change a dataframe into a matrix
aLittleDF <- tribble(~col1, ~col2, ~col3, 
                     "hi", 1, 2, 
                     "hello", 3, 4, 
                     "bonjour", 5, 6)

# note that because there are characters in one of the columns, all of the columns are matrices
DFtoMatrix <- as.matrix(aLittleDF)
# can also make a matrix into a dataframe using as.data.frame()


## @knitr df

# Dataframes / tibbles ----------------------------------------------------

data(diamonds)

# class() tells you what it is
class(diamonds)
# this is a tibble - type of dataframe
#?diamonds

# str() gives you the internal structure of a given object
str(diamonds)
# there are 10 variables here - numeric, integer, and ordered factor variables

# Factor variables these are perhaps the most different from other softwares. Check out the forcats cheat sheet from R studio for more info: https://rstudio.com/resources/cheatsheets/
# we'll do more on factors within data management
# this actually shows us the ORDERING of the levels
str(diamonds$cut)
xtabs(~cut, data=diamonds)



## @knitr list

# Lists -------------------------------------------------------------------
# lists are sort of vectors? 
aList <- vector("list", 5)
names(aList) <- c("binomial", "normal", "gamma", "exponential", "poisson")
aList

sampleSize <- 50 
aList[["binomial"]] <- rbinom(n=sampleSize, size=5, prob=0.4)
aList[["normal"]] <- rnorm(n=sampleSize, mean=10, sd=5)
aList[["gamma"]] <- rgamma(n=sampleSize, shape = 45, scale=23)
aList[[4]] <- rexp(n=sampleSize, rate=3) # can also use the number of the list to assign
aList[["poisson"]] <- rpois(n=sampleSize, lambda=2)


# 'apply' functions are a base R thing -- allow you you repeat a function over a list
lapply(aList, mean)

meanList <- lapply(aList, mean)

# $ operator will help you autocomplete -- can be helpful when we get into reg objects, etc. 
meanList$binomial
meanList[["binomial"]]



# there are so many possibilities with lists
# they can hold different kinds of objects, etc. etc.
# whole wide world out there once you get the basics down!
# and like I said, they are commonly used instead of for loops
# and 'vectorized approaches' are constantly shifting in R



## @knitr lm

# Modeling results: just a list object (?) --------------------------------

# in R modeling, the general formula is y ~ x vars
# tidymodels! 
reg <- lm(price ~ carat + x + y + z, data=diamonds)

summary(reg)

reg$coefficients
reg[["coefficients"]]

# easily plot of residuals vs. predicted values
plot(reg$fitted.values, reg$residuals)
# oof, that cone shape, a bad regression!

# can easily the fitted values and residuals to our diamonds data frame
# disclaimer: this is, to my knowledge, based on the ORDERING of the dataframe and object
# this has always seemed problematic to me, since the internal ordering could in theory change?
diamondsPlus <- diamonds %>%
  mutate(predicted = reg$fitted.values, 
         residuals = reg$residuals)

# say we wanted to make a fancier with ggplot...


## @knitr gg

# ggplot objects: just a list object round 2 (?) --------------------------

# this sets up our base graph
# if we print it, nothing will show up -- we haven't told ggplot HOW to graph yet
base <- ggplot(data=diamondsPlus, 
               aes(x=predicted, 
                   y=residuals)) 
base

# base contains a bunch of stuff that ggplot uses to make the graph
# for example, the actual data and labels for those data
base$data
base$labels

# add points
base + geom_point()

# add points, and color by the carat (a little prelude to ggplot!)
base + geom_point(aes(color=carat))

