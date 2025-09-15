# CMA Housing Affordability - Modeling Script
# -------------------------------------------------------------
# How to run (in R console or RStudio):
#   setwd("<project root>")
#   source("housing_affordability_modeling.R")
#
# Required packages:
#   install.packages(c("tidyverse", "dplyr", "car"))
#
# Input:
#   cma_quarterly_results_filtered_202506161001.csv
#
# Output:
#   Plots appear in the Plots pane or device; console shows summaries.

library(tidyverse)
library(dplyr)
library(car)

# -------------------------------------------------------------
# Load data
# -------------------------------------------------------------
data <- read.csv("cma_quarterly_results_filtered_202506161001.csv", header = TRUE)
print(head(data))

##################################################
# data cleaning
#################################################

df <- data |>
  rename(
    cma_name = `CMA.NAME`,
    payment_to_income_percent = `PAYMENT.TO.INCOME.PERCENT`,
    prime_interesterate = `PRIME.INTERESTERATE`,
    number_of_resales = `NUMBER.OF.RESALES`
  ) |>
  mutate(
    cma_name = as.factor(cma_name),
    payment_to_income_percent = as.numeric(payment_to_income_percent),
    prime_interesterate = as.numeric(prime_interesterate),
    number_of_resales = as.numeric(number_of_resales)
  )

print(head(df))

# -------------------------------------------------------------
# Quick exploratory plots
# -------------------------------------------------------------
plot(df$prime_interesterate, df$payment_to_income_percent,
     pch = 19, cex = 0.6,
     main = "Payment vs Prime Rate",
     xlab = "Prime Interest Rate (%)",
     ylab = "Payment to Income (%)")

plot(df$number_of_resales, df$payment_to_income_percent,
     pch = 19, cex = 0.6,
     main = "Payment vs #Resales",
     xlab = "Number of Resales",
     ylab = "Payment to Income (%)")

##################################################
#  Model Specification
#################################################
model1 <- lm(payment_to_income_percent ~ cma_name + prime_interesterate + number_of_resales, data = df)
print(summary(model1))
plot(model1$fitted.values, model1$residuals,
     main = "Residuals vs Fitted (Model 1)",
     xlab = "Fitted values", ylab = "Residuals", pch = 19)
abline(h = 0, col = "red", lwd = 2)
res <- residuals(model1)
qqnorm(res,
       main = "QQ Plot of Residuals",
       ylab = "Residuals",
       xlab = "Theoretical Quantiles",
       pch  = 19, cex = 0.6)
qqline(res, col = "blue", lwd = 2)

model2 <- lm(log(payment_to_income_percent) ~ cma_name + prime_interesterate + number_of_resales, data = df)
print(summary(model2))
plot(model2$fitted.values, model2$residuals,
     main = "Residuals vs Fitted (Model 2)",
     xlab = "Fitted values", ylab = "Residuals", pch = 19)
abline(h = 0, col = "red", lwd = 2)
res <- residuals(model2)
qqnorm(res,
       main = "QQ Plot of Residuals (model 2)",
       ylab = "Residuals",
       xlab = "Theoretical Quantiles",
       pch  = 19, cex = 0.6)
qqline(res, col = "blue", lwd = 2)

##################################################
#  Interaction Models
#################################################
inter_mod1 <- lm(log(payment_to_income_percent) ~ cma_name * prime_interesterate + number_of_resales, data = df)
print(summary(inter_mod1))

inter_mod2 <- lm(log(payment_to_income_percent) ~ cma_name * number_of_resales + prime_interesterate, data = df)
print(summary(inter_mod2))
plot(inter_mod2$fitted.values, inter_mod2$residuals,
     main = "Residuals vs Fitted (inter_mod2)",
     xlab = "Fitted values", ylab = "Residuals", pch = 19)
abline(h = 0, col = "red", lwd = 2)
res <- residuals(inter_mod2)
qqnorm(res,
       main = "QQ Plot of Residuals (inter_mod2)",
       ylab = "Residuals",
       xlab = "Theoretical Quantiles",
       pch  = 19, cex = 0.6)
qqline(res, col = "blue", lwd = 2)

inter_mod3 <- lm(log(payment_to_income_percent) ~ cma_name + number_of_resales * prime_interesterate, data = df)
print(summary(inter_mod3))

##################################################
#  Collinearity
#################################################
print(vif(inter_mod2))
print(vif(model2))

df <- df |>
  group_by(cma_name) |>
  mutate(
    resales_group_scaled = scale(number_of_resales)
  ) |>
  ungroup()

inter_mod2_group_scaled <- lm(log(payment_to_income_percent) ~ cma_name * resales_group_scaled 
                              + prime_interesterate, data = df
)
print(vif(inter_mod2_group_scaled))
print(summary(inter_mod2_group_scaled))
plot(inter_mod2_group_scaled$fitted.values, inter_mod2_group_scaled$residuals,
     main = "Residuals vs Fitted (inter_mod2_group_scaled)",
     xlab = "Fitted values", ylab = "Residuals", pch = 19)
abline(h = 0, col = "red", lwd = 2)
res <- residuals(inter_mod2_group_scaled)
qqnorm(res,
       main = "QQ Plot of Residuals (inter_mod2_group_scaled)",
       ylab = "Residuals",
       xlab = "Theoretical Quantiles",
       pch  = 19, cex = 0.6)
qqline(res, col = "blue", lwd = 2)

##################################################
#  Other Models
#################################################

model3 <- lm(payment_to_income_percent ~ cma_name + prime_interesterate + log(number_of_resales), data = df)
print(summary(model3))
plot(model3$fitted.values, model3$residuals,
     main = "Residuals vs Fitted (Model 3)",
     xlab = "Fitted values", ylab = "Residuals", pch = 19)
abline(h = 0, col = "red", lwd = 2)

prime_mod <- lm(payment_to_income_percent ~ prime_interesterate, data = df)
print(summary(prime_mod))
plot(prime_mod$fitted.values, prime_mod$residuals,
     main = "Residuals vs Fitted (prime_mod)",
     xlab = "Fitted values", ylab = "Residuals", pch = 19)
abline(h = 0, col = "red", lwd = 2)

model_poly <- lm(payment_to_income_percent ~ cma_name +
                   prime_interesterate + I(prime_interesterate^2) +
                   number_of_resales,
                 data = df)
print(summary(model_poly))
plot(model_poly$fitted.values, model_poly$residuals,
     main = "Residuals vs Fitted (model_poly)",
     xlab = "Fitted values", ylab = "Residuals", pch = 19)
abline(h = 0, col = "red", lwd = 2)

