# tutorial from
# http://genomicsclass.github.io/book/pages/dplyr_tutorial.html

library(dplyr)

library(downloader)
url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv"

filename <- "msleep_ggplot2.csv"
if (!file.exists(filename)) download(url,filename)
msleep <- read.csv("msleep_ggplot2.csv")
head(msleep)

# convert data to tbl class - easier to examine than data frame
# displays only data that can fit on screen
tbl_df(msleep)

# information dense summary of tbl data
glimpse(msleep)

# view in spreadsheet-like display
View(msleep)

# Select a set of columns: the name and the sleep_total columns.
sleepData <- select(msleep, name, sleep_total)
head(sleepData)

# To select all the columns except a specific column, use the “-“ (subtraction) operator 
# (also known as negative indexing)
head(select(msleep, -name))

# To select a range of columns by name, use the “:” (colon) operator
head(select(msleep, name:order))

# To select all columns that start with the character string “sl”, use the function starts_with()
head(select(msleep, starts_with("sl")))

# Some additional options to select columns based on a specific criteria include
# 
# ends_with() = Select columns that end with a character string
# contains() = Select columns that contain a character string
# matches() = Select columns that match a regular expression
# one_of() = Select columns names that are from a group of names

# Filter the rows for mammals that sleep a total of more than 16 hours.
filter(msleep, sleep_total >= 16)
filter(msleep, name == 'Owl monkey')

# Filter the rows for mammals that sleep a total of more than 16 hours
# and have a body weight of greater than 1 kilogram.
filter(msleep, sleep_total >= 16, bodywt >= 1)

# Filter the rows for mammals in the Perissodactyla and Primates taxonomic order
# You can use the boolean operators (e.g. >, <, >=, <=, !=, %in%) to create the logical tests.
filter(msleep, order %in% c("Perissodactyla", "Primates"))
filter(msleep, vore %in% c("carni", "herbi"))

# get distinct rows (remove duplicates)
nrow(msleep)
nrow(distinct(msleep))
distinct(msleep)

# get unique values for a column
distinct(msleep, vore)
distinct(msleep, order)

# Pipe operator: %>%
# Before we go any futher, let’s introduce the pipe operator: %>%. 
# dplyr imports this operator from another package (magrittr). 
# This operator allows you to pipe the output from one function to the input of another function. 
# Instead of nesting functions (reading from the inside to the outside), 
# the idea of of piping is to read the functions from left to right.

# Here’s an example you have seen:
head(select(msleep, name, sleep_total))

# Now in this case, we will pipe the msleep data frame to the function that will 
# select two columns (name and sleep_total) and then pipe the new data frame to 
# the function head() which will return the head of the new data frame.
msleep %>% 
  select(name, sleep_total) %>% 
  head

# Arrange or re-order rows using arrange()
# To arrange (or re-order) rows by a particular column such as the taxonomic order, 
# list the name of the column you want to arrange the rows by
msleep %>% arrange(vore) %>% head
msleep %>% arrange(order) %>% head

# Now, we will select three columns from msleep, arrange the rows by the taxonomic order 
# and then arrange the rows by descending sleep_total. Finally show the head of the final data frame
msleep %>% 
  select(name, order, sleep_total) %>%
  arrange(order, desc(sleep_total)) %>% 
  head

msleep %>% 
  select(name, order, sleep_total) %>%
  arrange(order, desc(sleep_total)) %>% 
  filter(sleep_total >= 16)

# The mutate() function will add new columns to the data frame. 
# Create a new column called rem_proportion which is the ratio of rem sleep to total amount of sleep.
msleep %>% 
  mutate(rem_proportion = sleep_rem / sleep_total) %>%
  head

# You can many new columns using mutate (separated by commas). 
# Here we add a second column called bodywt_grams which is the bodywt column in grams.
msleep %>% 
  mutate(rem_proportion = sleep_rem / sleep_total, 
         bodywt_grams = bodywt * 1000) %>%
  head

# The summarise() function will create summary statistics for a given column
# in the data frame such as finding the mean. For example, to compute the average number 
# of hours of sleep, apply the mean() function to the column sleep_total and call the summary value avg_sleep.
msleep %>% 
  summarise(avg_sleep = mean(sleep_total))

msleep %>% 
  summarise_each(funs(mean))

# There are many other summary statistics you could consider such sd(), 
# min(), max(), median(), sum(), n() (returns the length of vector), first() 
# (returns first value in vector), last() (returns last value in vector) and 
# n_distinct() (number of distinct values in vector).
msleep %>% 
  summarise(avg_sleep = mean(sleep_total), 
            min_sleep = min(sleep_total),
            max_sleep = max(sleep_total),
            total = n())

#####
# The group_by() verb is an important function in dplyr. As we mentioned before it’s related to concept 
# of “split-apply-combine”. We literally want to split the data frame by some variable (e.g. taxonomic order), 
# apply a function to the individual data frames and then combine the output.
# 
# Let’s do that: split the msleep data frame by the taxonomic order, then ask for the same summary statistics as above. 
# We expect a set of summary statistics for each taxonomic order.
msleep %>% 
  group_by(order) %>%
  summarise(avg_sleep = mean(sleep_total), 
            min_sleep = min(sleep_total), 
            max_sleep = max(sleep_total),
            total = n())

# Example of group_by to calculate Quantile from Azure ML tutorial
if(Azure){
  ## Read in the dataset. 
  BikeShare <- maml.mapInputPort(1)
  BikeShare$dteday <- as.POSIXct(as.integer(BikeShare$dteday), 
                                 origin = "1970-01-01")
}

## Build a dataframe with the quantile by month and 
## hour. Parameter Quantile determines the trim point. 
Quantile <- 0.10
require(dplyr)
quantByPer <- (
  BikeShare %>%
    group_by(workTime, monthCount) %>%
    summarise(Quant = quantile(cnt, 
                               probs = Quantile, 
                               na.rm = TRUE)) 
)

## Join the quantile informaiton with the 
## matching rows of the data frame. This is 
## join uses the names with common columns 
## as the keys. 
BikeShare2 <- inner_join(BikeShare, quantByPer)

## Filter for the rows we want and remove the 
## no longer needed column.
BikeShare2 <- BikeShare2 %>% 
  filter(cnt > Quant) 
BikeShare2[, "Quant"] <- NULL