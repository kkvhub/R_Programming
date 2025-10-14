# Kaushlendra Kumar Verma & Divya Devaraj
# MIS 545
# Lab03VermaKaushlendraDevarajDivya.R
# This assignment is about Importing ZooVisitSpending dataset, ploting 
# histogram, corelation matrix, generating linear regression model and
# testing for multicolinearity

# Install the tidyverse and dummies package
# install.packages("tidyverse")
# install.packages("corrplot")
# install.packages("olsrr")

# Load the tidyverse, corrplot and olsrr libraries
library(tidyverse)
library(corrplot)
library(olsrr)

# set working directory 
# setwd(
#   "K:/MSBA_course/09_Data Mining_MIS 545 301-7W1/01_Lab Assignments/Lab 03")

# Read ZooVisitSpending.csv into a tibble called zooSpending
# l for logical
# n for numerical 
# i for integer
# c for character
# f for factor
# D for date
# T for datetime

zooSpending <- read_csv(file = "ZooVisitSpending.csv",
                        col_types = "niil",
                        col_names = TRUE)

# Display the zooSpending tibble on the console
print(zooSpending)

# Display the structure of the zooSpending tibble
str(zooSpending)

# Display the summary of the zooSpending tibble
summary(zooSpending)

# create a function called DisplayAllHistogram that takes in a tibble parameter
# that will display a histogram for all numeric feature in the tibble
displayAllHistogram <- function(tibbleDataset) {
  tibbleDataset %>% 
    keep(is.numeric) %>% 
    gather() %>% 
    ggplot() + geom_histogram(mapping = aes(x = value, fill = key),
                              color = "black") + 
    facet_wrap(~key, scales = "free") +
    theme_minimal()
}

# call the displayAllHistogram function, passing in zooSpending as an 
# argument
displayAllHistogram(zooSpending)

#  Display corrrelation matrix rounded to two decimal place
round(cor(zooSpending),2)

# Display the correlation plot and limit correlation plot to bottom left
corrplot(cor(zooSpending),
         method = "number",
         type = "lower")

# Generate the linear regression model
zooSpendingModel <- lm(data = zooSpending,
                       formula = VisitSpending ~ .)

# Display the beta coefficient for the model on the console
print(zooSpendingModel)

# Display the linear regression model result using sumarry function 
summary(zooSpendingModel)

# Test for multicollinearity
ols_vif_tol(zooSpendingModel)
