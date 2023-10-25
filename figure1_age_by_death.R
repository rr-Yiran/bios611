library(tidyverse)
library(dplyr)
library(ggplot2)

data <- read.csv("derived_data/preprocessed_heart_failure.csv")

figure1 <- ggplot(data, aes(x=age, fill=as.factor(DEATH_EVENT))) +
  geom_histogram(binwidth=5, alpha=0.5, position="dodge")   +
  labs(title = "Distribution of Age by Survival Status",  # Adding the main title
       fill = "Survival Status") +  # Renaming the legend title
  scale_fill_manual(values = c("1" = "red", "0" = "blue"),  # Assigning colors
                    labels = c("1" = "Death", "0" = "Alive")) +  # Renaming the legend labels
  theme_minimal() 

ggsave(figure1, filename = "figures/figure1_age_by_death.png", height = 6, width = 10)
