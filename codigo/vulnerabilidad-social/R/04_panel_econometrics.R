# 04_panel_econometrics.R
# Prepared lightweight panel-econometric specifications.
#
# Status: script template prepared for execution in an R environment. It is not
# run during the exploratory stage. The script uses only variables available in
# data/processed/dashboard_panel.csv and writes explicit notes when optional
# econometric packages are unavailable.
#
# Possible dependent variables:
#   - monetary_poverty
#   - structural_vulnerability_index
# Possible explanatory variables, conditional on availability:
#   - labor_informality
#   - social_protection_coverage
#   - gdp_per_capita
#   - female_labor_participation
#   - unemployment
# Assumptions and limitations:
#   - Country-year aggregate panel; estimates are associational.
#   - Complete-case filtering changes the analytic sample by specification.
#   - Fixed effects absorb time-invariant country differences but do not solve
#     endogeneity, omitted time-varying confounders, or measurement error.
#   - Random effects and Hausman tests require the optional plm package.
#   - Robust and clustered standard errors require sandwich and lmtest.

if (!exists("read_panel")) source("R/00_setup.R")

panel <- read_panel()
base_regressors <- c(
  "labor_informality",
  "social_protection_coverage",
  "gdp_per_capita",
  "female_labor_participation",
  "unemployment"
)
regressors <- intersect(base_regressors, names(panel))
dependent_vars <- intersect(c("monetary_poverty", "structural_vulnerability_index"), names(panel))

availability <- data.frame(
  variable = c(dependent_vars, regressors),
  role = c(rep("dependent", length(dependent_vars)), rep("explanatory", length(regressors))),
  nonmissing = vapply(panel[c(dependent_vars, regressors)], function(x) sum(!is.na(num(x))), integer(1)),
  stringsAsFactors = FALSE
)
write_table(availability, "panel_model_variable_availability.csv")

cluster_coeftest <- function(model, d) {
  if (!optional_package("sandwich") || !optional_package("lmtest")) {
    return("Clustered/robust SE not available: install sandwich and lmtest.")
  }
  vc_country <- sandwich::vcovCL(model, cluster = d$iso3, type = "HC1")
  capture.output(lmtest::coeftest(model, vcov. = vc_country))
}

robust_coeftest <- function(model) {
  if (!optional_package("sandwich") || !optional_package("lmtest")) {
    return("HC1 robust SE not available: install sandwich and lmtest.")
  }
  capture.output(lmtest::coeftest(model, vcov. = sandwich::vcovHC(model, type = "HC1")))
}

run_lm_panel_models <- function(dep) {
  vars <- c(dep, regressors, "iso3", "year")
  d <- panel[complete.cases(panel[vars]), vars]
  for (v in c(dep, regressors, "year")) d[[v]] <- num(d[[v]])

  if (nrow(d) < 30 || length(regressors) == 0) {
    return(paste(dep, ": not available in current panel after complete-case filtering"))
  }

  f_base <- as.formula(paste(dep, "~", paste(regressors, collapse = " + ")))
  formulas <- list(
    pooled_ols = f_base,
    country_fixed_effects = update(f_base, . ~ . + factor(iso3)),
    year_fixed_effects = update(f_base, . ~ . + factor(year)),
    two_way_fixed_effects = update(f_base, . ~ . + factor(iso3) + factor(year))
  )
  models <- lapply(formulas, lm, data = d)

  out <- c(
    paste("Dependent variable:", dep),
    paste("Complete-case observations:", nrow(d)),
    paste("Countries:", length(unique(d$iso3))),
    paste("Years:", paste(range(d$year), collapse = "-")),
    "",
    "Model assumptions:",
    "- Pooled OLS assumes no unobserved country or year heterogeneity correlated with regressors.",
    "- Country FE controls for time-invariant country heterogeneity.",
    "- Year FE controls for common shocks.",
    "- TWFE includes both country and year effects and remains associational.",
    ""
  )

  for (name in names(models)) {
    out <- c(
      out,
      paste("===", name, "==="),
      capture.output(summary(models[[name]])),
      "--- HC1 robust SE ---",
      robust_coeftest(models[[name]]),
      "--- Country-clustered SE ---",
      cluster_coeftest(models[[name]], d),
      ""
    )
  }

  if (optional_package("plm")) {
    pdata <- plm::pdata.frame(d, index = c("iso3", "year"))
    re <- plm::plm(f_base, data = pdata, model = "random")
    fe <- plm::plm(f_base, data = pdata, model = "within", effect = "individual")
    twfe <- plm::plm(f_base, data = pdata, model = "within", effect = "twoways")
    out <- c(
      out,
      "=== random_effects_plm ===",
      capture.output(summary(re)),
      "=== fixed_effects_plm ===",
      capture.output(summary(fe)),
      "=== two_way_fixed_effects_plm ===",
      capture.output(summary(twfe)),
      "=== Hausman test: FE vs RE ===",
      capture.output(plm::phtest(fe, re)),
      ""
    )
  } else {
    out <- c(out, "Random effects and Hausman test not available: install plm.")
  }

  out
}

for (dep in dependent_vars) {
  write_model(run_lm_panel_models(dep), paste0("panel_models_", dep, ".txt"))
}
