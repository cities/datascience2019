# GGPlot R
gapminder <- read.csv("data/gapminder_data.csv")
str(gapminder)

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5, color=as.numeric(gapminder$continent)) + 
  scale_x_log10() +
  geom_smooth(method="lm")

ggplot(data = gapminder, mapping = aes(x=year, y=lifeExp, by=country, color=continent)) +
  geom_line()

gapminder_continent <- aggregate(lifeExp ~ continent + year, data = gapminder,
                                 mean)
ggplot(data = gapminder_continent, mapping = aes(x = year, y = lifeExp, color=continent)) +
  geom_line() + facet_wrap( ~ continent)

