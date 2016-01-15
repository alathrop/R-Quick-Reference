# Visualization quick reference

require(ggplot2)

# Multiple plots using lapply
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