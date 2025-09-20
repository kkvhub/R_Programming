# kaushlendra Kumar Verma
# MIS 545
# weeek03DemoETL.R
# Import CSV, assign data types, view summary statistics, manipulate tibbles,
# and generate histogram and box plots visualizations.


# Tidyverse packages ------------------------------------------------------

installed.packages()
library(tidyverse)


# Impoert CSV -------------------------------------------------------------
setwd("K:/MSBA_course/09_Data Mining_MIS 545 301-7W1/Week 3")
print(getwd())

# l for logical
# n for numerical 
# i for integer
# c for character
# f for factor
# D for date
# T for datetime
raceResults <- read_csv(file = "RaceResults.csv",
                        col_types = "fiififiiiifi",
                        col_names = TRUE)

view(raceResults)
str(raceResults)
# Tibbles -----------------------------------------------------------------
# we now have a tibble stored in memory called raceResults
# Displaying tibbles in the console

print(raceResults)

# Diaplay first 6 rows on the console
head(raceResults)

# Display the first 15 rows
head(raceResults, n = 15)

# Display structure of the tibble
str(raceResults)

# Display a summary of the tibble
summary(raceResults)


# dplyr package -----------------------------------------------------------

# summarizing features with summarize()
print(summarize(.data = raceResults, mean(iRating)))
print(summarize(.data = raceResults, median(Incidents)))
print(summarize(.data = raceResults, sd(iRating)))
print(summarize(.data = raceResults, IQR(Incidents)))
print(summarize(.data = raceResults, min(iRating)))
print(summarize(.data = raceResults, max(Incidents)))

# Using the built in non dplyr summary functions
mean(raceResults$iRating)
median(raceResults$Incidents)
sd(raceResults$iRating)
IQR(raceResults$Incidents)
min(raceResults$iRating)
max(raceResults$Incidents)

# selecting features with select ()
print(select(.data = raceResults,
             DriverName,
             FinPos,
             Region,
             iRating))
# save susetted feature into a new tibble
raceResultsSimplifies <- select(.data = raceResults,
                                DriverName,
                                FinPos,
                                Region,
                                iRating)

# Filtering records with filter()
print(filter(.data = raceResults,
             Region == "West"))

# Combining select and filter using "pipes" %>% 
print(raceResults %>% 
        select(DriverName,
               FinPos,
               Region,
               iRating) %>% 
        filter(Region == "West"))

# or 
print(filter(.data = raceResultsSimplifies,
             Region == "West"))
# Sorting results using arrange functions()
print(filter(.data = raceResultsSimplifies,
             Region == "West") %>% 
        arrange(iRating))

# sorting in descending order
print(filter(.data = raceResultsSimplifies,
             Region == "West") %>% 
        arrange(desc(iRating)))
# Grouping data using group_by() 
print(raceResults %>% 
        group_by(Region) %>% 
        summarize(AverageFinishPosition =mean(FinPos)) %>% 
        arrange(AverageFinishPosition),
      n = Inf)

# Calculating new features using mutate()
raceResults2 <- raceResults %>% 
  mutate(PositionGained = StartPos - FinPos,
         LogiRating = log(iRating))



# Converting data frames to tibble ----------------------------------------

# create a data frame
peopleDataFrame <- data.frame("Name" = c("Abe", "Ben", "Cal"),
                              "State" = as.factor(c("AZ", "NM", "AZ")),
                              "Age" = c(19L, 26L, 56L),
                              "weight" = c(146, 159.5, 188))
print(peopleDataFrame)

# Convert peopleDataFrame into tibble called peopleTibble
peopleTibble <- as_tibble(peopleDataFrame)
print(peopleTibble)


# Histogram Visualizations ------------------------------------------------

# Built-in Histogram
hist(raceResults$Incidents)
hist(raceResults$iRating)
hist(raceResults2$LogiRating)

# Histogram using ggplot visualization
# Data and Aesthetic layer:
histogramIncidents <- ggplot(data = raceResults,
                             aes(x = Incidents))

# Geometry layer :
histogramIncidents + geom_histogram(binwidth = 2)


# Adding a bin layer

histogramIncidents + geom_histogram(binwidth = 2, 
                                    color = "red")
# Adding a filcolorConverter
histogramIncidents + geom_histogram(binwidth = 2, 
                                    color = "red",
                                    fill = "pink",
                                    alpha = 0.5)

# theme layer : adding a title

histogramIncidents + geom_histogram(binwidth = 2, 
                                    color = "red",
                                    fill = "pink",
                                    alpha = 0.5) +
  ggtitle("Incidents Histogram")


# Box plot visualization --------------------------------------------------
# Data and Aesthetic layer:
boxplotiRating <- ggplot(data = raceResults,
                         aes (x = iRating))
# geometric layer:
boxplotiRating + geom_boxplot(color = "blue",
                              fill = "light pink")

# Segregate the boxplot by podium (TRUE) and non podium (False)
boxplotiRating <- ggplot(data = raceResults,
                         aes (x = iRating,
                              y = FinPos <=3))

# geometric layer:
boxplotiRating + geom_boxplot(color = "blue",
                              fill = "light pink")




















