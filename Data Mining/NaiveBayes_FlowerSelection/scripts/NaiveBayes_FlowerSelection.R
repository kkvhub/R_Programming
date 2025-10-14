# Kaushlendra Kumar Verma
# MIS Practice chapter 7
# NaiveBayese Modelling

# Import a flower datadset and generate a Naive Bayse model to predict iris type
# based on dimensions of petals and sepals.

# Install the tidyverse and dummies package
# install.packages("tidyverse")
# install.packages("dummies", repos = NULL, type="source")
# install.packages("corrplot")
# install.packages("e1071")


# Load the tidyverse, scale and dummies packages
library(tidyverse)
library(e1071)

# setwd("K:/MSBA/09_Data Mining_MIS 545 301-7W1/Week 5")
# Read IrisVaritiesBinned.csv into a tibble called iris
# l for logical
# n for numerical 
# i for integer
# c for character
# f for factor
# D for date
# T for datetime
iris <- read_csv(file = "IrisVarietiesBinned.csv",
                 col_types = "nnnnf",
                 col_names = TRUE)

# Display the iris tibble on the console
print(iris)

# Display the stucture of the iris tibble   
str(iris)

# Display the summary of iris tibble  
summary(iris)

# Split the data into training and testing
# the set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(1013)

# create a vector of 75% randomly sampled rows from the original dataset
sampleSet <- sample(nrow(iris),
                    round(nrow(iris)*0.75),
                    replace = FALSE)

# Put the records from the 75% sample into irisTraining
irisTraining <- iris[sampleSet, ]

# Put all other records (25%) into irisTesting
irisTesting <- iris[-sampleSet, ]

# Train the naive bayese model
irisModel <-  naiveBayes(formula = Variety ~ .,
                        data = irisTraining,
                        laplace = 1)

# Build prbabilities for each record in testing dataset
irisProbabilitity <- predict(irisModel,
                             irisTesting,
                             type = "raw")

# Display the probabilities from irisprobabilities on the console
print(irisProbabilitity)

# Predict classes for each record in the testing dataset
irisPrediction <- predict(irisModel,
                          irisTesting,
                          type = "class")

# Display the predictions from irisPrediction on the console
print(irisPrediction)

# Evaluate the model by forming a confusion matrix
irisConfusionMatrix <- table(irisTesting$Variety,
                             irisPrediction)

# Display the confusion matrix on the console
print(irisConfusionMatrix)

# Calculate the model predicitve accuracy
predictiveAccuracy <- sum(diag(irisConfusionMatrix)) / nrow(irisTesting)

# Display the predicitve accuracy of the console
print(predictiveAccuracy)

















