# 🧭 Passport Cost Analysis – Explanatory Modeling using R

### 📘 **Overview**
This project analyzes the determinants of **passport cost variations across 125 countries**, using multiple governance and socioeconomic indicators.  
The goal is to build an **explanatory regression model** in **R** to identify how factors such as **political stability**, **government effectiveness**, and **economic strength (GDP)** influence passport pricing.

---

### 🎯 **Objective**
To explain and quantify how political and economic variables impact passport cost globally, and to identify key drivers influencing variations in administrative pricing among countries.

---

### 🧩 **Dataset**
- **Source:** Custom-compiled dataset (`passportcosts.csv`) from publicly available governance and economic indicators.  
- **Observations:** 125 countries  
- **Key Variables:**

| Variable | Description |
|-----------|-------------|
| `cost` | Passport cost (in USD) |
| `gdp` | GDP per capita |
| `politicalstability` | World Governance Indicator |
| `voice` | Voice & accountability index |
| `govteffectiveness` | Government effectiveness |
| `regulatory`, `ruleoflaw`, `corruption` | Institutional governance metrics |
| `region`, `restrict`, `commonwealth`, `language` | Categorical factors |
| `popn2004`, `migrants`, `migprop`, `flowuscanz` | Demographic indicators |

---

### ⚙️ **R Libraries Used**
```r
library(tidyverse)
library(dummies)
library(scales)
library(corrplot)
library(olsrr)
library(car)
library(BeSS)
```

---

### 🧠 **Methodology**
1. **Data Import & Cleaning:**  
   - Imported CSV using `read_csv()`  
   - Removed redundant columns and handled missing data.  

2. **Feature Engineering:**  
   - Created log-transformed variables for population, migrants, and GDP to normalize skewed data.  
   - Removed highly correlated variables using correlation matrices and `corrplot`.  

3. **Model Development:**  
   - Built multiple **linear regression models** (`lm()`) using different sets of predictors.  
   - Evaluated **multicollinearity** using `vif()` and removed redundant variables.  
   - Used **ANOVA (Type III)** tests to determine variable significance.  
   - Applied **stepwise model selection** (forward, backward, both) with **BIC** penalty to identify parsimonious models.  
   - Used **Best Subset Selection (BeSS)** to validate key predictors.  

4. **Model Refinement:**  
   - Final model derived from both **stepwise** and **BeSS** methods:  
     \[
     \text{cost} = \beta_0 + \beta_1(\text{politicalstability}) + \beta_2(\log(\text{GDP}))
     \]
   - Verified residual normality using **QQ plots** and assessed homoscedasticity via residual plots.  

---

### 📊 **Results Summary**
| Model | Significant Predictors | Adj. R² | Key Insights |
|--------|------------------------|----------|---------------|
| Full Model | Many (high collinearity) | 0.11 | Multicollinearity present among governance indicators |
| Refined Model | Political Stability, log(GDP) | **0.095** | Passport costs rise with GDP, decrease with political instability |
| Stepwise BIC | Political Stability, Regulatory Quality, Corruption, log(GDP) | 0.14 | Governance and economy jointly shape passport pricing |
| BeSS Model | Political Stability, log(GDP) | **Best explanatory model** | Simplified yet robust |

---

### 💡 **Key Insights**
- **Higher GDP per capita** countries tend to charge **more for passports**, reflecting higher administrative and service costs.  
- **Improved political stability** correlates with **lower passport costs**, suggesting more efficient governance structures.  
- Governance indicators such as **corruption and regulatory quality** play secondary but noticeable roles.  

---

### 🧾 **Final Model Summary**
**Final Explanatory Equation:**  
\[
\text{Passport Cost} = -59.43 - 18.64(\text{Political Stability}) + 13.73(\log(\text{GDP}))
\]

**Model Fit:**  
- Adjusted R² = **0.095**  
- F-statistic = **7.52 (p < 0.001)**  
- VIF values < 2.3 ⇒ No multicollinearity issues.  

---

### 🚀 **How to Run**
1. Clone the repository:  
   ```bash
   git clone https://github.com/yourusername/PassportCostAnalysis.git
   ```
2. Open R or RStudio and set the working directory to the project folder:  
   ```r
   setwd("path_to_your_folder/PassportCostAnalysis")
   ```
3. Run the script:  
   ```r
   source("PassportCostAnalysis.R")
   ```

---

### 📈 **Visualization Examples**
- `corrplot()` — Visualizes correlations among variables.  
- `boxplot()` — Compares cost across categorical variables (region, language, etc.).  
- `qqPlot()` — Tests normality of residuals.  

---

### 💼 **Business Relevance**
This analysis helps policymakers and global administrative bodies **benchmark passport pricing** by:  
- Identifying governance inefficiencies driving administrative costs.  
- Understanding regional economic disparities.  
- Promoting equitable pricing strategies aligned with income levels and institutional quality.

---

### 👩‍💻 **Author**
**Kaushlendra Kumar Verma**  
Master’s in Business Analytics, University of Arizona  
📧 [Your Email or LinkedIn URL]
