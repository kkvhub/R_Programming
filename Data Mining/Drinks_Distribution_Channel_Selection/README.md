# 🥤 Data Mining Project – Pepsi Drinks Distribution Channel Selection

**Authors:** Kaushlendra Kumar Verma, Rama Subba Reddy, Lovely Kumari & Yanyun Wu  
**Course:** MIS 545 – Data Mining  
**Institution:** Eller College of Management, University of Arizona  
**Project Type:** Group Project  
**Technologies Used:** R (Tidyverse, rpart, e1071, class, corrplot, SMOTE)  

---

## 📘 Project Overview

This project applies **supervised machine learning models** in R to predict the 
**optimal distribution channel (Direct vs Indirect)** for **Pepsi** across 
**target location**.  
The goal is to enable **data‑driven decisions** for selecting efficient 
distribution channels based on **demographics, market type, 
and revenue potential**.

Models compared:

- Logistic Regression  
- Decision Tree (rpart)  
- Naïve Bayes (e1071)  
- k‑Nearest Neighbors (class)

---

## 📂 Repository Structure

```
R_Programming/
└── Data Mining/
    └── DrinksDistributionChannelSelection/
        ├── data/
        ├── scripts/
        ├── output/
        │   ├── confusion_matrices/
        │   ├── model_accuracy_plots/
        │   └── correlation_plots/
        └── README.md
```

---

## 📑 Dataset Description

| Variable | Type | Description |
|-----------|------|-------------|
| `Location` | Character | District name |
| `Population` | Numeric | District population |
| `PopulationType` | Factor | Category of population (FTP, TLP, FLP, OLP, UFTP) |
| `Market` | Factor | Type of market (Rural Towns, Semi Urban, Urban, Rural Villages) |
| `PotentialRevenue` | Numeric | Expected annual revenue potential (₹) |
| `PresentRevenue` | Numeric | Current annual revenue (₹) |
| `Vehicles` | Integer | Number of vehicles servicing the region |
| `Distribution` | Factor | Target variable: `Direct` or `Indirect` |

---

## ⚙️ Workflow

### **1️⃣ Data Pre‑processing**
- Removed non‑predictive variables (`Location`, `Population`)
- Dropped `PresentRevenue` due to > 90% missing values
- Transformed `PotentialRevenue` (log scale for normalization)
- Encoded categorical variables using `dummies`
- Handled class imbalance using `SMOTE` oversampling
- Removed multicollinear features based on correlation analysis (`corrplot`)

### **2️⃣ Exploratory Data Analysis**
- Histograms for `Vehicles` and `PotentialRevenue`
- Boxplots and scatterplots to visualize market‑wise and population‑wise patterns
- Correlation matrix to detect collinear predictors

### **3️⃣ Model Training & Evaluation**
| Model | Key Steps | Accuracy | FPR | FNR | Key Findings |
|:------|:-----------|:----------|:----|:----|:--------------|
| **Decision Tree (rpart)** 
| `cp = 0.0001` → simple structure & high stability | 99.27 % | 0 % | 6.25 % 
| Highly accurate, clear rule‑based splits |
| **Naïve Bayes (e1071)** 
| Binned numeric vars into 10 equal frequency bins 
| 99.27 % | 0 % | 6.67 % | Performs well even with moderate data imbalance |
| **Logistic Regression** 
| Log‑transform + dummy encoding + SMOTE | 94.89 % | 5.78 % | 0 % 
| `Vehicles` & `PotentialRevenue` significant predictors |
| **k‑Nearest Neighbors** 
| Optimal k = 39 (√n rounded to odd) | 97.44 % | 2.47 % | 3.12 % 
| Balanced performance with low error rates |

---

## 📊 Key Insights

- **Urban markets** and **higher revenue zones** favor **Direct Distribution**.  
- **Rural and low‑vehicle density areas** are best served via **Direct Distribution**.  
- **Potential Revenue** and **Vehicles** are the most influential predictors across models.  
- **Decision Tree** and **Naïve Bayes** achieved the highest predictive accuracy (> 99 %).  

---

## ▶️ How to Run

1. Clone the repository or download the project folder.  
2. Place `DrinksDistributionDatasetMasterFile.csv` inside the `data/` directory.  
3. Open `DrinksDistributionChannelSelection.R` in RStudio.  
4. Run the script step‑by‑step to view EDA, model training outputs and plots.  
5. Confusion matrices and accuracy metrics will appear in the console.

---

## 🧠 Managerial Implications

- Pepsi can **prioritize indirect distribution** in **urban markets** to leverage existing network efficiencies.  
- **Direct distribution** remains optimal for rural districts with limited vehicle availability and lower revenue potential.  
- Data‑driven modeling can substantially reduce logistical inefficiencies and optimize route planning.

---

## 🏆 Summary Table

| Model | Accuracy | FPR | FNR | Most Important Predictors |
|:------|:----------|:----|:----|:--------------------------|
| Logistic Regression | 94.89 % | 5.78 % | 0 % | Vehicles, Potential Revenue |
| k‑Nearest Neighbors | 97.44 % | 2.47 % | 3.12 % | Vehicles, Revenue Clusters |
| Naïve Bayes | 99.27 % | 0 % | 6.67 % | Binned Vehicles, Revenue |
| Decision Tree | 99.27 % | 0 % | 6.25 % | Vehicles, Revenue, Market Type |

---

## 📜 License & Credits

This project was developed as part of **MIS 545 – Data Mining** coursework  
at the **University of Arizona**, Eller College of Management.

© 2025 Kaushlendra Kumar Verma, Rama Subba Reddy, Lovely Kumari & Yanyun Wu.  
All rights reserved.
