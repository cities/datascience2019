# Load biketown data by URL
# https://www.r-bloggers.com/getting-data-from-an-online-source/

if (!require("pacman")) {install.packages("pacman"); library(pacman)}
pacman::p_load(tidyverse)
#pacman::p_load(data.table)
#pacman::p_load(RCurl)

#month(lubridate::mdy("7/1/2016"))
#lubridate::myd("7/2016", truncated=2) %>% format("%m")

base_url = "https://s3.amazonaws.com/biketown-tripdata-public/"
start_date <- "1/2018" %>% lubridate::myd(truncated=2)
end_date <- "12/2018" %>% lubridate::myd(truncated=2)

date_range <- seq(start_date, end_date, by='months')

make_url <- function(d) {
  paste0(base_url, format(d, "%Y_%m"), ".csv")
}

urls <- lapply(date_range, make_url)
for (u in urls) {
  download.file(u, destfile = paste0("data/biketown/", str_sub(u,-11,-1)))
}
      
?download.file
               
get_biketown_urls <- 
 function(first_month="7/2016", lat_month="6/2017", 
          base_url="https://s3.amazonaws.com/biketown-tripdata-public/") {
   # set day to first of month
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
               