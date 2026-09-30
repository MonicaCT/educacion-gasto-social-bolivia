# Data Exploration Report

This report summarizes the current dashboard_panel.csv only. No data were downloaded, no original panel values were modified, and no econometric or machine-learning models were estimated.

## Panel Overview

- Observations: 648 country-years
- Countries: 27
- Years: 24 (2000-2023)
- Variables: 15
- Rows complete across all numeric indicators: 14

## Variable Dictionary and Coverage

| variable | type | description | units | nonmissing | missing_pct | first_year | last_year | countries_with_data |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| iso3 | identifier/text | country identifier | identifier | 648 | 0.00 | 2000 | 2023 | 27 |
| country_name | identifier/text | country name | text | 648 | 0.00 | 2000 | 2023 | 27 |
| region_lac | categorical/text | regional classification | categorical | 648 | 0.00 | 2000 | 2023 | 27 |
| year | numeric | calendar year | integer | 648 | 0.00 | 2000 | 2023 | 27 |
| monetary_poverty | numeric | monetary poverty | percentage/rate | 423 | 34.72 | 2000 | 2023 | 23 |
| extreme_poverty | numeric | extreme poverty | percentage/rate | 423 | 34.72 | 2000 | 2023 | 23 |
| labor_informality | numeric | labor informality | percentage/rate | 302 | 53.40 | 2000 | 2023 | 24 |
| social_protection_coverage | numeric | social protection coverage | percentage/rate | 202 | 68.83 | 2002 | 2023 | 21 |
| gdp_per_capita | numeric | GDP per capita | monetary level | 648 | 0.00 | 2000 | 2023 | 27 |
| female_labor_participation | numeric | female labor force participation | percentage/rate | 87 | 86.57 | 2016 | 2023 | 11 |
| male_labor_participation | numeric | male labor force participation | percentage/rate | 87 | 86.57 | 2016 | 2023 | 11 |
| unemployment | numeric | unemployment | percentage/rate | 521 | 19.60 | 2000 | 2023 | 27 |
| gini | numeric | income inequality | index | 351 | 45.83 | 2000 | 2023 | 23 |
| social_expenditure | numeric | social expenditure | numeric indicator | 146 | 77.47 | 2000 | 2020 | 8 |
| structural_vulnerability_index | numeric | structural vulnerability index | index | 648 | 0.00 | 2000 | 2023 | 27 |

## Descriptive Statistics

| variable | n | mean | sd | min | p25 | median | p75 | max | cv_abs |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| year | 648 | 2,011.500 | 6.928 | 2,000.000 | 2,005.750 | 2,011.500 | 2,017.250 | 2,023.000 | 0.003 |
| monetary_poverty | 423 | 30.797 | 19.805 | 0.500 | 15.800 | 29.700 | 46.300 | 93.600 | 0.643 |
| extreme_poverty | 423 | 8.508 | 8.427 | 0.100 | 2.200 | 6.100 | 12.250 | 75.100 | 0.990 |
| labor_informality | 302 | 60.730 | 16.917 | 18.325 | 48.904 | 60.322 | 74.222 | 98.413 | 0.279 |
| social_protection_coverage | 202 | 60.121 | 18.220 | 14.523 | 46.424 | 63.058 | 74.406 | 97.987 | 0.303 |
| gdp_per_capita | 648 | 8,385.307 | 6,711.018 | 1,219.119 | 3,997.600 | 6,181.389 | 10,298.263 | 33,549.336 | 0.800 |
| female_labor_participation | 87 | 51.986 | 6.465 | 42.275 | 47.354 | 50.825 | 56.063 | 72.775 | 0.124 |
| male_labor_participation | 87 | 75.775 | 4.398 | 66.375 | 71.788 | 76.275 | 78.100 | 85.025 | 0.058 |
| unemployment | 521 | 7.138 | 3.632 | 1.583 | 4.311 | 6.600 | 9.225 | 25.438 | 0.509 |
| gini | 351 | 48.124 | 5.239 | 34.100 | 44.600 | 48.300 | 52.000 | 61.600 | 0.109 |
| social_expenditure | 146 | 6.282 | 3.694 | 0.852 | 3.751 | 5.550 | 7.982 | 20.879 | 0.588 |
| structural_vulnerability_index | 648 | -0.164 | 0.708 | -2.299 | -0.549 | -0.234 | 0.233 | 3.316 | 4.304 |

## Missing Values

