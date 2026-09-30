# Research Questions

This file defines research questions that can be studied using only the current country-year panel in `data/processed/dashboard_panel.csv`. All proposed analyses are descriptive or associational unless a future version adds a credible identification strategy.

## 1. Does labor informality predict higher monetary poverty across LAC?

- Motivation: Informality is a central channel through which households remain exposed to low earnings, weak insurance, and limited access to contributory benefits.
- Hypothesis: Countries and years with higher labor informality have higher monetary poverty.
- Variables required: `monetary_poverty`, `labor_informality`, `gdp_per_capita`, `unemployment`, `gini`, `iso3`, `year`.
- Suggested econometric method: Pooled OLS, country fixed effects, year fixed effects, and two-way fixed effects with country-clustered standard errors.
- Possible academic contribution: Clarifies whether poverty and informality move together beyond simple cross-country income differences.
- Possible limitations: Informality coverage is incomplete; the relationship may be endogenous because poverty and informality can reinforce each other.

## 2. Is social protection coverage associated with lower structural vulnerability?

- Motivation: Social protection systems are designed to reduce exposure to shocks and persistent deprivation.
- Hypothesis: Higher `social_protection_coverage` is associated with a lower `structural_vulnerability_index`.
- Variables required: `structural_vulnerability_index`, `social_protection_coverage`, `labor_informality`, `gdp_per_capita`, `unemployment`, `iso3`, `year`.
- Suggested econometric method: Two-way fixed effects as the baseline associational specification; robustness with alternative samples.
- Possible academic contribution: Links institutional protection to a multidimensional vulnerability outcome.
- Possible limitations: Social protection coverage has high missingness and may expand in response to vulnerability, creating reverse causality.

## 3. Are poverty and informality distinct dimensions of vulnerability?

- Motivation: Applied policy debates often treat poverty as the main indicator of vulnerability, but labor-market structure may capture a separate dimension.
- Hypothesis: Poverty and informality are positively related but not redundant.
- Variables required: `monetary_poverty`, `extreme_poverty`, `labor_informality`, `structural_vulnerability_index`.
- Suggested econometric method: Correlation analysis, variance decomposition in the composite index, and PCA as a descriptive extension.
- Possible academic contribution: Supports a multidimensional approach to vulnerability measurement.
- Possible limitations: PCA and correlations do not identify causal channels; missing informality observations can shape conclusions.

## 4. Does GDP per capita moderate the poverty-informality relationship?

- Motivation: Informality may have different implications in lower-income versus higher-income economies.
- Hypothesis: The association between informality and poverty is stronger where GDP per capita is lower.
- Variables required: `monetary_poverty`, `labor_informality`, `gdp_per_capita`, interaction between informality and GDP per capita, `iso3`, `year`.
- Suggested econometric method: Fixed effects regression with an interaction term and standardized regressors.
- Possible academic contribution: Tests whether structural labor-market risks differ by development level.
- Possible limitations: Interaction terms are sensitive to scaling and require careful interpretation; GDP may itself be affected by informality.

## 5. Is extreme poverty more sensitive to structural vulnerability than monetary poverty?

- Motivation: Extreme poverty may respond differently to institutional and labor-market conditions than broader monetary poverty.
- Hypothesis: `extreme_poverty` has a stronger association with the structural vulnerability index than `monetary_poverty`.
- Variables required: `extreme_poverty`, `monetary_poverty`, `structural_vulnerability_index`, controls.
- Suggested econometric method: Parallel FE/TWFE models with poverty measures as alternative dependent variables.
- Possible academic contribution: Distinguishes broad deprivation from the lower tail of the poverty distribution.
- Possible limitations: Extreme poverty has the same missingness footprint as monetary poverty in the current panel.

## 6. Do gender labor indicators add information to vulnerability measurement?

- Motivation: Gendered labor-market exclusion can compound poverty and informal work.
- Hypothesis: Female labor participation and the gender labor gap add explanatory power to vulnerability rankings.
- Variables required: `female_labor_participation`, `male_labor_participation`, `structural_vulnerability_index`, poverty and informality indicators.
- Suggested econometric method: Index sensitivity analysis and descriptive comparisons for the post-2016 sample.
- Possible academic contribution: Connects vulnerability measurement to gendered labor-market structure.
- Possible limitations: Female and male labor participation are available for only 87 observations and 11 countries.

