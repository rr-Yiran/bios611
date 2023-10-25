PHONY: clean

clean:
	rm derived_data/*
	rm logs/*
	rm figures/*

derived_data/preprocessed_%.csv logs/preprocessed_%.csv:\
  source_data/%.csv step1_preprocessing.R
	Rscript step1_preprocessing.R $*

figures/figure1_age_by_death.png: figure1_age_by_death.R derived_data/preprocessed_heart_failure.csv
	Rscript figure1_age_by_death.R

figures/figure2_ejection_fraction_by_death.png: figure2_ejection_fraction_by_death.R derived_data/preprocessed_heart_failure.csv
	Rscript figure2_ejection_fraction_by_death.R