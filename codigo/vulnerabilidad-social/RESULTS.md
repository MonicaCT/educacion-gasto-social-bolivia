# Results

This section interprets the first stage of econometric results generated from the existing country-year panel. The analysis uses only previously generated outputs in `outputs/models/` and `MODEL_INTERPRETATION.md`. No additional models are estimated in this document.

## Sample and Outcome Selection

The preferred dependent variable for the first econometric stage is the structural vulnerability index. This choice is driven by coverage: the index is observed for the full panel of 648 country-year observations, while monetary poverty is observed for 423 observations and labor informality, social protection, and Gini coverage are more limited. The actual regression sample is the complete-case sample for the structural vulnerability index, labor informality, social protection coverage, GDP per capita, unemployment, and the Gini index. This yields 178 country-year observations across 17 countries and 18 years.

The sample restriction is substantively important. The model does not represent all 27 countries in the full row-balanced panel. It represents the subset where the institutional, labor-market, macroeconomic, and inequality indicators are jointly observed. Female and male labor participation and social expenditure were excluded from the first model set because their missingness would reduce the usable sample too sharply.

The selected outcome, structural vulnerability, is a composite index. This is appropriate for a first-stage multidimensional analysis, but it also requires caution. Several regressors used in the model are conceptually close to the components of vulnerability. The estimates therefore describe conditional associations between observed vulnerability-related dimensions rather than clean causal effects on an outcome that is independent of the regressors.

## Descriptive Context

The exploratory audit shows that vulnerability in the panel is multidimensional. Monetary poverty has a mean of 30.797, labor informality has a mean of 60.730, social protection coverage has a mean of 60.121, and unemployment has a mean of 7.138 among available observations. The full panel also shows strong pairwise relationships among key variables: labor informality is strongly negatively correlated with GDP per capita, monetary poverty is strongly correlated with extreme poverty, and poverty measures are strongly correlated with the structural vulnerability index.

These descriptive patterns motivate the econometric specification. They suggest that vulnerability is unlikely to be captured by poverty alone. Labor-market structure, social protection, macroeconomic capacity, unemployment, and inequality all plausibly enter the same empirical space.

## Model 1: Pooled OLS

The pooled OLS model estimates a single association across all observed country-years without controlling for unobserved country-specific or year-specific factors. In this model, all coefficients have the expected sign. Labor informality, unemployment, and inequality are positively associated with structural vulnerability. Social protection coverage and GDP per capita are negatively associated with structural vulnerability.

The pooled estimate for labor informality is 0.0129. Interpreted mechanically, a ten-point increase in labor informality is associated with a 0.129-point increase in the vulnerability index. The pooled estimate for social protection coverage is -0.0103, implying that a ten-point increase in coverage is associated with a 0.103-point reduction in the index. GDP per capita, scaled in thousands, has a coefficient of -0.0333. Unemployment has a larger point estimate, 0.0490 per unit, and Gini has a coefficient of 0.0322.

All pooled coefficients are statistically significant under country-clustered standard errors. However, pooled OLS is the least credible specification for interpretation because it does not account for persistent cross-country differences. Countries differ in institutions, demographic composition, social policy regimes, productive structure, geography, and long-run development trajectories. If these features are correlated with informality, social protection, inequality, or GDP, pooled OLS will combine within-country variation with cross-country level differences.

## Model 2: Country Fixed Effects

The country fixed effects model absorbs time-invariant country differences. It therefore asks whether changes within a country over time are associated with changes in the structural vulnerability index, conditional on the observed covariates. This is a more informative specification than pooled OLS because it removes stable country-level confounders.

The main coefficients remain similar in sign and magnitude. The coefficient on labor informality falls from 0.0129 in pooled OLS to 0.0105 with country fixed effects. This attenuation suggests that part of the pooled association reflects persistent cross-country differences: countries with higher long-run informality also tend to have higher long-run vulnerability. Yet the coefficient remains positive and statistically significant, indicating that within-country changes in informality are still associated with changes in vulnerability.

The social protection coefficient changes only modestly, from -0.0103 to -0.0099. This stability is notable. It suggests that the negative association between social protection coverage and vulnerability is not driven only by fixed differences across countries. GDP per capita remains negative, unemployment remains positive, and inequality remains positive. The Gini coefficient rises from 0.0322 to 0.0403, suggesting that within-country changes in inequality may be especially relevant for changes in structural vulnerability in the analytic sample.

The R-squared increases substantially, from 0.9792 in the pooled model to 0.9969 with country fixed effects. This is expected in a panel where country fixed effects capture persistent differences across countries. It should not be interpreted as proof of causal validity. It primarily indicates that country-specific baseline differences explain a large share of variation in the composite index.

## Model 3: Two-Way Fixed Effects

The two-way fixed effects model adds year fixed effects to the country fixed effects specification. This controls for common shocks and region-wide temporal patterns, such as macroeconomic cycles, changes in measurement environments, broad policy diffusion, or shared external shocks. This is the preferred specification in the first-stage analysis because it controls for both stable country heterogeneity and common time shocks.

The two-way fixed effects results preserve the main pattern. Labor informality remains positively associated with structural vulnerability. Social protection coverage remains negatively associated with vulnerability. GDP per capita remains negative, although its magnitude is smaller and its statistical significance is weaker than in the previous models. Unemployment and inequality remain positive and statistically significant.

