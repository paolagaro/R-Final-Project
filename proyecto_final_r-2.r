---
title: "Fruit Consumption Analysis"
author: "Paola Baez"
date: "2025-06-22"
output: html_document
---

```{r setup, include=FALSE}
library(tidyverse)
library(dplyr)
```

## 📂 Import and Prepare Data

```{r importar-datos}
psd_data <- read.csv("psd_fruits.csv")

# Data verification
head(psd_data)
nrow(psd_data)
colnames(psd_data)
psd_data <- psd_data[!is.na(psd_data$Country_Name), ]

# Filter only United States
df_us <- psd_data %>%
  filter(trimws(Country_Name) == "United States")
```

## 🔍 Exploratory Analysis

```{r top-frutas}
# Top 3 most consumed fruits
top_domestic <- df_us %>%
  filter(Attribute_Description == "Domestic Consumption") %>%
  group_by(Commodity_Description) %>%
  summarise(total_consumption = sum(Value, na.rm = TRUE)) %>%
  arrange(desc(total_consumption)) %>%
  slice_head(n = 3)
top_domestic
```

```{r prepare-top3-data}
top3_fruits <- top_domestic$Commodity_Description

top3_data <- df_us %>%
  filter(Commodity_Description %in% top3_fruits,
         Attribute_Description %in% c("Domestic Consumption", "Imports", "Exports"))
```

## 📊 Visualization 1: Bar chart - Top 3 Fruits

```{r bar-chart}
top3_summary <- top3_data %>%
  group_by(Commodity_Description, Attribute_Description) %>%
  summarise(total = sum(Value, na.rm = TRUE))

ggplot(top3_summary, aes(x = Commodity_Description, y = total, fill = Attribute_Description)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Fruit Consumption, Imports, and Exports in the U.S.",
       x = "Fruit",
       y = "Total (tons)",
       fill = "Category") +
  theme_minimal()
```

## 📈 Visualization 2: Linear Regression - Apples

```{r regresion-lineal}
apples_data <- df_us %>%
  filter(Commodity_Description == "Apples, Fresh",
         Attribute_Description == "Domestic Consumption") %>%
  select(Calendar_Year, Value) %>%
  filter(!is.na(Value))

model_apples <- lm(Value ~ Calendar_Year, data = apples_data)
summary(model_apples)

ggplot(apples_data, aes(x = Calendar_Year, y = Value)) +
  geom_point(color = "#4C9AFF", alpha = 0.6) +
  geom_smooth(method = "lm", se = TRUE, color = "#FF6F61") +
  labs(title = "Trends in domestic apple consumption in the U.S.",
       subtitle = "With regression line and 95% confidence band",
       x = "Year",
       y = "Consumption (metric tons)") +
  theme_minimal()
```

## 🧪 Hypothesis Test: Apple Consumption > Imports

```{r prueba-hipotesis}
consumo_manzanas <- df_us %>%
  filter(Commodity_Description == "Apples, Fresh",
         Attribute_Description == "Domestic Consumption") %>%
  select(Valor = Value) %>%
  filter(!is.na(Valor))

importaciones_manzanas <- df_us %>%
  filter(Commodity_Description == "Apples, Fresh",
         Attribute_Description == "Imports") %>%
  select(Valor = Value) %>%
  filter(!is.na(Valor))

prueba_t <- t.test(
  consumo_manzanas$Valor,
  importaciones_manzanas$Valor,
  alternative = "greater"
)

prueba_t
```

## 📊 Visualization 3: Pie Chart - Top 3 Fruit Distribution

```{r pie-chart}
top3_summary_wide <- top3_data %>%
  group_by(Commodity_Description, Attribute_Description) %>%
  summarise(total = sum(Value, na.rm = TRUE)) %>%
  pivot_wider(names_from = Attribute_Description, values_from = total) %>%
  mutate(Import_Percentage = Imports / `Domestic Consumption` * 100,
         Export_Percentage = Exports / `Domestic Consumption` * 100)

top3_pie_data <- top3_summary_wide %>%
  select(Commodity_Description, Imports, Exports, `Domestic Consumption`) %>%
  pivot_longer(cols = c(Imports, Exports, `Domestic Consumption`),
               names_to = "Category", values_to = "Value")

ggplot(top3_pie_data, aes(x = "", y = Value, fill = Category)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y") +
  facet_wrap(~Commodity_Description) +
  labs(title = "Distribution Of Consumption, Imports and Exports by Fruit",
       fill = "Category") +
  theme_void() +
  theme(strip.text = element_text(size = 12, face = "bold"),
        legend.title = element_text(face = "bold"),
        plot.title = element_text(hjust = 0.5, face = "bold"))
```

## ✅ Conclusions

- Apple consumption has significantly increased over time.
- Domestic consumption of apples is significantly greater than imports (confirmed by t-test, p < 0.001).
- Apple, peaches, and pears are the top three most consumed fruits in the U.S.
