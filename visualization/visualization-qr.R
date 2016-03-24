# Visualization quick reference

require(ggplot2)

# Multiple plots using lapply and vector of times as a parameter
# From MSFT Azure ML tutorial book
## Make time series plots for certain hours of the day 
require( ggplot2) 
times <- c( 7, 9, 12, 15, 18, 20, 22) 
# BikeShare $ Time <- Time 
lapply( times, function( times){ 
  ggplot( BikeShare[ BikeShare $ hr == times, ], 
          aes( x = dteday, y = cnt)) + 
    geom_line() + 
    ylab(" Log number of bikes") + 
    labs( title = paste(" Bike demand at ", 
                        as.character( times), ": 00", spe ="")) + 
    theme( text = element_text( size = 20)) } 
  )

#####
# From MSFT Azure ML tutorial book
# Example of using the same x column with different y columns (and associated labels)
# in a plot, using the Map() function

## This code gives a first look at the predictor values vs the demand for bikes. 

# If you are not familiar with using Map() this code may look a bit intimidating. 
# When faced with functional code like this, always read from the inside out. 
# On the inside, you can see the ggplot2 package functions. 
# This code is contained in an anonymous function with two arguments. 
# Map() iterates over the two argument lists to produce the series of plots.

labels <- list(" Box plots of hourly bike demand", "Box plots of monthly bike demand", 
               "Box plots of bike demand by weather factor",
               "Box plots of bike demand by workday vs. holiday", 
               "Box plots of bike demand by day of the week") 
xAxis <- list(" hr", "mnth", "weathersit", "isWorking", "dayWeek") 
Map( function( X, label){ 
  ggplot( BikeShare, aes_string( x = X, 
                                 y = "cnt", 
                                 group = X)) + 
  geom_boxplot( ) + ggtitle( label) + 
                       theme( text = 
                                element_text( size = 18)) }, 
  xAxis, labels)

#####
# Similar example using continuous variables and the Map() function, plus loess smoothed line
# From MSFT Azure ML tutorial book
# Finally, we’ll create some plots to explore the continuous variables, using the following code:

## Look at the relationship between predictors and bike demand
labels <- c(" Bike demand vs temperature",
            "Bike demand vs humidity", 
            "Bike demand vs windspeed", 
            "Bike demand vs hr") 
xAxis <- c(" temp", "hum", "windspeed", "hr") 
Map( function( X, label){ 
  ggplot( BikeShare, aes_string( x = X, y = "cnt")) + 
  geom_point( aes_string( colour = "cnt"), alpha = 0.1) + 
  scale_colour_gradient( low = "green", high = "blue") + 
  geom_smooth( method = "loess") + 
  ggtitle( label) + 
  theme( text = element_text( size = 20)) }, 
xAxis, labels)

##########

# Plotting residuals | Use lapply and implicit function for multiple plots
# From MSFT Azure ML tutorial book
## Compute the residuals
library(dplyr)
inFrame <-  mutate(inFrame, resids = predicted - cnt)

## Plot the residuals. First a histogram and 
## a qq plot of the residuals.
ggplot(inFrame, aes(x = resids)) + 
  geom_histogram(binwidth = 1, fill = "white", color = "black")

qqnorm(inFrame$resids)
qqline(inFrame$resids)

## Plot the residuals by hour and transformed work hour.
library(dplyr)

# mutate function requires dplyr package
inFrame <- mutate(inFrame, fact.hr = as.factor(hr),
                  fact.workTime = as.factor(workTime))                                  
facts <- c("fact.hr", "fact.workTime") 
lapply(facts, function(x){ 
  ggplot(inFrame, aes_string(x = x, y = "resids")) + 
    geom_boxplot( ) + 
    ggtitle("Residual of actual versus predicted bike demand by hour")})
  

###########

library("car") # companion to applied regression package

scatterplot(Age ~ Income, data=week2, id.n=4) # bi-variate, continuous variables

Boxplot ( ~ AvgExp, data=week2 ) # univariate, continuous variable

Boxplot ( AvgExp ~ MDR, data=week2) # bi-variate, continuous ~ discrete

Boxplot ( AvgExp ~ OwnRent, data=week2) # bi-variate, continuous ~ binomial