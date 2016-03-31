## ----rmarkdown install---------------------------------------------------
if (!require("rmarkdown")) install.packages("rmarkdown", repos='https://cran.revolutionanalytics.com')
library(rmarkdown)

## ----setup, include=TRUE-------------------------------------------------
knitr::opts_chunk$set(cache = FALSE, echo = TRUE)

## ----package management--------------------------------------------------
# ensure package 'pacman' for package management is installed
if (!require("pacman")) install.packages("pacman")
library(pacman)

# add any required packages to the p_load() function parameters 
pacman::p_load(rmarkdown, 
               e1071, # for support vector machines 
               update=TRUE)
pacman::p_loaded() # check which packages are loaded

## ----generate data and plot----------------------------------------------
library(rmarkdown)
set.seed(10111)

# generate 40 observations, normally distributed, mean=0, sd=1
# x is a matrix of 20 rows, 2 cols
x<-matrix(rnorm(40),20,2)
# y is a vector that takes values -1 and 1, with 10 observations each
y<-rep(c(-1,1),c(10,10))
# for x index values where y = 1, add 1 to the current value of x
# in this case, the last 10 values of y have y=1, so the last 10 values of x are used
x[y==1,]<-x[y==1,]+1

plot(x,col=y+3,pch=19)

## ----fit and plot svm----------------------------------------------------
library(e1071) 
dat=data.frame(x,y=as.factor(y))

# cost is tuning parameter
# param scale=FALSE means do not standardize the variables
svmfit=svm(y~.,data=dat,kernel="linear",cost=10,scale=FALSE)
print(svmfit)
plot(svmfit,dat)

## ----custom svm plot-----------------------------------------------------
make.grid=function(x,n=75){ # 75x75 grid
  grange=apply(x,2,range)
  x1=seq(from=grange[1,1],to=grange[2,1],length=n)
  x2=seq(from=grange[1,2],to=grange[2,2],length=n)
  expand.grid(X1=x1,X2=x2)
  }
xgrid=make.grid(x)
ygrid=predict(svmfit,xgrid)
plot(xgrid,col=c("red","blue")[as.numeric(ygrid)],pch=20,cex=.2) # grid points
points(x,col=y+3,pch=19) # original points
points(x[svmfit$index,],pch=5,cex=2) # squares indicate support points #cool

## ----extract linear coefficients plot boundary---------------------------
beta=drop(t(svmfit$coefs)%*%x[svmfit$index,])
beta0=svmfit$rho
plot(xgrid,col=c("red","blue")[as.numeric(ygrid)],pch=20,cex=.2)
points(x,col=y+3,pch=19)
points(x[svmfit$index,],pch=5,cex=2)
abline(beta0/beta[2],-beta[1]/beta[2])
abline((beta0-1)/beta[2],-beta[1]/beta[2],lty=2)
abline((beta0+1)/beta[2],-beta[1]/beta[2],lty=2)

## ----get data for nonlinear example--------------------------------------
load(url("http://www.stanford.edu/~hastie/ElemStatLearn/datasets/ESL.mixture.rda"))
names(ESL.mixture)
rm(x,y)
attach(ESL.mixture)

## ----plot data-----------------------------------------------------------
plot(x,col=y+1)
dat=data.frame(y=factor(y),x)
fit=svm(factor(y)~.,data=dat,scale=FALSE,kernel="radial",cost=5)

## ------------------------------------------------------------------------
xgrid=expand.grid(X1=px1,X2=px2)
ygrid=predict(fit,xgrid)
plot(xgrid,col=as.numeric(ygrid),pch=20,cex=.2)
points(x,col=y+1,pch=19)

## ----plot contours-------------------------------------------------------
func=predict(fit,xgrid,decision.values=TRUE)
func=attributes(func)$decision
xgrid=expand.grid(X1=px1,X2=px2)
ygrid=predict(fit,xgrid)
plot(xgrid,col=as.numeric(ygrid),pch=20,cex=.2)
points(x,col=y+1,pch=19)

contour(px1,px2,matrix(func,69,99),level=0,add=TRUE)
contour(px1,px2,matrix(prob,69,99),level=.5,add=TRUE,col="blue",lwd=2)

