# Kaushlendra Kumar Verma
# MIS Practice chapter 5
# week04LogisticRegression.R

# setwd("C:/Users/User/OneDrive - University of Arizona/MSBA/09_Data Mining_MIS 545 301-7W1/Week 4")

# Install the tidyverse and dummies package
# install.packages("tidyverse")
# install.packages("dummies", repos = NULL, type="source")
# install.packages("corrplot")
# install.packages("smotefamily")

# Load the tidyverse, scale and dummies packages
library(tidyverse)
library(dummies)
library(scales)
library(corrplot)
library(olsrr)
library(smotefamily)
universityRetention <- read_csv(file = "UniversityRetention.csv",
                                col_types = "nlln",
                                col_names = TRUE)

# display the universityRetention tibble on the console
print(universityRetention)

# Display the structure of the universityRetention tibble
str(universityRetention)

# Display a summary of the inoversityRetention tibble
summary(universityRetention)

# Display a correlation matrix rounded to two places
round(cor(universityRetention),2)

#  Display a correlation plot using the "number" method and limit output to the
# bottom left
corrplot(cor(universityRetention),
         method = "number",
         type = "lower")

# Split the data into training and testing
# the set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(1234)

# create a vector of 75% randomly sampled rows from the original dataset
sampleSet <- sample(nrow(universityRetention),
                    round(nrow(universityRetention)*0.75),
                    replace = FALSE)

# Put the records from the 75% sample into universityRetentionTraining
universityRetentionTraining <- universityRetention[sampleSet,]

# Put all other records (25%) into universityRetentionTraining
universityRetentionTesting <- universityRetention[-sampleSet,]

# Do we have class imbalance in the training dataset?
summary(universityRetentionTraining$Withdraw)

# Store the magnitude of class imbalance into a variable
classImbalanceMagnitude <- 299 /76

# Deal with class imbalance in the training dataset
universityRetentionTrainingSmoted <- 
  tibble(SMOTE(X = data.frame(universityRetentionTraining),
               target = universityRetentionTraining$Withdraw,
               dup_size = 3)$data)
summary(universityRetentionTrainingSmoted)

# Convert Seminar and Withdraw back into logical types
universityRetentionTrainingSmoted <- universityRetentionTrainingSmoted %>%
  mutate(Withdraw = as.logical(Withdraw),
         Seminar = as.logical(Seminar))
# Get rid of "class" coloumn in tibble ( added by SMOTE())
universityRetentionTrainingSmoted <- universityRetentionTrainingSmoted %>%
  select(-class)

# Check for class imbalance on the smoted dataset
summary(universityRetentionTrainingSmoted)

# Generate the logistic regression model
universityRetentionModel <- glm(data = universityRetentionTrainingSmoted,
                                family = binomial,
                                formula = Withdraw ~ .)

# Display the oytput of the logistic regression madel. Remember that the beta 
# coefficients are log-odds
summary(universityRetentionModel)

# Calculate the odds ratios for each coefficient
# An odds ratio above 1 represents that an incerease in the independent variable
# will increase the odds of the student withdrawing
# An odds ratio below 1 represents that an incerease in the independent variable
# will decrease the odds of the student withdrawing
#An odds ratio of 1 represents that a change in the independent variable
# will have no effect on the odds of the student withdrawing
exp(coef(universityRetentionModel)["GPA"])
exp(coef(universityRetentionModel)["SeminarTRUE"])
exp(coef(universityRetentionModel)["AnnualIncome"])

# Use the model to predict outcomes in the testing dataset
universityRetentionPrediction <- predict(universityRetentionModel,
                                         universityRetentionTesting,
                                         type = "response")
# displat universityRetentionPrediction on the console 
print(universityRetentionPrediction)

# Treat anything below or equal to 0.5 as 0, anything above 0.5 as 1
universityRetentionPrediction <- 
  ifelse(universityRetentionPrediction >= 0.5, 1, 0)

# displat universityRetentionPrediction on the console 
print(universityRetentionPrediction)

# create confusion matrix
universityRetentionConfusionMatrix <- table(universityRetentionTesting$Withdraw,
                                            universityRetentionPrediction)

# Display the confussion matrix
print(universityRetentionConfusionMatrix)

# Calculate the false positive rate
# % of times our model predicted the student would withdraw, but they did not
# 42/(42+61)
universityRetentionConfusionMatrix[1,2] / 
  (universityRetentionConfusionMatrix[1,2] +
     universityRetentionConfusionMatrix[1,1])

# Calculate the false negative rate
# % of times our model predicted the student would not withdraw, but they did 
# 12/(12+10)
universityRetentionConfusionMatrix[2,1] / 
  (universityRetentionConfusionMatrix[2,1] +
     universityRetentionConfusionMatrix[2,2])

# Calculate the prediction accuaracy by dividing the number of true positives and
# true negatives by the total amount of predictions in the testing dataset
sum(diag(universityRetentionConfusionMatrix)) / nrow(universityRetentionTesting)















































