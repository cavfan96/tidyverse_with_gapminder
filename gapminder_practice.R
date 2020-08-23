# tidyverse

library(gapminder)
library(dplyr)
gapminder

## Filter Verb
# filters show a subset of the data

# filter for just the year 2007 using the pipe %>%
# piping simply is creating a df on the fly without
# changing your original data frame unless you assign it
# as a new dataframe
gapminder %>%
  filter(year == 2007)

# filter for the US - need quotes around text
gapminder %>%
  filter(country == "United States")

# filter by two conditions
gapminder %>%
  filter(country == "United States", year == 2007)

## Arrange Verb

# Sorts the data 
gapminder %>%
  arrange(gdpPercap)

gapminder %>%
  arrange(desc(gdpPercap))

# combining verbs to find richest countries in 2007 descending order
gapminder %>%
  filter(year == 2007) %>%
  arrange(desc(gdpPercap))

## Mutate Verb

# changes the data value in a new value, doesn't effect the original data

gapminder %>%
  mutate(pop = pop / 1000000)

# add a variable

gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  arrange(desc(gdp))

# Create, filter, and sort the data by combining verbs
gapminder %>%
  mutate(gdp = gdpPercap * pop) %>%
  filter(year == 2007) %>%
  arrange(desc(gdp))

## Data Visualization
## Data, Aesthetic, Layer

library(ggplot2)

# create a new dataframe for 2007
gapminder_2007 <- gapminder %>%
  filter(year == 2007)

gapminder_2007

# ggplots start with the df and then an aesthetic
# then you add a layer (scatterplot, bar chart, etc.)
ggplot(gapminder_2007, aes(x = gdpPercap,
                           y = lifeExp)) +
  geom_point()

# use a logscale if there's several orders of magnitude in one section
# of the x-axis or y-axis
ggplot(gapminder_2007, aes(x = gdpPercap,
                           y = lifeExp)) +
  geom_point() +
  scale_x_log10()

# group the data by continent with color
ggplot(gapminder_2007, aes(x = gdpPercap,
                           y = lifeExp, color = continent)) +
  geom_point() +
  scale_x_log10()

# group the data by continent and size of population as aesthetics #3 and #4
# on top of aesthetics #1 (x) and #2 (y)
ggplot(gapminder_2007, aes(x = gdpPercap,
                           y = lifeExp, 
                           color = continent,
                           size = pop)) +
  geom_point() +
  scale_x_log10()

## Faceting

# Faceting explores categorical variables into subplots.
ggplot(gapminder_2007, aes(x = gdpPercap,
                           y = lifeExp)) +
  geom_point() +
  scale_x_log10() +
  facet_wrap(~ continent)

## Summarize

# finding powerful data points using summarize and its 
# functionality from the dplyr package
# mean, min, max, sum and median are available functions
# you can do as many of these functions as you wish

gapminder %>%
  summarize(meanLifeExp = mean(lifeExp))

gapminder %>%
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp))

gapminder %>%
  filter(year == 2007) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))

## group_By

# group_by replaces filter and does the summarize by a "group"
gapminder %>%
  group_by(year) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))

# group_by is now done after filtering and does the summarize by a "group"
gapminder %>%
  filter(year == 2007) %>%
  group_by(continent) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))

# group_by is now done after filtering and does the summarize by a "group"
gapminder %>%
  group_by(year, continent) %>%
  summarize(meanLifeExp = mean(lifeExp),
            totalPop = sum(pop))

### Dynamic viz
by_year <- gapminder %>%
  group_by(year) %>%
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))

# plot these summaries now
ggplot(by_year, aes(x = year, y = totalPop)) +
  geom_point()

# add y = 0 to the graph
ggplot(by_year, aes(x = year, y = totalPop)) +
  geom_point() +
  expand_limits(y = 0)

# group by year, continent into new data frame
by_year_continent <- gapminder %>%
  group_by(year, continent) %>%
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))

ggplot(by_year_continent, aes(x = year,
                              y = totalPop,
                              color = continent)) +
  geom_point() +
  expand_limits(y = 0)

### Line Plots

ggplot(by_year_continent, aes(x = year,
                              y = meanLifeExp,
                              color = continent)) +
  geom_line() +
  expand_limits(y = 0)

### Bar Plots

# In a bar plot, the categorical goes on the x-axis
# and the height of the bar is determined by the y-axis quantitative
# variable
by_continent <- gapminder %>%
  group_by(continent) %>%
  summarize(totalPop = sum(pop),
            meanLifeExp = mean(lifeExp))

ggplot(by_continent, aes(x = continent,
                         y = meanLifeExp)) +
  geom_col()

### Histogram

# Investigate one variable distribution at a time in "bins"
# Uses only one axis in the aesthetic
ggplot(gapminder_2007, aes(x = lifeExp)) +
  geom_histogram()

# change the histogram bin width
# you can also change the # of bins, using bins = <insert #>
ggplot(gapminder_2007, aes(x = lifeExp)) +
  geom_histogram(binwidth = 5)

### Box Plots

# Shows the importance of a variable distribution for comparison
# box plots have 2 aesthetics where x = categorical and y = measurable
# variable you want to compare
ggplot(gapminder_2007, aes(x = continent, y = lifeExp)) +
  geom_boxplot()

# add a label using labs and title
ggplot(gapminder_2007, aes(x = lifeExp)) +
  geom_histogram(binwidth = 5) +
  labs(
    title = paste(
      "Life Expectancy Across Continents"
    )
  )

# done anotehr way
ggplot(gapminder_2007, aes(x = lifeExp)) +
  geom_histogram(binwidth = 5) +
  labs(title = "Life Expectancy Across Continents")

# using ggtitle
ggplot(gapminder_2007, aes(x = lifeExp)) +
  geom_histogram(binwidth = 5) +
  ggtitle("Life Expectancy Across Continents")

