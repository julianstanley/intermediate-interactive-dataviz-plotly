library(plotly)
library(dplyr)

# Load US economy dataset
us_economy <- read.csv("../Chapter-1/economic-indicators/state_economic_data.csv")
dplyr::glimpse(economy)

# Animate a bubble chart of house_price against gdp over region
us_economy %>%
  filter(year == 2017) %>%
  plot_ly(x = ~gdp, y = ~house_price) %>%
  add_markers(size = ~population, color = ~region,
              frame = ~region, ids = ~state,
              marker = list(sizemode = "diameter")) %>%
  animation_opts(frame = 2000, transition = 300, easing = "elastic") %>%
  animation_slider(
    currentvalue = list(
      prefix = "",
      font = list(color="red")
    )
  ) %>%
  layout(
    xaxis = list(title = "Real GDP (millions USD)"),
    yaxis = list(title = "Housing price index")
  )

# Polish the axis titles and log-transform the x-axis of the original
# bubble chart animation
us_economy %>%
  plot_ly(x = ~gdp, y = ~house_price,
          hoverinfo = "text", text = ~state) %>%
  add_markers(
    size = ~population, color = ~region,
    frame = ~year, ids = ~state,
    marker = list(sizemode = "diameter", sizeref = 3)
  ) %>%
  layout(
    xaxis = list(title = "Real GDP (millions USD)", type = "log"),
    yaxis = list(title = "Housing price index")
  )

# Adding layers
# Add the year as background text and remove the slider
us_economy %>%
  plot_ly(x = ~gdp, y = ~house_price, hoverinfo = "text", text = ~state) %>%
  add_text(x = 200000, y = 450, text = ~year, frame = ~year,
           textfont = list(color = toRGB("gray80"), size = 150),
           ids = ~1) %>%
  add_markers(size = ~population, color = ~region,
              frame = ~year, ids = ~state,
              marker = list(sizemode = "diameter", sizeref = 3)) %>%
  layout(xaxis = list(title = "Real GDP (millions USD)", type = "log"),
         yaxis = list(title = "Housing price index")) %>%
  animation_slider(hide = TRUE)


# extract the 1997 data
us1997 <- us_economy %>%
  filter(year == 1997)

# create an animated scatterplot with baseline from 1997
us_economy %>%
  plot_ly(x = ~gdp, y = ~house_price) %>%
  add_markers(data = us1997, marker = list(color = toRGB("gray60"), opacity = 0.5)) %>%
  add_markers(frame = ~year, ids = ~state, data = us_economy, showlegend = FALSE, alpha = 0.5) %>%
  layout(xaxis = list(type = "log"))


