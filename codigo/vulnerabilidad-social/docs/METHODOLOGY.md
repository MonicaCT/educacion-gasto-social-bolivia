# Methodology

## Data Audit

The audit reports panel dimensions, country and year coverage, missingness, variable coverage, descriptive statistics, and panel balance.

## Structural Vulnerability Index

The generated index variants use available indicators:

- Poverty: higher values imply higher vulnerability.
- Labor informality: higher values imply higher vulnerability.
- Social protection: lower values imply higher vulnerability.
- GDP per capita: lower values imply higher vulnerability.
- Gender labor gap: higher values imply higher vulnerability.
- Unemployment: higher values imply higher vulnerability.

Two transformations are implemented:

- Min-max normalization.
- Z-score standardization.

The baseline index averages available normalized components. Sensitivity checks compare alternative weights and leave-one-component-out rankings.

## Machine Learning

The R script creates `high_risk` using the 75th percentile of the structural vulnerability index. It runs random forest if the package is available; otherwise it falls back to a simple logistic model. No expensive tuning grid is used.