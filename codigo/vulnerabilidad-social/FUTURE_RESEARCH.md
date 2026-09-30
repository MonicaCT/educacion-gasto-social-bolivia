# Future Research

This document proposes future research directions using the current panel as the foundation. Some lines can be pursued immediately with the existing data; others require robustness checks, additional metadata, or future source expansion.

## Econometrics

1. Estimate monetary poverty and extreme poverty as alternative dependent variables to reduce mechanical links with the composite index.
2. Compare pooled OLS, country fixed effects, year fixed effects, and two-way fixed effects across alternative samples.
3. Add lagged dependent variables to study persistence in vulnerability, conditional on appropriate dynamic panel methods.
4. Test whether social protection moderates the association between informality and vulnerability through interaction terms.
5. Implement wild cluster bootstrap inference for the Stage 1 coefficients given the limited number of clusters.
6. Evaluate whether results are sensitive to excluding one country at a time.
7. Estimate period-specific models before and after major regional shocks, subject to sample size.
8. Add random effects and Hausman tests in a full R environment.

## Machine Learning

9. Classify high-vulnerability country-years using the 75th percentile of the structural vulnerability index.
10. Compare logistic regression, random forest, and gradient boosting as lightweight predictive models.
11. Use feature importance to identify which variables are most predictive of high vulnerability.
12. Test whether prediction improves when index components are replaced by lagged indicators.
13. Compare predictive performance across subperiods.
14. Use clustering to classify countries into vulnerability regimes.

## Development Economics

15. Study whether vulnerability declines with GDP per capita at the same rate across countries.
16. Examine whether growth without formalization leaves structural vulnerability high.
17. Analyze whether inequality weakens the vulnerability-reducing association of GDP per capita.
18. Compare country pathways where poverty falls but informality remains persistent.

## Poverty

19. Use monetary poverty as the outcome to test whether the same regressors predict direct deprivation.
20. Compare monetary poverty and extreme poverty models to identify differences in lower-tail vulnerability.
21. Study whether poverty reductions are accompanied by improvements in social protection coverage.
22. Examine whether poverty outliers are associated with specific country-year shocks.

## Labor Market

23. Investigate informality as a structural predictor of vulnerability net of unemployment.
24. Compare the roles of unemployment and informality as distinct labor-market risk margins.
25. Study whether changes in GDP per capita are associated with lower informality.
26. Extend the panel with sectoral employment variables to test structural transformation hypotheses.

## Social Protection

27. Decompose social protection into social assistance and social insurance if compatible ASPIRE variables are added.
28. Examine whether social protection coverage is more strongly associated with poverty, vulnerability, or inequality.
29. Study whether countries with high informality benefit differently from social protection expansion.
30. Add program timing for selected countries to develop event-study designs.

## Public Policy

31. Build country vulnerability typologies for policy prioritization.
32. Develop a dashboard that separates index rankings from component-level policy diagnostics.
33. Compare short-term shock exposure with long-term structural vulnerability.
34. Evaluate whether social expenditure aligns with social protection coverage where data are available.

## Spatial Econometrics

35. Explore whether vulnerability is spatially clustered across neighboring countries.
36. Test whether regional spillovers matter for labor informality or migration-sensitive indicators.
37. Add geographic weights to examine cross-border correlation in vulnerability trends.
38. Compare Caribbean, Andean, Central American, and Southern Cone patterns if regional identifiers are refined.

## Forecasting

39. Forecast structural vulnerability using lagged poverty, informality, GDP per capita, unemployment, and social protection coverage.
40. Compare simple autoregressive forecasts with machine-learning forecasts.
41. Identify countries where predicted vulnerability diverges from observed vulnerability.
42. Use forecast errors as diagnostic signals for country-specific shocks or measurement breaks.

## Gender Economics

43. Study whether female labor participation improves vulnerability prediction in the post-2016 sample.
44. Construct a gender labor gap indicator and evaluate its contribution to index rankings.
45. Examine whether gender labor indicators are more informative in high-informality countries.
46. Expand gender coverage using compatible ILOSTAT or WDI indicators in a future data update.

## Bolivia-Focused Research

47. Develop a Bolivia country profile linking poverty decline, persistent informality, and social protection expansion.
48. Compare Bolivia with regional peers that experienced similar poverty reductions but different informality trajectories.
49. Use aggregate event-study designs only where policy timing and data windows are credible.
50. Complement aggregate findings with household microdata in a future, separate research project.
