# Kaushlendra Kumar Verma 
# MIS 545
# kNN Programming
# This code is about doing prediction modeling and generating the results using
# K-Nearest Neighbour Model for determining size of sedan

# Install the tidyverse, class and corrplot package
# install.packages("tidyverse")
# install.packages("corrplot")
# install.packages("class")

# Load the tidyverse, corrplot and class packages
library(tidyverse)
library(corrplot)
library(class)

# Set working Directory
# setwd(
#   "K:/MSBA_course/09_Data Mining_MIS 545 301-7W1/01_Lab Assignments/Lab 04")

# Read SedanSize.csv into a tibble called sedanSize
# l for logical
# n for numerical 
# i for integer
# c for character
# f for factor
# D for date
# T for datetime
sedanSize <- read_csv(file = "SedanSize.csv",
                      col_types = "cfnii",
                      col_names = TRUE)

# Display the sedanSize tibble on the console
print(sedanSize)

# Display the stucture of the sedanSize tibble   
str(sedanSize)

# Display the summary of sedanSize tibble  
summary(sedanSize)

# Removeing the MakeModel feature from the sedanSize tibble
sedanSize <- sedanSize %>% select(-MakeModel)

# Seperate the tibble into two. One with just the lable and one with the other
# variables.
sedanSizeLabels <- sedanSize %>% select(SedanSize)
sedanSize <- sedanSize %>% select(-SedanSize)

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

# call the displayAllHistogram function, passing in sedanSize as an 
# argument
displayAllHistogram(sedanSize)

# Split the data into training and testing
# the set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(517)

# create a vector of 75% randomly sampled rows from the original dataset
sampleSet <- sample(nrow(sedanSize),
                    round(nrow(sedanSize)*0.75),
                    replace = FALSE)

# Put the records from the 75% sample into sedanSizeTraining
sedanSizeTraining <- sedanSize[sampleSet, ]
sedanSizeTrainingLabels <- sedanSizeLabels[sampleSet, ]

# Put all other records (25%) into sedanSizeTesting
sedanSizeTesting <- sedanSize[-sampleSet, ]
sedanSizeTestingLabels <- sedanSizeLabels[-sampleSet, ]

# Generate the K-Neighbour model
sedanSizePrediction <- knn(train = sedanSizeTraining,
                          test = sedanSizeTesting,
                          cl = sedanSizeTrainingLabels$SedanSize,
                          k = 7)

# Display the prediction from the testing dataset on the console
print(sedanSizePrediction)

# Display a summary of the predictions from the testing dataset
print(summary(sedanSizePrediction))

# Evaluate the model by forming a confusion matrix
sedanSizeConfusionMatrix <- table(sedanSizeTestingLabels$SedanSize,
                                 sedanSizePrediction)

# Display the confusion matrix on the console
print(sedanSizeConfusionMatrix)

# Calculate the model predective accuracy
predectiveAccuracy <- sum(diag(sedanSizeConfusionMatrix)) / 
  nrow(sedanSizeTesting)

# Diaplay the predictive accuracy on the console
print(predectiveAccuracy)

# Create a matrix of K values with their predective accuracy
kValueMAtrix <- matrix(data = NA,
                       nrow = 0,
                       ncol = 2)

# Assign column names to the matrix
colnames(kValueMAtrix) <- c("k value", "Predective Accuracy")

# Loop through with different values of k to determine the best fitting model
# using odd numbers from 1 to number of observations in the training data set
for (kvalue in 1:nrow(sedanSizeTraining)) {
  # Only calculate predictive accuracy if the k value is odd
  if(kvalue %% 2 != 0){
    # generate the model
    sedanSizePrediction <- knn(train = sedanSizeTraining,
                               test = sedanSizeTesting,
                               cl = sedanSizeTrainingLabels$SedanSize,
                               k = kvalue)
    
    # generate the confusion matrix
    sedanSizeConfusionMatrix <- table(sedanSizeTestingLabels$SedanSize,
                                      sedanSizePrediction)
    
    # calculate the predective accuracy
    predectiveAccuracy <- sum(diag(sedanSizeConfusionMatrix)) / 
      nrow(sedanSizeTesting)
    print(predectiveAccuracy)
    
    # Add a new row to the kValueMatrix
    kValueMAtrix <- rbind(kValueMAtrix, c(kvalue, predectiveAccuracy))
    
  } 
}

# Display and view the KValue and predective Accuracy 
# matrix to determine the best k value.
print(kValueMAtrix)