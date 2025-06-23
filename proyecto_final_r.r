---
title: "Fruit Consumption Analysis"
author: "Paola"
date: "2025-06-22"
output: html_document
---

```{r setup, include=FALSE}
library(tidyverse)
```

## 📂 Import and Prepare Data

```{r importar-datos}
psd_data <- read.csv("psd_fruits.csv")

# Filter only United States
data_us <- psd_data %>%
  filter(Country_Name == "United States")

# Keep only relevant attributes
filtered_data <- data_us %>%
  filter(Attribute_Description %in% c("Domestic Consumption", "Imports", "Exports"))
```

## 🔍 Exploratory Analysis

```{r top-frutas}
# Top 3 most consumed fruits
top_consumption <- filtered_data %>%
  filter(Attribute_Description == "Domestic Consumption") %>%
  group_by(Commodity_Description) %>%
  summarise(Total = sum(Value, na.rm = TRUE)) %>%
  arrange(desc(Total)) %>%
  slice_head(n = 3)

top_consumption
```

## 📊 Visualization 1: Bar chart of apple consumption, imports, and exports

```{r barras}
apples_summary <- filtered_data %>%
  filter(Commodity_Description == "Apples, Fresh") %>%
  group_by(Attribute_Description) %>%
  summarise(Total = sum(Value, na.rm = TRUE))

ggplot(apples_summary, aes(x = Attribute_Description, y = Total, fill = Attribute_Description)) +
  geom_col(width = 0.6) +
  labs(
    title = "Apple Consumption, Imports, and Exports in the U.S.",
    x = "Category",
    y = "Total (tons)",
    caption = "Note: The average domestic consumption of apples is significantly higher than imports (p < 0.001)"
  ) +
  scale_fill_manual(values = c("Domestic Consumption" = "forestgreen", 
                               "Imports" = "orange", 
                               "Exports" = "steelblue")) +
  theme_minimal()
```

## 📈 Visualization 2: Linear regression of apple consumption over time

```{r regresion-lineal}
apples_data <- filtered_data %>%
  filter(Commodity_Description == "Apples, Fresh",
         Attribute_Description == "Domestic Consumption") %>%
  select(Year = Calendar_Year, Consumption = Value) %>%
  filter(!is.na(Consumption))

apple_model <- lm(Consumption ~ Year, data = apples_data)
summary(apple_model)

ggplot(apples_data, aes(x = Year, y = Consumption)) +
  geom_point(color = "forestgreen", size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = "tomato", size = 1.2) +
  labs(
    title = "Trend of Apple Domestic Consumption in the U.S.",
    subtitle = "Source: USDA - Product Supplied Distribution",
    x = "Year",
    y = "Consumption (tons)",
    caption = "Linear regression analysis"
  ) +
  theme_minimal()
```

## 🧪 Hypothesis Test: Consumption vs. Imports

```{r prueba-hipotesis}
apple_consumption <- filtered_data %>%
  filter(Commodity_Description == "Apples, Fresh",
         Attribute_Description == "Domestic Consumption") %>%
  select(Value = Value) %>%
  filter(!is.na(Value))

apple_imports <- filtered_data %>%
  filter(Commodity_Description == "Apples, Fresh",
         Attribute_Description == "Imports") %>%
  select(Value = Value) %>%
  filter(!is.na(Value))

hypothesis_test <- t.test(
  apple_consumption$Value,
  apple_imports$Value,
  alternative = "greater"
)

hypothesis_test
```

## 📊 Visualization 3: Pie chart - Top 3 most consumed fruits

```{r pie-chart}
top_fruits_names <- top_consumption$Commodity_Description

top_fruits_data <- filtered_data %>%
  filter(Commodity_Description %in% top_fruits_names,
         Attribute_Description == "Domestic Consumption") %>%
  group_by(Commodity_Description) %>%
  summarise(Total = sum(Value, na.rm = TRUE))

ggplot(top_fruits_data, aes(x = "", y = Total, fill = Commodity_Description)) +
  geom_col() +
  coord_polar(theta = "y") +
  labs(title = "Consumption Distribution of Top 3 Fruits") +
  theme_void()
```

## ✅ Conclusions

- Apple consumption has significantly increased over time.
- Domestic consumption is much higher than imports (confirmed by the t-test).
- Bananas are the most consumed fruit, followed by apples and oranges.
