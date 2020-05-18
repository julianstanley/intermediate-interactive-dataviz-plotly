library(plotly)
library(dplyr)

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
                        "<br>Population: ", population))%>%
  add_markers(color = ~Region, size = ~Economy..GDP.per.Capita.)
