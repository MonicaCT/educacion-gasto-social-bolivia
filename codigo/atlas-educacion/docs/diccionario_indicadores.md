# Diccionario de indicadores

[← Documentación](README.md) · [Metodología](metodologia.md) · [Fuentes](fuentes.md) · [Abrir dashboard](https://monicact.github.io/atlas-bolivia-cpv2024/)

Este documento define los principales indicadores y conceptos utilizados en **Atlas Bolivia · CPV 2024**.

## Convenciones

- \(P\): población total.
- \(P_a\): población de edad \(a\).
- \(H\): hombres.
- \(M\): mujeres.
- \(E\): estudiantes registrados.
- **UE**: unidad educativa.

---

## Indicadores demográficos y territoriales

| Indicador | Definición | Cálculo / unidad | Interpretación y precaución |
|---|---|---|---|
| **Población total** | Personas registradas en el territorio seleccionado. | \(P=\sum P_i\) · personas | Magnitud poblacional del filtro activo. |
| **Hombres** | Población registrada como hombres. | suma · personas | Se utiliza también para la razón de masculinidad. |
| **Mujeres** | Población registrada como mujeres. | suma · personas | Se utiliza también para la razón de masculinidad. |
| **Población 0–4** | Personas de 0 a 4 años. | \(\sum_{a=0}^{4} P_a\) | Grupo analítico de primera infancia. |
| **Población de 5 años** | Personas con 5 años cumplidos. | \(P_5\) | Se muestra separadamente como transición previa a primaria. |
| **Población 6–11** | Personas de 6 a 11 años. | \(\sum_{a=6}^{11}P_a\) | Aproximación descriptiva a seis edades vinculadas con primaria; no demuestra asistencia. |
| **Población 12–17** | Personas de 12 a 17 años. | \(\sum_{a=12}^{17}P_a\) | Aproximación descriptiva a seis edades vinculadas con secundaria; no demuestra asistencia. |
| **Población 5–17** | Personas de 5 a 17 años. | \(\sum_{a=5}^{17}P_a\) | Grupo demográfico de interés educativo. No equivale a matrícula. |
| **Población 18–24** | Personas de 18 a 24 años. | suma · personas | Juventud y transición hacia educación superior/formación/mercado laboral. |
| **Población 25–59** | Personas de 25 a 59 años. | suma · personas | Tramo adulto amplio. |
| **Población 60+** | Personas de 60 años o más. | suma · personas | Grupo analítico de población mayor. |
| **Población 65+** | Personas de 65 años o más. | suma · personas | Se utiliza en envejecimiento y dependencia demográfica. |
| **Edad mediana** | Edad que divide la población acumulada en dos mitades. | años | No es la edad promedio. |
| **Índice de envejecimiento** | Personas de 65+ por cada 100 menores de 15. | \((P_{65+}/P_{0-14})\times100\) | Mayor valor = estructura relativamente más envejecida. No es porcentaje de adultos mayores. |
| **Dependencia demográfica** | Personas de 0–14 y 65+ por cada 100 personas de 15–64. | \(((P_{0-14}+P_{65+})/P_{15-64})\times100\) | Razón demográfica, no dependencia económica individual. |
| **Razón de masculinidad** | Hombres por cada 100 mujeres. | \((H/M)\times100\) | 100 implica igualdad numérica entre hombres y mujeres. |
| **Localidades y comunidades** | Número de registros territoriales de detalle dentro de la selección. | conteo | Describe registros, no necesariamente una tipología jurídica homogénea. |
| **Municipios con registros** | Municipios/TIOC distintos con al menos un registro territorial en la selección. | conteo de códigos únicos | Mide cobertura territorial de registros, no tamaño poblacional. |
| **Mediana por localidad** | Valor central de la población de los registros territoriales ordenados. | personas | Describe la localidad registrada mediana; no a la persona típica. |
| **Ciudades >100.000** | Registros territoriales con población mayor a 100.000. | conteo y población acumulada | Umbral analítico; no sustituye definiciones legales de ciudad. |
| **Participación urbana** | Proporción de población clasificada como urbana respecto de la población clasificada rural + urbana. | porcentaje | Depende del campo de área disponible. |
| **Participación rural** | Proporción de población clasificada como rural. | porcentaje | Debe leerse junto con valores sin clasificación cuando existan. |

---

## Indicadores educativos

| Indicador | Definición | Cálculo / unidad | Interpretación y precaución |
|---|---|---|---|
| **Unidad educativa (UE)** | Registro de establecimiento educativo incluido en la información utilizada por el dashboard. | conteo | Una UE es una observación educativa, no una persona. |
| **Unidades educativas** | Número de UE incluidas por los filtros activos. | conteo | Describe presencia de registros educativos. |
| **Estudiantes registrados** | Suma del número de estudiantes asociado a las UE seleccionadas. | \(E=\sum E_j\) · estudiantes | No debe compararse mecánicamente con la población 5–17 como si fuera cobertura. |
| **UE con área clasificada** | UE cuya comunidad asociada dispone de categoría rural o urbana utilizable. | conteo | La clasificación corresponde al campo territorial utilizado por el dashboard. |
| **UE sin clasificación de área** | UE cuya comunidad asociada no dispone de categoría rural/urbana utilizable. | conteo | No significa que la UE carezca de ubicación o que no exista. |
| **Dependencia Fiscal** | UE registrada con dependencia Fiscal. | conteo / estudiantes | Distribución descriptiva según la categoría registrada. |
| **Dependencia Convenio** | UE registrada con dependencia Convenio. | conteo / estudiantes | Distribución descriptiva según la categoría registrada. |
| **Dependencia Privada** | UE registrada con dependencia Privada. | conteo / estudiantes | Distribución descriptiva según la categoría registrada. |
| **UE con localidad identificada** | UE que pudo asociarse de forma única a una localidad/comunidad dentro del mismo municipio/TIOC. | conteo | Es un vínculo analítico construido por el dashboard. |
| **UE sin localidad identificada** | UE para la cual no se obtuvo una coincidencia territorial única. | conteo | No implica ausencia física de la UE. |
| **Matrícula vinculada** | Estudiantes de UE vinculadas inequívocamente a la localidad seleccionada. | suma · estudiantes | Solo incluye UE con vínculo territorial único. |

---

## Conceptos cartográficos

| Concepto | Definición | Cómo leerlo |
|---|---|---|
| **Coropleta** | Mapa en el que cada polígono recibe un color según el valor de un indicador. | Permite comparar territorios, no sustituye la lectura del valor exacto. |
| **Cuantil** | Clase construida al ordenar territorios por un indicador y dividirlos en grupos de tamaño similar. | Un color más intenso indica posición relativa mayor; las distancias entre clases no son necesariamente iguales. |
| **Polígono municipal/TIOC** | Geometría utilizada para representar una unidad territorial. | Es soporte cartográfico; el valor estadístico se incorpora por unión territorial. |
| **Punto de UE** | Ubicación de una unidad educativa con coordenadas válidas. | La ausencia de punto puede deberse a falta de coordenadas utilizables. |
| **WGS84 / EPSG:4326** | Sistema geodésico de referencia de la capa cartográfica municipal utilizada. | Estándar común para mapas web y coordenadas geográficas. |

---

## Indicadores que no deben confundirse

### Población 5–17 vs. estudiantes registrados

Son magnitudes distintas:

- **Población 5–17:** residentes censados en ese grupo de edad.
- **Estudiantes registrados:** suma de estudiantes de las UE consideradas.

La razón entre ambas no se denomina automáticamente “cobertura”, porque puede existir movilidad territorial de estudiantes, diferencias de edades y diferencias de referencia temporal.

### 60+ vs. 65+

El dashboard utiliza **60+** como grupo descriptivo del ciclo de vida, mientras que el **índice de envejecimiento** y la **dependencia demográfica** utilizan **65+**. Son cortes distintos con funciones analíticas distintas.

### Mediana por localidad vs. edad mediana

- **Mediana por localidad:** mediana de población entre registros territoriales.
- **Edad mediana:** edad que divide a las personas en dos mitades acumuladas.

No deben interpretarse como el mismo tipo de variable.
