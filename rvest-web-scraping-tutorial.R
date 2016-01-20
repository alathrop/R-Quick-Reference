# rvest package for web scraping

library("devtools")
install_github("hadley/rvest")

library(rvest)

# lego movie demo
#####
lego_movie <- read_html("http://www.imdb.com/title/tt1490017/")

rating <- lego_movie %>% 
  html_nodes("strong span") %>%
  html_text() %>%
  as.numeric()
rating
#> [1] 7.8

cast <- lego_movie %>%
  html_nodes("#titleCast .itemprop span") %>%
  html_text()
cast
#>  [1] "Will Arnett"     "Elizabeth Banks" "Craig Berry"    
#>  [4] "Alison Brie"     "David Burrows"   "Anthony Daniels"
#>  [7] "Charlie Day"     "Amanda Farinos"  "Keith Ferguson" 
#> [10] "Will Ferrell"    "Will Forte"      "Dave Franco"    
#> [13] "Morgan Freeman"  "Todd Hansen"     "Jonah Hill"

poster <- lego_movie %>%
  html_nodes("#img_primary img") %>%
  html_attr("src")
poster
#> [1] "http://ia.media-imdb.com/images/M/MV5BMTg4MDk1ODExN15BMl5BanBnXkFtZTgwNzIyNjg3MDE@._V1_SX214_AL_.jpg"
#####

# Zillow demo
#####
# Inspired by https://github.com/notesofdabbler
library(rvest)
library(tidyr)

url <- "http://www.zillow.com/homes/for_sale/Greenwood-IN/fsba,fsbo,fore,cmsn_lt/house_type/52333_rid/39.638414,-86.011362,39.550714,-86.179419_rect/12_zm/0_mmm/"

url <- "http://www.zillow.com/homes/for_sale/Castle-Rock-CO/fsba,fsbo,fore,cmsn_lt/house_type/23984_rid/globalrelevance_sort/39.571822,-104.39724,39.123135,-105.289879_rect/10_zm/0_mmm/"


houses <- read_html(url) %>%
  html_nodes("article")

str(houses)
houses[[2]]

z_id <- houses %>% html_attr("id")

address <- houses %>%
  html_node(".property-address a") %>%
  html_attr("href") %>%
  strsplit("/") %>%
  pluck(3, character(1))

area <- function(x) {
  val <- as.numeric(gsub("[^0-9.]+", "", x))
  as.integer(val * ifelse(grepl("ac", x), 43560, 1))
}
sqft <- houses %>%
  html_node(".property-lot") %>%
  html_text() %>%
  area()

year_build <- houses %>%
  html_node(".property-year") %>%
  html_text() %>%
  gsub("Built in ", "", .) %>%
  as.integer()

price <- houses %>%
  html_node(".price-large") %>%
  html_text() %>%
  tidyr::extract_numeric()

params <- houses %>%
  html_node(".property-data") %>%
  html_text() %>%
  strsplit(", ")
beds <- params %>%
  pluck(1, character(1)) %>%
  extract_numeric()
baths <- params %>%
  pluck(2, character(1)) %>%
  extract_numeric()
house_area <- params %>%
  pluck(3, character(1)) %>%
  area()
#####