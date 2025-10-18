# Kaushlendra Kumar Verma, Yanyun Wu & Susej Sullivan
# ECON 511A Group project
# week04LogisticRegression.R

# # Install the necessary package
# install.packages("tidyverse")
# install.packages("corrplot")
# install.packages("smotefamily")

# (Cost and log variables)------------------------------------------------------

# Load the tidyverse, scale and corrplot packages
library(tidyverse)
library(scales)
library(corrplot)
library(olsrr)
library(car)
library(BeSS)

# Read passportcosts.csv into a tibble called passportcost
# l for logical
# n for numerical
# i for integer
# c for character
# f for factor
# D for date
# T for datetime
passportCost <- read_csv(file = "data/passportcosts.csv",
                         col_types = "ccnnnnnnnniinicfff",
                         col_names = TRUE )

# Display the passportCost tibble on the console
print(passportCost)

# Display the stucture of the passportCost tibble
str(passportCost)

# Display the summary of passportCost tibble
summary(passportCost)

# transforming the log of population in the dataset
passportCost <- passportCost %>%
  mutate(LogPopn = log(popn2004)) %>%
  mutate(Logmigrant = log(migrants)) %>%
  mutate(logGDP = log(gdp)) %>%
  mutate(LogInvMigprop = log(1/migprop))

# remove the transformed data
passportCost <- passportCost %>% select(-popn2004, -migrants, -gdp,
                                        -flowuscanz, -migprop)

# create a function called DisplayAllHistogram that takes in a tibble parameter
# that will display a histogram for all numeric feature in the tibble
displayAllHistogram <- function(tibbleDataset) {
  tibbleDataset %>%
    keep(is.numeric) %>%
    gather() %>%
    ggplot() + geom_histogram(mapping = aes(x = value, fill = key),
                              color = "black") +
    facet_wrap(~key, scales = "free") +
    theme_minimal()}

# call the displayAllHistogram function, passing in distribution as an argument
displayAllHistogram(passportCost)

# Dispaly the scatterplot for all contineous variables in the model wrt cost
plot(passportCost$cost, passportCost$logGDP)
plot(passportCost$cost, passportCost$voice)
plot(passportCost$cost, passportCost$politicalstability)
plot(passportCost$cost, passportCost$govteffectiveness)
plot(passportCost$cost, passportCost$regulatory)
plot(passportCost$cost, passportCost$ruleoflaw)
plot(passportCost$cost, passportCost$corruption)
plot(passportCost$cost, passportCost$LogPopn)
plot(passportCost$cost, passportCost$Logmigrant)
plot(passportCost$cost, passportCost$LogInvMigprop)

# Display the boxplot for factor variables
boxplot(cost ~ region, data = passportCost)
boxplot(cost ~ restrict, data = passportCost)
boxplot(cost ~ commonwealth, data = passportCost)
boxplot(cost ~ language, data = passportCost)

# fitting the linear model with all variables except country name and code
passportCostModel0 <- lm(data = passportCost,
                         formula = cost ~ .-country_name -code)

# Display summary for the fitted model
summary(passportCostModel0)

# Display the correlation matrix
round(cor(passportCost %>% keep(is.numeric)),2)

corrplot(round(cor(passportCost %>% keep(is.numeric)),2),
         method = "number",
         type = "lower")

# there is high correlation between ruleoflaw$govteffectiveness and
# corruption$ruleoflaw and regulatory thus removing them form analysis
passportCost1 <- passportCost %>% select(-ruleoflaw, 
                                         -govteffectiveness, - regulatory)

# Display the correlation matrix
round(cor(passportCost1 %>% keep(is.numeric)),2)

# Again display the correlation matrix
corrplot(round(cor(passportCost1 %>% keep(is.numeric)),2),
         method = "number",
         type = "lower")

# fitting the linear model based
passportCostModel1 <- lm(data = passportCost1,
                         formula = cost ~ .-country_name -code)

# Display summary for the initial fitted model
summary(passportCostModel1)

# checking multicollinearity
vif(passportCostModel1)

# plot between fitted values and residuals
plot(passportCostModel1$fitted.values, passportCostModel1$residuals)

