library(tidyverse)
library(dplyr)
source("utils.R");

args <- commandArgs(trailingOnly=TRUE);
input_sd <- args[[1]];
ensure_directory("logs");
log <- make_logger(sprintf("logs/preprocessed_%s.md", input_sd))

data <- read_csv(sprintf("source_data/%s.csv", input_sd))
summary(data)

data$anaemia <- as.factor(data$anaemia) 
data$diabetes <- as.factor(data$diabetes) 
data$high_blood_pressure <- as.factor(data$high_blood_pressure) 
data$sex <- as.factor(data$sex) 
data$smoking <- as.factor(data$smoking) 
data$DEATH_EVENT <- as.factor(data$DEATH_EVENT) 

log("Summary of %s",input_sd);
log(summary(data))

# why the preprocessed data still be read as numerical?
ensure_directory("derived_data")
write_csv(data, sprintf("derived_data/preprocessed_%s.csv", input_sd))
