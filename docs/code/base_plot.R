# Plot Biketown data 2018
library(tidyverse)

setwd("data/biketown")
monthly_data <- 
  list.files() %>%
  lapply(read_csv)

setwd("../../")

biketown_2018 <- 
  dplyr::bind_rows(monthly_data)

str(biketown_2018)

biketown_2018$month <- 
  lubridate::mdy(biketown_2018$StartDate) %>% 
  lubridate::month(label = T, abbr = T)
biketown_2018$hour <- 
  lubridate::hms(biketown_2018$StartTime) %>% 
  lubridate::hour()

# Base

freq_by_month <- table(biketown_2018$month)
freq_by_hour <- table(biketown_2018$hour)
freq_by_bike <- table(biketown_2018$BikeName)
freq_by_station <- table(biketown_2018$StartHub)

barplot(freq_by_month)
barplot(freq_by_hour)

dotchart(sort(freq_by_station, decreasing = T)[1:25])
dotchart(sort(freq_by_station)[(length(freq_by_station)-25):167])

hist(station_starts_annual, 
     breaks = seq(0, max(station_starts_annual) + 250, 250))

hist(freq_by_bike)
abline(v = median(freq_by_bike), col="red")

stations_by_month <- aggregate(RouteID ~ StartHub + month,
                               data = biketown_2018, length)
colnames(stations_by_month)[3] <- "starts"

top_stations <- as.data.frame(sort(freq_by_station, decreasing = T)[1:9])

top9 <- subset(stations_by_month, StartHub %in% top_stations$Var1)
top9$StartHub <- factor(top9$StartHub)

ggplot(data = top9, mapping = aes(x=month, y=starts, group = StartHub, 
                                  color=StartHub)) +
  geom_line()

ggplot(data = top9, mapping = aes(x = month, y = starts, group = StartHub)) +
  geom_line() + facet_wrap( ~ StartHub)

ggplot(data = top9, mapping = aes(x = month, y = starts)) +
  geom_point() + facet_wrap( ~ StartHub)

str(top9)
