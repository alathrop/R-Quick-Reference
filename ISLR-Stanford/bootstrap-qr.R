
# chapter 5 quiz quiz model

library(ISLR) # use for getting Auto data set for example
library(boot) # for bootstrap functions

# preliminary look at data and regression results

load("5.R.RData")
matplot(Xy,type="l")

cor(Xy) # correlation is low between predictors and response

myLr <- lm(y~X1+X2, data=Xy)
summary(myLr) # R-sq is low. Linear model and assumptions may not be appropriate. See notes for text

#----------------
# Estimating the Accuracy of a Linear Regression Model

boot.fn=function(data,index)
  return(coef(lm(y~.,data=data,subset=index)))
boot.fn(Xy,1:1000)

set.seed(1)
boot.fn(Xy,sample(1000,1000,replace=T))
boot.fn(Xy,sample(1000,1000,replace=T))

boot(Xy,boot.fn,1000)
summary(lm(y~.,data=Xy))$coef

boot.fn=function(data,index)
  coefficients(lm(y~.,data=Xy,subset=index))
set.seed(1)
boot(Xy,boot.fn,1000)
summary(lm(y~.,data=Xy))$coef


#------------------
# Example from text using Auto data
# Estimating the Accuracy of a Linear Regression Model
attach(Auto)
boot.fn=function(data,index)
  return(coef(lm(mpg~horsepower,data=data,subset=index)))
boot.fn(Auto,1:392)
set.seed(1)
boot.fn(Auto,sample(392,392,replace=T))
boot.fn(Auto,sample(392,392,replace=T))
boot(Auto,boot.fn,1000)
summary(lm(mpg~horsepower,data=Auto))$coef
boot.fn=function(data,index)
  coefficients(lm(mpg~horsepower+I(horsepower^2),data=data,subset=index))
set.seed(1)
boot(Auto,boot.fn,1000)
summary(lm(mpg~horsepower+I(horsepower^2),data=Auto))$coef


