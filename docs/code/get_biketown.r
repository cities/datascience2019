# Load biketown data by URL
# https://www.r-bloggers.com/getting-data-from-an-online-source/

if (!require("pacman")) {install.packages("pacman"); library(pacman)}
pacman::p_load(tidyverse)
pacman::p_load(data.table)
pacman::p_load(RCurl)

lubridate::mdy("7/1/2016")

get_biketown_urls <- 
  function(start_month=7, start_year=2016, end_month=7, end_year=2016, 
           base_url="https://s3.amazonaws.com/biketown-tripdata-public/") {
    # set day to first of month
    start_date = paste(start_month, "01", start_year, sep="-")
    end_date = paste(end_month, "01", end_year, sep="-")
    date_range = seq(lubridate::mdy(start_date), lubridate::mdy(end_date), 
        by='months')
    urls = lapply(date_range, function(x) {
      paste0(base_url, lubridate::year(x), "_", lubridate::month(x), ".csv")}
      )
    return(urls)
  }

# 
urls <- get_biketown_urls()
month_by_month <- lapply(urls, print)
month_by_month <- lapply(urls, data.table::fread)
month_by_month <- lapply(urls, function(x) { 
  read.csv(textConnection(getURL(x)), header=T)})
dat <- month_by_month[[1]]
summary(dat)
# just grab a month for now
# todo: function-ize this
base_url = "https://s3.amazonaws.com/biketown-tripdata-public/"
month = "2016_07"
myfile <- getURL(paste0(base_url, month, ".csv"))
mydat <- read.csv(textConnection(myfile), header=T)
head(mydat)
summary(mydat)
write.csv(mydat, paste0("data/biketown/", month, ".csv"))

# Playing with lapply
f <- function(x) {data.frame(a=sample(letters, 10, rep=T),
                             b=rnorm(10), c=rnorm(10))}
lodf <- lapply(seq(1, 3), f)
df <- dplyr::bind_rows(lodf)
