# Run all R analysis scripts in order.
source("R/00_setup.R")
source("R/01_data_audit.R")
source("R/02_descriptive_analysis.R")
source("R/03_structural_vulnerability_index.R")
source("R/04_panel_econometrics.R")
source("R/06_robustness_sensitivity.R")
message("Analysis complete. Outputs written to outputs/.")
