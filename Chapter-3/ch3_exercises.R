library(plotly)
library(dplyr)
library(crosstalk)

# Load US economy dataset
us_economy <- read.csv("../Chapter-1/economic-indicators/state_economic_data.csv")
dplyr::glimpse(us_economy)

# Create a smaller dataset
us2017 <- us_economy %>%
  filter(year == 2017)

# Put into a SharedData object for crosstalk
shared_us <- SharedData$new(us2017)

# Create a scatterplot of house_price vs. home_owners
p1 <- shared_us %>%
  plot_ly(x = ~home_owners, y = ~house_price) %>%
  add_markers()

# Scatterplot of house_price vs. employment rate
p2 <- shared_us %>%
  plot_ly(x = ~employment/population, y = ~house_price) %>%
  add_markers()

# Combine the plots
subplot(p1, p2, titleX = TRUE, shareY = TRUE) %>%
  hide_legend() %>%
  highlight(on = "plotly_selected")

# Practice
shared_data <- us_economy %>%
  filter(year == 1997) %>%
  SharedData$new(key = ~region)

# Create a scatterplot of house_price vs. home_owners
p1 <- shared_data %>%
  plot_ly(hoverinfo = "text", text = ~region) %>%
  group_by(region) %>%
  summarize(avg.housep = mean(house_price, na.rm = TRUE)) %>%
  add_markers(x = ~avg.housep, y = ~region)

# Scatterplot of house_price vs. employment rate
p2 <- shared_data %>%
  plot_ly(x = ~house_price, y = ~home_owners, text = ~state) %>%
  add_markers()

subplot(p1, p2) %>% hide_legend()

# Dotplot example (in course)

# Create a shared data object keyed by region
shared_region <- SharedData$new(us_economy, key = ~region)

# Create a dotplot of avg house_price by region in 2017
dp_chart <- shared_region %>%
  plot_ly() %>%
  filter(year == 2017) %>%
  group_by(region) %>%
  summarize(avg.hpi = mean(house_price, na.rm = TRUE)) %>%
  add_markers(x = ~avg.hpi, y = ~region)

# Code for time series plot
ts_chart <- shared_region %>%
  plot_ly(x = ~year, y = ~house_price, hoverinfo = "text", text = ~state) %>%
  group_by(state) %>%
  add_lines()

subplot(dp_chart, ts_chart)

# Create a shared data object keyed by division
shared_div <- SharedData$new(us2017, key = ~division)

# Create a bar chart for division
bc <- shared_div %>%
  plot_ly() %>%
  count(division) %>%
  add_bars(x = ~division, y = ~n) %>%
  layout(barmode = "overlay")

# Bubble chart
bubble <- shared_div %>%
  plot_ly(x = ~home_owners, y = ~house_price, hoverinfo = "text", text = ~state) %>%
  add_markers(size = ~population, marker = list(sizemode = "diameter", sizeref=3))

# Link bc and bubble
subplot(bc, bubble) %>% hide_legend()

## Persistent selection
subplot(bc, bubble) %>% hide_legend() %>%
  highlight(persistent = TRUE, dynamic = TRUE)

## Drop-down selection
us_economy %>%
  SharedData$new(key = ~state, group = "Select a country") %>%
  plot_ly(x = ~year, y = ~house_price, alpha = 0.5,
          hoverinfo = "text", text = ~state) %>%
  group_by(state) %>%
  add_lines() %>%
  highlight(selectize = TRUE)

# Create a shared data object keyed by region
region_data <- SharedData$new(us2017, key = ~region, group = "Select a region")

# Enable indirect selection by region
region_data %>%
  plot_ly(x = ~home_owners, y = ~house_price, hoverinfo = "text", text = ~state) %>%
  add_markers(size = ~population, marker = list(sizemode = "diameter")) %>%
  highlight(selectize = TRUE)


# Making a version with selector widgets
bscols(widths = c(2, 5, 5),
       list(
  filter_slider(id  = "house", label = "House Price",
                       sharedData = shared_div, column = ~house_price),
       filter_select(id = "division", label = "Region",
                     sharedData = shared_div, group = ~division)),
       bubble %>% layout(yaxis = list(range = c(0, 900)),
                         xaxis = list(range = c(0, 100))))

# More sliders! (This one works much better)
shared_us <- SharedData$new(us2017)
p17 <- shared_us %>%
  plot_ly(x = ~home_owners, y = ~house_price,
          color = ~region, height = 400) %>%
  add_markers() %>%
  layout(xaxis = list(title = "Home ownership (%)"),
         yaxis = list(title = "HPI"))

# add a slider filter for each axis below the scatterplot
bscols(
  list(p17 %>% layout(yaxis = list(range = c(0, 900)),
                      xaxis = list(range = c(0, 100))),
       filter_slider(id = "price",  label = "HPI",  sharedData = shared_us,  column = ~house_price),
       filter_slider(id = "owners",  label = "Home ownership (%)",  sharedData = shared_us, column = ~home_owners)
  )
)
