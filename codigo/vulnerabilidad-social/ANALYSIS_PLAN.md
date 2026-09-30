# Analysis Plan

This plan organizes the repository as a staged research project. Stages should be executed sequentially, with reproducibility checks before moving from descriptive work to model-based claims.

## Stage 1: Exploratory Data Analysis

Objective: Understand the country-year panel before estimating models.

Current status: Completed in `DATA_EXPLORATION_REPORT.md` and `outputs/eda/`.

Core tasks:

- Verify panel dimensions, countries, years, and row balance.
- Summarize missingness by variable, country, and year.
- Produce descriptive statistics, histograms, boxplots, missingness maps, correlation matrices, aggregate trends, and rankings.
- Identify high missingness variables and likely modeling constraints.

Decision rule: No model should be interpreted before sample coverage and missingness are documented.

## Stage 2: Composite Index Construction

Objective: Evaluate structural vulnerability as a multidimensional construct.

Core tasks:

- Normalize available indicators using min-max and z-score transformations.
- Define baseline component weights.
- Construct alternative index variants.
- Compare country rankings across index definitions.
- Document sensitivity to missingness and component inclusion.

Expected output: Index tables, latest-year rankings, Bolivia versus LAC profile, and sensitivity diagnostics.

## Stage 3: Econometric Analysis

Objective: Estimate associational panel relationships using transparent, lightweight specifications.

Core tasks:

- Estimate pooled OLS, country fixed effects, year fixed effects, and two-way fixed effects.
- Add random effects and Hausman tests when `plm` is available.
- Report robust and country-clustered standard errors when `sandwich` and `lmtest` are available.
- Use `monetary_poverty`, `extreme_poverty`, and `structural_vulnerability_index` as possible outcomes.

Interpretation rule: Results are associational unless a future design provides credible identification.

## Stage 4: Machine Learning

Objective: Assess whether observable indicators can classify high-vulnerability country-years.

Core tasks:

- Define `high_risk` using the 75th percentile of the structural vulnerability index.
- Fit a random forest if available.
- Fit gradient boosting only if `gbm` is already installed.
- Use logistic regression as the base-R fallback.
- Report accuracy and AUC only where supported.
- Produce feature-importance summaries when available.

Interpretation rule: Predictive performance does not imply causal importance.

## Stage 5: Robustness

Objective: Evaluate whether descriptive and model-based findings depend on measurement choices.

Core tasks:

- Compare min-max and z-score index variants.
- Test alternative weights.
- Conduct leave-one-component-out index rankings.
- Compare samples with and without high-missingness variables.
- Report all sample restrictions.

## Stage 6: Policy Implications

Objective: Translate descriptive evidence into careful applied policy insights.

Core tasks:

- Identify country profiles with overlapping poverty, informality, and social protection gaps.
- Separate descriptive patterns from causal claims.
- Discuss institutional constraints and measurement limitations.
- Highlight where better data are needed.

## Stage 7: Academic Paper

Objective: Convert the repository into a paper-ready research workflow.

Core tasks:

- Write introduction, conceptual framework, data section, empirical strategy, results, robustness, and limitations.
- Ensure every table and figure is reproducible from scripts.
- Keep claims proportional to the identification strategy.
- Prepare transparent appendices for index construction and missingness.

## Stage 8: Interactive Dashboard

Objective: Communicate the panel and findings through an accessible research interface.

Core tasks:

- Present rankings, country profiles, and trend diagnostics.
- Link dashboard visuals to reproducible outputs.
- Include methodological notes and data limitations.
- Avoid presenting descriptive evidence as causal.

