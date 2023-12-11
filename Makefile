.PHONY: clean

clean:
	rm derived_data/*
	rm logs/*
	rm figures/*
	rm -f Report.pdf

#.created-dirs:
	#mkdir -p figures

# deriv clean data from raw dataset
derived_data/preprocessed_%.csv logs/preprocessed_%.csv:\
  source_data/%.csv step1_preprocessing.R
	Rscript step1_preprocessing.R $*

# bulid three models and save model information
derived_data/model.RData: step3_modeling.R derived_data/preprocessed_heart_failure.csv
	Rscript step3_modeling.R

# figures for exploratory description analyis and visualization of prediction model results
figures/figure1_age_by_death.png: step2_visualization.R derived_data/preprocessed_heart_failure.csv
	Rscript step2_visualization.R

figures/figure2_ejection_fraction_by_death.png: step2_visualization.R derived_data/preprocessed_heart_failure.csv
	Rscript step2_visualization.R

figures/figure3_correlation_plot.png: step2_visualization.R derived_data/preprocessed_heart_failure.csv
	Rscript step2_visualization.R
	
figures/figure4_Response_Death_Events_plot.png: step2_visualization.R derived_data/preprocessed_heart_failure.csv
	Rscript step2_visualization.R

figures/figure_result_ROC_plot.png figures/figure_result_rf_importance.png: step3_modeling.R derived_data/preprocessed_heart_failure.csv
	Rscript step3_modeling.R

# Build the final report for the project
report.pdf: Report.Rmd figures/figure1_age_by_death.png figures/figure2_ejection_fraction_by_death.png figures/figure3_correlation_plot.png figures/figure4_Response_Death_Events_plot.png figures/figure_result_ROC_plot.png figures/figure_result_rf_importance.png
	Rscript -e "rmarkdown::render('./Report.Rmd')"