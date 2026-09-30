# OECD-Style Research Dashboard

This folder contains a lightweight Quarto dashboard for the research repository.

## Files

- `dashboard.qmd`: dashboard source file.
- `styles.css`: OECD-inspired academic styling.
- `README.md`: dashboard notes.

## Render

```bash
quarto render dashboard/dashboard.qmd
```

The dashboard is static and does not require Shiny. It uses precomputed figures from `outputs/figures/oecd_style/` and existing model outputs from `outputs/models/`.

## Interpretation

The dashboard reports descriptive and associational evidence only. Econometric results should not be interpreted as causal estimates.
