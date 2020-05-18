library(plotly)
library(dplyr)

# This dataset wasn't made available by the course, so I created my own, based
# on the UN data available from kaggle.

# Load data
happy <- read.csv("./world-happiness/2015.csv")
population <- read.csv("./world-happiness/populations.csv")
dplyr::glimpse(happy)
dplyr::glimpse(population)
happy <- merge(happy, population, by = "Country")
dplyr::glimpse(happy)

# Color points based on income
happy %>%
  plot_ly(x = ~Health..Life.Expectancy., y = ~Happiness.Score) %>%
  add_markers(color = ~Economy..GDP.per.Capita.)

# Add a categorical variable to separate Economy into four groups
happy$income_cat <- cut(happy$Economy..GDP.per.Capita., 4)

# Plot based on that economic classification
happy %>%
  plot_ly(x = ~Health..Life.Expectancy., y = ~Happiness.Score) %>%
  add_markers(symbol = ~income_cat)

# Can also change size based on population
happy %>%
  plot_ly(x = ~Health..Life.Expectancy., y = ~Happiness.Score) %>%
  add_markers(size = ~population)

# Add hover information, clean up
happy %>%
  plot_ly(x = ~Health..Life.Expectancy., y = ~Happiness.Score,
          hoverinfo = "text",
          text = ~paste("Country: ", Country,
                        "<br>Population: ", population)) %>%
  add_markers(size = ~population) %>%
  layout(
    xaxis = list(title = "Healthy life expectancy"),
    yaxis = list(title = "National happiness score")
  )

# Another pretty graph, this time colored by region and size by log(gdp)
happy %>%
  plot_ly(x = ~Health..Life.Expectancy., y = ~Happiness.Score,
          hoverinfo = "text",
          text = ~paste("Country: ", Country,
                        "<br>Population: ", population)) %>%
  add_markers(color = ~Region, size = ~Economy..GDP.per.Capita.)


# A separate plot, this time of generosity and happiness, with a proper tooltip
happy %>%
  plot_ly(x = ~Generosity, y = ~Happiness.Score,
            hoverinfo = "text",
            text = ~paste("Country: ", Country,
                          "<br> GDP per Capita: ", round(Economy..GDP.per.Capita., 2),
                          "<br> Happiness score: ", round(Happiness.Score, 2),
                          "<br> Happiness rank: ", Happiness.Rank,
                          "<br> Generosity: ", round(Generosity, 2),
                          "<br> Trust in government: ", round(Trust..Government.Corruption., 2))) %>%
  add_markers(symbol = ~income_cat,
              symbols = c("circle-open", "square-open", "star-open", "x-thin-open")) %>%
  layout(xaxis = list(title = "Generosity"),
         yaxis = list(title = "National Happiness Score"))

# Second dataset: US economy
us_economy <- read.csv("economic-indicators/state_economic_data.csv")
dplyr::glimpse(economy)

# Bubble plot!
us_economy %>%
  filter(year == 2017) %>%
  plot_ly(x = ~gdp, y = ~house_price,
          hoverinfo = "text", text = ~state) %>%
  add_markers(size = ~population, color = ~region,
              marker = list(sizemode = "diameter", sizeref = 2.5))


# Line chart
us_economy %>%
  filter(year >= 2000) %>%
  group_by(state) %>%
  plot_ly(x = ~year, y = ~house_price) %>%
  add_lines()

# Animated charts!
us_economy %>%
  plot_ly(x = ~home_owners, y = ~house_price,
          hoverinfo = "text", text = ~state) %>%
  add_markers(size = ~population, frame = ~year,
              color = ~region, ids = ~state) %>%
  layout(xaxis = list(autorange = "reversed"))






