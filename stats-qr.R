## Compute the residuals
library(dplyr)
inFrame <-  mutate(inFrame, resids = predicted - cnt)

#####
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

#####