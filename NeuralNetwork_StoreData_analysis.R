# Kaushlendra Kumar Verma
# MIS Neural network demo
# week06NeuralNetwork store data analysis

# Import a dataset of departmental store data. Generate a neural network to 
# predict if the consumer will use a coupon based in their annual store spending
# and if they have a store credit card.

# Install the tidyverse and neuralnetwork packages
# install.packages("tidyverse")
# install.packages("neuralnet")


# Load the tidyverse and neuralnet packages
library(tidyverse)
library(neuralnet)

# Set the working directory
# setwd("K:/OneDrive - University of Arizona/MSBA/
#       09_Data Mining_MIS 545 301-7W1/Week 6")

# Read DepartmentalStoreSpending.csv into a tibble called departmentStore
# l for logical
# n for numerical 
# i for integer
# c for character
# f for factor
# D for date
# T for datetime
departmentStore <- read_csv(file = "DepartmentStoreSpending.csv",
                    col_types = "nll",
                    col_names = TRUE) 

# Display the departmentalStore tibble on the console
print(departmentStore)

# Display the stucture of the departmentalStore tibble   
str(departmentStore)

# Display the summary of departmentalStore tibble  
summary(departmentStore)

# Scale the annual spending feature from 0 to 1
departmentStore <- departmentStore %>% 
  mutate(AnnualSpendingScaled = (AnnualSpending - min(AnnualSpending))/
           (max(AnnualSpending) - min(AnnualSpending)))

# Split the data into training and testing
# the set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(9912)

# create a vector of 75% randomly sampled rows from the original dataset
sampleSet <- sample(nrow(departmentStore),
                    round(nrow(departmentStore)*0.75),
                    replace = FALSE)

# Put the records from the 75% sample into irisTraining
departmentStoreTraining <- departmentStore[sampleSet, ]

# Put all other records (25%) into irisTesting
departmentStoreTesting <- departmentStore[-sampleSet, ]

# Generate the neural network
departmentStoreNeuralNet <- neuralnet(
  formula = UsedCoupon ~ AnnualSpendingScaled + HasStoreCreditCard,
  data = departmentStoreTraining,
  hidden = 20,
  act.fct = "logistic",
  linear.output = FALSE)

# Display the neural network results
print(departmentStoreNeuralNet $ result.matrix)

# Visualize the neural network
plot(deparmentalStoreNeuralNet)

# Use financeNeuralNet to generate probabilities on the 
# depatmentStoretesting data set
departmentStoreProbability <- compute(deparmentalStoreNeuralNet,
                                      departmentStoreTesting)

# Display the predictions from the testing dataset on the console
print(departmentStoreProbability)

# Convert probability predictions into 0/1 predictions
departmentStorePrediction <- 
  ifelse(departmentStoreProbability$net.result > 0.5,1,0)

# Display the prediction on the console
print(departmentStorePrediction)

# Evaluate the model by forming the confusion matrix
departmentStoreConfusionMatrix <- table(departmentStoreTesting$UsedCoupon, 
                                        departmentStorePrediction)

# display the confusion matrix on the console
print(departmentStoreConfusionMatrix)

# calculate the predective accuracy of the model
departmentPredectiveAccuracy <- sum(diag(departmentStoreConfusionMatrix)) / 
  nrow(departmentStoreTesting)

# Display the predective accuracy on the console
print(departmentPredectiveAccuracy)

