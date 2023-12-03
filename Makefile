PHONY: clean

clean:
	rm derived_data/*
	rm logs/*
	rm figures/*

#.created-dirs:
	#mkdir -p figures

#derived_data
derived_data/preprocessed_%.csv logs/preprocessed_%.csv:\
  source_data/%.csv step1_preprocessing.R
	Rscript step1_preprocessing.R $*

# figures
figures/figure1_age_by_death.png: step2_visualization.R derived_data/preprocessed_heart_failure.csv
	Rscript step2_visualization.R

figures/figure2_ejection_fraction_by_death.png: step2_visualization.R derived_data/preprocessed_heart_failure.csv
	Rscript step2_visualization.R