The coefficient on labor informality in the TWFE model is 0.0103. A ten-point increase in informality is therefore associated with a 0.103-point increase in the structural vulnerability index, conditional on controls, country fixed effects, and year fixed effects. This is economically meaningful given the observed standard deviation of the vulnerability index of 0.708 in the full panel. The social protection coefficient is -0.0102, nearly symmetric in magnitude with the informality coefficient. A ten-point increase in social protection coverage is associated with a 0.102-point lower vulnerability index.

GDP per capita, scaled in thousands, has a coefficient of -0.0219 and is significant at the 5 percent level. This coefficient is smaller than in the pooled and country fixed effects models, suggesting that part of the GDP association is absorbed by common year shocks or country-specific trajectories. Unemployment has a coefficient of 0.0537, implying that a one-point increase in unemployment is associated with a 0.054-point higher vulnerability index. The Gini coefficient is 0.0359, consistent with the interpretation that inequality is an important dimension of structural vulnerability.

The TWFE R-squared is 0.9977. This high value must be interpreted carefully. It reflects the composite nature of the index, the inclusion of several conceptually related regressors, and the explanatory power of country and year fixed effects. It should not be read as evidence that the model has solved identification problems.

## Comparison Across Models

The stability of the signs across all three models is the central empirical result. Informality, unemployment, and inequality are consistently positively associated with vulnerability. Social protection and GDP per capita are consistently negatively associated with vulnerability. This pattern is robust to moving from pooled OLS to country fixed effects and then to two-way fixed effects.

The changes in magnitude are also informative. The informality coefficient declines when country fixed effects are introduced, which indicates that part of the pooled relationship reflects stable cross-country differences. The coefficient then remains very similar after adding year fixed effects, suggesting that the informality-vulnerability relationship is not simply an artifact of common time shocks. The social protection coefficient is especially stable across specifications, remaining close to -0.01 in all three models. GDP per capita is more sensitive to the fixed effects structure, which is unsurprising because development level varies strongly across countries and over time. Unemployment and Gini remain positive throughout.

The preferred interpretation is therefore not that any individual coefficient proves a causal effect. Rather, the results show that the multidimensional vulnerability framework behaves coherently in the panel. Variables that theory associates with greater vulnerability have positive coefficients; variables that theory associates with protective capacity have negative coefficients; and these patterns survive increasingly demanding fixed-effects structures.

## Relation to the Literature

The results are broadly consistent with major themes in development economics, labor economics, and social policy research. A large body of work treats informality as a marker of weak labor-market attachment, limited access to social insurance, low productivity, and exposure to income risk. The positive association between informality and vulnerability is consistent with that conceptual tradition.

The negative association between social protection coverage and vulnerability is also consistent with the general view that social protection systems can buffer households against poverty, unemployment, old-age risk, and shocks. However, the present analysis does not identify the effect of a specific program or reform. It should therefore be read as evidence of alignment between institutional coverage and lower vulnerability, not as a causal estimate of program impact.

The positive coefficients on unemployment and inequality align with the idea that labor-market slack and unequal distribution can increase structural risk. The GDP per capita coefficient aligns with the standard development economics expectation that higher average income is associated with lower vulnerability. A formal literature review should be added before publication, with precise citations and a clearer positioning of the paper relative to work on informality, poverty dynamics, social protection, and multidimensional vulnerability.

## Why FE and TWFE Are Preferable

Fixed effects are preferable because the region contains countries with deeply different institutional histories, development levels, labor-market structures, and social policy regimes. Pooled OLS cannot distinguish whether high vulnerability is associated with informality because informality rises within a country, or because countries with high long-run informality are structurally different from countries with low long-run informality.

Country fixed effects remove time-invariant country differences. Two-way fixed effects go further by also removing common year shocks. The TWFE model is not causal by itself, but it is a more disciplined descriptive specification. It asks whether deviations within countries over time, net of common year patterns, are associated with vulnerability. This is closer to the kind of empirical comparison required in applied development economics.

## Limitations of the Results

The main limitations are substantive, not cosmetic. First, the estimates are associational. Reverse causality is plausible: vulnerability may lead governments to expand social protection, while weak labor markets may both cause and respond to poverty. Second, omitted variables remain important. Fiscal capacity, demographic structure, migration, urbanization, political institutions, sectoral composition, and crisis exposure are not fully modeled here. Third, the index is composite and conceptually linked to several regressors, which increases interpretability for dashboard purposes but complicates causal interpretation.

Fourth, missingness shapes the analytic sample. The first-stage regression uses 178 observations and 17 countries, not the full 648-row panel. Fifth, clustered standard errors are based on 17 country clusters, which is a limited number for inference. Sixth, random effects and Hausman tests were not implemented because the current environment lacks the required R panel-econometric packages.

## Summary

The first-stage econometric results provide coherent descriptive evidence that structural vulnerability in Latin America and the Caribbean is associated with labor informality, social protection, development level, unemployment, and inequality. The results are strongest as evidence for a multidimensional research agenda. They are not yet evidence of causal effects. The next scientific step should be robustness analysis, alternative index construction, sample sensitivity, and eventually stronger identification strategies where policy timing or credible instruments can be documented.
