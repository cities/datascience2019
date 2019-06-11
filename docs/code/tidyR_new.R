# tidyr gather and spread
library(tidyverse)

bikenet <- read_csv("data/bikenet-change.csv")
str(bikenet)
head(bikenet)

# gather facility columns into single year variable
bikenet_long <- bikenet %>% 
  gather(key="year", value="facility", 
         facility2008:facility2013, na.rm = T) %>%
  mutate(year = str_sub(year, start= -4), quad = str_sub(fdpre, end = 2))

head(bikenet_long)
str(bikenet_long)

bikenet_long %>% filter(bikeid == 139730) # peek at SW Broadway
?filter
fac_lengths <- bikenet_long %>% 
  filter(facility %in% c("BKE-LANE", "BKE-BLVD", "BKE-BUFF", "BKE-TRAK",
                         "PTH-REMU")) %>%
  group_by(year, facility) %>%
  summarise(metres = sum(length_m)) %>%
  mutate(miles = metres / 1609)
head(fac_lengths)

p <- ggplot(fac_lengths, aes(year, miles, group = facility, 
))
p + geom_line()
p + geom_line(size = 1, color = "blue") + facet_wrap( ~ facility)
p + geom_line(size = 1) + scale_y_log10()

p <- ggplot(fac_lengths, aes(year, miles, group = facility))                    
p + geom_line(size = 1, color = "blue") + facet_wrap( ~ quad)


fac_length <- aggregate(length_m ~ facility + year, data=bikenet_long, sum)
head(fac_length)
fac_length <- subset(fac_length, !is.na(facility))

str(fac_length)

p <- ggplot(data=fac_length, aes(year, length_m, group=factor(facility), 
                                 color=(factor(facility))))
p + geom_bar()



?gather
