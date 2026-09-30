source("R/00_setup.R")
panel <- read_panel()
vars <- c("monetary_poverty", "labor_informality", "social_protection_coverage", "structural_vulnerability_index")

trend <- aggregate(panel[vars], list(year=panel$year), function(x) mean(num(x), na.rm=TRUE))
write_table(trend, "yearly_trends.csv")

latest_year <- max(panel$year, na.rm=TRUE)
latest <- panel[panel$year == latest_year, ]
latest <- latest[order(-num(latest$structural_vulnerability_index)), ]
write_table(latest[, c("iso3","country_name","year",vars)], "latest_structural_vulnerability_ranking.csv")

bolivia <- panel[panel$country_name == "Bolivia", ]
write_table(bolivia[, c("iso3","country_name","year",vars)], "bolivia_profile.csv")

corr_vars <- c("monetary_poverty","labor_informality","social_protection_coverage","gdp_per_capita","female_labor_participation","unemployment","structural_vulnerability_index")
corr <- cor(panel[corr_vars], use="pairwise.complete.obs")
write.csv(corr, file.path(paths$tables, "correlation_matrix.csv"))

png(file.path(paths$figures, "yearly_trends.png"), width=1200, height=800, res=140)
plot(trend$year, trend$monetary_poverty, type="l", col="#0B2F44", lwd=2, xlab="Year", ylab="Percent", main="Average poverty, informality, and social protection")
lines(trend$year, trend$labor_informality, col="#8A7650", lwd=2)
lines(trend$year, trend$social_protection_coverage, col="#6F8F7A", lwd=2)
legend("topright", legend=c("Poverty", "Informality", "Social protection"), col=c("#0B2F44", "#8A7650", "#6F8F7A"), lwd=2, bty="n")
dev.off()