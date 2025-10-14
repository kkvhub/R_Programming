# Kaushlendra Kumar Verma
# MIS 545
# Adam Sandler films Clustring 

# Import a dataset of Adam Sandler films and generate a model to discover 
# pattern among the films

# Install the tidyverse and factoextra packages
# install.packages("tidyverse")
# install.packages("factoextra")

# Load the tidyverse and facoretra packages
library(tidyverse)
library(stats)
library(factoextra)
library(cluster)
library(gridExtra)

# Read SandlerFilms.csv into a tibble called sandlerFilms
# l for logical
# n for numerical 
# i for integer
# c for character
# f for factor
# D for date
# T for datetime
sandlerFilms <- read_csv(file = "SandlerFilms.csv",
                         col_types = "cnn",
                         col_names = TRUE)

# Display the sandlerFilms tibble on the console
print(sandlerFilms)

# Display the stucture of the sandlerFilms tibble   
str(sandlerFilms)

# Display the summary of sandlerFilms tibble  
summary(sandlerFilms)

# Convert the column containing the film title to he row title of the tibble.
# this is a requirement for later visualizing the clusters.
sandlerFilms <- sandlerFilms %>% column_to_rownames(var = "Title")
sandlerFilms <- sandlerFilms %>% select(-...4)

# Scale both features in the tibble so they have equal impact on the clustring 
# calculations
sandlerFilmsScaled <- sandlerFilms %>% 
  select(CriticRating,BoxOffice) %>% scale()

# Select the ramdom seed to 1780
set.seed(1780)

# generate the K-mean cluster
sandlerFilms4Cluster <- kmeans(x = sandlerFilmsScaled,
                               centers = 4,
                               nstart = 25)

# Display the cluster size
sandlerFilms4Cluster$size

# Display tcluster centres (z- scores)
sandlerFilms4Cluster$centers

# Visualize the clusters
fviz_cluster(object = sandlerFilms4Cluster,
             data = sandlerFilmsScaled,
             repel = FALSE)

# Optimizing the values for K
# Elbow method
fviz_nbclust(x = sandlerFilmsScaled,
             FUNcluster = kmeans,
             method = "wss")

# Average Silhouette method
fviz_nbclust(x = sandlerFilmsScaled,
             FUNcluster = kmeans,
             method = "silhouette")

# Gap statistics method
fviz_nbclust(x = sandlerFilmsScaled,
             FUNcluster = kmeans,
             method = "gap_stat")

# Regenerate the analysis by optimum number of clusters
# generate the K-mean cluster
sandlerFilms3Cluster <- kmeans(x = sandlerFilmsScaled,
                               centers = 3,
                               nstart = 25)

# Display the cluster size
sandlerFilms3Cluster$size

# Display tcluster centres (z- scores)
sandlerFilms3Cluster$centers

# Visualize the clusters
fviz_cluster(object = sandlerFilms3Cluster,
             data = sandlerFilmsScaled,
             repel = FALSE)














