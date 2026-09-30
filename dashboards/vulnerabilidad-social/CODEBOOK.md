# Codebook

Main file: `data/processed/dashboard_panel.csv`.

| Variable | Description |
|---|---|
| `iso3` | ISO3 country code. |
| `country_name` | Country name. |
| `region_lac` | Regional grouping used in the source panel. |
| `year` | Calendar year. |
| `monetary_poverty` | Monetary poverty measure in the harmonized panel. |
| `extreme_poverty` | Extreme poverty measure in the harmonized panel. |
| `labor_informality` | Labor informality measure. |
| `social_protection_coverage` | Social protection coverage measure. |
| `gdp_per_capita` | GDP per capita. |
| `female_labor_participation` | Female labor-force participation. |
| `male_labor_participation` | Male labor-force participation. |
| `unemployment` | Unemployment rate. |
| `gini` | Income inequality measure. |
| `social_expenditure` | Social expenditure indicator where available. |
| `structural_vulnerability_index` | Existing structural vulnerability index from the source dashboard panel. |

Generated variables in `panel_with_indices.csv` include min-max and z-score component transformations, `gender_gap`, `svi_minmax`, and `svi_zscore`.