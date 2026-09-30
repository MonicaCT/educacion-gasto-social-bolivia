# Empirical Framework

This framework organizes future analysis using the current aggregate country-year panel. It does not report new results and should be read as a research design document.

## Conceptual Framework

Structural vulnerability is treated as a multidimensional condition shaped by material deprivation, labor-market segmentation, limited institutional protection, macroeconomic capacity, inequality, and gendered labor-market conditions. The panel allows these dimensions to be studied at the country-year level for Latin America and the Caribbean.

The core conceptual chain is:

```text
Economic structure and institutions
  -> labor informality, unemployment, social protection, inequality
  -> monetary poverty and extreme poverty
  -> structural vulnerability
```

The framework recognizes feedback loops. Poverty can increase informality; informality can limit social insurance financing; social protection may expand in response to poverty; and macroeconomic performance may affect all of these simultaneously.

## Expected Relationships

- Higher `labor_informality` is expected to be associated with higher poverty and vulnerability.
- Higher `social_protection_coverage` is expected to be associated with lower vulnerability, conditional on coverage and measurement quality.
- Higher `gdp_per_capita` is expected to be associated with lower poverty and vulnerability.
- Higher `unemployment` is expected to be associated with higher vulnerability, although informality may absorb labor-market distress in some countries.
- Higher `gini` is expected to be associated with higher vulnerability.
- Lower `female_labor_participation` or larger gender labor gaps may indicate additional structural vulnerability, but coverage is limited in the current panel.

## Possible Dependent Variables

- `monetary_poverty`: broad monetary deprivation outcome.
- `extreme_poverty`: lower-tail deprivation outcome.
- `structural_vulnerability_index`: composite vulnerability outcome.
- `high_risk`: future binary outcome derived from the top quartile of the vulnerability index.

## Main Independent Variables

- `labor_informality`: labor-market segmentation and weak formal employment access.
- `social_protection_coverage`: institutional protection and risk-pooling capacity.
- `gdp_per_capita`: macroeconomic development level.
- `female_labor_participation`: gendered labor-market inclusion.
- `unemployment`: open labor-market slack.
- `gini`: inequality.
- `social_expenditure`: public social effort where coverage is available.

## Controls and Fixed Effects

Potential controls should be selected based on the dependent variable and sample coverage:

- Country fixed effects: absorb time-invariant institutional, geographic, and historical differences.
- Year fixed effects: absorb region-wide shocks and common macro trends.
- GDP per capita: controls for development level.
- Unemployment: controls for labor-market slack.
- Gini: controls for distributional structure.
- Female labor participation: controls for gendered labor-market inclusion, when coverage permits.

## Econometric Specifications

Baseline associational model:

```text
Y_ct = beta_1 Informality_ct + beta_2 SocialProtection_ct
       + beta_3 GDPpc_ct + beta_4 Unemployment_ct
       + alpha_c + lambda_t + epsilon_ct
```

where `c` indexes countries and `t` indexes years. `alpha_c` are country fixed effects and `lambda_t` are year fixed effects.

Interaction extension:

```text
Y_ct = beta_1 Informality_ct + beta_2 SocialProtection_ct
       + beta_3 Informality_ct x SocialProtection_ct
       + controls_ct + alpha_c + lambda_t + epsilon_ct
```

This extension asks whether social protection is associated with lower vulnerability differently in high-informality settings.

## Endogeneity Risks

- Reverse causality: social protection may expand because poverty or vulnerability is high.
- Omitted variables: political institutions, tax capacity, demographic changes, migration, sectoral structure, and crisis exposure are not fully represented in the current panel.
- Measurement error: poverty, informality, and social protection may come from different source systems and harmonization procedures.
- Sample selection: complete-case models may exclude countries or years with weaker statistical systems.
- Dynamic persistence: poverty and informality are persistent; static FE models may omit lagged adjustment.

## Future Mitigation Strategies

- Add lagged regressors and dynamic panel specifications where the time dimension permits.
- Use robustness checks with alternative samples, alternative index weights, and leave-one-component-out designs.
- Add policy timing variables only where implementation dates are independently documented.
- Explore external instruments only if a theoretically credible and empirically valid source is identified.
- Report all results as associational unless a credible quasi-experimental design is implemented.

## Current Interpretation Rule

All current econometric and machine-learning scripts should be treated as prepared analysis templates. No causal claims should be made from the current repository until models are executed in a reproducible R environment and identification assumptions are explicitly defended.

