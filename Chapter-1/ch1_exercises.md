

```r
library(plotly)
library(dplyr)

# Load data
happy <- read.csv("./world-happiness/2015.csv")
population <- read.csv("./world-happiness/populations.csv")
dplyr::glimpse(happy)
```

```
## Rows: 158
## Columns: 12
## $ Country                       <fct> Switzerland, Iceland, Denmark, Norway, Canada, Finland, Netherlands, Sweden, New Zealand, Au…
## $ Region                        <fct> Western Europe, Western Europe, Western Europe, Western Europe, North America, Western Europ…
## $ Happiness.Rank                <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 2…
## $ Happiness.Score               <dbl> 7.587, 7.561, 7.527, 7.522, 7.427, 7.406, 7.378, 7.364, 7.286, 7.284, 7.278, 7.226, 7.200, 7…
## $ Standard.Error                <dbl> 0.03411, 0.04884, 0.03328, 0.03880, 0.03553, 0.03140, 0.02799, 0.03157, 0.03371, 0.04083, 0.…
## $ Economy..GDP.per.Capita.      <dbl> 1.39651, 1.30232, 1.32548, 1.45900, 1.32629, 1.29025, 1.32944, 1.33171, 1.25018, 1.33358, 1.…
## $ Family                        <dbl> 1.34951, 1.40223, 1.36058, 1.33095, 1.32261, 1.31826, 1.28017, 1.28907, 1.31967, 1.30923, 1.…
## $ Health..Life.Expectancy.      <dbl> 0.94143, 0.94784, 0.87464, 0.88521, 0.90563, 0.88911, 0.89284, 0.91087, 0.90837, 0.93156, 0.…
## $ Freedom                       <dbl> 0.66557, 0.62877, 0.64938, 0.66973, 0.63297, 0.64169, 0.61576, 0.65980, 0.63938, 0.65124, 0.…
## $ Trust..Government.Corruption. <dbl> 0.41978, 0.14145, 0.48357, 0.36503, 0.32957, 0.41372, 0.31814, 0.43844, 0.42922, 0.35637, 0.…
## $ Generosity                    <dbl> 0.29678, 0.43630, 0.34139, 0.34699, 0.45811, 0.23351, 0.47610, 0.36262, 0.47501, 0.43562, 0.…
## $ Dystopia.Residual             <dbl> 2.51738, 2.70201, 2.49204, 2.46531, 2.45176, 2.61955, 2.46570, 2.37119, 2.26425, 2.26646, 3.…
```

```r
dplyr::glimpse(population)
```

```
## Rows: 285
## Columns: 2
## $ Country    <fct> "WORLD", "More developed regions", "Less developed regions", "Least developed countries", "Less developed regio…
## $ population <dbl> 7794798.729, 1273304.261, 6521494.468, 1057438.163, 5464056.305, 5050207.589, 533143.398, 72076.098, 1263092.93…
```

```r
happy <- merge(happy, population, by = "Country")
dplyr::glimpse(happy)
```

```
## Rows: 135
## Columns: 13
## $ Country                       <fct> Afghanistan, Albania, Algeria, Angola, Argentina, Armenia, Australia, Austria, Azerbaijan, B…
## $ Region                        <fct> Southern Asia, Central and Eastern Europe, Middle East and Northern Africa, Sub-Saharan Afri…
## $ Happiness.Rank                <int> 153, 95, 68, 137, 30, 127, 10, 13, 80, 49, 109, 59, 19, 155, 79, 96, 128, 16, 134, 152, 157,…
## $ Happiness.Score               <dbl> 3.575, 4.959, 5.605, 4.033, 6.574, 4.350, 7.284, 7.200, 5.212, 5.960, 4.694, 5.813, 6.937, 3…
## $ Standard.Error                <dbl> 0.03084, 0.05013, 0.05099, 0.04758, 0.04612, 0.04763, 0.04083, 0.03751, 0.03363, 0.05412, 0.…
## $ Economy..GDP.per.Capita.      <dbl> 0.31982, 0.87867, 0.93929, 0.75778, 1.05351, 0.76821, 1.33358, 1.33723, 1.02389, 1.32376, 0.…
## $ Family                        <dbl> 0.30285, 0.80434, 1.07772, 0.86040, 1.24823, 0.77711, 1.30923, 1.29704, 0.93793, 1.21624, 0.…
## $ Health..Life.Expectancy.      <dbl> 0.30335, 0.81325, 0.61766, 0.16683, 0.78723, 0.72990, 0.93156, 0.89042, 0.64045, 0.74716, 0.…
## $ Freedom                       <dbl> 0.23414, 0.35733, 0.28579, 0.10384, 0.44974, 0.19847, 0.65124, 0.62433, 0.37030, 0.45492, 0.…
## $ Trust..Government.Corruption. <dbl> 0.09719, 0.06413, 0.17383, 0.07122, 0.08484, 0.03900, 0.35637, 0.18676, 0.16065, 0.30600, 0.…
## $ Generosity                    <dbl> 0.36510, 0.14272, 0.07822, 0.12344, 0.11451, 0.07855, 0.43562, 0.33088, 0.07799, 0.17362, 0.…
## $ Dystopia.Residual             <dbl> 1.95210, 1.89894, 2.43209, 1.94939, 2.83600, 1.75873, 2.26646, 2.53320, 2.00073, 1.73797, 2.…
## $ population                    <dbl> 38928.341, 2877.800, 43851.043, 32866.268, 45195.777, 2963.234, 25499.881, 9006.400, 10139.1…
```

```r
# Color points based on income
happy %>%
  plot_ly(x = ~Health..Life.Expectancy., y = ~Happiness.Score) %>%
  add_markers(color = ~Economy..GDP.per.Capita.)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

```r
# Add a categorical variable to separate Economy into four groups
happy$income_cat <- cut(happy$Economy..GDP.per.Capita., 4)

# Plot based on that economic classification
happy %>%
  plot_ly(x = ~Health..Life.Expectancy., y = ~Happiness.Score) %>%
  add_markers(symbol = ~income_cat)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png)

```r
# Can also change size based on population
happy %>%
  plot_ly(x = ~Health..Life.Expectancy., y = ~Happiness.Score) %>%
  add_markers(size = ~population)
```

```
## Warning: `line.width` does not currently support multiple values.
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-3.png)

```r
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
```

```
## Warning: `line.width` does not currently support multiple values.
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-4.png)