The panel is balanced at the country-year row level, but indicator coverage varies by variable and country. Variables with the highest missing shares are:

| variable | nonmissing | missing | missing_pct | countries_with_data |
| --- | --- | --- | --- | --- |
| male_labor_participation | 87 | 561 | 86.57 | 11 |
| female_labor_participation | 87 | 561 | 86.57 | 11 |
| social_expenditure | 146 | 502 | 77.47 | 8 |
| social_protection_coverage | 202 | 446 | 68.83 | 21 |
| labor_informality | 302 | 346 | 53.40 | 24 |
| gini | 351 | 297 | 45.83 | 23 |
| monetary_poverty | 423 | 225 | 34.72 | 23 |
| extreme_poverty | 423 | 225 | 34.72 | 23 |
| unemployment | 521 | 127 | 19.60 | 27 |
| structural_vulnerability_index | 648 | 0 | 0.00 | 27 |

See outputs/eda/missing_values_map.svg for the country-year missingness map.

## Distribution and Outlier Screen

Potential outliers are flagged using a simple 1.5 IQR rule. These are diagnostic flags rather than deletion rules.

| variable | outlier_rule | lower_bound | upper_bound | outlier_count | outlier_pct | min_outlier | max_outlier |
| --- | --- | --- | --- | --- | --- | --- | --- |
| gdp_per_capita | 1.5*IQR | -5,453.394 | 19,749.258 | 49 | 7.56 | 19,887.233 | 33,549.336 |
| structural_vulnerability_index | 1.5*IQR | -1.721 | 1.406 | 41 | 6.33 | -2.299 | 3.316 |
| extreme_poverty | 1.5*IQR | -12.875 | 27.325 | 12 | 2.84 | 27.400 | 75.100 |
| unemployment | 1.5*IQR | -3.060 | 16.596 | 10 | 1.92 | 16.648 | 25.438 |
| social_expenditure | 1.5*IQR | -2.594 | 14.328 | 6 | 4.11 | 14.359 | 20.879 |
| female_labor_participation | 1.5*IQR | 34.292 | 69.125 | 3 | 3.45 | 71.425 | 72.775 |
| monetary_poverty | 1.5*IQR | -29.950 | 92.050 | 1 | 0.24 | 93.600 | 93.600 |
| labor_informality | 1.5*IQR | 10.928 | 112.199 | 0 | 0.00 |  |  |

Distribution plots are saved as:

- outputs/eda/histograms.svg
- outputs/eda/boxplots.svg

## Main Correlations

Pairwise Pearson correlations are computed using available observations for each pair. The strongest absolute correlations are:

| variable_1 | variable_2 | correlation | abs_correlation |
| --- | --- | --- | --- |
| labor_informality | gdp_per_capita | -0.844 | 0.844 |
| monetary_poverty | extreme_poverty | 0.793 | 0.793 |
| monetary_poverty | structural_vulnerability_index | 0.791 | 0.791 |
| gdp_per_capita | male_labor_participation | -0.769 | 0.769 |
| labor_informality | male_labor_participation | 0.767 | 0.767 |
| gini | structural_vulnerability_index | 0.749 | 0.749 |
| extreme_poverty | structural_vulnerability_index | 0.735 | 0.735 |

The full matrix is saved as outputs/eda/correlation_matrix.svg and outputs/eda/eda_correlation_matrix.csv.

## Variables With Low Variability

No numeric indicator is flagged by the low-variability screen (sd = 0 or absolute coefficient of variation below 0.05).

## Time-Series and Ranking Diagnostics

Aggregate trends and latest-year rankings are saved as:

- outputs/eda/aggregate_time_series.svg
- outputs/eda/rankings_by_indicator.svg
- outputs/eda/eda_aggregate_time_series.csv
- outputs/eda/eda_latest_rankings_by_indicator.csv

These graphics are descriptive and should not be interpreted as causal evidence.

## Panel Limitations

- The current panel is country-year aggregate data; it cannot identify household-level mechanisms.
- Units and source definitions are not fully embedded for every variable, especially social_expenditure and the exact monetary unit of gdp_per_capita.
- Missingness differs across indicators, which can change the sample used by each descriptive or modeling exercise.
- The structural vulnerability index is already present in the panel; alternative index construction is scripted elsewhere but should be reported transparently.
- Correlations and rankings are sensitive to indicator scaling, missing data, and country coverage.
- Econometric and machine-learning scripts should be treated as prepared analysis templates until executed in an R environment with explicit runtime logs.