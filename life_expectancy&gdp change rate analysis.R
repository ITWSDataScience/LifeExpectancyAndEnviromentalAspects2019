library(tidyr)
library(readr)
library(dplyr)
library(ggplot2)


data <- read_csv("Life Expectancy Data.csv") %>% 
  select(
    country = Country, 
    stat = Status, 
    year = Year, 
    gdp = GDP, 
    life_exp = "Life expectancy"
  )

data.delta <- data %>% 
  drop_na(life_exp, gdp) %>%
  group_by(country) %>%
  mutate(
    inc_life_exp = (lag(life_exp, default = life_exp[1]) / life_exp - 1) * 100,
    inc_gdp = (lag(gdp, default = gdp[1]) / gdp - 1) * 100,
    rate_life_gdp = inc_life_exp / inc_gdp
  ) %>% 
  filter(year != 2015, inc_gdp < 100)

ggplot(
  filter(
    data.delta, 
    country == "United States of America" | 
    country == "Russian Federation" | 
    country == "China" | 
    country == "Zimbabwe"
  ), 
  aes(x = year, y = inc_life_exp, col = country)
  ) +
  geom_point() + 
  geom_line(size = 0.8) + 
  scale_x_continuous(breaks = 2000:2014) +
  labs(
    title = "Life Expectancy Change Over Year",
    x = "Year",
    y = "Life Expectency Rate of Change %"
  )

ggplot(
    filter(
      data.delta, 
      country == "United States of America" | 
        country == "Russian Federation" | 
        country == "China" | 
        country == "Zimbabwe"
    ), 
    aes(x = year, y = inc_gdp, col = country)
  ) +
  geom_point() + 
  geom_line(size = 0.8) + 
  scale_x_continuous(breaks = 2000:2014) +
  labs(
    title = "GDP Change Over Year",
    x = "Year",
    y = "GDP Rate of Change %"
  )
