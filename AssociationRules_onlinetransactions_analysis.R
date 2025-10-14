# Kaushlendra Kumar Verma
# MIS 545
# AssocoationRule for online transactions

# Import a dataset of online transactions and generate a model to discover 
# association rules among the product

# Install the tidyverse and neuralnetwork packages
# install.packages("tidyverse")
# install.packages("arules")


# Load the tidyverse and neuralnet packages
library(tidyverse)
library(arules)

# Set the working directory
# setwd("K:/MSBA/09_Data Mining_MIS 545 301-7W1/Week 7")

# Read RetailSingle.csv into a tibble called onlineTransactions
# l for logical
# n for numerical 
# i for integer
# c for character
# f for factor
# D for date
# T for datetime
onlineTransactions <- read.transactions(file = "RetailSingle.csv",
                                        format = "single",
                                        header = TRUE,
                                        sep = ",",
                                        cols = c("OrderID", "ItemID"))

# Display the summary of onlineTransactions
summary(onlineTransactions)

# Display the first three transactions in the console
inspect(onlineTransactions[1:3])

# Examin the frequency of a single item (22423 - 3 tier cake stand)
itemFrequency(onlineTransactions[,"22423"])

# Convert the frequency vallues in onlineTransactions to a tibble.
onlineTransactionsFrequency <- 
  tibble(Items = names(itemFrequency(onlineTransactions)),
         Frequency = itemFrequency(onlineTransactions))

# Display the item frequencies on the tibble
print(onlineTransactionsFrequency)

# Display the 10 most frequently purchased items on the console
onlineTransactionsFrequency %>%
  arrange(desc(Frequency)) %>%
  slice(1:10)

# Generate the association rules model
# (373 days of data 25,900 transactions)
# Include items that were purchased on average at least once per day
onlineTransactionsRules <-
  apriori(onlineTransactions,
          parameter = list(
            support = (1 * 373) / 25900,
            confidence = 0.5,
            minlen = 2))

# Display a summary of association rules
summary(onlineTransactionsRules)

# Display the first 10 association rules
inspect(onlineTransactionsRules[1:10])

# Sort the association rules by lift and view the top 10
onlineTransactionsRules %>% 
  sort(by = "lift") %>% 
  head(n = 10) %>% 
  inspect()



