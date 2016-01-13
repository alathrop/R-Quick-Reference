# Quick reference for loading and exporting data

# The following command clears your R workspace (all variables in memory) to give you
# a fresh start. If you want to do this, execute the command without the # symbol.
rm(list=ls())
#
######################
# Load and export data
######################

# ---------------
# browse for file
# ---------------
trnData = read.csv(file.choose(),na.strings=c("NA"," "))

# fix function opens edit window
fix(trnData)

# -----
# Excel
# -----
require(gdata)
library(gdata)

# define path to perl (perl is required for gdata)
zz <- file.path("C:", "Perl64", "bin", "perl.exe")
# ID the compatible Excel file formats for use with gdata 
xlsFormats(perl = zz, verbose = FALSE)

# read Excel using gdata
df <- read.xls("data\\apple.xlsx", sheet="data", perl=zz)


# -----
# CSV
# -----
# read CSV
MyData <- read.csv("data\\apple.csv", header=TRUE, check.names=FALSE, stringsAsFactors=FALSE)

# Assuming your working directory is /home/hermie and you want to load a .csv file from a directory 
# below your current WD (let's say /home/hermie/data), you can simply do this:
# 
# setwd('/home/hermie')
# myData <- read.csv('./data/myCsvFile.csv')

# Of course you could also navigate "upwards" in the directory tree. Let's say you want to load a file in
# Bob's home directory (/home/bob). You can do it as follows:
#   
# setwd('/home/hermie')
# data_from_bob <- read.csv('../bob/otherDataFile.csv') # Of course, this will work
# # only if you can read
# # files from that directory


# write CSV
write.csv(MyData, file="data\\apple_out.csv")

# -----
# Text files (tab separated, UTF-8 Encoded from Spotfire)
# Includes Byte Order Mark (BOM characters at beginning of file)
# http://stackoverflow.com/questions/21624796/read-the-text-file-with-bom-in-r
# -----
my.data.frame <- read.table("data\\PropertyDamage.txt", 
                            header=T, sep="\t",
                            check.names=FALSE, 
                            fileEncoding="UTF-8-BOM")

# -----
# load data from packages
# -----
library(ISLR) # package from Machine Learning textbook
data() # list all data sets in base R and loaded packages
data(Auto) # load the Auto dataset from the ISLR package
help(Auto) # get a description of the dataset

summary(Auto)

sum(!complete.cases(Auto)) # Count of incomplete cases (this dataset does not have missing values)
sum(is.na(Auto)) # alternate way to count missing values
Auto = na.omit(Auto) # remove missing values

# -----
# SAS
# -----
library("sas7bdat")

#read the data into R from working directory
week2 = read.sas7bdat('data\\credit_card_week_2.sas7bdat')

# -----
# data Format manipulations
# -----

# this does not include a working data set

## Date columns treatment
# date columns enter as character class and need to be changed to Date (POSIXlt) class

#fail.date.colnames <- names(d.fail[grep("Date",names(d.fail))]) # all cols with "Date" in the name
#d.fail.class    <- unlist(lapply(d.fail[,d.fail.colnames], class)) # column classes

# columns with "Date" in name and class "character" (some date columns are just a year as an integer
# and do not need to be converted
# date.cols <- which(d.fail.colnames %in% fail.date.colnames & d.fail.class=="character")

# temp$FailureDate <- strptime(temp$FailureDate, format="%Y/%m/%d %H:%M:%S") # From LINN wellbore project
# temp$CreatedDate <- as.POSIXlt(temp$CreatedDate, format="%Y/%m/%d %H:%M:%S")

# change a group of columns in data frame
# d.fail[,date.cols] <- apply(d.fail[,date.cols],2, function(x) as.POSIXlt(x, format="%Y/%m/%d %H:%M:%S"))

# d.fail[,date.cols] <- apply(d.fail[,date.cols],2, function(x) 
#                             as.POSIXct(x, format="%Y/%m/%d %H:%M:%S", origin="1970-01-01"))
