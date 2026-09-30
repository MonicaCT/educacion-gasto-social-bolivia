# Limitations

- The current panel is aggregate country-year data, not household microdata.
- Descriptive patterns should not be interpreted causally.
- Missingness differs across indicators, especially social protection and gender labor variables.
- Econometric models require an R runtime; coefficients were not generated in the current environment.
- Random forest requires the `randomForest` package; it is optional and not installed here.
- Composite index rankings are sensitive to normalization, weighting, and indicator coverage.
- If a variable is not present in the panel, scripts omit it or document it as not available in the current panel.