# Use Anova( ) to find sequential sums of squares
Anova(passportCostModel1, type = "III")

# correlation between Cost and the variables with GVIF over 1000
cor(passportCost %>% select(cost, LogPopn, Logmigrant, LogInvMigprop))
corrplot(cor(passportCost1 %>% 
               select(cost, LogPopn, Logmigrant, LogInvMigprop)),
         method = "number",
         type = "lower")

# from the corrplot it is seen that LogInvMigprop has the lowest correlation 
# with Cost, thus removing it from the model and re modeling it
passportCostModel2 <- lm(data = passportCost1,
                         formula = cost ~ voice + politicalstability + 
                           corruption + region + restrict + commonwealth +
                           language + LogPopn + Logmigrant + logGDP )

# Display summary for the modified fitted model
summary(passportCostModel2)
formula(passportCostModel2)

# checking multicollinearity
vif(passportCostModel2)

# Display the correlation matrix
round(cor(passportCost %>% keep(is.numeric)),2)

# plot between fitted values and residuals
plot(passportCostModel2$fitted.values, passportCostModel2$residuals)

# Check for normally distributed error through qqPlot
qqPlot(rstudent(passportCostModel2), distribution="t", df=106, pch=16,
       ylab="Studentized Residuals")

# Use Anova( ) to find sequential sums of squares.
Anova(passportCostModel2, type = "III")

# final model from regression analysis
passportCostModel3 <- lm(data = passportCost1,
                         formula = cost ~ politicalstability + region + logGDP)
# Display summary for the fitted model
summary(passportCostModel3)
vif(passportCostModel3)

# Use Anova( ) to find sequential sums of squares.
Anova(passportCostModel3, type = "III")

# The goal of the problem is to develop a explanatory model thus starting with
# BIC penalized liklihood method for analysing various models

# forward stepwise with BIC,
passportCostBase <- lm(cost ~ 1, data = passportCost)

passportCost.stepfB <- step(passportCostBase, formula(passportCostModel0),
                            direction="forward", k = log(nrow(passportCost)))

# Summary of passportCost.stepfB
summary(passportCost.stepfB)

# Backward stepwise with BIC
passportCost.stepbB <- step(passportCostModel0, formula(passportCostModel0),
                            direction="backward", k = log(nrow(passportCost)))

# Summary of passportCost.stepfB
summary(passportCost.stepbB)

# bothstepwise with BIC, here is the command.
passportCost.stepboB <- step(passportCostBase, formula(passportCostModel0),
                             direction="both", k = log(nrow(passportCost)))

# Summary of passportCost.stepboB
summary(passportCost.stepboB)

# formula from stepwise selection
# when selection is done in forward direction
formula(passportCost.stepfB)

# when selection is done in backward direction
formula(passportCost.stepbB)

# when selection is done in both direction
formula(passportCost.stepboB)

# using subset selection process for doing all selection process at one
#Create a data frame for the x predictors we want to use in bess.
passportCost.bessx <- passportCost[,c(4,5,6,7,8,9,14,15,16,17)]


# The bess command has options: x matrix, y variable, family="gaussian" 
# for linear and family="binomial" for logistic, method="sequential",
# factor= a vector using c( ) with column numbers that should be factors.

passportCost.bess1 <- bess(passportCost.bessx, passportCost$cost,
                           family="gaussian", method="sequential")

summary(passportCost.bess1)
coef(passportCost.bess1)

# Final explanatory model for passport cost
passportCostExplanatoryModel <- lm(data = passportCost1,
                                   formula = cost ~ politicalstability + logGDP)

# Display summary for the final fitted explanatory model
summary(passportCostExplanatoryModel)

# checking multicollinearity
vif(passportCostExplanatoryModel)

# plot between fitted values and residuals
plot(passportCostExplanatoryModel$fitted.values, 
     passportCostExplanatoryModel$residuals)

# Check for normally distributed error through qqPlot
qqPlot(rstudent(passportCostExplanatoryModel), distribution="t", df=122, pch=16,
       ylab="Studentized Residuals")
