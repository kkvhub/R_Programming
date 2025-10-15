# Kaushlendra Kumar Verma, Rama Subba Reddy, Lovely Kumari & Yanyun Wu
# MIS 545 Group Project
# DrinksDistributionChannelSelection.R
# This code below is about leveraging R-based machine learning models i.e
# Logistic Regression, Decision Tree, Naïve Bayes, and k-Nearest Neighbors 
# to predict the optimal distribution channel (Direct vs Indirect) for Pepsi 
# across Andhra Pradesh districts in India, based on factors like revenue 
# potential & population segmentation to enable data-driven decisions.  
# The data was sourced through a personal network and is not publicly available.

# Set the working directory
# setwd("K:/MSBA/09_Data Mining_MIS 545 301-7W1/Group project/Pepsi dataset")

# Install the necessary packages
# install.packages("tidyverse")
# install.packages("dummies", repos = NULL, type="source")
# install.packages("rpart")
# install.packages("rpart.plot")
# install.packages("class")
# install.packages("e1071")
# install.packages("corrplot")
# install.packages("smotefamily")

# Load the necessary libraries
library(tidyverse)
library(dummies)
library(rpart)
library(rpart.plot)
library(class)
library(e1071)
library(corrplot)
library(smotefamily)

# Read DrinksDistributionDatasetMasterFile.csv into a tibble called distribution
distribution <- read_csv(file = "data/DrinksDistributionDatasetMasterFile.csv",
                 col_types = "cnffnnif",
                 col_names = TRUE)

# Display the distribution tibble 
print(distribution)

# Display the structure of the distribution tibble   
str(distribution)

# Display the summary of distribution tibble  
summary(distribution)

# Function to display correlation plot for a tibble
displayCorrPlot <- function(tibble) {
  numeric_cols <- tibble[, sapply(tibble, is.numeric)]
  corr_matrix <- round(cor(numeric_cols, use = "pairwise.complete.obs"), 2)
  corrplot(corr_matrix, method = "number", type = "lower")
}

# Display correlation plot for distribution
displayCorrPlot (distribution)

# DATA PREPROCESSING -----------------------------------------------------------
# Removing identifier column Location and numeric column Population
# Population also has perfect multicollinearity with PotentialRevenue
distribution <- distribution %>% select(-Location, -Population)

# Re-validating correlation matrix 
displayCorrPlot(distribution)

# Analysis on Present Revenue
directDistributors <- distribution %>% 
  filter(PresentRevenue != 0 & Distribution == 1)
indirectDistributors <- distribution %>% 
  filter(PresentRevenue != 0 & Distribution == 0)
print(nrow(directDistributors))
print(nrow(indirectDistributors))

# Only 10% of the dataset has PresentRevenue populated, so this feature needs 
# to be dropped such that distributionFinal is not impacted by missing values
distributionFinal <- distribution %>% select(-PresentRevenue)

# EXPLORATORY ANALYSIS ---------------------------------------------------------
# Create a function called DisplayAllHistogram that takes in a tibble parameter
# that will display a histogram for all numeric feature in the tibble
displayAllHistogram <- function(tibbleDataset) {
  tibbleDataset %>% 
    keep(is.numeric) %>% 
    gather() %>% 
    ggplot() + geom_histogram(mapping = aes(x = value, fill = key),
                              color = "black") + 
    facet_wrap(~key, scales = "free") +
    theme_minimal()}

# call the displayAllHistogram function, passing distribution as an argument
displayAllHistogram(distributionFinal)

# Transformation of PotentialRevenue for better visuals in Exploratory Analysis
distributionFinal <- distributionFinal %>% 
  mutate(PotentialRevenue = PotentialRevenue/1000)

# Histogram of Vehicles
ggplot(distributionFinal, aes(x = Vehicles)) +
  geom_histogram(aes(fill = ..count..), bins = 20, 
                 color = "black", alpha = 0.8) +
  stat_bin(binwidth = 0.25, geom = "text", 
           aes(label = ifelse(..count.. > 0, ..count.., "")), 
           vjust = -0.5, hjust = -0.5,  size = 3) +
  scale_fill_gradient(low = "pink", high = "red") +
  labs(title = "Histogram of Vehicles", 
       x = "Vehicles", y = "Count") +
  theme_minimal()


