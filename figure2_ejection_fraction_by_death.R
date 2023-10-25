library(tidyverse)
library(dplyr)
library(ggplot2)

data <- read_csv("derived_data/preprocessed_heart_failure.csv")

figure2 <- ggplot(data, aes(x=factor(DEATH_EVENT), y=ejection_fraction, fill=factor(DEATH_EVENT)))  +
  geom_boxplot() +
  labs(title = "Distribution of Ejection Fraction by Survival Status",  # Adding the main title
       x = "Survival Status",  # Correcting the X-axis label
       y = "Ejection Fraction",  # Correcting the Y-axis label
       fill = "Survival Status") +  # Renaming the legend title
  scale_fill_discrete(labels = c("Death", "Alive")) +  # Renaming the legend labels
  theme_minimal() 

ggsave(figure2, filename = "figures/figure2_ejection_fraction_by_death.png", height = 6, width = 10)
