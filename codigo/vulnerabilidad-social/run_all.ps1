# Run reproducible research outputs without installing new dependencies.
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/run_eda_report.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/run_econometric_stage1.ps1

# If R/Rscript is available, the R workflow is:
# Rscript run_all.R
