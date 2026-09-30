# Limitations

This document develops the limitations of the current repository and the first-stage econometric results. It should be read alongside `DATA_EXPLORATION_REPORT.md`, `MODEL_INTERPRETATION.md`, and `EMPIRICAL_FRAMEWORK.md`.

## Missing Values

Missingness is the main practical constraint in the current panel. The row-balanced panel contains 648 country-year observations across 27 countries and 24 years, but indicator coverage varies substantially. The structural vulnerability index and GDP per capita are fully observed. Monetary poverty and extreme poverty are observed for 423 observations. Labor informality is observed for 302 observations. Social protection coverage is observed for 202 observations. Gini is observed for 351 observations. Female and male labor participation are observed for only 87 observations, and social expenditure is observed for 146 observations.

This missingness directly shapes the first-stage regression sample. The econometric model uses complete cases for the structural vulnerability index, labor informality, social protection coverage, GDP per capita, unemployment, and Gini. That sample contains 178 observations, 17 countries, and 18 years. The regression results therefore do not represent the full 27-country panel. They represent the subset with jointly observed data.

Missingness may not be random. Countries with weaker statistical capacity, more volatile political conditions, or less developed administrative systems may be less likely to report certain indicators. If missingness is correlated with vulnerability, estimates based on complete cases may be biased.

## Endogeneity

The current estimates are associational. Several forms of endogeneity are plausible.

Reverse causality is a central concern. Social protection coverage may reduce vulnerability, but governments may also expand social protection because vulnerability is high. Informality may increase vulnerability, but vulnerable households may also sort into informal work. Inequality may shape vulnerability, but vulnerability can also reinforce unequal distribution through education, health, and labor-market channels.

Simultaneity is also possible. Labor informality, unemployment, social protection, poverty, and inequality may respond together to macroeconomic shocks, political reforms, commodity cycles, demographic change, or external crises. A static fixed-effects model cannot fully separate these channels.

## Causality

No causal claim should be made from the current first-stage models. Country fixed effects and year fixed effects improve the descriptive specification by controlling for stable country characteristics and common time shocks. They do not identify causal effects unless stronger assumptions are satisfied.

A causal interpretation would require additional design elements: clearly defined treatment variation, credible timing, parallel-trend evidence for event-study designs, valid instruments, or other sources of exogenous variation. The current repository has not implemented those designs.

## Measurement

Several variables require careful measurement documentation before publication. The exact source definitions and units are not fully embedded in the panel for every variable. This is especially important for social protection coverage, social expenditure, GDP per capita units, and harmonized poverty measures.

Measurement error may differ across countries and years. Poverty and inequality measures often depend on household surveys, which vary in timing, coverage, questionnaire design, and harmonization procedures. Informality definitions may differ depending on whether they refer to workers, jobs, firms, social security contributions, or legal status. Social protection coverage may combine heterogeneous programs with different eligibility rules and coverage concepts.

Measurement error can attenuate coefficients, distort comparisons, and weaken cross-country comparability.

## Coverage

The panel covers 27 countries from 2000 to 2023 at the row level. However, usable coverage differs by variable. Some indicators are available only in later years or for a subset of countries. Gender labor indicators begin only in 2016 where available. Social expenditure ends in 2020 where available and covers only 8 countries.

Coverage limitations restrict which questions can be answered. The current panel is well suited for descriptive regional analysis, baseline panel regressions, and vulnerability profiling. It is less suited for detailed program evaluation, household-level mechanisms, subnational heterogeneity, or gender analysis without further data expansion.

## Omitted Variables

The first-stage econometric model omits several theoretically important variables: fiscal capacity, tax revenue, demographic dependency ratios, education, health access, urbanization, migration, sectoral employment, commodity dependence, inflation, political institutions, crisis exposure, and policy implementation timing.

If omitted variables are correlated with both the regressors and structural vulnerability, estimated coefficients may capture broader institutional or macroeconomic differences. Fixed effects reduce some omitted-variable concerns but cannot remove time-varying omitted factors.

## Data Quality

The repository includes EDA outputs and diagnostic files, but data quality remains an ongoing research task. Potential concerns include harmonization across sources, inconsistent reporting periods, source revisions, structural breaks in measurement, and extreme values.

The EDA flags potential outliers using a 1.5 IQR rule. These are not automatic errors. Some extreme values may reflect real country conditions. Others may reflect measurement issues. Publication-quality analysis should document how each major outlier is treated.

## International Comparability

Cross-country comparison is difficult in Latin America and the Caribbean because countries differ in statistical systems, survey frequency, labor-market institutions, social protection architecture, and macroeconomic structure. A percentage-point change in social protection coverage may not represent the same institutional change in two countries. Informality may also have different meanings depending on labor law, enforcement, firm structure, and social insurance design.

Fixed effects help with time-invariant comparability problems, but they do not solve changes in measurement over time or differences in program composition.

## Composite Index Limitations

The structural vulnerability index is useful for summarizing multidimensional risk, but it creates interpretation challenges.

First, index construction depends on component selection. Adding or removing poverty, informality, social protection, GDP, unemployment, inequality, or gender indicators can change rankings. Second, normalization matters. Min-max and z-score approaches can produce different relative distances. Third, weighting matters. Equal weights are transparent but not necessarily theoretically correct. Fourth, missingness matters. If countries have different component coverage, the index may not be equally informative across countries and years.

Most importantly for the first-stage regressions, some regressors are conceptually related to the index itself. This can produce high R-squared values and strong coefficients that partly reflect the structure of the index rather than independent causal relationships. This does not invalidate descriptive analysis, but it limits causal interpretation.

## Inference Limitations

The first-stage models use country-clustered standard errors with 17 clusters. This is a limited number of clusters. P-values should therefore be interpreted cautiously. Future work should consider wild cluster bootstrap or alternative inference approaches in an R environment.

Random effects and Hausman tests were not implemented in the current environment because the necessary R panel packages were not available. Their absence does not invalidate the estimated OLS and fixed-effects results, but it means model-selection diagnostics remain incomplete.

## External Validity

The results are most applicable to country-years with complete data on the selected variables. They should not be generalized automatically to countries excluded from the complete-case sample, to subnational regions, or to households. Household-level mechanisms require microdata.

## Summary

The current repository is scientifically useful because it is transparent about data coverage, model choice, and interpretation limits. The main limitation is not a lack of results, but the fact that the results are descriptive and based on a composite index with incomplete covariate coverage. The next stage should focus on robustness, alternative outcomes, and stronger identification before any causal policy claims are made.

