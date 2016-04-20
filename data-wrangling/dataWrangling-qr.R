# Data Wrangling Quick Reference

library(dplyr)
library(ISLR)

data(Wage)
summary(Wage)
ls(Wage)

tbl_df(Wage)
glimpse(Wage)

Wage %>%
  group_by(education) %>%
  summarise(avg=mean(wage)) %>%
  arrange(avg)

summarise(Wage)

# convert date info in format 'mm/dd/yyyy'
# <http://www.statmethods.net/input/dates.html>
strDates <- c("01/05/1965", "08/16/1975")
dates <- as.Date(strDates, "%m/%d/%Y")
