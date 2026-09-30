# 04. Methodology

The first-stage empirical strategy estimates three panel specifications using the existing country-year panel. No new data are introduced, and no new models are estimated for this paper package. The methodology described here corresponds to the outputs already generated in `outputs/models/`.

## Panel Structure

Let `c` index countries and `t` index years. The preferred dependent variable is the structural vulnerability index. The explanatory variables are labor informality, social protection coverage, GDP per capita scaled in thousands, unemployment, and the Gini index. The analytic sample is restricted to country-years with complete data for all variables in the baseline specification.

## Model 1: Pooled OLS

The pooled OLS model is:

```text
SVI_ct = beta_1 Informality_ct + beta_2 SocialProtection_ct
       + beta_3 GDPpc_ct + beta_4 Unemployment_ct
       + beta_5 Gini_ct + epsilon_ct
```

This model pools all country-years and does not control for unobserved country or year heterogeneity. It is useful as a baseline but is not the preferred specification because countries differ in persistent institutions, labor-market structures, social protection systems, and development levels.

## Model 2: Country Fixed Effects

The country fixed effects model is:

```text
SVI_ct = beta X_ct + alpha_c + epsilon_ct
```

Country fixed effects absorb time-invariant country characteristics. This specification asks whether changes within a country over time are associated with changes in structural vulnerability, conditional on the observed regressors.

## Model 3: Two-Way Fixed Effects

The two-way fixed effects model is:

```text
SVI_ct = beta X_ct + alpha_c + lambda_t + epsilon_ct
```

This model adds year fixed effects to control for common shocks or region-wide changes that affect all countries in a given year. It is the preferred first-stage specification because it controls for both stable country heterogeneity and common time shocks.

## Inference

Standard errors are clustered by country. This is appropriate because observations within a country are likely to be serially correlated and exposed to shared institutions and measurement practices. However, the analytic sample contains 17 country clusters, so p-values should be interpreted cautiously. Future work should add wild cluster bootstrap or related small-cluster inference methods in a full R environment.

## Interpretation

All estimates are interpreted as conditional associations, not causal effects. Fixed effects improve the specification by absorbing some unobserved heterogeneity, but they do not solve reverse causality, time-varying omitted variables, measurement error, or simultaneity. This is especially important because the dependent variable is a composite index and several regressors are conceptually related to the index itself.