## 7. Which countries combine high vulnerability with weak social protection coverage?

- Motivation: Policy prioritization requires identifying countries with overlapping risk and limited institutional buffers.
- Hypothesis: Some countries rank high on vulnerability while also having low social protection coverage.
- Variables required: `structural_vulnerability_index`, `social_protection_coverage`, `country_name`, `year`.
- Suggested econometric method: Latest-year ranking, bivariate classification, and country profile plots.
- Possible academic contribution: Produces an interpretable policy typology for applied development research.
- Possible limitations: Coverage of social protection is sparse and may not be available for the same latest year across countries.

## 8. Are vulnerability rankings robust to alternative index construction?

- Motivation: Composite indexes can be sensitive to normalization, weights, and indicator availability.
- Hypothesis: The broad set of high-vulnerability countries is stable, but exact ranks shift across index definitions.
- Variables required: Poverty, informality, social protection, GDP per capita, unemployment, gender labor indicators, `structural_vulnerability_index`.
- Suggested econometric method: Min-max versus z-score index comparison, alternative weights, and leave-one-component-out rankings.
- Possible academic contribution: Makes the measurement strategy transparent and credible for academic review.
- Possible limitations: Index robustness cannot solve measurement error in the underlying indicators.

## 9. Does unemployment explain vulnerability once informality is considered?

- Motivation: In LAC, unemployment and informality may represent different labor-market margins.
- Hypothesis: Informality remains associated with vulnerability after controlling for unemployment.
- Variables required: `structural_vulnerability_index`, `labor_informality`, `unemployment`, `gdp_per_capita`, `iso3`, `year`.
- Suggested econometric method: TWFE with both labor-market variables; robustness to dropping one variable at a time.
- Possible academic contribution: Separates open unemployment from informal employment as sources of structural risk.
- Possible limitations: Labor informality and unemployment can be jointly determined by macroeconomic conditions.

## 10. Is inequality associated with higher structural vulnerability?

- Motivation: Inequality may increase exposure to poverty and limit the redistributive effectiveness of growth.
- Hypothesis: Higher `gini` is associated with higher vulnerability.
- Variables required: `structural_vulnerability_index`, `gini`, poverty, informality, GDP per capita, `iso3`, `year`.
- Suggested econometric method: FE/TWFE models and descriptive partial correlations.
- Possible academic contribution: Connects inequality to multidimensional vulnerability rather than poverty alone.
- Possible limitations: Gini coverage is incomplete and may be measured with survey harmonization differences.

## 11. Is Bolivia an example of declining poverty but persistent labor informality?

- Motivation: Country profiles can reveal whether poverty reduction translates into lower structural vulnerability.
- Hypothesis: Bolivia shows a long-run decline in monetary poverty while labor informality remains high.
- Variables required: `country_name`, `year`, `monetary_poverty`, `labor_informality`, `social_protection_coverage`, `structural_vulnerability_index`.
- Suggested econometric method: Descriptive time-series profile and comparison with LAC averages.
- Possible academic contribution: Provides a policy-relevant case study within the aggregate panel.
- Possible limitations: Aggregate data cannot identify household mobility, program take-up, or regional heterogeneity inside Bolivia.

## 12. Can lightweight predictive models identify high-vulnerability country-years?

- Motivation: A research portfolio can show how interpretable machine learning complements econometric analysis.
- Hypothesis: Poverty, informality, GDP per capita, social protection, and inequality predict high-risk country-years.
- Variables required: `high_risk` derived from the 75th percentile of `structural_vulnerability_index`, plus available features.
- Suggested method: Random forest if available, gradient boosting if available, and logistic regression fallback; no expensive tuning.
- Possible academic contribution: Demonstrates reproducible predictive risk classification using transparent features.
- Possible limitations: Prediction is not causal; train/test splits are sensitive in small country-year panels.

