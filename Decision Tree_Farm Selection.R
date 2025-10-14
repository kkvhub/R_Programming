# Kaushlendra Kumar Verma 
# MIS 545
# Decision Tree Modelling

# This R code is about importing Indonasian Rice farm dataset to generate 
# a Decision Tree model to predict farm's ownership status

# Install the tidyverse and rpart.plot package
# install.packages("tidyverse")
# install.packages("rpart.plot")

# Load the tidyverse, rpart and rpart.plot libraries
library(tidyverse)
library(rpart)
library(rpart.plot)

# Set working dierctory
# setwd(
#   "K:/MSBA_course/09_Data Mining_MIS 545 301-7W1/01_Lab Assignments/Lab 04")

# Read IndonesianRiceFarms.csv into a tibble called riceFarms
# l for logical
# n for numerical 
# i for integer
# c for character
# f for factor
# D for date
# T for datetime
riceFarm <- read_csv(file = "IndonesianRiceFarms.csv",
                     col_types = "fniiinf",
                     col_names = TRUE )

# Display the riceFarm tibble on the console
print(riceFarm)

# Display the stucture of the riceFarm tibble   
str(riceFarm)

# Display the summary of riceFarm tibble  
summary(riceFarm)

# Split the data into training and testing
# the set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(370)

# create a vector of 75% randomly sampled rows from the original dataset
sampleSet <- sample(nrow(riceFarm),
                    round(nrow(riceFarm)*0.75),
                    replace = FALSE)

# Put the records from the 75% sample into irisTraining
riceFarmTraining <- riceFarm[sampleSet, ]

# Put all other records (25%) into irisTesting
riceFarmTesting <- riceFarm[-sampleSet, ]

# Train the decision tree model using the training data set. Note the 
# complexity parameter of 0.01 is the default value
riceFarmDecisionTreeModel <- rpart(formula = FarmOwnership ~ .,
                                  method = "class",
                                  cp = 0.01,
                                  data = riceFarmTraining)

# Display the decision tree plot
rpart.plot(riceFarmDecisionTreeModel)

# Predict classes for each record in the testing dataset
riceFarmPrediction <- predict(riceFarmDecisionTreeModel,
                             riceFarmTesting,
                             type = "class")

# Display the predictions from riceFarmPrediction on the console
print(riceFarmPrediction)

# Evaluate the model by froming a confusion matrix
riceFarmConfusionMatrix <- table(riceFarmTesting$FarmOwnership,
                                riceFarmPrediction)

# Display the Confusion Matrix
print(riceFarmConfusionMatrix)

# Calculate the model predective accuaracy 
predectiveAccuracy <- sum(diag(riceFarmConfusionMatrix))/
  nrow(riceFarmTesting)

# Display the predective accuracy on the console
print(predectiveAccuracy)

# Decreasing the complexity parameter to 0.007 an then again doing the modeling
riceFarmDecisionTreeModel <- rpart(formula = FarmOwnership ~ .,
                                   method = "class",
                                   cp = 0.007,
                                   data = riceFarmTraining)

# Display the decision tree plot
rpart.plot(riceFarmDecisionTreeModel)

# Predict classes for each record in the testing dataset
riceFarmPrediction <- predict(riceFarmDecisionTreeModel,
                              riceFarmTesting,
                              type = "class")

# Display the predictions from riceFarmPrediction on the console
print(riceFarmPrediction)

# Evaluate the model by froming a confusion matrix
riceFarmConfusionMatrix <- table(riceFarmTesting$FarmOwnership,
                                 riceFarmPrediction)

# Display the Confusion Matrix
print(riceFarmConfusionMatrix)

# Calculate the model predective accuaracy 
predectiveAccuracy <- sum(diag(riceFarmConfusionMatrix))/
  nrow(riceFarmTesting)

# Display the predective accuracy on the console
print(predectiveAccuracy)


