## Compute the residuals
library(dplyr)
inFrame <-  mutate(inFrame, resids = predicted - cnt)
