# 🌾 Decision Tree Modeling – Indonesian Rice Farm Ownership

**Author:** Kaushlendra Kumar Verma  
**Course:** MIS 545 – Data Mining  
**Model Type:** Decision Tree Classification  
**Dataset:** `IndonesianRiceFarms.csv`  

---

## 📘 Project Overview

This R project applies a **decision tree classifier** to predict farm ownership 
status in Indonesian rice farms using several farm characteristics. The model is 
built using the `rpart` and `rpart.plot` libraries in R.

---

## 📂 Folder Structure

```
data_mining/
└── decision_tree_rice_farm/
    ├── data/
    │   └── IndonesianRiceFarms.csv
    ├── scripts/
    │   └── riceFarm_decision_tree.R
    ├── output/
    │   └── (decision tree plots, accuracy screenshots)
    └── README.md
```

---

## 📑 Data Description

The dataset `IndonesianRiceFarms.csv` contains the following variables:

| Variable | Type | Description |
|----------|------|-------------|
| `FarmOwnership` | Factor | Target variable indicating ownership status |
| `Area` | Numeric | Area of the farm |
| `LandPreparationCost` | Integer | Cost of land preparation |
| `FertilizerCost` | Integer | Cost of fertilizer |
| `LabourCost` | Integer | Cost of labor |
| `SeedCost` | Integer | Cost of seeds |
| `RiceYield` | Numeric | Total rice produced |

---

## ⚙️ Steps Performed

1. **Load Data**  
   - Read and inspect `IndonesianRiceFarms.csv`

2. **Split Data**  
   - 75% for training  
   - 25% for testing

3. **Build Decision Tree Model**  
   - Using `rpart()` with `cp = 0.01` and `cp = 0.007`  
   - Visualized using `rpart.plot()`

4. **Evaluate Model**  
   - Predictions on test data  
   - Confusion matrix  
   - Predictive accuracy calculated and displayed

---

## 📊 Example Output

```
Confusion Matrix:
             Predicted
Actual       Yes   No
    Yes      28    3
    No        2   32

Predictive Accuracy: 0.93
```

---

## 🧰 Required Libraries

Install these if not already available:

```r
install.packages("tidyverse")
install.packages("rpart")
install.packages("rpart.plot")
```

---

## ▶️ How to Run

1. Place `IndonesianRiceFarms.csv` in the `data/` folder  
2. Open `riceFarm_decision_tree.R` inside RStudio  
3. Run the script step-by-step or all at once  
4. Visualizations and confusion matrix will be displayed

---

## 🧠 Insights

- Decision trees provide clear visual explanations of splits
- Predictive accuracy is high with minimal overfitting at `cp = 0.007`
- Farm cost and yield-related variables are important predictors

---

## 📜 License

This project is developed as part of the academic requirements for MIS 545 at 
the University of Arizona.

© 2025 Kaushlendra Kumar Verma. All rights reserved.
