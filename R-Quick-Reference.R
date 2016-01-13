library("sas7bdat")
library(ggplot2)
library(knitr)
library(car) # companion for applied regression
library(Hmisc)

#read the data into R from working directory
week2 = read.sas7bdat('data\\credit_card_week_2.sas7bdat') #data from PREDICT411 week2 homework

# you could also save the data from the excel file as a csv and use:
# week2 = read.csv('Credit_Card_Week_2.csv')

str(week2)
names(week2) # column names

library("car") # companion to applied regression package

scatterplot(Age ~ Income, data=week2, id.n=4) # bi-variate, continuous variables

Boxplot ( ~ AvgExp, data=week2 ) # univariate, continuous variable

Boxplot ( AvgExp ~ MDR, data=week2) # bi-variate, continuous ~ discrete

Boxplot ( AvgExp ~ OwnRent, data=week2) # bi-variate, continuous ~ binomial

# 2 forms for chi-sq test for 2 categorical variables
summary(table(week2$MDR,week2$OwnRent)) 
test <- chisq.test((table(week2$MDR,week2$OwnRent))) 
test # just print summary of test results like chi-sq stat and p-value
str(test) # view the list elements produced from chi-sq test (like test$p.value)

# use the with function
test <- with(week2,(chisq.test((table(MDR, OwnRent)))))
test

# t-test comparison of means between continuous and binomial
ttest <- t.test(week2$AvgExp, week2$OwnRent) 
ttest
str(ttest)

t.test(u$age ~ u$y) # age is continuous, y is 0,1 factor

##################################################

# code from 411 Assignment 3 for cleaning data
# i.e. removing unneeded columns and coercing factor class 

# read the data into R: unemployment
u = read.sas7bdat('data\\unemp_week_3.sas7bdat')

summary(u)
head(u)
names(u)

# 2: remove unused variables 'state' and 'bluecol
u <- u[,-c(3,13)]

# 3: Some cleansing to organize the variable classes

# create vector of names of ocntinuous vars
cont <- c('stateur','statemb','age','age2','tenure','yrdispl','rr','rr2')

# use 'setdiff' function to create vector of all categorical vars !!
categ <- setdiff(names(u), cont)

# identify column numbers for categorical variables in data framw
cnum <- which(names(u) %in% categ)

# coerce factor class for categorical vars
for(i in cnum){
  u[,cnum] <- lapply(u[,cnum], as.factor)
}
str(u)

