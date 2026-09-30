source("R/00_setup.R")
panel <- read_panel()

num_vars <- c("monetary_poverty","extreme_poverty","labor_informality","social_protection_coverage","gdp_per_capita","female_labor_participation","male_labor_participation","unemployment","gini","social_expenditure","structural_vulnerability_index")
summary <- data.frame(
  metric = c("rows", "columns", "countries", "first_year", "last_year", "balanced_panel"),
  value = c(nrow(panel), ncol(panel), length(unique(panel$iso3)), min(panel$year), max(panel$year), nrow(panel) == length(unique(panel$iso3))*length(unique(panel$year)))
)
write_table(summary, "data_audit_summary.csv")

coverage <- do.call(rbind, lapply(names(panel), function(v) {
  non_missing <- sum(!is.na(panel[[v]]) & panel[[v]] != "")
  data.frame(variable = v, non_missing = non_missing, missing = nrow(panel) - non_missing, coverage_pct = round(100 * non_missing/nrow(panel), 2))
}))
write_table(coverage, "missing_values.csv")

desc <- do.call(rbind, lapply(intersect(num_vars, names(panel)), function(v) {
  x <- num(panel[[v]])
  data.frame(variable=v, n=sum(!is.na(x)), mean=mean(x,na.rm=TRUE), sd=sd(x,na.rm=TRUE), min=min(x,na.rm=TRUE), p25=quantile(x,.25,na.rm=TRUE), median=median(x,na.rm=TRUE), p75=quantile(x,.75,na.rm=TRUE), max=max(x,na.rm=TRUE))
}))
write_table(desc, "descriptive_statistics.csv")

balance <- aggregate(year ~ iso3 + country_name, panel, function(x) length(unique(x)))
names(balance)[3] <- "observed_years"
balance$balanced <- balance$observed_years == length(unique(panel$year))
write_table(balance, "panel_balance.csv")