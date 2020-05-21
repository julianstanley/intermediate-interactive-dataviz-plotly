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

space_launches %>%
  group_by(launch_year, state_code) %>%
  summarize(launches = n()) %>%
  SharedData$new(key = ~state_code) %>%
  plot_ly(x = ~launch_year, y = ~launches, color = ~state_code) %>%
  group_by(state_code) %>%
  add_lines()
