# 🏠 CMA Housing Affordability Analysis (2000–2025)

This repository contains an R-based statistical analysis of housing affordability across major Canadian Metropolitan Areas (CMAs) using data from BC Stats and Statistics Canada.

## 📌 Research Question

**How do local market activity (number of quarterly resales) and borrowing costs (Prime Interest Rate) jointly explain variations in housing affordability (measured as Payment to Income Percent), across Canadian Metropolitan Areas, from 2000 through Q1 2025, accounting for regional effects?**

## 📊 Data Source

- **Primary Dataset**: `cma_quarterly_results_filtered_202506161001.csv`
- **Source**: BC Stats – [B.C. Housing Affordability Data](https://catalogue.data.gov.bc.ca/dataset/b-c-housing-affordability)
- Includes:
  - Median family income (StatsCan)
  - Median house prices (BC Assessment)
  - Prime interest rate (Bank of Canada)
  - Resale counts (BCA)

## 🧪 Methods

- Multiple linear regression models were fitted:
  - **Additive model**
  - **Log-transformed response model**
  - **Interaction models**
- Main predictors:
  - `Prime Interest Rate`
  - `Number of Resales`
  - `CMA` region
- Diagnostic tools:
  - Residual plots
  - QQ plots
  - VIF (Variance Inflation Factor) for collinearity check

## ✅ Main Findings

- **Vancouver** has consistently higher housing burden than other CMAs.
- **Prime interest rate** is strongly positively associated with housing burden.
- **Resale activity** has a small but significant effect.
- **Best model** includes interaction terms between region and number of resales, improving model fit (Adj R² ≈ 0.4093).
- Log-transformation stabilized variance and improved residual normality.

## 📂 Files

| File | Description |
|------|-------------|
| `housing_affordability_modeling.R` | Full R script for data cleaning, plotting, and modeling |
| `housing_affordability_analysis.Rmd` | R Markdown report version (for knitting HTML/PDF) |
| `.gitignore` | Ignore RStudio/project cache and knitr output |
| `README.md` | This file |

> Note: The raw CSV file is **not included**. Please place your file in the root directory and ensure the name matches exactly.

## ▶️ How to Run

In RStudio or R console:

```r
install.packages(c("tidyverse", "dplyr", "car"))
setwd("your/project/path")  # Ensure the CSV is present
source("housing_affordability_modeling.R")
