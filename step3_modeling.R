library(tidyverse)
library(dplyr)
library(ggplot2)
library(caret)
library(pROC)
set.seed(123)

data <- read_csv("derived_data/preprocessed_heart_failure.csv")


# Splitting the data
splitIndex <- createDataPartition(data$DEATH_EVENT, p = .80, list = FALSE, times = 1)
data$DEATH_EVENT <- factor(data$DEATH_EVENT)
trainData <- data[ splitIndex,]
testData  <- data[-splitIndex,]

# Train Logistic Regression, Random Forest, and GBM model
models <- list(
  logistic = train(DEATH_EVENT ~ ., data = trainData, method = "glm", family = "binomial"),
  randomForest = train(DEATH_EVENT ~ ., data = trainData, method = "rf"),
  gbm = train(DEATH_EVENT ~ ., data = trainData, method = "gbm", verbose = FALSE)
)

# Model Evaluation
results <- lapply(models, function(model) {
  predictions <- predict(model, testData)
  
  # Ensure predictions are factors with the same levels as in training data
  # predictions <- factor(predictions, levels = levels(trainData$DEATH_EVENT))
  # Getting predicted probabilities
  prob_predictions <- predict(model, testData, type = "prob")
  
  # Ensure you reference the correct column for your event of interest
  # Assuming '1' is the event of interest
  event_prob <- prob_predictions[, "1"]
  
  roc_curve <- roc(as.numeric(testData$DEATH_EVENT), event_prob)
  
  list(
    confusionMatrix = confusionMatrix(predictions, testData$DEATH_EVENT),
    ROC = roc_curve
  )
})

# ROC Curve Plot
roc_data <- lapply(names(results), function(model) {
  data.frame(
    model = model,
    tpr = results[[model]]$ROC$sensitivities,
    fpr = 1 - results[[model]]$ROC$specificities
  )
}) %>% do.call(rbind, .)

ROC_plot <- ggplot(roc_data, aes(x = fpr, y = tpr, color = model)) +
  geom_line() +
  geom_abline(linetype = "dashed") +
  labs(title = "ROC Curve Comparison", x = "False Positive Rate", y = "True Positive Rate") +
  theme_minimal()
ggsave(ROC_plot, filename = "figures/figure_result_ROC_plot.png", height = 6, width = 10)


# Plotting Random Forest feature importance
rf_importance <- varImp(models$randomForest$finalModel)
rf_importance <- data.frame(
  Variable = rownames(rf_importance),
  Overall = rf_importance$Overall)
rf_plot <- ggplot(rf_importance) +
  geom_bar(aes(x = reorder(Variable, Overall), y = Overall), stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Feature Importance for Random Forest")
ggsave(rf_plot, filename = "figures/figure_result_rf_importance.png")

save.image(file = "derived_data/model.RData")
