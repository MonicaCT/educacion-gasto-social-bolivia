# Model Interpretation

This document reports the first real econometric results generated from the existing country-year panel. No new data were downloaded, no panel values were modified, and no machine-learning models were estimated.

## Dependent Variable Selection

The selected dependent variable is structural_vulnerability_index because it has complete coverage in the current panel. monetary_poverty remains available for later robustness work but has lower coverage.

## Analytic Sample

The Stage 1 specification uses complete cases for:

- structural_vulnerability_index
- labor_informality
- social_protection_coverage
- gdp_per_capita, scaled as gdp_per_capita_1000
- unemployment
- gini

Analytic sample: 178 observations, 17 countries, and 18 years. Female and male labor participation and social expenditure are excluded from this first model set because they reduce the usable sample substantially.

## Model Specifications

### Model 1: Pooled OLS

SVI_ct = beta_1 Informality_ct + beta_2 SocialProtection_ct + beta_3 GDPpc_ct + beta_4 Unemployment_ct + beta_5 Gini_ct + epsilon_ct

This model pools all country-years and does not control for unobserved country or year heterogeneity.

### Model 2: Country Fixed Effects

SVI_ct = beta X_ct + alpha_c + epsilon_ct

This model controls for time-invariant differences across countries.

### Model 3: Two-Way Fixed Effects

SVI_ct = beta X_ct + alpha_c + lambda_t + epsilon_ct

This model controls for both time-invariant country differences and common year shocks. It is the preferred specification in this first stage, but it remains associational.

Random effects and Hausman tests were not run in this environment because the required R panel-econometric dependencies are not available. They remain planned for a future R-based replication.

## Model Fit

| Model | Observations | Country clusters | R2 | Adjusted R2 | Country FE | Year FE |
|---|---:|---:|---:|---:|---|---|
| Model 1: Pooled OLS | 178 | 17 | 0.9792 | 0.9786 | False | False |
| Model 2: Country Fixed Effects | 178 | 17 | 0.9969 | 0.9965 | True | False |
| Model 3: Two-Way Fixed Effects | 178 | 17 | 0.9977 | 0.9971 | True | True |

## Coefficient Table

Country-clustered standard errors are reported.

| Model | Term | Estimate | Cluster SE | t-statistic | p-value |
|---|---|---:|---:|---:|---:|
| Model 1: Pooled OLS | labor_informality | 0.01292 | 0.00157 | 8.242 | 0.0000 |
| Model 1: Pooled OLS | social_protection_coverage | -0.01029 | 0.00072 | -14.295 | 0.0000 |
| Model 1: Pooled OLS | gdp_per_capita_1000 | -0.03330 | 0.00474 | -7.031 | 0.0000 |
| Model 1: Pooled OLS | unemployment | 0.04902 | 0.00488 | 10.053 | 0.0000 |
| Model 1: Pooled OLS | gini | 0.03221 | 0.00363 | 8.862 | 0.0000 |
| Model 2: Country Fixed Effects | labor_informality | 0.01055 | 0.00113 | 9.304 | 0.0000 |
| Model 2: Country Fixed Effects | social_protection_coverage | -0.00991 | 0.00045 | -22.087 | 0.0000 |
| Model 2: Country Fixed Effects | gdp_per_capita_1000 | -0.03158 | 0.00700 | -4.513 | 0.0004 |
| Model 2: Country Fixed Effects | unemployment | 0.04936 | 0.00157 | 31.452 | 0.0000 |
| Model 2: Country Fixed Effects | gini | 0.04028 | 0.00233 | 17.321 | 0.0000 |
| Model 3: Two-Way Fixed Effects | labor_informality | 0.01032 | 0.00103 | 10.032 | 0.0000 |
| Model 3: Two-Way Fixed Effects | social_protection_coverage | -0.01017 | 0.00045 | -22.658 | 0.0000 |
| Model 3: Two-Way Fixed Effects | gdp_per_capita_1000 | -0.02194 | 0.00975 | -2.250 | 0.0388 |
| Model 3: Two-Way Fixed Effects | unemployment | 0.05372 | 0.00256 | 21.015 | 0.0000 |
| Model 3: Two-Way Fixed Effects | gini | 0.03588 | 0.00275 | 13.070 | 0.0000 |

## Economic Interpretation of Model 3

- labor_informality (Labor informality): In Model 3, a one-unit increase is associated with a 0.0103-point higher value of the structural vulnerability index, holding observed controls, country fixed effects, and year fixed effects constant. The coefficient is statistically significant at the 1% level (estimate = 0.0103, cluster SE = 0.0010, p = 0.0000).
- social_protection_coverage (Social protection coverage): In Model 3, a one-unit increase is associated with a 0.0102-point lower value of the structural vulnerability index, holding observed controls, country fixed effects, and year fixed effects constant. The coefficient is statistically significant at the 1% level (estimate = -0.0102, cluster SE = 0.0004, p = 0.0000).
- gdp_per_capita_1000 (GDP per capita (thousands)): In Model 3, a 1,000-unit increase in GDP per capita is associated with a 0.0219-point lower value of the structural vulnerability index, holding observed controls, country fixed effects, and year fixed effects constant. The coefficient is statistically significant at the 5% level (estimate = -0.0219, cluster SE = 0.0097, p = 0.0388).
- unemployment (Unemployment): In Model 3, a one-unit increase is associated with a 0.0537-point higher value of the structural vulnerability index, holding observed controls, country fixed effects, and year fixed effects constant. The coefficient is statistically significant at the 1% level (estimate = 0.0537, cluster SE = 0.0026, p = 0.0000).
- gini (Gini index): In Model 3, a one-unit increase is associated with a 0.0359-point higher value of the structural vulnerability index, holding observed controls, country fixed effects, and year fixed effects constant. The coefficient is statistically significant at the 1% level (estimate = 0.0359, cluster SE = 0.0027, p = 0.0000).

## Statistical Significance

Statistical significance is evaluated using country-clustered standard errors and t-based p-values with cluster degrees of freedom. Given the small number of clusters, the p-values should be read cautiously.

## Limitations

- These estimates are associational and should not be interpreted causally.
- The structural vulnerability index may be mechanically related to some regressors because several indicators are conceptually part of vulnerability measurement.
- Complete-case filtering reduces the sample to 178 observations and 17 countries.
- Social protection coverage has substantial missingness in the full panel, which shapes the analytic sample.
- Country fixed effects absorb time-invariant heterogeneity but do not solve reverse causality, time-varying omitted variables, or measurement error.
- Random effects and Hausman diagnostics are deferred until an R environment with panel-econometric packages is available.

## Policy Implications

The first-stage models provide disciplined descriptive evidence on how labor-market structure, institutional protection, macroeconomic development, unemployment, and inequality move with structural vulnerability. Policy interpretation should focus on multidimensional risk profiles rather than single-variable causal claims. The results motivate more careful robustness checks and future identification work before making strong policy recommendations.

## Generated Outputs

- outputs/models/model1_pooled.html
- outputs/models/model2_fe.html
- outputs/models/model3_twfe.html
- outputs/models/comparative_table.html
- outputs/models/stage1_coefficients.csv
- outputs/models/stage1_analytic_sample.csv
- outputs/models/model_selection_diagnostics.csv
- outputs/figures/models/coefplot.svg
- outputs/figures/models/predicted_vs_observed.svg
- outputs/figures/models/residual_diagnostics.svg