param(
  [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"
$culture = [Globalization.CultureInfo]::InvariantCulture
$dataPath = Join-Path $ProjectRoot "data\processed\dashboard_panel.csv"
$modelsDir = Join-Path $ProjectRoot "outputs\models"
$figDir = Join-Path $ProjectRoot "outputs\figures\models"
New-Item -ItemType Directory -Force -Path $modelsDir | Out-Null
New-Item -ItemType Directory -Force -Path $figDir | Out-Null

Add-Type -TypeDefinition @"
using System;
using System.Collections.Generic;

public class OlsResult {
  public double[] Beta;
  public double[] Residuals;
  public double[] Fitted;
  public double[,] ClusterVcov;
  public double[,] ClassicVcov;
  public double R2;
  public double AdjR2;
  public int N;
  public int K;
  public int Clusters;
}

public static class Econometrics {
  public static double[,] Transpose(double[,] a) {
    int n = a.GetLength(0), k = a.GetLength(1);
    double[,] t = new double[k,n];
    for (int i=0;i<n;i++) for (int j=0;j<k;j++) t[j,i] = a[i,j];
    return t;
  }
  public static double[,] MatMul(double[,] a, double[,] b) {
    int n = a.GetLength(0), m = a.GetLength(1), k = b.GetLength(1);
    double[,] c = new double[n,k];
    for (int i=0;i<n;i++) for (int j=0;j<k;j++) {
      double s = 0.0;
      for (int r=0;r<m;r++) s += a[i,r] * b[r,j];
      c[i,j] = s;
    }
    return c;
  }
  public static double[] MatVec(double[,] a, double[] x) {
    int n = a.GetLength(0), k = a.GetLength(1);
    double[] y = new double[n];
    for (int i=0;i<n;i++) {
      double s = 0.0;
      for (int j=0;j<k;j++) s += a[i,j] * x[j];
      y[i] = s;
    }
    return y;
  }
  public static double[,] Invert(double[,] a) {
    int n = a.GetLength(0);
    double[,] aug = new double[n, 2*n];
    for (int i=0;i<n;i++) {
      for (int j=0;j<n;j++) aug[i,j] = a[i,j];
      aug[i,n+i] = 1.0;
    }
    for (int col=0; col<n; col++) {
      int pivot = col;
      double max = Math.Abs(aug[col,col]);
      for (int r=col+1; r<n; r++) {
        double val = Math.Abs(aug[r,col]);
        if (val > max) { max = val; pivot = r; }
      }
      if (max < 1e-12) throw new Exception("Singular matrix in OLS design.");
      if (pivot != col) {
        for (int j=0;j<2*n;j++) { double tmp = aug[col,j]; aug[col,j] = aug[pivot,j]; aug[pivot,j] = tmp; }
      }
      double div = aug[col,col];
      for (int j=0;j<2*n;j++) aug[col,j] /= div;
      for (int r=0;r<n;r++) if (r != col) {
        double factor = aug[r,col];
        for (int j=0;j<2*n;j++) aug[r,j] -= factor * aug[col,j];
      }
    }
    double[,] inv = new double[n,n];
    for (int i=0;i<n;i++) for (int j=0;j<n;j++) inv[i,j] = aug[i,n+j];
    return inv;
  }
  public static OlsResult Fit(double[,] X, double[] y, string[] cluster) {
    int n = X.GetLength(0), k = X.GetLength(1);
    double[,] Xt = Transpose(X);
    double[,] XtX = MatMul(Xt, X);
    double[,] XtXInv = Invert(XtX);
    double[] Xty = MatVec(Xt, y);
    double[] beta = MatVec(XtXInv, Xty);
    double[] fitted = MatVec(X, beta);
    double[] resid = new double[n];
    double ybar = 0.0;
    for (int i=0;i<n;i++) ybar += y[i];
    ybar /= n;
    double sse = 0.0, tss = 0.0;
    for (int i=0;i<n;i++) { resid[i] = y[i] - fitted[i]; sse += resid[i]*resid[i]; tss += (y[i]-ybar)*(y[i]-ybar); }
    double sigma2 = sse / Math.Max(1, n-k);
    double[,] classic = new double[k,k];
    for (int i=0;i<k;i++) for (int j=0;j<k;j++) classic[i,j] = sigma2 * XtXInv[i,j];

    Dictionary<string, double[]> sums = new Dictionary<string, double[]>();
    for (int i=0;i<n;i++) {
      string g = cluster[i];
      if (!sums.ContainsKey(g)) sums[g] = new double[k];
      for (int j=0;j<k;j++) sums[g][j] += X[i,j] * resid[i];
    }
    double[,] meat = new double[k,k];
    foreach (double[] s in sums.Values) {
      for (int i=0;i<k;i++) for (int j=0;j<k;j++) meat[i,j] += s[i]*s[j];
    }
    double[,] tmp = MatMul(XtXInv, meat);
    double[,] clusterV = MatMul(tmp, XtXInv);
    int G = sums.Count;
    double correction = 1.0;
    if (G > 1 && n > k) correction = (G/(G-1.0)) * ((n-1.0)/(n-k));
    for (int i=0;i<k;i++) for (int j=0;j<k;j++) clusterV[i,j] *= correction;

    double r2 = 1.0 - sse/tss;
    double adj = 1.0 - (1.0-r2) * ((n-1.0)/(Math.Max(1.0, n-k)));
    return new OlsResult { Beta=beta, Residuals=resid, Fitted=fitted, ClusterVcov=clusterV, ClassicVcov=classic, R2=r2, AdjR2=adj, N=n, K=k, Clusters=G };
  }

  public static double LogGamma(double z) {
    double[] p = {676.5203681218851, -1259.1392167224028, 771.32342877765313, -176.61502916214059, 12.507343278686905, -0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7};
    if (z < 0.5) return Math.Log(Math.PI) - Math.Log(Math.Sin(Math.PI*z)) - LogGamma(1-z);
    z -= 1;
    double x = 0.99999999999980993;
    for (int i=0;i<p.Length;i++) x += p[i]/(z+i+1);
    double t = z + p.Length - 0.5;
    return 0.5*Math.Log(2*Math.PI) + (z+0.5)*Math.Log(t) - t + Math.Log(x);
  }
  public static double Betacf(double a, double b, double x) {
    int maxit = 200;
    double eps = 3e-14, fpmin = 1e-300;
    double qab = a+b, qap = a+1, qam = a-1;
    double c = 1.0, d = 1.0 - qab*x/qap;
    if (Math.Abs(d) < fpmin) d = fpmin;
    d = 1.0/d;
    double h = d;
    for (int m=1; m<=maxit; m++) {
      int m2 = 2*m;
      double aa = m*(b-m)*x/((qam+m2)*(a+m2));
      d = 1.0 + aa*d; if (Math.Abs(d) < fpmin) d = fpmin;
      c = 1.0 + aa/c; if (Math.Abs(c) < fpmin) c = fpmin;
      d = 1.0/d; h *= d*c;
      aa = -(a+m)*(qab+m)*x/((a+m2)*(qap+m2));
      d = 1.0 + aa*d; if (Math.Abs(d) < fpmin) d = fpmin;
      c = 1.0 + aa/c; if (Math.Abs(c) < fpmin) c = fpmin;
      d = 1.0/d;
      double del = d*c;
      h *= del;
      if (Math.Abs(del-1.0) < eps) break;
    }
    return h;
  }
  public static double RegularizedBeta(double x, double a, double b) {
    if (x <= 0) return 0;
    if (x >= 1) return 1;
    double bt = Math.Exp(LogGamma(a+b) - LogGamma(a) - LogGamma(b) + a*Math.Log(x) + b*Math.Log(1-x));
    if (x < (a+1)/(a+b+2)) return bt * Betacf(a,b,x) / a;
    return 1 - bt * Betacf(b,a,1-x) / b;
  }
  public static double StudentTCdf(double t, double df) {
    if (df <= 0) return Double.NaN;
    if (t == 0) return 0.5;
    double x = df / (df + t*t);
    double ib = RegularizedBeta(x, df/2.0, 0.5);
    if (t > 0) return 1 - 0.5*ib;
    return 0.5*ib;
  }
  public static double PValueFromT(double t, double df) {
    double cdf = StudentTCdf(Math.Abs(t), df);
    return Math.Max(0.0, Math.Min(1.0, 2.0*(1.0-cdf)));
  }
}
"@

function Is-Missing($v) {
  return ($null -eq $v -or [string]::IsNullOrWhiteSpace([string]$v) -or [string]$v -in @("NA","NaN","null","."))
}
function To-Double($v) {
  if (Is-Missing $v) { return $null }
  $tmp = 0.0
  if ([double]::TryParse([string]$v, [Globalization.NumberStyles]::Any, $culture, [ref]$tmp)) { return $tmp }
  return $null
}
function Fmt($x, [int]$digits = 3) {
  if ($null -eq $x -or [double]::IsNaN([double]$x)) { return "" }
  return ([double]$x).ToString("N$digits", $culture)
}
function Html($s) { [System.Net.WebUtility]::HtmlEncode([string]$s) }
function Stars($p) {
  if ($null -eq $p -or [double]::IsNaN([double]$p)) { return "" }
  if ($p -lt 0.01) { return "***" }
  if ($p -lt 0.05) { return "**" }
  if ($p -lt 0.10) { return "*" }
  return ""
}
function SignifText($p) {
  if ($p -lt 0.01) { return "statistically significant at the 1% level" }
  if ($p -lt 0.05) { return "statistically significant at the 5% level" }
  if ($p -lt 0.10) { return "marginally significant at the 10% level" }
  return "not statistically significant at conventional levels"
}
function DirectionText($b) {
  if ($b -gt 0) { return "higher" }
  if ($b -lt 0) { return "lower" }
  return "unchanged"
}

$panel = Import-Csv -LiteralPath $dataPath
$columns = @($panel[0].PSObject.Properties.Name)
$depCandidates = @("structural_vulnerability_index", "monetary_poverty")
$dep = $depCandidates | Where-Object { $columns -contains $_ } | Select-Object -First 1
if (-not $dep) { throw "No candidate dependent variable found." }

$regressors = @("labor_informality", "social_protection_coverage", "gdp_per_capita_1000", "unemployment", "gini")
$rawNeeded = @($dep, "labor_informality", "social_protection_coverage", "gdp_per_capita", "unemployment", "gini", "iso3", "country_name", "year")
$sample = @()
foreach ($row in $panel) {
  $ok = $true
  foreach ($v in $rawNeeded) { if (Is-Missing $row.$v) { $ok = $false; break } }
  if ($ok) {
    $obj = [ordered]@{
      iso3 = $row.iso3
      country_name = $row.country_name
      year = [int]$row.year
      dependent = [double](To-Double $row.$dep)
      labor_informality = [double](To-Double $row.labor_informality)
      social_protection_coverage = [double](To-Double $row.social_protection_coverage)
      gdp_per_capita_1000 = ([double](To-Double $row.gdp_per_capita)) / 1000.0
      unemployment = [double](To-Double $row.unemployment)
      gini = [double](To-Double $row.gini)
    }
    $sample += [pscustomobject]$obj
  }
}

$diagnostics = @()
$diagCombos = @(
  @("gdp_per_capita", "unemployment"),
  @("labor_informality", "gdp_per_capita", "unemployment"),
  @("labor_informality", "social_protection_coverage", "gdp_per_capita", "unemployment"),
  @("labor_informality", "social_protection_coverage", "gdp_per_capita", "unemployment", "gini"),
  @("labor_informality", "social_protection_coverage", "gdp_per_capita", "female_labor_participation", "unemployment"),
  @("labor_informality", "social_protection_coverage", "gdp_per_capita", "unemployment", "social_expenditure")
)
foreach ($combo in $diagCombos) {
  $vars = @($dep) + $combo
  $complete = @($panel | Where-Object { $ok=$true; foreach($v in $vars){ if(Is-Missing $_.$v){$ok=$false; break} }; $ok })
  $diagnostics += [pscustomobject]@{
    dependent = $dep
    regressors = ($combo -join " + ")
    observations = $complete.Count
    countries = @($complete.iso3 | Sort-Object -Unique).Count
    years = @($complete.year | Sort-Object -Unique).Count
  }
}
$diagnostics | Export-Csv -LiteralPath (Join-Path $modelsDir "model_selection_diagnostics.csv") -NoTypeInformation -Encoding UTF8

$countries = @($sample.iso3 | Sort-Object -Unique)
$years = @($sample.year | Sort-Object -Unique)
if ($sample.Count -lt 50) { throw "Selected analytic sample is too small: $($sample.Count)." }

function Build-Design($modelType) {
  $names = New-Object System.Collections.Generic.List[string]
  $names.Add("Intercept")
  foreach ($r in $regressors) { $names.Add($r) }
  if ($modelType -in @("fe", "twfe")) {
    foreach ($c in ($countries | Select-Object -Skip 1)) { $names.Add("country_fe_$c") }
  }
  if ($modelType -eq "twfe") {
    foreach ($y in ($years | Select-Object -Skip 1)) { $names.Add("year_fe_$y") }
  }
  $n = $sample.Count
  $k = $names.Count
  $X = New-Object 'double[,]' $n, $k
  $Y = New-Object 'double[]' $n
  $Cluster = New-Object 'string[]' $n
  for ($i=0; $i -lt $n; $i++) {
    $row = $sample[$i]
    $Y[$i] = [double]$row.dependent
    $Cluster[$i] = [string]$row.iso3
    for ($j=0; $j -lt $k; $j++) {
      $name = $names[$j]
      if ($name -eq "Intercept") { $X[$i,$j] = 1.0 }
      elseif ($regressors -contains $name) { $X[$i,$j] = [double]$row.$name }
      elseif ($name.StartsWith("country_fe_")) { $X[$i,$j] = if ($row.iso3 -eq $name.Substring(11)) { 1.0 } else { 0.0 } }
      elseif ($name.StartsWith("year_fe_")) { $X[$i,$j] = if ([int]$row.year -eq [int]$name.Substring(8)) { 1.0 } else { 0.0 } }
    }
  }
  return [pscustomobject]@{ X=$X; Y=$Y; Cluster=$Cluster; Names=@($names) }
}

$modelSpecs = @(
  [pscustomobject]@{ id="model1"; file="model1_pooled.html"; title="Model 1: Pooled OLS"; type="pooled"; countryFE=$false; yearFE=$false; equation="SVI_ct = beta X_ct + epsilon_ct" },
  [pscustomobject]@{ id="model2"; file="model2_fe.html"; title="Model 2: Country Fixed Effects"; type="fe"; countryFE=$true; yearFE=$false; equation="SVI_ct = beta X_ct + alpha_c + epsilon_ct" },
  [pscustomobject]@{ id="model3"; file="model3_twfe.html"; title="Model 3: Two-Way Fixed Effects"; type="twfe"; countryFE=$true; yearFE=$true; equation="SVI_ct = beta X_ct + alpha_c + lambda_t + epsilon_ct" }
)

$results = @{}
$coefRows = @()
foreach ($spec in $modelSpecs) {
  $design = Build-Design $spec.type
  $fit = [Econometrics]::Fit($design.X, $design.Y, $design.Cluster)
  $results[$spec.id] = [pscustomobject]@{ spec=$spec; design=$design; fit=$fit }
  $dfCluster = [math]::Max(1, $fit.Clusters - 1)
  for ($j=0; $j -lt $design.Names.Count; $j++) {
    $name = $design.Names[$j]
    $se = [math]::Sqrt([math]::Abs(($fit.ClusterVcov).GetValue($j,$j)))
    $t = if ($se -gt 0) { $fit.Beta[$j] / $se } else { [double]::NaN }
    $p = [Econometrics]::PValueFromT($t, $dfCluster)
    $coefRows += [pscustomobject]@{
      model_id = $spec.id
      model = $spec.title
      term = $name
      estimate = $fit.Beta[$j]
      cluster_se = $se
      t_stat = $t
      p_value = $p
      conf_low = $fit.Beta[$j] - 1.96*$se
      conf_high = $fit.Beta[$j] + 1.96*$se
      observations = $fit.N
      parameters = $fit.K
      clusters = $fit.Clusters
      r_squared = $fit.R2
      adj_r_squared = $fit.AdjR2
    }
  }
}
$coefRows | Export-Csv -LiteralPath (Join-Path $modelsDir "stage1_coefficients.csv") -NoTypeInformation -Encoding UTF8

$sample | Select-Object iso3,country_name,year,dependent,labor_informality,social_protection_coverage,gdp_per_capita_1000,unemployment,gini | Export-Csv -LiteralPath (Join-Path $modelsDir "stage1_analytic_sample.csv") -NoTypeInformation -Encoding UTF8

$labels = @{
  labor_informality = "Labor informality"
  social_protection_coverage = "Social protection coverage"
  gdp_per_capita_1000 = "GDP per capita (thousands)"
  unemployment = "Unemployment"
  gini = "Gini index"
}

function CoefCell($row) {
  if ($null -eq $row) { return "" }
  $stars = Stars ([double]$row.p_value)
  return "$(Fmt $row.estimate 4)$stars<br><span class='se'>($(Fmt $row.cluster_se 4))</span>"
}
function TableCss() {
  return "<style>body{font-family:Segoe UI,Arial,sans-serif;color:#1f2937;margin:32px;}h1{font-size:22px;color:#12355b;}table{border-collapse:collapse;width:100%;font-size:14px;}th{background:#eef2f7;color:#12355b;text-align:left;}th,td{border:1px solid #d8dee9;padding:8px;vertical-align:top;}.num{text-align:right;}.se{color:#64748b;font-size:12px;}.note{font-size:12px;color:#64748b;margin-top:12px;}caption{caption-side:bottom;text-align:left;color:#64748b;font-size:12px;padding-top:10px;}</style>"
}

foreach ($spec in $modelSpecs) {
  $fit = $results[$spec.id].fit
  $rowsHtml = foreach ($r in $regressors) {
    $row = $coefRows | Where-Object { $_.model_id -eq $spec.id -and $_.term -eq $r } | Select-Object -First 1
    "<tr><td>$(Html $labels[$r])</td><td class='num'>$(Fmt $row.estimate 5)</td><td class='num'>$(Fmt $row.cluster_se 5)</td><td class='num'>$(Fmt $row.t_stat 3)</td><td class='num'>$(Fmt $row.p_value 4)</td></tr>"
  }
  $html = @"
<!doctype html><html><head><meta charset='utf-8'><title>$($spec.title)</title>$(TableCss)</head><body>
<h1>$($spec.title)</h1>
<p><strong>Dependent variable:</strong> $dep. <strong>Inference:</strong> country-clustered standard errors.</p>
<table><thead><tr><th>Variable</th><th>Estimate</th><th>Cluster SE</th><th>t-statistic</th><th>p-value</th></tr></thead><tbody>
$($rowsHtml -join "`n")
</tbody></table>
<p class='note'>Observations: $($fit.N). Countries: $($fit.Clusters). Parameters: $($fit.K). R-squared: $(Fmt $fit.R2 4). Adjusted R-squared: $(Fmt $fit.AdjR2 4). Country fixed effects: $($spec.countryFE). Year fixed effects: $($spec.yearFE). Fixed-effect dummies are estimated but not displayed.</p>
</body></html>
"@
  [IO.File]::WriteAllText((Join-Path $modelsDir $spec.file), $html, [Text.Encoding]::UTF8)
}

$compRows = foreach ($r in $regressors) {
  $cells = foreach ($spec in $modelSpecs) {
    $row = $coefRows | Where-Object { $_.model_id -eq $spec.id -and $_.term -eq $r } | Select-Object -First 1
    "<td class='num'>$(CoefCell $row)</td>"
  }
  "<tr><td>$(Html $labels[$r])</td>$($cells -join '')</tr>"
}
$metaRows = @(
  "<tr><td>Observations</td>" + (($modelSpecs | ForEach-Object { "<td class='num'>$($results[$_.id].fit.N)</td>" }) -join "") + "</tr>",
  "<tr><td>Countries</td>" + (($modelSpecs | ForEach-Object { "<td class='num'>$($results[$_.id].fit.Clusters)</td>" }) -join "") + "</tr>",
  "<tr><td>R-squared</td>" + (($modelSpecs | ForEach-Object { "<td class='num'>$(Fmt $results[$_.id].fit.R2 4)</td>" }) -join "") + "</tr>",
  "<tr><td>Adjusted R-squared</td>" + (($modelSpecs | ForEach-Object { "<td class='num'>$(Fmt $results[$_.id].fit.AdjR2 4)</td>" }) -join "") + "</tr>",
  "<tr><td>Country FE</td>" + (($modelSpecs | ForEach-Object { "<td class='num'>$($_.countryFE)</td>" }) -join "") + "</tr>",
  "<tr><td>Year FE</td>" + (($modelSpecs | ForEach-Object { "<td class='num'>$($_.yearFE)</td>" }) -join "") + "</tr>"
)
$compHtml = @"
<!doctype html><html><head><meta charset='utf-8'><title>Comparative Econometric Table</title>$(TableCss)</head><body>
<h1>Comparative Econometric Table</h1>
<p>Dependent variable: <strong>$dep</strong>. Standard errors clustered by country in parentheses.</p>
<table><thead><tr><th>Variable</th><th>Model 1<br>Pooled OLS</th><th>Model 2<br>Country FE</th><th>Model 3<br>Two-way FE</th></tr></thead><tbody>
$($compRows -join "`n")
<tr><td colspan='4'><strong>Model statistics</strong></td></tr>
$($metaRows -join "`n")
</tbody><caption>Significance: *** p&lt;0.01, ** p&lt;0.05, * p&lt;0.10. FE dummy coefficients are estimated but omitted from display.</caption></table>
</body></html>
"@
[IO.File]::WriteAllText((Join-Path $modelsDir "comparative_table.html"), $compHtml, [Text.Encoding]::UTF8)

function Scale($x, $min, $max, $lo, $hi) {
  if ($max -eq $min) { return ($lo + $hi)/2 }
  return $lo + (($x - $min) / ($max - $min)) * ($hi - $lo)
}
function SvgEsc($s) { [Security.SecurityElement]::Escape([string]$s) }

# Coefficient plot for key terms across models.
$plotRows = @($coefRows | Where-Object { $regressors -contains $_.term })
$xMin = ($plotRows | ForEach-Object { [double]$_.conf_low } | Measure-Object -Minimum).Minimum
$xMax = ($plotRows | ForEach-Object { [double]$_.conf_high } | Measure-Object -Maximum).Maximum
$pad = ($xMax - $xMin) * 0.10; $xMin -= $pad; $xMax += $pad
$w=1000; $h=620; $left=230; $right=60; $top=55; $rowH=88; $plotW=$w-$left-$right
$colors=@{model1="#7b8794"; model2="#376795"; model3="#9f6b5f"}
$svg = New-Object System.Collections.Generic.List[string]
$svg.Add("<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h'><rect width='100%' height='100%' fill='#ffffff'/><style>text{font-family:Segoe UI,Arial,sans-serif;fill:#243447}.title{font-size:18px;font-weight:600}.small{font-size:11px;fill:#64748b}.grid{stroke:#e5e7eb;stroke-width:1}.zero{stroke:#334155;stroke-width:1;stroke-dasharray:4 4}</style>")
$svg.Add("<text x='30' y='30' class='title'>Coefficient Plot: Stage 1 Econometric Models</text>")
$zeroX = Scale 0 $xMin $xMax $left ($left+$plotW)
$svg.Add("<line x1='$(Fmt $zeroX 1)' y1='$top' x2='$(Fmt $zeroX 1)' y2='$($h-70)' class='zero'/>")
for ($i=0; $i -lt $regressors.Count; $i++) {
  $term=$regressors[$i]
  $baseY=$top + $i*$rowH + 32
  $svg.Add("<text x='30' y='$($baseY+4)' class='small'>$(SvgEsc $labels[$term])</text>")
  $svg.Add("<line x1='$left' y1='$baseY' x2='$($left+$plotW)' y2='$baseY' class='grid'/>")
  $offsets=@{model1=-14; model2=0; model3=14}
  foreach($spec in $modelSpecs){
    $r=$coefRows | Where-Object { $_.model_id -eq $spec.id -and $_.term -eq $term } | Select-Object -First 1
    $y=$baseY+$offsets[$spec.id]
    $x1=Scale ([double]$r.conf_low) $xMin $xMax $left ($left+$plotW)
    $x2=Scale ([double]$r.conf_high) $xMin $xMax $left ($left+$plotW)
    $x=Scale ([double]$r.estimate) $xMin $xMax $left ($left+$plotW)
    $color=$colors[$spec.id]
    $svg.Add("<line x1='$(Fmt $x1 1)' y1='$y' x2='$(Fmt $x2 1)' y2='$y' stroke='$color' stroke-width='2'/>")
    $svg.Add("<circle cx='$(Fmt $x 1)' cy='$y' r='4.5' fill='$color'/>")
  }
}
$legendY=$h-32; $lx=260
foreach($spec in $modelSpecs){ $svg.Add("<circle cx='$lx' cy='$legendY' r='4.5' fill='$($colors[$spec.id])'/><text x='$($lx+10)' y='$($legendY+4)' class='small'>$($spec.title)</text>"); $lx+=230 }
$svg.Add("</svg>")
[IO.File]::WriteAllText((Join-Path $figDir "coefplot.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)

# Predicted vs observed for TWFE.
$tw = $results["model3"].fit
$obs = @($sample | ForEach-Object { [double]$_.dependent })
$pred = @($tw.Fitted)
$minPO = [math]::Min(($obs | Measure-Object -Minimum).Minimum, ($pred | Measure-Object -Minimum).Minimum)
$maxPO = [math]::Max(($obs | Measure-Object -Maximum).Maximum, ($pred | Measure-Object -Maximum).Maximum)
$w=760; $h=640; $left=75; $right=35; $top=55; $bottom=70; $plotW=$w-$left-$right; $plotH=$h-$top-$bottom
$svg = New-Object System.Collections.Generic.List[string]
$svg.Add("<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h'><rect width='100%' height='100%' fill='#ffffff'/><style>text{font-family:Segoe UI,Arial,sans-serif;fill:#243447}.title{font-size:18px;font-weight:600}.small{font-size:11px;fill:#64748b}.grid{stroke:#e5e7eb;stroke-width:1}.axis{stroke:#cbd5e1;stroke-width:1}</style>")
$svg.Add("<text x='30' y='30' class='title'>Predicted vs Observed: Two-Way Fixed Effects</text>")
for($g=0;$g -le 4;$g++){ $xx=$left+$g*$plotW/4; $yy=$top+$g*$plotH/4; $svg.Add("<line x1='$(Fmt $xx 1)' y1='$top' x2='$(Fmt $xx 1)' y2='$($top+$plotH)' class='grid'/><line x1='$left' y1='$(Fmt $yy 1)' x2='$($left+$plotW)' y2='$(Fmt $yy 1)' class='grid'/>") }
$xA=Scale $minPO $minPO $maxPO $left ($left+$plotW); $yA=$top+$plotH-(Scale $minPO $minPO $maxPO 0 $plotH); $xB=Scale $maxPO $minPO $maxPO $left ($left+$plotW); $yB=$top+$plotH-(Scale $maxPO $minPO $maxPO 0 $plotH)
$svg.Add("<line x1='$(Fmt $xA 1)' y1='$(Fmt $yA 1)' x2='$(Fmt $xB 1)' y2='$(Fmt $yB 1)' stroke='#9f6b5f' stroke-width='2' stroke-dasharray='5 5'/>")
for($i=0;$i -lt $obs.Count;$i++){ $x=Scale $pred[$i] $minPO $maxPO $left ($left+$plotW); $y=$top+$plotH-(Scale $obs[$i] $minPO $maxPO 0 $plotH); $svg.Add("<circle cx='$(Fmt $x 1)' cy='$(Fmt $y 1)' r='3' fill='#376795' opacity='0.65'/>") }
$svg.Add("<line x1='$left' y1='$($top+$plotH)' x2='$($left+$plotW)' y2='$($top+$plotH)' class='axis'/><line x1='$left' y1='$top' x2='$left' y2='$($top+$plotH)' class='axis'/>")
$svg.Add("<text x='$($left+$plotW/2-55)' y='$($h-25)' class='small'>Predicted SVI</text><text x='10' y='$($top+$plotH/2)' class='small' transform='rotate(-90 10,$($top+$plotH/2))'>Observed SVI</text>")
$svg.Add("</svg>")
[IO.File]::WriteAllText((Join-Path $figDir "predicted_vs_observed.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)

# Residual diagnostics: residual vs fitted and histogram.
$resid = @($tw.Residuals)
$fitted = @($tw.Fitted)
$xMinRF=($fitted | Measure-Object -Minimum).Minimum; $xMaxRF=($fitted | Measure-Object -Maximum).Maximum
$yMinRF=($resid | Measure-Object -Minimum).Minimum; $yMaxRF=($resid | Measure-Object -Maximum).Maximum
$w=980; $h=520; $svg = New-Object System.Collections.Generic.List[string]
$svg.Add("<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h'><rect width='100%' height='100%' fill='#ffffff'/><style>text{font-family:Segoe UI,Arial,sans-serif;fill:#243447}.title{font-size:18px;font-weight:600}.small{font-size:11px;fill:#64748b}.grid{stroke:#e5e7eb;stroke-width:1}.axis{stroke:#cbd5e1;stroke-width:1}</style>")
$svg.Add("<text x='30' y='30' class='title'>Residual Diagnostics: Two-Way Fixed Effects</text>")
$left1=70; $top1=65; $pw1=520; $ph=360
for($g=0;$g -le 4;$g++){ $xx=$left1+$g*$pw1/4; $yy=$top1+$g*$ph/4; $svg.Add("<line x1='$(Fmt $xx 1)' y1='$top1' x2='$(Fmt $xx 1)' y2='$($top1+$ph)' class='grid'/><line x1='$left1' y1='$(Fmt $yy 1)' x2='$($left1+$pw1)' y2='$(Fmt $yy 1)' class='grid'/>") }
$zeroY=$top1+$ph-(Scale 0 $yMinRF $yMaxRF 0 $ph); $svg.Add("<line x1='$left1' y1='$(Fmt $zeroY 1)' x2='$($left1+$pw1)' y2='$(Fmt $zeroY 1)' stroke='#9f6b5f' stroke-width='1.5' stroke-dasharray='4 4'/>")
for($i=0;$i -lt $resid.Count;$i++){ $x=Scale $fitted[$i] $xMinRF $xMaxRF $left1 ($left1+$pw1); $y=$top1+$ph-(Scale $resid[$i] $yMinRF $yMaxRF 0 $ph); $svg.Add("<circle cx='$(Fmt $x 1)' cy='$(Fmt $y 1)' r='3' fill='#376795' opacity='0.60'/>") }
$svg.Add("<text x='$($left1+180)' y='$($top1+$ph+38)' class='small'>Fitted values</text><text x='12' y='$($top1+190)' class='small' transform='rotate(-90 12,$($top1+190))'>Residuals</text>")
$left2=660; $top2=65; $pw2=250; $bins=14
$minR=($resid | Measure-Object -Minimum).Minimum; $maxR=($resid | Measure-Object -Maximum).Maximum; $counts=@(0)*$bins
foreach($e in $resid){ $idx=if($maxR -eq $minR){0}else{[math]::Floor((($e-$minR)/($maxR-$minR))*$bins)}; if($idx -ge $bins){$idx=$bins-1}; if($idx -lt 0){$idx=0}; $counts[$idx]++ }
$maxC=($counts | Measure-Object -Maximum).Maximum
for($b=0;$b -lt $bins;$b++){ $barH=($counts[$b]/[double]$maxC)*$ph; $bw=$pw2/$bins-3; $x=$left2+$b*($pw2/$bins); $y=$top2+$ph-$barH; $svg.Add("<rect x='$(Fmt $x 1)' y='$(Fmt $y 1)' width='$(Fmt $bw 1)' height='$(Fmt $barH 1)' fill='#6f8faf' opacity='0.85'/>") }
$svg.Add("<text x='$($left2+60)' y='$($top2+$ph+38)' class='small'>Residual distribution</text>")
$svg.Add("</svg>")
[IO.File]::WriteAllText((Join-Path $figDir "residual_diagnostics.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)

# Interpretation document.
$twRows = @($coefRows | Where-Object { $_.model_id -eq "model3" -and $regressors -contains $_.term })
$interpretBullets = foreach ($r in $twRows) {
  $label = $labels[$r.term]
  $unit = if ($r.term -eq "gdp_per_capita_1000") { "a 1,000-unit increase in GDP per capita" } else { "a one-unit increase" }
  "- $($r.term) ($label): In Model 3, $unit is associated with a $(Fmt ([math]::Abs($r.estimate)) 4)-point $(DirectionText $r.estimate) value of the structural vulnerability index, holding observed controls, country fixed effects, and year fixed effects constant. The coefficient is $(SignifText $r.p_value) (estimate = $(Fmt $r.estimate 4), cluster SE = $(Fmt $r.cluster_se 4), p = $(Fmt $r.p_value 4))."
}
$modelStats = foreach ($spec in $modelSpecs) {
  $fit=$results[$spec.id].fit
  "| $($spec.title) | $($fit.N) | $($fit.Clusters) | $(Fmt $fit.R2 4) | $(Fmt $fit.AdjR2 4) | $($spec.countryFE) | $($spec.yearFE) |"
}
$coefMdRows = foreach ($r in ($coefRows | Where-Object { $regressors -contains $_.term })) {
  "| $($r.model) | $($r.term) | $(Fmt $r.estimate 5) | $(Fmt $r.cluster_se 5) | $(Fmt $r.t_stat 3) | $(Fmt $r.p_value 4) |"
}
$interp = @"
# Model Interpretation

This document reports the first real econometric results generated from the existing country-year panel. No new data were downloaded, no panel values were modified, and no machine-learning models were estimated.

## Dependent Variable Selection

The selected dependent variable is $dep because it has complete coverage in the current panel. monetary_poverty remains available for later robustness work but has lower coverage.

## Analytic Sample

The Stage 1 specification uses complete cases for:

- $dep
- labor_informality
- social_protection_coverage
- gdp_per_capita, scaled as gdp_per_capita_1000
- unemployment
- gini

Analytic sample: $($sample.Count) observations, $($countries.Count) countries, and $($years.Count) years. Female and male labor participation and social expenditure are excluded from this first model set because they reduce the usable sample substantially.

## Model Specifications

### Model 1: Pooled OLS

SVI_ct = beta_1 Informality_ct + beta_2 SocialProtection_ct + beta_3 GDPpc_ct + beta_4 Unemployment_ct + beta_5 Gini_ct + epsilon_ct

This model pools all country-years and does not control for unobserved country or year heterogeneity.

### Model 2: Country Fixed Effects

SVI_ct = beta X_ct + alpha_c + epsilon_ct

This model controls for time-invariant differences across countries.

### Model 3: Two-Way Fixed Effects

SVI_ct = beta X_ct + alpha_c + lambda_t + epsilon_ct

This model controls for both time-invariant country differences and common year shocks. It is the preferred specification in this first stage, but it remains associational.

Random effects and Hausman tests were not run in this environment because the required R panel-econometric dependencies are not available. They remain planned for a future R-based replication.

## Model Fit

| Model | Observations | Country clusters | R2 | Adjusted R2 | Country FE | Year FE |
|---|---:|---:|---:|---:|---|---|
$($modelStats -join "`n")

## Coefficient Table

Country-clustered standard errors are reported.

| Model | Term | Estimate | Cluster SE | t-statistic | p-value |
|---|---|---:|---:|---:|---:|
$($coefMdRows -join "`n")

## Economic Interpretation of Model 3

$($interpretBullets -join "`n")

## Statistical Significance

Statistical significance is evaluated using country-clustered standard errors and t-based p-values with cluster degrees of freedom. Given the small number of clusters, the p-values should be read cautiously.

## Limitations

- These estimates are associational and should not be interpreted causally.
- The structural vulnerability index may be mechanically related to some regressors because several indicators are conceptually part of vulnerability measurement.
- Complete-case filtering reduces the sample to 178 observations and 17 countries.
- Social protection coverage has substantial missingness in the full panel, which shapes the analytic sample.
- Country fixed effects absorb time-invariant heterogeneity but do not solve reverse causality, time-varying omitted variables, or measurement error.
- Random effects and Hausman diagnostics are deferred until an R environment with panel-econometric packages is available.

## Policy Implications

The first-stage models provide disciplined descriptive evidence on how labor-market structure, institutional protection, macroeconomic development, unemployment, and inequality move with structural vulnerability. Policy interpretation should focus on multidimensional risk profiles rather than single-variable causal claims. The results motivate more careful robustness checks and future identification work before making strong policy recommendations.

## Generated Outputs

- outputs/models/model1_pooled.html
- outputs/models/model2_fe.html
- outputs/models/model3_twfe.html
- outputs/models/comparative_table.html
- outputs/models/stage1_coefficients.csv
- outputs/models/stage1_analytic_sample.csv
- outputs/models/model_selection_diagnostics.csv
- outputs/figures/models/coefplot.svg
- outputs/figures/models/predicted_vs_observed.svg
- outputs/figures/models/residual_diagnostics.svg
"@
[IO.File]::WriteAllText((Join-Path $ProjectRoot "MODEL_INTERPRETATION.md"), $interp, [Text.Encoding]::UTF8)

[pscustomobject]@{
  status = "completed"
  dependent_variable = $dep
  observations = $sample.Count
  countries = $countries.Count
  years = $years.Count
  models = "pooled OLS; country fixed effects; two-way fixed effects"
  inference = "country-clustered standard errors"
} | ConvertTo-Json | Out-File -LiteralPath (Join-Path $modelsDir "stage1_model_run_status.json") -Encoding UTF8

Write-Host "Econometric Stage 1 complete. Outputs written to outputs/models and outputs/figures/models."