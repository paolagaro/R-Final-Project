R-Final-Project
Analysis of fresh fruit consumption, imports, and exports in the U.S., with a focus on apples.

📊 Dataset:
Nombre: Product Supplied Distribution of Fruits and Vegetables
Fuente: USDA (https://apps.fas.usda.gov/psdonline/)
Formato: CSV
Filtrado: Solo EE.UU., categorías de consumo doméstico, importaciones y exportaciones.

🍎 Fruit Consumption Analysis in the U.S.

📌 Project Overview

This project explores the domestic consumption, imports, and exports of fresh fruits in the United States using USDA data. The main goal is to identify the most consumed fruits and analyze trends over time—especially for apples.

---

📂 Dataset

- Source: USDA - Product Supplied Distribution (https://apps.fas.usda.gov/psdonline/)
- Format: CSV
- Filters applied
  *Country: United States
  * Attributes: Domestic Consumption, Imports, Exports
  * Fruits: All, with a focus on apples



🧹 Data Preparation

- The dataset was imported using `read.csv()`
- I filtered for data related only to the U.S.
- I used the `dplyr` package to:
  * Select relevant attributes
  * Group and summarize totals by fruit and category
  * Find the top 3 most consumed fruits



📊 Exploratory Analysis

The top 3 most consumed fruits (by total domestic consumption) were:

1. Apples  
2. Peaches 
3. pears

I also calculated total values for consumption, imports, and exports, and created summary plots.



📈 Linear Regression

To check if apple consumption has increased over time, I ran a linear regression using:

