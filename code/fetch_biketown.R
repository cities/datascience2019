# Load public biketown trip data by date range
# see: https://www.biketownpdx.com/system-data

# pacman allows checking for and loading packages in short line of code
if (!require("pacman")) {install.packages("pacman"); library(pacman)}
pacman::p_load("tidyverse")

get_data <- function(start, end, 
                     base_url="https://s3.amazonaws.com/biketown-tripdata-public/",
                     outdir="data/biketown",
                     ) {
  # make_url function availavble only within get_data function
  make_url <- function(date, base_url) {
    paste0(base_url, format(date, "%Y_%m"), ".csv")
  }
  # parse date range
  start_date <- start %>% lubridate::myd(truncated=2)
  end_date <- end %>% lubridate::myd(truncated=2)
  date_range <- seq(start_date, end_date, by='months')
  
  # lapply(a, b) just applies function b to sequence a  
  urls <- lapply(date_range, make_url, base_url = base_url)
  
  # for loops can be easier to write but are slower for long loops
  for (u in urls) {
    download.file(u, destfile = paste0(outdir, str_sub(u,-11))) 
    
  }
}

### Manual Run ###
# Params
start = "8/2018"
end = "8/2018"
outdir = "data/biketown/"
get_data(start, end, 
         outdir=outdir)

# Stitch monthly files together for analysis
biketown_all <- paste0(outdir, list.files(outdir)) %>%
  lapply(read.csv, stringsAsFactors = F) %>%
  bind_rows() 

# Or, write out stitched file
write.csv(biketown_all, "biketown_all.csv")
