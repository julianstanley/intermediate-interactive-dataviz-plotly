library(plotly)
library(dplyr)
library(crosstalk)
library(tidyverse)
library(purrr)

# R package downloads
monthly_logs <- cranlogs::cran_downloads(package = c("ggvis", "highcharter", "plotly", "rbokeh", "ggvis"),
                                         from = "2014-01-01", to = "2020-01-01")
monthly_logs_clean <- monthly_logs %>%
  mutate(month = format(date, "%m"), year = format(date, "%Y")) %>%
  group_by(month, year, package) %>%
  summarise(total = sum(count)) %>%
  unite(month_year, c("month", "year"))

# monthly_logs_clean %>%
#   split(f = .$package) %>%
#   accumulate(., ~bind_rows(.x, .y)) %>%
#   bind_rows(.id = "frame")

# This plot isn't quite right because I couldn't get the cumulative
# sum of downloads, just the static downloads (and the processed dataset
# isn't provided. Oh well)
dplyr::glimpse(monthly_logs_clean)

shared_logs <- monthly_logs_clean %>%
  SharedData$new(key = ~package)

shared_logs %>%
  plot_ly(x = ~month_year, y = ~total, color = ~package) %>%
  add_lines() %>%
  highlight()

# Launches over time
space_launches <- read.csv("space/launches.csv")
dplyr::glimpse(space_launches)

# Basic: Launches by year
space_launches %>%
  count(launch_year) %>%
  plot_ly(x = ~launch_year, y = ~n) %>%
  add_lines(fill = "tozeroy") %>%
  layout(xaxis = list(title = "Year"),
         yaxis = list(title = "Launches"))

# Barchart version
space_launches %>%
  count(launch_year) %>%
  plot_ly(x = ~launch_year, y = ~n) %>%
  add_bars() %>%
  layout(xaxis = list(title = "Year"),
         yaxis = list(title = "Launches"))

# table of launches by year, only by state agencies
state_launches <- space_launches %>%
  filter(agency_type == "state") %>%
  count(launch_year, state_code)

# create a ShareData object for plotting
shared_launches <- state_launches %>% SharedData$new(key = ~state_code)

# Create a line chart for launches by state, with highlighting
state_plot <- shared_launches %>%
  plot_ly(x = ~launch_year, y = ~n, color = ~state_code) %>%
  add_lines() %>%
  highlight()

# Compare private and state agencies
all_launches <- space_launches %>%
  count(launch_year, agency_type)

# See the two s-deiby-side!
shared_launches <- all_launches %>% SharedData$new(key = ~agency_type)

agencies_plot <- shared_launches %>%
  plot_ly(x = ~launch_year, y = ~n, color = ~agency_type) %>%
  add_lines() %>%
  highlight()


subplot(state_plot, agencies_plot)

# Cumulative plots
# Complete the state_launches data set
annual_launches <- state_launches %>%
  count(launch_year, state_code) %>%
  complete(state_code, launch_year, fill = list(n = 0))

# Create the cumulative data set
cumulative_launches <- annual_launches %>%
  split(f = .$state_code) %>%
  accumulate(., ~bind_rows(.x, .y)) %>%
  bind_rows(.id = "frame")

# Create the cumulative animation
cumulative_launches %>%
  plot_ly(x = ~launch_year, y = ~n, color = ~state_code) %>%
  add_lines(frame = ~frame, ids = ~state_code)

# Linked views
shared_launches <- SharedData$new(all_launches, key = ~agency_type)

line_chart <- shared_launches %>%
  plot_ly(x = ~launch_year, y = ~n, color = ~agency_type) %>%
  add_lines() %>%
  hide_legend()

bar_chart <- shared_launches %>%
  plot_ly(y = ~fct_reorder(agency_type, n), x = ~n, color = ~agency_type) %>%
  count(agency_type) %>%
  add_bars() %>%
  layout(barmode = "overlay", yaxis = list(title = "")) %>%
  hide_legend

subplot(bar_chart, line_chart) %>%
  hide_legend() %>%
  highlight()

bscols(
  widths = c(4, NA),
  line_chart %>% highlight(),
  bar_chart %>% highlight()
)

# Highlight args: on = plotly_click, hover, or selected.
# off = plotly_doubleclick, deselect, or relayout
# persistent, dynamic, selectize can be T/F
# color can also be specified

# Selector widgets
bscols(widths = c(2, NA),
       list(filter_checkbox(id = "agency",
                            label = "Agency type",
                            shared_launches,
                            ~agency_type),
            filter_select(id = "agency2",
                          label = "Agency type dropdown",
                          shared_launches,
                          ~agency_type)),
       line_chart %>% highlight(on = "plotly_selected", off = "plotly_deselect"))


