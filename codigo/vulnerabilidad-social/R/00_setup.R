# 00_setup.R
# Shared setup for the structural vulnerability LAC analysis.

`%||%` <- function(x, y) if (is.null(x)) y else x

project_root <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% getwd()), ".."), mustWork = FALSE)
if (!dir.exists(file.path(project_root, "data"))) project_root <- getwd()

paths <- list(
  data = file.path(project_root, "data", "processed", "dashboard_panel.csv"),
  tables = file.path(project_root, "outputs", "tables"),
  figures = file.path(project_root, "outputs", "figures"),
  models = file.path(project_root, "outputs", "models")
)
invisible(lapply(paths[c("tables", "figures", "models")], dir.create, recursive = TRUE, showWarnings = FALSE))

read_panel <- function() {
  read.csv(paths$data, stringsAsFactors = FALSE, check.names = FALSE)
}
num <- function(x) suppressWarnings(as.numeric(x))
write_table <- function(x, name) write.csv(x, file.path(paths$tables, name), row.names = FALSE)
write_model <- function(x, name) writeLines(x, file.path(paths$models, name), useBytes = TRUE)

minmax <- function(x, higher_is_risk = TRUE) {
  x <- num(x)
  rng <- range(x, na.rm = TRUE)
  if (!is.finite(rng[1]) || diff(rng) == 0) return(rep(NA_real_, length(x)))
  z <- (x - rng[1]) / diff(rng)
  if (higher_is_risk) z else 1 - z
}
zscore <- function(x, higher_is_risk = TRUE) {
  x <- num(x); s <- sd(x, na.rm = TRUE)
  if (!is.finite(s) || s == 0) return(rep(NA_real_, length(x)))
  z <- (x - mean(x, na.rm = TRUE)) / s
  if (higher_is_risk) z else -z
}
optional_package <- function(pkg) requireNamespace(pkg, quietly = TRUE)