# Histogram of Potential Revenue
ggplot(distributionFinal, aes(x = log(PotentialRevenue))) +
  geom_histogram(aes(fill = ..count..), bins = 30, 
                 color = "black", alpha = 0.8) +
  scale_fill_gradient(low = "yellow", high = "red") +
  labs(title = "Histogram of Potential Revenue", 
       x = "Log(Potential Revenue)", y = "Count") +
  theme_minimal()

# Scaterplot for potential revenue and vehicles
scattePlotPotentialRevenueandVehicle <- ggplot(data = distributionFinal,
                                               aes(y = Vehicles,
                                                   x = log(PotentialRevenue)))
# Add geometry layer and best fit line
scattePlotPotentialRevenueandVehicle + geom_point( size =2, color = "blue") + 
  labs(title = "Scaterplot for Potential Revenue and Vehicle count", 
       x = "Log(Potential Revenue)", y = "Vehicle Count") +
  geom_smooth(method = lm,
              level = 0,
              color = "red")

# Average potential revenue by distribution type Side-by-side boxplot
ggplot(distributionFinal, aes(x = Distribution, 
                              y = log(PotentialRevenue))) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Boxplot of Log(Potential Revenue) by Distribution Type",
       x = "Distribution Type", y = "Potential Revenue") +
  theme_minimal()

# QUERY 1: Average potential revenue by distribution type and vehicle
# Summarize by Distribution
summaryDistribution <- distributionFinal %>%
  group_by(Distribution) %>%
  summarize(
    avgPotentialRevenue = mean(PotentialRevenue, na.rm = TRUE),
    totalVehicles = sum(Vehicles, na.rm = TRUE)) %>%
  tidyr::pivot_longer(cols = -Distribution, 
                      names_to = "Metric", values_to = "Value")

# Plot grouped bar chart
ggplot(summaryDistribution, aes(x = Distribution, y = Value, fill = Metric)) +
  geom_col(position = "dodge") +
  labs(title = "Summary Metrics by Distribution Type",
       x = "Distribution Type", y = "Value") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal()

# QUERY 2: How the distribution strategy vary across Rural and Urban Markets
# Reveals whether urban markets prefer Indirect distribution and rural markets 
# favor Direct distribution.
# Summarize by Market and Distribution
summaryMarket <- distributionFinal %>%
  group_by(Market, Distribution) %>%
  summarize(
    avgRevenue = mean(PotentialRevenue, na.rm = TRUE),
    avgVehicles = mean(Vehicles, na.rm = TRUE)
  ) %>%
  arrange(Market)

# Long format for plotting
summaryDetail <- summaryMarket %>%
  pivot_longer(cols = c(avgRevenue, avgVehicles),
               names_to = "Metric", values_to = "Value")

