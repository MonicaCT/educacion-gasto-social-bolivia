param(
  [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"
$Culture = [Globalization.CultureInfo]::InvariantCulture

$dataPath = Join-Path $ProjectRoot "data\processed\dashboard_panel.csv"
$edaDir = Join-Path $ProjectRoot "outputs\eda"
New-Item -ItemType Directory -Force -Path $edaDir | Out-Null

$panel = Import-Csv -LiteralPath $dataPath
$n = $panel.Count
$columns = @($panel[0].PSObject.Properties.Name)
$numericVars = @(
  "year",
  "monetary_poverty",
  "extreme_poverty",
  "labor_informality",
  "social_protection_coverage",
  "gdp_per_capita",
  "female_labor_participation",
  "male_labor_participation",
  "unemployment",
  "gini",
  "social_expenditure",
  "structural_vulnerability_index"
) | Where-Object { $columns -contains $_ }

function Is-Missing($v) {
  return ($null -eq $v -or [string]::IsNullOrWhiteSpace([string]$v) -or [string]$v -in @("NA","NaN","null","."))
}

function To-Double($v) {
  if (Is-Missing $v) { return $null }
  $tmp = 0.0
  if ([double]::TryParse([string]$v, [Globalization.NumberStyles]::Any, $Culture, [ref]$tmp)) { return $tmp }
  return $null
}

function Fmt($x, [int]$digits = 3) {
  if ($null -eq $x -or [double]::IsNaN([double]$x)) { return "" }
  return ([double]$x).ToString("N$digits", $Culture)
}

function Quantile($values, [double]$p) {
  $v = @($values | Where-Object { $null -ne $_ } | Sort-Object)
  if ($v.Count -eq 0) { return $null }
  if ($v.Count -eq 1) { return [double]$v[0] }
  $pos = ($v.Count - 1) * $p
  $lo = [math]::Floor($pos)
  $hi = [math]::Ceiling($pos)
  if ($lo -eq $hi) { return [double]$v[$lo] }
  return ([double]$v[$lo] + ($pos - $lo) * ([double]$v[$hi] - [double]$v[$lo]))
}

function Mean($values) {
  $v = @($values | Where-Object { $null -ne $_ })
  if ($v.Count -eq 0) { return $null }
  return (($v | Measure-Object -Average).Average)
}

function Sd($values) {
  $v = @($values | Where-Object { $null -ne $_ })
  if ($v.Count -lt 2) { return $null }
  $m = Mean $v
  $ss = 0.0
  foreach ($x in $v) { $ss += ([double]$x - $m) * ([double]$x - $m) }
  return [math]::Sqrt($ss / ($v.Count - 1))
}

function Corr($xs, $ys) {
  $pairs = @()
  for ($i = 0; $i -lt $xs.Count; $i++) {
    if ($null -ne $xs[$i] -and $null -ne $ys[$i]) {
      $pairs += ,@([double]$xs[$i], [double]$ys[$i])
    }
  }
  if ($pairs.Count -lt 3) { return $null }
  $xv = @($pairs | ForEach-Object { $_[0] })
  $yv = @($pairs | ForEach-Object { $_[1] })
  $mx = Mean $xv
  $my = Mean $yv
  $num = 0.0
  $dx = 0.0
  $dy = 0.0
  foreach ($p in $pairs) {
    $a = [double]$p[0] - $mx
    $b = [double]$p[1] - $my
    $num += $a * $b
    $dx += $a * $a
    $dy += $b * $b
  }
  if ($dx -eq 0 -or $dy -eq 0) { return $null }
  return $num / [math]::Sqrt($dx * $dy)
}

function Esc($s) {
  if ($null -eq $s) { return "" }
  return [Security.SecurityElement]::Escape([string]$s)
}

function Save-Csv($rows, $name) {
  $target = Join-Path $edaDir $name
  if ($null -eq $rows) {
    "note`nno rows flagged" | Out-File -LiteralPath $target -Encoding UTF8
    return
  }
  $rows | Export-Csv -LiteralPath $target -NoTypeInformation -Encoding UTF8
}

function MdTable($rows, $cols, $limit = 30) {
  $out = New-Object System.Collections.Generic.List[string]
  $out.Add("| " + ($cols -join " | ") + " |")
  $out.Add("| " + (($cols | ForEach-Object { "---" }) -join " | ") + " |")
  foreach ($r in @($rows | Select-Object -First $limit)) {
    $cells = foreach ($c in $cols) {
      $v = $r.$c
      if ($null -eq $v) { "" } else { ([string]$v).Replace("|", "\|") }
    }
    $out.Add("| " + ($cells -join " | ") + " |")
  }
  return ($out -join "`n")
}

$metadata = @{
  iso3 = @("country identifier", "ISO3 country code", "identifier")
  country_name = @("country name", "country label", "text")
  region_lac = @("regional classification", "Latin America and Caribbean region flag/group", "categorical")
  year = @("calendar year", "year", "integer")
  monetary_poverty = @("monetary poverty", "percent of population or source rate in panel scale", "percentage/rate")
  extreme_poverty = @("extreme poverty", "percent of population or source rate in panel scale", "percentage/rate")
  labor_informality = @("labor informality", "percent/rate of employment in informal conditions", "percentage/rate")
  social_protection_coverage = @("social protection coverage", "coverage rate in panel scale", "percentage/rate")
  gdp_per_capita = @("GDP per capita", "constant/source currency unit not fully documented in current panel", "monetary level")
  female_labor_participation = @("female labor force participation", "percent/rate", "percentage/rate")
  male_labor_participation = @("male labor force participation", "percent/rate", "percentage/rate")
  unemployment = @("unemployment", "percent/rate", "percentage/rate")
  gini = @("income inequality", "Gini index", "index")
  social_expenditure = @("social expenditure", "unit not fully documented in current panel", "numeric indicator")
  structural_vulnerability_index = @("structural vulnerability index", "composite vulnerability measure already present in panel", "index")
}

$variableRows = foreach ($c in $columns) {
  $vals = @($panel | ForEach-Object { $_.$c })
  $missing = @($vals | Where-Object { Is-Missing $_ }).Count
  $type = if ($numericVars -contains $c) { "numeric" } elseif ($c -in @("iso3","country_name")) { "identifier/text" } else { "categorical/text" }
  $years = @()
  $countries = @()
  foreach ($row in $panel) {
    if (-not (Is-Missing $row.$c)) {
      $years += [int]$row.year
      $countries += $row.iso3
    }
  }
  [pscustomobject]@{
    variable = $c
    type = $type
    description = if ($metadata.ContainsKey($c)) { $metadata[$c][0] } else { "not available in current panel metadata" }
    units = if ($metadata.ContainsKey($c)) { $metadata[$c][2] } else { "not available in current panel metadata" }
    nonmissing = $n - $missing
    missing = $missing
    missing_pct = Fmt (($missing / [double]$n) * 100) 2
    first_year = if ($years.Count) { ($years | Measure-Object -Minimum).Minimum } else { "" }
    last_year = if ($years.Count) { ($years | Measure-Object -Maximum).Maximum } else { "" }
    countries_with_data = @($countries | Sort-Object -Unique).Count
  }
}
Save-Csv $variableRows "eda_variable_summary.csv"

$statsRows = foreach ($v in $numericVars) {
  $vals = @($panel | ForEach-Object { To-Double $_.$v })
  $obs = @($vals | Where-Object { $null -ne $_ })
  $m = Mean $obs
  $sd = Sd $obs
  [pscustomobject]@{
    variable = $v
    n = $obs.Count
    mean = Fmt $m
    sd = Fmt $sd
    min = Fmt (Quantile $obs 0)
    p25 = Fmt (Quantile $obs .25)
    median = Fmt (Quantile $obs .5)
    p75 = Fmt (Quantile $obs .75)
    max = Fmt (Quantile $obs 1)
    cv_abs = if ($null -ne $m -and [math]::Abs($m) -gt 0) { Fmt ([math]::Abs($sd / $m)) } else { "" }
  }
}
Save-Csv $statsRows "eda_descriptive_statistics.csv"

$outlierRows = foreach ($v in ($numericVars | Where-Object { $_ -ne "year" })) {
  $vals = @($panel | ForEach-Object { To-Double $_.$v })
  $obs = @($vals | Where-Object { $null -ne $_ })
  $q1 = Quantile $obs .25
  $q3 = Quantile $obs .75
  $iqr = if ($null -ne $q1 -and $null -ne $q3) { $q3 - $q1 } else { $null }
  $lo = if ($null -ne $iqr) { $q1 - 1.5 * $iqr } else { $null }
  $hi = if ($null -ne $iqr) { $q3 + 1.5 * $iqr } else { $null }
  $outs = @($obs | Where-Object { $null -ne $lo -and ($_ -lt $lo -or $_ -gt $hi) })
  [pscustomobject]@{
    variable = $v
    outlier_rule = "1.5*IQR"
    lower_bound = Fmt $lo
    upper_bound = Fmt $hi
    outlier_count = $outs.Count
    outlier_pct = Fmt (($outs.Count / [double][math]::Max($obs.Count,1)) * 100) 2
    min_outlier = if ($outs.Count) { Fmt (Quantile $outs 0) } else { "" }
    max_outlier = if ($outs.Count) { Fmt (Quantile $outs 1) } else { "" }
  }
}
Save-Csv $outlierRows "eda_outlier_screen.csv"

$corrVars = @($numericVars | Where-Object { $_ -ne "year" })
$series = @{}
foreach ($v in $corrVars) { $series[$v] = @($panel | ForEach-Object { To-Double $_.$v }) }
$corrRows = foreach ($a in $corrVars) {
  $obj = [ordered]@{ variable = $a }
  foreach ($b in $corrVars) { $obj[$b] = Fmt (Corr $series[$a] $series[$b]) }
  [pscustomobject]$obj
}
Save-Csv $corrRows "eda_correlation_matrix.csv"

$highCorrRows = foreach ($i in 0..($corrVars.Count - 2)) {
  foreach ($j in ($i + 1)..($corrVars.Count - 1)) {
    $r = Corr $series[$corrVars[$i]] $series[$corrVars[$j]]
    if ($null -ne $r -and [math]::Abs($r) -ge .70) {
      [pscustomobject]@{
        variable_1 = $corrVars[$i]
        variable_2 = $corrVars[$j]
        correlation = Fmt $r
        abs_correlation = Fmt ([math]::Abs($r))
      }
    }
  }
}
Save-Csv $highCorrRows "eda_high_correlations.csv"

$lowVarRows = foreach ($r in $statsRows) {
  $cv = To-Double $r.cv_abs
  $sd = To-Double $r.sd
  if ($r.variable -ne "year" -and (($null -ne $sd -and $sd -eq 0) -or ($null -ne $cv -and $cv -lt .05))) {
    [pscustomobject]@{ variable = $r.variable; sd = $r.sd; cv_abs = $r.cv_abs; decision = "low variability screen flag" }
  }
}
Save-Csv $lowVarRows "eda_low_variability_flags.csv"

$coverageCountryRows = foreach ($g in ($panel | Group-Object iso3)) {
  $rows = @($g.Group)
  $obj = [ordered]@{ iso3 = $g.Name; country_name = $rows[0].country_name; observations = $rows.Count; first_year = ($rows.year | ForEach-Object { [int]$_ } | Measure-Object -Minimum).Minimum; last_year = ($rows.year | ForEach-Object { [int]$_ } | Measure-Object -Maximum).Maximum }
  foreach ($v in ($numericVars | Where-Object { $_ -ne "year" })) {
    $obj[$v + "_nonmissing"] = @($rows | Where-Object { -not (Is-Missing $_.$v) }).Count
  }
  [pscustomobject]$obj
}
Save-Csv $coverageCountryRows "eda_country_coverage.csv"

$latestYear = ($panel.year | ForEach-Object { [int]$_ } | Measure-Object -Maximum).Maximum
$rankingVars = @("structural_vulnerability_index","monetary_poverty","labor_informality","social_protection_coverage") | Where-Object { $columns -contains $_ }
$rankingRows = foreach ($v in $rankingVars) {
  $rows = @($panel | Where-Object { [int]$_.year -eq $latestYear -and -not (Is-Missing $_.$v) } | ForEach-Object {
    [pscustomobject]@{ indicator = $v; iso3 = $_.iso3; country_name = $_.country_name; year = $_.year; value = To-Double $_.$v }
  } | Sort-Object value -Descending)
  $rank = 1
  foreach ($r in $rows) {
    [pscustomobject]@{ indicator = $v; rank = $rank; iso3 = $r.iso3; country_name = $r.country_name; year = $r.year; value = Fmt $r.value }
    $rank++
  }
}
Save-Csv $rankingRows "eda_latest_rankings_by_indicator.csv"

$trendVars = @("monetary_poverty","labor_informality","social_protection_coverage","structural_vulnerability_index") | Where-Object { $columns -contains $_ }
$trendRows = foreach ($g in ($panel | Group-Object year | Sort-Object { [int]$_.Name })) {
  $obj = [ordered]@{ year = [int]$g.Name }
  foreach ($v in $trendVars) {
    $obj[$v] = Fmt (Mean @($g.Group | ForEach-Object { To-Double $_.$v }))
  }
  [pscustomobject]$obj
}
Save-Csv $trendRows "eda_aggregate_time_series.csv"

function Svg-Header($w, $h) {
  return "<svg xmlns='http://www.w3.org/2000/svg' width='$w' height='$h' viewBox='0 0 $w $h'><rect width='100%' height='100%' fill='#ffffff'/><style>text{font-family:Segoe UI,Arial,sans-serif;fill:#243447}.title{font-size:18px;font-weight:600}.small{font-size:11px;fill:#64748b}.axis{stroke:#cbd5e1;stroke-width:1}.grid{stroke:#e5e7eb;stroke-width:1}.bar{fill:#376795}.accent{fill:#8aa6c1}.line{fill:none;stroke-width:2.2}</style>"
}

function Svg-Footer() { return "</svg>" }

function Save-Histograms {
  $vars = @($corrVars)
  $w = 1080; $h = 900; $cols = 3; $rows = [math]::Ceiling($vars.Count / $cols)
  $cellW = 330; $cellH = 190; $marginX = 35; $marginY = 60
  $svg = New-Object System.Collections.Generic.List[string]
  $svg.Add((Svg-Header $w $h))
  $svg.Add("<text x='35' y='32' class='title'>Distributions of Main Numeric Indicators</text>")
  for ($k = 0; $k -lt $vars.Count; $k++) {
    $v = $vars[$k]
    $vals = @($series[$v] | Where-Object { $null -ne $_ })
    if ($vals.Count -eq 0) { continue }
    $min = Quantile $vals 0; $max = Quantile $vals 1
    $x0 = $marginX + ($k % $cols) * $cellW
    $y0 = $marginY + [math]::Floor($k / $cols) * $cellH
    $plotW = 270; $plotH = 115; $bins = 12
    $counts = @(0) * $bins
    foreach ($val in $vals) {
      $idx = if ($max -eq $min) { 0 } else { [math]::Floor((([double]$val - $min) / ($max - $min)) * $bins) }
      if ($idx -ge $bins) { $idx = $bins - 1 }
      if ($idx -lt 0) { $idx = 0 }
      $counts[$idx]++
    }
    $maxCount = [math]::Max(1, ($counts | Measure-Object -Maximum).Maximum)
    $svg.Add("<text x='$x0' y='$($y0 - 10)' class='small'>$(Esc $v)</text>")
    $svg.Add("<line x1='$x0' y1='$($y0 + $plotH)' x2='$($x0 + $plotW)' y2='$($y0 + $plotH)' class='axis'/>")
    for ($b = 0; $b -lt $bins; $b++) {
      $bw = $plotW / $bins - 2
      $bh = ($counts[$b] / $maxCount) * $plotH
      $bx = $x0 + $b * ($plotW / $bins)
      $by = $y0 + $plotH - $bh
      $svg.Add("<rect x='$(Fmt $bx 1)' y='$(Fmt $by 1)' width='$(Fmt $bw 1)' height='$(Fmt $bh 1)' class='bar' opacity='0.82'/>")
    }
  }
  $svg.Add((Svg-Footer))
  [IO.File]::WriteAllText((Join-Path $edaDir "histograms.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)
}

function Save-Boxplots {
  $vars = @($corrVars)
  $w = 1050; $h = 760; $left = 245; $plotW = 720; $top = 55; $rowH = 58
  $svg = New-Object System.Collections.Generic.List[string]
  $svg.Add((Svg-Header $w $h))
  $svg.Add("<text x='35' y='30' class='title'>Boxplots and Potential Outlier Ranges</text>")
  for ($i = 0; $i -lt $vars.Count; $i++) {
    $v = $vars[$i]
    $vals = @($series[$v] | Where-Object { $null -ne $_ })
    if ($vals.Count -eq 0) { continue }
    $min = Quantile $vals 0; $q1 = Quantile $vals .25; $med = Quantile $vals .5; $q3 = Quantile $vals .75; $max = Quantile $vals 1
    $scale = if ($max -eq $min) { 1 } else { $max - $min }
    $y = $top + $i * $rowH
    $xMin = $left
    $xMax = $left + $plotW
    $xq1 = $left + (($q1 - $min) / $scale) * $plotW
    $xq3 = $left + (($q3 - $min) / $scale) * $plotW
    $xm = $left + (($med - $min) / $scale) * $plotW
    $svg.Add("<text x='35' y='$($y + 5)' class='small'>$(Esc $v)</text>")
    $svg.Add("<line x1='$xMin' y1='$y' x2='$xMax' y2='$y' class='grid'/>")
    $svg.Add("<line x1='$(Fmt $xMin 1)' y1='$y' x2='$(Fmt $xMax 1)' y2='$y' stroke='#376795' stroke-width='1.6'/>")
    $svg.Add("<rect x='$(Fmt $xq1 1)' y='$($y - 12)' width='$(Fmt ($xq3 - $xq1) 1)' height='24' fill='#dbe7f2' stroke='#376795'/>")
    $svg.Add("<line x1='$(Fmt $xm 1)' y1='$($y - 15)' x2='$(Fmt $xm 1)' y2='$($y + 15)' stroke='#12355b' stroke-width='2'/>")
    $svg.Add("<text x='$($left + $plotW + 12)' y='$($y + 4)' class='small'>min $(Fmt $min 1) | max $(Fmt $max 1)</text>")
  }
  $svg.Add((Svg-Footer))
  [IO.File]::WriteAllText((Join-Path $edaDir "boxplots.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)
}

function Save-CorrelationSvg {
  $vars = @($corrVars)
  $cell = 52; $left = 245; $top = 95; $w = $left + $cell * $vars.Count + 60; $h = $top + $cell * $vars.Count + 80
  $svg = New-Object System.Collections.Generic.List[string]
  $svg.Add((Svg-Header $w $h))
  $svg.Add("<text x='35' y='32' class='title'>Correlation Matrix</text>")
  for ($i = 0; $i -lt $vars.Count; $i++) {
    $svg.Add("<text x='$($left + $i*$cell + 7)' y='82' class='small' transform='rotate(-45 $($left + $i*$cell + 7),82)'>$(Esc $vars[$i])</text>")
    $svg.Add("<text x='35' y='$($top + $i*$cell + 31)' class='small'>$(Esc $vars[$i])</text>")
    for ($j = 0; $j -lt $vars.Count; $j++) {
      $r = Corr $series[$vars[$j]] $series[$vars[$i]]
      $val = if ($null -eq $r) { 0 } else { [double]$r }
      $abs = [math]::Abs($val)
      $color = if ($val -ge 0) { "#376795" } else { "#9f6b5f" }
      $opacity = 0.12 + 0.82 * $abs
      $x = $left + $j * $cell; $y = $top + $i * $cell
      $svg.Add("<rect x='$x' y='$y' width='$($cell-2)' height='$($cell-2)' fill='$color' opacity='$(Fmt $opacity 2)'/>")
      $svg.Add("<text x='$($x + 8)' y='$($y + 31)' font-size='10' fill='#0f172a'>$(Fmt $val 2)</text>")
    }
  }
  $svg.Add((Svg-Footer))
  [IO.File]::WriteAllText((Join-Path $edaDir "correlation_matrix.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)
}

function Save-MissingMap {
  $countries = @($panel | Sort-Object country_name | Select-Object -ExpandProperty country_name -Unique)
  $years = @($panel.year | Sort-Object { [int]$_ } -Unique)
  $cellW = 26; $cellH = 16; $left = 210; $top = 75; $w = $left + $cellW * $years.Count + 70; $h = $top + $cellH * $countries.Count + 70
  $svg = New-Object System.Collections.Generic.List[string]
  $svg.Add((Svg-Header $w $h))
  $svg.Add("<text x='35' y='30' class='title'>Missing Values by Country-Year</text>")
  for ($j = 0; $j -lt $years.Count; $j += 2) {
    $svg.Add("<text x='$($left + $j*$cellW)' y='58' class='small' transform='rotate(-45 $($left + $j*$cellW),58)'>$($years[$j])</text>")
  }
  for ($i = 0; $i -lt $countries.Count; $i++) {
    $country = $countries[$i]
    $svg.Add("<text x='35' y='$($top + $i*$cellH + 12)' class='small'>$(Esc $country)</text>")
    for ($j = 0; $j -lt $years.Count; $j++) {
      $row = @($panel | Where-Object { $_.country_name -eq $country -and [int]$_.year -eq [int]$years[$j] })[0]
      $miss = 0
      foreach ($v in ($numericVars | Where-Object { $_ -ne "year" })) { if (Is-Missing $row.$v) { $miss++ } }
      $share = $miss / [double](($numericVars | Where-Object { $_ -ne "year" }).Count)
      $opacity = 0.05 + 0.85 * $share
      $fill = if ($share -eq 0) { "#eef2f7" } else { "#376795" }
      $svg.Add("<rect x='$($left+$j*$cellW)' y='$($top+$i*$cellH)' width='$($cellW-2)' height='$($cellH-2)' fill='$fill' opacity='$(Fmt $opacity 2)'/>")
    }
  }
  $svg.Add((Svg-Footer))
  [IO.File]::WriteAllText((Join-Path $edaDir "missing_values_map.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)
}

function Save-Trends {
  $vars = @($trendVars)
  $w = 980; $h = 620; $left = 70; $right = 40; $top = 60; $bottom = 65
  $plotW = $w - $left - $right; $plotH = $h - $top - $bottom
  $years = @($trendRows | ForEach-Object { [int]$_.year })
  $minYear = ($years | Measure-Object -Minimum).Minimum; $maxYear = ($years | Measure-Object -Maximum).Maximum
  $svg = New-Object System.Collections.Generic.List[string]
  $svg.Add((Svg-Header $w $h))
  $svg.Add("<text x='35' y='32' class='title'>Regional Aggregate Trends</text>")
  $colors = @("#12355b","#376795","#6f8faf","#9f6b5f")
  for ($g = 0; $g -le 4; $g++) {
    $yy = $top + $g * ($plotH / 4)
    $svg.Add("<line x1='$left' y1='$(Fmt $yy 1)' x2='$($left+$plotW)' y2='$(Fmt $yy 1)' class='grid'/>")
  }
  for ($k = 0; $k -lt $vars.Count; $k++) {
    $v = $vars[$k]
    $vals = @($trendRows | ForEach-Object { To-Double $_.$v })
    $min = Quantile $vals 0; $max = Quantile $vals 1
    $scale = if ($max -eq $min) { 1 } else { $max - $min }
    $pts = New-Object System.Collections.Generic.List[string]
    for ($i = 0; $i -lt $trendRows.Count; $i++) {
      $yr = [int]$trendRows[$i].year
      $val = To-Double $trendRows[$i].$v
      if ($null -eq $val) { continue }
      $x = $left + (($yr - $minYear) / [double]($maxYear - $minYear)) * $plotW
      $y = $top + $plotH - (($val - $min) / $scale) * $plotH
      $pts.Add("$(Fmt $x 1),$(Fmt $y 1)")
    }
    $svg.Add("<polyline points='$($pts -join " ")' class='line' stroke='$($colors[$k % $colors.Count])'/>")
    $svg.Add("<text x='$($left + 20 + $k*215)' y='$($h - 20)' class='small' fill='$($colors[$k % $colors.Count])'>$(Esc $v)</text>")
  }
  $svg.Add("<line x1='$left' y1='$($top+$plotH)' x2='$($left+$plotW)' y2='$($top+$plotH)' class='axis'/>")
  $svg.Add((Svg-Footer))
  [IO.File]::WriteAllText((Join-Path $edaDir "aggregate_time_series.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)
}

function Save-Rankings {
  $vars = @($rankingVars)
  $w = 1080; $h = 760; $cols = 2; $cellW = 520; $cellH = 330; $xPad = 40; $yPad = 65
  $svg = New-Object System.Collections.Generic.List[string]
  $svg.Add((Svg-Header $w $h))
  $svg.Add("<text x='35' y='32' class='title'>Latest-Year Rankings by Indicator ($latestYear)</text>")
  for ($k = 0; $k -lt $vars.Count; $k++) {
    $v = $vars[$k]
    $topRows = @($rankingRows | Where-Object { $_.indicator -eq $v } | Select-Object -First 10)
    if ($topRows.Count -eq 0) { continue }
    $x0 = $xPad + ($k % $cols) * $cellW
    $y0 = $yPad + [math]::Floor($k / $cols) * $cellH
    $maxVal = ($topRows | ForEach-Object { To-Double $_.value } | Measure-Object -Maximum).Maximum
    $svg.Add("<text x='$x0' y='$($y0 - 15)' class='small'>$(Esc $v)</text>")
    for ($i = 0; $i -lt $topRows.Count; $i++) {
      $r = $topRows[$i]
      $val = To-Double $r.value
      $barW = if ($maxVal -eq 0) { 0 } else { ($val / $maxVal) * 260 }
      $y = $y0 + $i * 27
      $svg.Add("<text x='$x0' y='$($y + 15)' class='small'>$(Esc $r.country_name)</text>")
      $svg.Add("<rect x='$($x0+190)' y='$y' width='$(Fmt $barW 1)' height='18' fill='#376795' opacity='0.85'/>")
      $svg.Add("<text x='$($x0+460)' y='$($y + 14)' class='small'>$(Fmt $val 1)</text>")
    }
  }
  $svg.Add((Svg-Footer))
  [IO.File]::WriteAllText((Join-Path $edaDir "rankings_by_indicator.svg"), ($svg -join "`n"), [Text.Encoding]::UTF8)
}

Save-Histograms
Save-Boxplots
Save-CorrelationSvg
Save-MissingMap
Save-Trends
Save-Rankings

$panelYears = @($panel.year | ForEach-Object { [int]$_ })
$minPanelYear = ($panelYears | Measure-Object -Minimum).Minimum
$maxPanelYear = ($panelYears | Measure-Object -Maximum).Maximum
$countryCount = @($panel.iso3 | Sort-Object -Unique).Count
$yearCount = @($panelYears | Sort-Object -Unique).Count
$completeRows = @($panel | Where-Object {
  $ok = $true
  foreach ($v in ($numericVars | Where-Object { $_ -ne "year" })) { if (Is-Missing $_.$v) { $ok = $false } }
  $ok
}).Count

$topCorr = @($highCorrRows | Sort-Object { -1 * [double]$_.abs_correlation } | Select-Object -First 10)
$topOutliers = @($outlierRows | Sort-Object { -1 * [int]$_.outlier_count } | Select-Object -First 8)
$missingTop = @($variableRows | Sort-Object { -1 * [double]$_.missing_pct } | Select-Object -First 10)

$report = @"
# Data Exploration Report

This report summarizes the current `dashboard_panel.csv` only. No data were downloaded, no original panel values were modified, and no econometric or machine-learning models were estimated.

## Panel Overview

- Observations: $n country-years
- Countries: $countryCount
- Years: $yearCount ($minPanelYear-$maxPanelYear)
- Variables: $($columns.Count)
- Rows complete across all numeric indicators: $completeRows

## Variable Dictionary and Coverage

$(MdTable $variableRows @("variable","type","description","units","nonmissing","missing_pct","first_year","last_year","countries_with_data") 40)

## Descriptive Statistics

$(MdTable $statsRows @("variable","n","mean","sd","min","p25","median","p75","max","cv_abs") 40)

## Missing Values

The panel is balanced at the country-year row level, but indicator coverage varies by variable and country. Variables with the highest missing shares are:

$(MdTable $missingTop @("variable","nonmissing","missing","missing_pct","countries_with_data") 10)

See `outputs/eda/missing_values_map.svg` for the country-year missingness map.

## Distribution and Outlier Screen

Potential outliers are flagged using a simple 1.5 IQR rule. These are diagnostic flags rather than deletion rules.

$(MdTable $topOutliers @("variable","outlier_rule","lower_bound","upper_bound","outlier_count","outlier_pct","min_outlier","max_outlier") 12)

Distribution plots are saved as:

- `outputs/eda/histograms.svg`
- `outputs/eda/boxplots.svg`

## Main Correlations

Pairwise Pearson correlations are computed using available observations for each pair. The strongest absolute correlations are:

$(if ($topCorr.Count -gt 0) { MdTable $topCorr @("variable_1","variable_2","correlation","abs_correlation") 10 } else { "No pairwise absolute correlation above 0.70 was found." })

The full matrix is saved as `outputs/eda/correlation_matrix.svg` and `outputs/eda/eda_correlation_matrix.csv`.

## Variables With Low Variability

$(if (@($lowVarRows).Count -gt 0) { MdTable $lowVarRows @("variable","sd","cv_abs","decision") 20 } else { "No numeric indicator is flagged by the low-variability screen (`sd = 0` or absolute coefficient of variation below 0.05)." })

## Time-Series and Ranking Diagnostics

Aggregate trends and latest-year rankings are saved as:

- `outputs/eda/aggregate_time_series.svg`
- `outputs/eda/rankings_by_indicator.svg`
- `outputs/eda/eda_aggregate_time_series.csv`
- `outputs/eda/eda_latest_rankings_by_indicator.csv`

These graphics are descriptive and should not be interpreted as causal evidence.

## Panel Limitations

- The current panel is country-year aggregate data; it cannot identify household-level mechanisms.
- Units and source definitions are not fully embedded for every variable, especially `social_expenditure` and the exact monetary unit of `gdp_per_capita`.
- Missingness differs across indicators, which can change the sample used by each descriptive or modeling exercise.
- The structural vulnerability index is already present in the panel; alternative index construction is scripted elsewhere but should be reported transparently.
- Correlations and rankings are sensitive to indicator scaling, missing data, and country coverage.
- Econometric and machine-learning scripts should be treated as prepared analysis templates until executed in an R environment with explicit runtime logs.
"@

[IO.File]::WriteAllText((Join-Path $ProjectRoot "DATA_EXPLORATION_REPORT.md"), $report, [Text.Encoding]::UTF8)

[pscustomobject]@{
  status = "completed"
  report = "DATA_EXPLORATION_REPORT.md"
  eda_outputs = $edaDir
  rows = $n
  countries = $countryCount
  years = $yearCount
} | ConvertTo-Json | Out-File -LiteralPath (Join-Path $edaDir "eda_run_status.json") -Encoding UTF8

Write-Host "EDA report and figures written to $edaDir"



