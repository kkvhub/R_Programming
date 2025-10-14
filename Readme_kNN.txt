# 🚗 K-Nearest Neighbour (KNN) Prediction Model – Sedan Size Classification
**Author:** Kaushlendra Kumar Verma  
**Course:** MIS 545 – Data Mining  
**Lab ID:** kNN_Programming 

---

## 📘 Overview
This project demonstrates **supervised learning** using the **K-Nearest Neighbour (KNN)** algorithm in R to predict the **size category of sedans** based on their numerical features.  

The goal is to:
- Perform **data preprocessing** and exploration  
- Build and evaluate a **KNN classification model**  
- Identify the optimal **k-value** that yields the highest predictive accuracy  

---

## 🧰 Packages Used
| Package | Purpose |
|----------|----------|
| `tidyverse` | Data wrangling, visualization, and manipulation |
| `class` | Provides the `knn()` function for K-Nearest Neighbour classification |
| `corrplot` | Visualizing correlation matrices (optional for data exploration) |

Install required packages (if not already installed):
```r
install.packages(c("tidyverse", "class", "corrplot"))
