# Kaushlendra Kumar Verma
# MIS Practice chapter 4
# week04LinearRegression.R

# setwd("C:/Users/User/OneDrive - University of Arizona/MSBA/09_Data Mining_MIS 545 301-7W1/Week 4")

# Install the tidyverse and dummies package
# install.packages("tidyverse")
# install.packages("dummies", repos = NULL, type="source")
# install.packages("corrplot")


# Load the tidyverse, scale and dummies packages
library(tidyverse)
library(dummies)
library(scales)
library(corrplot)
library(olsrr)

healthInsurance <- read_csv(file = "HealthInsurance.csv", 
                            col_types = "ifniffn",
                            col_names = TRUE)

# Display the healthinsurance tibble on the console
print(healthInsurance)

# Display the structure of the healthInsurance tibble
str(healthInsurance)

# Display the summary of the healthinsurance tibble
summary(healthInsurance)

# remove the charges outliers
# determine outliers in the charges feature
# calclate outlier min and max and store into variable called outliermin and
# outliermax
outlierMin <- quantile(healthInsurance$Charges, 0.25) -
  (IQR(healthInsurance$Charges) * 1.5)
outlierMax <- quantile(healthInsurance$Charges, 0.75) +
  (IQR(healthInsurance$Charges) * 1.5)

# remove the outliers from the dataset 
healthInsurance <- healthInsurance %>% 
  filter(Charges >= outlierMin & Charges <= outlierMax)

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

# call the displayAllHistogram function, passing in healthInsurance as an 
# argument
displayAllHistogram(healthInsurance)

# convert healthInsurance into a data.frame()
healthInsuranceDataFrame <- data.frame(healthInsurance)

# dummy code Sex, smoker and region using dummy.data.frame(), convert it back
# into a tibble, and store the result back in to the original tibble.
healthInsurance <- as_tibble(dummy.data.frame(data = healthInsuranceDataFrame,
                                              names = c("Sex",
                                                        "Smoker",
                                                        "Region")))

# display the healthInsurance tibble on the console
print(healthInsurance)

# Drop the sexmale, smokerno and Regionssouthwest features
healthInsurance <- select(.data = healthInsurance, 
                          -Sexmale,
                          -Smokerno,
                          -Regionsouthwest)
# Rename some variables using the rename() function to shorten them so more fits 
#  on the console.
# format: newName = oldName

healthInsurance <- rename(.data = healthInsurance,
                          Female = Sexfemale,
                          Smoker = Smokeryes,
                          RegionSE = Regionsoutheast,
                          RegionNW = Regionnorthwest,
                          RegionNE = Regionnortheast)

#  pairwise correleation between RegionSE and BMI
cor(healthInsurance$RegionSE, healthInsurance$BMI)

#  Display corrrelation matrix
cor(healthInsurance)

# if the tibble has non numeric values, limit the correlation to a 
# numeric values to prevent errors.
cor(healthInsurance %>% keep(is.numeric))

# Round the correlation matrix to  two decimal places
round(cor(healthInsurance),2)

# Display the correlation plot
corrplot(cor(healthInsurance),
         method = "circle")
# Limit correlation plot to bottom left
corrplot(cor(healthInsurance),
         method = "circle",
         type = "lower")
# Method options include: circle, square, elipse, color, shade, pie, and number
corrplot(cor(healthInsurance),
         method = "square",
         type = "lower")
corrplot(cor(healthInsurance),
         method = "ellipse",
         type = "lower")
corrplot(cor(healthInsurance),
         method = "color",
         type = "lower")
corrplot(cor(healthInsurance),
         method = "shade",
         type = "lower")
corrplot(cor(healthInsurance),
         method = "pie",
         type = "lower")
corrplot(cor(healthInsurance),
         method = "number",
         type = "lower")

# Generate the linear regression model
healthInsuranceModel <- lm(data = healthInsurance,
                           formula = Charges~Age + Female + BMI + Children + Smoker
                           +RegionSE + RegionNW + RegionNE)

# if using all the remaining features we can use the period instead of 
# listng all the parameters individually
healthInsuranceModel <- lm(data = healthInsurance,
                           formula = Charges~ .)

# Display the beta coefficient for the model on the console
print(healthInsuranceModel)

# Display the linear regression model result using sumarry function 
summary(healthInsuranceModel)

# Test for multicollinearity
ols_vif_tol(healthInsuranceModel)

















