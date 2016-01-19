# Data Wrangling Quick Reference

library(dplyr)

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