# 06_robustness_sensitivity.R
# Prepared robustness and sensitivity checks for the vulnerability index.
#
# Status: lightweight script template for future execution in R.
#
# Checks prepared:
#   - min-max index versus z-score index
#   - alternative component weights
#   - leave-one-component-out rankings
#   - latest-year rank correlations
# Assumptions and limitations:
#   - This script evaluates index construction, not causal effects.
#   - Components are used only when available in the current panel.
#   - Missingness can affect the composition of each index variant.

if (!exists("read_panel")) source("R/00_setup.R")

panel_path <- file.path(project_root, "data", "processed", "panel_with_indices.csv")
panel <- if (file.exists(panel_path)) read.csv(panel_path, stringsAsFactors = FALSE) else read_panel()

risk_components <- intersect(c(
  "monetary_poverty",
  "labor_informality",
  "unemployment",
  "gini"
), names(panel))
protective_components <- intersect(c(
  "social_protection_coverage",
  "gdp_per_capita",
  "female_labor_participation"
), names(panel))
components <- c(risk_components, protective_components)

for (v in components) panel[[v]] <- num(panel[[v]])

if (length(components) < 2) {
  write_model("not available in current panel: fewer than two index components", "robustness_summary.txt")
} else {
  make_index <- function(data, weights = NULL, method = c("minmax", "zscore"), omit = character()) {
    method <- match.arg(method)
    use_components <- setdiff(components, omit)
    if (is.null(weights)) weights <- rep(1 / length(use_components), length(use_components))
    weights <- weights / sum(weights)
    pieces <- lapply(use_components, function(v) {
      higher_is_risk <- v %in% risk_components
      if (method == "minmax") minmax(data[[v]], higher_is_risk) else zscore(data[[v]], higher_is_risk)
    })
    mat <- do.call(cbind, pieces)
    rowSums(t(t(mat) * weights), na.rm = FALSE)
  }

  panel$svi_minmax_sensitivity <- make_index(panel, method = "minmax")
  panel$svi_zscore_sensitivity <- make_index(panel, method = "zscore")

  latest_year <- max(num(panel$year), na.rm = TRUE)
  latest <- panel[num(panel$year) == latest_year, ]
  latest$rank_minmax <- rank(-latest$svi_minmax_sensitivity, ties.method = "min")
  latest$rank_zscore <- rank(-latest$svi_zscore_sensitivity, ties.method = "min")
  write_table(latest[, c("iso3", "country_name", "year", "rank_minmax", "rank_zscore", "svi_minmax_sensitivity", "svi_zscore_sensitivity")], "ranking_method_sensitivity.csv")

  weight_sets <- list(
    equal_weights = rep(1, length(components)),
    poverty_informality_emphasis = ifelse(components %in% c("monetary_poverty", "labor_informality"), 2, 1),
    protection_macro_emphasis = ifelse(components %in% c("social_protection_coverage", "gdp_per_capita"), 2, 1)
  )
  weight_rows <- do.call(rbind, lapply(names(weight_sets), function(name) {
    idx <- make_index(panel, weights = weight_sets[[name]], method = "minmax")
    tmp <- panel[num(panel$year) == latest_year, c("iso3", "country_name", "year")]
    tmp$specification <- name
    tmp$index_value <- idx[num(panel$year) == latest_year]
    tmp$rank <- rank(-tmp$index_value, ties.method = "min")
    tmp
  }))
  write_table(weight_rows, "weight_sensitivity_latest.csv")

  loo_rows <- do.call(rbind, lapply(components, function(omit_component) {
    idx <- make_index(panel, method = "minmax", omit = omit_component)
    tmp <- panel[num(panel$year) == latest_year, c("iso3", "country_name", "year")]
    tmp$omitted_component <- omit_component
    tmp$index_value <- idx[num(panel$year) == latest_year]
    tmp$rank <- rank(-tmp$index_value, ties.method = "min")
    tmp
  }))
  write_table(loo_rows, "leave_one_out_component_rankings.csv")

  summary_lines <- c(
    "Robustness and sensitivity summary",
    paste("Components used:", paste(components, collapse = ", ")),
    paste("Latest year:", latest_year),
    paste("Rank correlation min-max vs z-score:", round(cor(latest$rank_minmax, latest$rank_zscore, use = "complete.obs"), 3)),
    "Prepared checks: min-max versus z-score, alternative weights, leave-one-component-out rankings.",
    "Interpretation: large rank shifts indicate sensitivity to index construction and should be reported as a limitation."
  )
  write_model(summary_lines, "robustness_summary.txt")
}