# Grouped bar plot with facets for each Metric
ggplot(summaryDetail, aes(x = Market, y = Value, fill = Distribution)) +
  geom_col(position = "dodge") +
  facet_wrap(~Metric, scales = "free_y") +
  labs(title = "Market-wise Summary by Distribution",
       x = "Market", y = "Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# QUERY 3: Population Type Influence on Distribution and Vehicles
# Highlights how population density influences distribution planning
# Summarize by Population and Distribution
summaryPopulationType <- distributionFinal %>%
  group_by(PopulationType, Distribution) %>%
  summarize(
    avgVehicles = mean(Vehicles, na.rm = TRUE),
    avgPotentialRevenue = mean(PotentialRevenue, na.rm = TRUE)) 

# Grouped bar plot for avgVehicles
ggplot(summaryPopulationType, aes(x = PopulationType, y = avgVehicles, 
                              fill = Distribution)) +
  geom_col(position = position_dodge()) +
  labs(title = "Average Vehicles by Population Type and Distribution",
       x = "Population Type", y = "Average Vehicles") +
  theme_minimal()

# Grouped bar plot for avgPotentialRevenue
ggplot(summaryPopulationType, aes(x = PopulationType, y = avgPotentialRevenue, 
                              fill = Distribution)) +
  geom_col(position = position_dodge()) +
  labs(title = "Average Potential Revenue by Population Type and Distribution",
       x = "Population Type", y = "Average Potential Revenue") +
  theme_minimal()

# MODELING PROCESS--------------------------------------------------------------
# Decision Tree Model ----------------------------------------------------------

# The set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(1234)

# Create a vector of 75% randomly sampled rows from the original dataset
sampleSetDT <- sample(nrow(distributionFinal),
                    round(nrow(distributionFinal) * 0.75), replace = FALSE)

# Put the records from the 75% sample into distributionTrainingDT
distributionTrainingDT <- distributionFinal[sampleSetDT, ]

# Put all other records (25%) into distributionTestingDT
distributionTestingDT <- distributionFinal[-sampleSetDT, ]

# Note the distribution statistics in the training dataset
summary(distributionTrainingDT$Distribution) # Direct(78) Indirect(743)

# Train the decision tree model using the training dataset 
# Note the complexity parameter of 0.0001
distributionDTModel <- rpart(formula = Distribution ~ ., method = "class",
                             cp = 0.0001, data = distributionTrainingDT)

# Display the decision tree plot
rpart.plot(distributionDTModel)

# Predict classes for each record in the testing dataset
dTPrediction <- predict(distributionDTModel, distributionTestingDT, 
                        type = "class")

# Display the predictions from dTPrediction 
print(dTPrediction)

# Evaluate the model by forming a confusion matrix
dTConfusionMatrix <- table(distributionTestingDT$Distribution, dTPrediction)

# Display the Confusion Matrix
print(dTConfusionMatrix)

# Calculate the model predictive accuracy 
dTPredictiveAccuracy <- sum(diag(dTConfusionMatrix)) / 
  nrow(distributionTestingDT)
print(dTPredictiveAccuracy)

# Calculate the false positive rate: % of times our distributionDTModel 
# predicted the distribution type to be Direct but they were Indirect
dTFPR <- dTConfusionMatrix[2, 1] / sum(dTConfusionMatrix[2, ])
print(dTFPR)

# Calculate the false negative rate: % of times our distributionDTModel 
# predicted the distribution type to be Indirect but they were Direct 
dTFNR  <- dTConfusionMatrix[1, 2] / sum(dTConfusionMatrix[1, ])
print(dTFNR)

# cpValue Matrix is created to check for branching
cpValueMatrix <- matrix(data = NA, nrow = 0, ncol = 2)
colnames(cpValueMatrix) <- c("cp value", "Predictive Accuracy")

# Creating a loop from cp = 1e-01 to cp= 1e-100 to check for branching
for (cpValue in 1:100) {
  cp = 0.1 ^ cpValue
  dt <- rpart(formula = Distribution ~ ., method = "class", cp = cp,
              data = distributionTrainingDT)
  pred <- predict(dt, distributionTestingDT, type = "class")
  cm <- table(distributionTestingDT$Distribution, pred)
  acc <- sum(diag(cm)) / nrow(distributionTestingDT)
  cpValueMatrix <- rbind(cpValueMatrix, c(cp, acc))
}

# Display cpValueMatrix
print(cpValueMatrix)

# SUMMARY:
# Decision tree branches and predictive accuracy remains same as it was for 
# complexity parameter of 0.0001
# Accuracy: 99.27%, FPR: 0%, FNR: 6.25%

# Naive Bayes Model ------------------------------------------------------------
# Required Data PreProcessing: 
# 1) Binning by PotentialRevenue
# Step 1: Sort 
distributionFinalBinned <- distributionFinal[order(
  distributionFinal$PotentialRevenue), ]

# Step 2: Equal-frequency bins
distributionFinalBinned <- distributionFinalBinned %>% 
  mutate(bin = ntile(PotentialRevenue, 10))

# Step 3: Compute the mean of each bin and replace values & display on console
distributionFinalBinned <- distributionFinalBinned %>% group_by(bin) %>% 
  mutate(PotentialRevenue = mean(PotentialRevenue))

# Validate binned data
print(distributionFinalBinned)

# 2) Binning by Vehicles
# Step 1: Sort 
distributionFinalBinned <- distributionFinalBinned[order(
  distributionFinalBinned$Vehicles), ]

# Step 2: Equal-frequency bins
distributionFinalBinned <- distributionFinalBinned %>%
  mutate(bin = ntile(Vehicles, 10))

# Step 3: Compute the mean of each bin and replace values & display on console
distributionFinalBinned <- distributionFinalBinned %>% group_by(bin) %>% 
  mutate(Vehicles = ceiling(mean(Vehicles)))

# Validate binned data
print(distributionFinalBinned)

# Remove the bin column from dataset
distributionFinalBinned <- distributionFinalBinned %>% select(-bin)

# The set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(1234)

# Create a vector of 75% randomly sampled rows from the original dataset
sampleSetNB <- sample(nrow(distributionFinalBinned),
                      round(nrow(distributionFinalBinned) * 0.75), 
                      replace = FALSE)

# Put the records from the 75% sample into distributionTrainingNB
distributionTrainingNB <- distributionFinalBinned[sampleSetNB, ]

# Put all other records (25%) into distributionTestingNB
distributionTestingNB <- distributionFinalBinned[-sampleSetNB, ]

# Train the Naive Bayes model
naiveBayesModel <-  naiveBayes(formula = Distribution ~ .,
                               data = distributionTrainingNB, laplace = 1)

# Build nBProbability for each record in testing dataset
nBProbability <- predict(naiveBayesModel, distributionTestingNB, type = "raw")

# Display the probabilities from nBProbability 
print(nBProbability)

# Predict classes for each record in the testing dataset
nBPrediction <- predict(naiveBayesModel, distributionTestingNB,
                                type = "class")

# Display the predictions from nBPrediction 
print(nBPrediction)

# Evaluate the model by forming a confusion matrix
nBConfusionMatrix <- table(distributionTestingNB$Distribution, nBPrediction)

# Display the confusion matrix 
print(nBConfusionMatrix)

# Calculate the model predictive accuracy
nBPredictiveAccuracy <- sum(diag(nBConfusionMatrix)) / 
  nrow(distributionTestingNB)
print(nBPredictiveAccuracy)

# Calculate the false positive rate: % of times our naiveBayesModel predicted 
# the distribution type to be Direct but they were Indirect 
nBFPR <- nBConfusionMatrix[2, 1] / sum(nBConfusionMatrix[2, ])
print(nBFPR)

# Calculate the false negative rate: % of times our naiveBayesModel predicted 
# the distribution type to be Indirect but they were Direct 
nBFNR <- nBConfusionMatrix[1, 2] / sum(nBConfusionMatrix[1, ])
print(nBFNR)

# SUMMARY:
# Naive Bayes predictive accuracy will not be impacted for moderately impacted 
# data by SMOTE
# Accuracy: 99.27%, FPR: 0%, FNR: 6.67%

# Logistic Regression Model ----------------------------------------------------
# Required Data PreProcessing: 
# Checking Separation between Population and Distribution
table(distributionFinal$PopulationType, distributionFinal$Distribution)

# Checking Separation between Market and Distribution
table(distribution$Market, distribution$Distribution)

# To handle inflated Coefficient values, we are taking a log of PotentialRevenue
distributionFinal <- distributionFinal %>% 
  mutate(PotentialRevenue = log(PotentialRevenue))

# Using dummies to split factor variables
distributionFinal <- as_tibble(dummy.data.frame(
  data = data.frame(distributionFinal), names = c("PopulationType","Market")))

# Removing one category from each PopulationType & Market
distributionFinal <- distributionFinal %>% 
  select(-PopulationTypeUFTP, -`MarketRural Villages`)

# Identifying dependent variable in terms of 0(Indirect) and 1(Direct)
distributionFinal <- distributionFinal %>% 
  mutate(Distribution = ifelse(Distribution == "Direct", 1, 0))

# Display the tibble
print(distributionFinal)

# Display structure of tibble
str(distributionFinal)

# Display summary of tibble
summary(distributionFinal)

# Display corrplot and removing multi-collinear variables iteratively 
displayCorrPlot(distributionFinal)

# Removed -`MarketRural Towns` as it has perfect collinearity of 1.0 with 
# PopulationTypeFTP
distributionFinalLG <- distributionFinal %>% select(-`MarketRural Towns`) 

# Re-validate corrplot
displayCorrPlot(distributionFinalLG)

# Removed -`MarketSemi Urban` as it has high collinearity of 0.89 with 
# PopulationTypeOLP
distributionFinalLG <- distributionFinalLG %>% select(-`MarketSemi Urban`) 

# Re-validate corrplot
displayCorrPlot(distributionFinalLG)

# Converting dependent Distribution variable to logical 
distributionFinalLG <- distributionFinalLG %>% 
  mutate(Distribution = as.logical(Distribution))

# The set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(1234)

# Create a vector of 75% randomly sampled rows from the original dataset
sampleSetLG <- sample(nrow(distributionFinalLG),
                    round(nrow(distributionFinalLG) * 0.75), replace = FALSE)

distributionTrainingLG <- distributionFinalLG[sampleSetLG, ]
distributionTestingLG <- distributionFinalLG[-sampleSetLG, ]

# Display summary of training dataset
summary(distributionTrainingLG)

# Verification of class balance in training data
print(nrow(filter(.data = distributionTrainingLG, Distribution == 0))/
  nrow(filter(.data = distributionTrainingLG, Distribution == 1)))

# SMOTE of the training data to remove class imbalance
distributionTrainingSmotedLG <- tibble(SMOTE(
  X = data.frame(distributionTrainingLG),
  target = distributionTrainingLG$Distribution,
  dup_size = 9)$data)

# Display summary of distributionTrainingSmotedLG
summary(distributionTrainingSmotedLG)

# Verification of class balance in distributionTrainingSmotedLG
print(nrow(filter(.data = distributionTrainingSmotedLG, Distribution == 0))/
  nrow(filter(.data = distributionTrainingSmotedLG, Distribution == 1)))

# Converting dependent variable Distribution to logical
distributionTrainingSmotedLG <- distributionTrainingSmotedLG %>%
  mutate(Distribution = as.logical(Distribution))

# Drop the 'class' column created during SMOTE
distributionTrainingSmotedLG <- distributionTrainingSmotedLG %>% select(-class)

# Display summary of smoted Training Data set
summary(distributionTrainingSmotedLG)

# Generating the logarithmic Model lgModel1 with all features
lgModel1 <- glm(data = distributionTrainingSmotedLG, family = binomial, 
                formula = Distribution ~ .)

# Display Summary of lgModel1
summary(lgModel1)

# To reduce complexity, we have refitted the model with selected features based
# on correlation plot analysis from earlier
# Generating the logarithmic Model lgModel2 with selected features
lgModel2 <- glm(data = distributionTrainingSmotedLG, family = binomial, 
                formula = Distribution ~ PotentialRevenue + Vehicles + 
                  MarketUrban + PopulationTypeFTP)

# Display Summary of lgModel2
summary(lgModel2)

# Generating the logarithmic Model lgModel with only significant variables
# because Market Segments and Population Segments are highly collinear in nature
lgModel <- glm(data = distributionTrainingSmotedLG, family = binomial, 
               formula = Distribution ~ PotentialRevenue + Vehicles)

# Display Summary of lgModel
summary(lgModel)

# Predict using lgModel
lgPrediction <- predict(lgModel, distributionTestingLG, type = "response")

# Convert predictions into binary response as 0 & 1
lgPrediction <- ifelse(lgPrediction >= 0.5, 1, 0)

# Build confusion matrix
lgCFM <- table(distributionTestingLG$Distribution, lgPrediction)
print(lgCFM)

# Calculate the model predicitve accuracy
lgPredictiveAccuracy <- sum(diag(lgCFM)) / nrow(distributionTestingLG)
print(lgPredictiveAccuracy)

# Calculate the false positive rate: % of times our lgModel predicted the 
# distribution type to be Direct but they were Indirect 
lgFPR <- lgCFM[1, 2] / sum(lgCFM[1, ])
print(lgFPR)

# Calculate the false negative rate: % of times our lgModel predicted the 
# distribution type to be Indirect but they were Direct 
lgFNR <- lgCFM[2, 1] / sum(lgCFM[2, ])
print(lgFNR)

# SUMMARY: 
# Through lgModel, we can inference that Vehicles and PotentialRevenue is
# statistically significant and jointly explains the variance between Direct and
# Indirect Distribution channels, without influence of other features 
# available to us. Selecting only significant features also drops the 
# Fisher Scoring iterations from 24 to 9.
# Accuracy: 94.89%, FPR: 5.78%, FNR:0% 

# k-Nearest Neighbors Model  ---------------------------------------------------
# Display currently pre-processed data which is to be used
print(distributionFinal)

# The set.seed() function is used to ensure that we can get the same result 
# every time we run a random sampling process
set.seed(1234)

# Create a vector of 75% randomly sampled rows from the original dataset
sampleSetKNN <- sample(nrow(distributionFinal),
                       round(nrow(distributionFinal) * 0.75), replace = FALSE)

# Put all other records (25%) into Testing dataset
distributionTestingKNN <- distributionFinal[-sampleSetKNN, ]
distributionTestingKNNLabels <- distributionTestingKNN %>% select(Distribution)
distributionTestingKNN <- distributionTestingKNN %>% select(-Distribution)

# Put the records from the 75% sample into Training dataset
distributionTrainingKNN <- distributionFinal[sampleSetKNN, ]

# SMOTE of training set before separating Labels
distributionTrainingKNNSmoted <- tibble(SMOTE(
  X = data.frame(distributionTrainingKNN), 
  target = distributionTrainingKNN$Distribution,
  dup_size = 9)$data)

# Extracting Labels into a separate dataset
distributionTrainingKNNSmotedLabels <- distributionTrainingKNNSmoted %>% 
  select(Distribution)
distributionTrainingKNNSmoted <- distributionTrainingKNNSmoted %>% 
  select(-Distribution, -class)

# Creating a kValue Matrix to choose optimal k
kValueMatrix <- matrix(data = NA, nrow = 0, ncol = 2)
colnames(kValueMatrix) <- c("k value", "Predictive Accuracy")

for (kValue in 1:100) {
  if (kValue %% 2 != 0) { 
    prediction <- knn(train = distributionTrainingKNNSmoted,
                      test = distributionTestingKNN,
                      cl= distributionTrainingKNNSmotedLabels$Distribution, 
                      k = kValue)
    cm <- table(distributionTestingKNNLabels$Distribution, prediction)
    acc <- sum(diag(cm)) / nrow(distributionTestingKNN)
    kValueMatrix <- rbind(kValueMatrix, c(kValue, acc))
  }
}

# Display kValueMatrix
print(kValueMatrix)

# Validate nearest odd integer for optimal k
optimalK <- round(sqrt(nrow(distributionTrainingKNNSmoted)))
optimalK <- ifelse(optimalK %% 2 != 0, optimalK, optimalK - 1) 
print(optimalK)

# Generating a kNN model based on nearest odd integer as it has better 
# model evaluation FNR and FPR
kNNPrediction <- knn(train = distributionTrainingKNNSmoted,
                     test = distributionTestingKNN,
                     cl = distributionTrainingKNNSmotedLabels$Distribution,
                     k = optimalK)

# Display the prediction from the testing dataset 
print(kNNPrediction)

# Display a summary of the predictions from the testing dataset
summary(kNNPrediction)

# Evaluate the model by forming a confusion matrix
kNNConfusionMatrix <- table(distributionTestingKNNLabels$Distribution,
                            kNNPrediction)

# Display the confusion matrix 
print(kNNConfusionMatrix)

# Calculate the model predictive accuracy
kNNPredictiveAccuracy <- sum(diag(kNNConfusionMatrix)) / 
  nrow(distributionTestingKNN)
print(kNNPredictiveAccuracy)

# Calculate the false positive rate: % of times our kNNPrediction model
# predicted the distribution type to be Direct but they were Indirect
kNNFPR <- kNNConfusionMatrix[1, 2] / sum(kNNConfusionMatrix[1, ])
print(kNNFPR)

# Calculate the false negative rate: % of times our kNNPrediction model 
# predicted the distribution type to be Indirect but they were Direct 
kNNFNR <- kNNConfusionMatrix[2, 1] / sum(kNNConfusionMatrix[2, ] )
print(kNNFNR)

# SUMMARY:
# The kValueMatrix tells us that k < 35 and k > 55 have higher predictive power 
# but their False Positive and False Negative rates are worse than the optimal
# k at 39.
# Accuracy: 97.44%, FPR:2.47%, FNR: 3.12%
# -----------------------------------------------------------------------------# 