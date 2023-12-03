library(tidyverse)
library(dplyr)
library(ggplot2)
library(GGally)

data <- read_csv("derived_data/preprocessed_heart_failure.csv")

# figure1 age_by_death 
figure1 <- ggplot(data, aes(x=age, fill=as.factor(DEATH_EVENT))) +
  geom_histogram(binwidth=5, alpha=0.5, position="dodge")   +
  labs(title = "Distribution of Age by Survival Status",  # Adding the main title
       fill = "Survival Status") +  # Renaming the legend title
  scale_fill_manual(values = c("1" = "red", "0" = "blue"),  # Assigning colors
                    labels = c("1" = "Death", "0" = "Alive")) +  # Renaming the legend labels
  theme_minimal() 
ggsave(figure1, filename = "figures/figure1_age_by_death.png", height = 6, width = 10)


# figure2 ejection_fraction_by_death
figure2 <- ggplot(data, aes(x=factor(DEATH_EVENT), y=ejection_fraction, fill=factor(DEATH_EVENT)))  +
  geom_boxplot() +
  labs(title = "Distribution of Ejection Fraction by Survival Status",  # Adding the main title
       x = "Survival Status",  # Correcting the X-axis label
       y = "Ejection Fraction",  # Correcting the Y-axis label
       fill = "Survival Status") +  # Renaming the legend title
  scale_fill_discrete(labels = c("Death", "Alive")) +  # Renaming the legend labels
  theme_minimal() 
ggsave(figure2, filename = "figures/figure2_ejection_fraction_by_death.png", height = 6, width = 10)

numerical_data <- data %>% select(all_of(numerical_features))
print(ggpairs(numerical_data))



