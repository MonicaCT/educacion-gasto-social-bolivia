# Contributing

Thank you for considering contributions to this research repository. The project is designed as a reproducible applied development economics and data science workflow.

## Scope

Useful contributions include:

- Documentation improvements.
- Reproducibility checks.
- Data-quality notes.
- Lightweight descriptive analysis.
- Transparent econometric or machine-learning scripts.
- Improvements to figures, tables, and methodology notes.

Please do not add new data sources without documenting source, download date, variable definitions, units, and license or access conditions.

## Research Standards

- Do not modify raw or processed panel data manually.
- Keep descriptive findings separate from causal claims.
- Document all sample restrictions.
- Report missingness and variable coverage before modeling.
- Prefer simple, auditable code over complex pipelines.
- Avoid expensive model tuning unless it is explicitly justified.

## Reproducibility

Before submitting changes:

1. Run the lightweight PowerShell outputs if working on Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/run_minimal_outputs.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/run_eda_report.ps1
```

2. If R is available, run:

```bash
Rscript run_all.R
```

3. Confirm that generated outputs are written to `outputs/` and that no temporary files are committed.

## Commit Style

Use concise, descriptive commit messages, for example:

- `document empirical framework`
- `add exploratory data audit outputs`
- `prepare panel econometrics templates`

## Review Checklist

- The change is consistent with the current panel.
- No undocumented data were added.
- No model results were invented or manually edited.
- Documentation reflects limitations and missingness.
- Figures and tables can be regenerated.

