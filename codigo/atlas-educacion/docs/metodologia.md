# Metodología

[← Documentación](README.md) · [Fuentes](fuentes.md) · [Diccionario de indicadores](diccionario_indicadores.md) · [Abrir dashboard](https://monicact.github.io/atlas-bolivia-cpv2024/)

## 1. Propósito

El dashboard organiza información territorial, demográfica y educativa con referencia al **Censo de Población y Vivienda 2024 (CPV 2024)** para facilitar el análisis descriptivo de Bolivia a distintas escalas geográficas.

La metodología está diseñada para responder preguntas como:

- ¿Dónde se concentra la población?
- ¿Cómo cambia la estructura por edades entre territorios?
- ¿Qué municipios presentan una estructura relativamente más envejecida?
- ¿Cómo se distribuyen las unidades educativas registradas?
- ¿Qué localidades/comunidades pueden explorarse conjuntamente con información educativa vinculada?

El dashboard no estima efectos causales ni sustituye una evaluación de impacto.

---

## 2. Unidad territorial de análisis

La estructura de navegación utilizada es:

**Bolivia → departamento → provincia → municipio/TIOC → localidad/comunidad**.

Los filtros restringen simultáneamente las tablas, gráficos, indicadores y mapas. El valor nacional se obtiene cuando no existe ningún filtro territorial activo.

### Municipio / TIOC

En la escala municipal se mantiene la organización compatible con el CPV 2024. La capa cartográfica empleada contiene 343 unidades del nivel municipal: 340 municipios y 3 TIOC.

### Localidad/comunidad

El dashboard utiliza el campo territorial disponible para ciudad/localidad/comunidad como unidad descriptiva de detalle. No impone una clasificación adicional cuando la fuente no permite distinguir de manera consistente entre tipos de asentamiento.

---

## 3. Filtros

Los principales filtros son:

1. **Departamento**
2. **Provincia**
3. **Municipio / TIOC**
4. **Área geográfica**

Los resultados se recalculan sobre el subconjunto seleccionado. Cuando un filtro se reinicia, el dashboard vuelve a mostrar el universo correspondiente al nivel superior.

---

## 4. Agregación de población

La población total de una selección se calcula como la suma de la población de todos los registros territoriales incluidos:

\[
P = \sum_{i=1}^{n} P_i
\]

Donde:

- \(P_i\) = población del registro territorial \(i\);
- \(n\) = número de registros incluidos por los filtros.

La misma lógica se utiliza para hombres, mujeres y edades simples.

---

## 5. Edades simples y grupos analíticos

Las edades simples se agregan en siete grupos para facilitar la lectura:

| Grupo | Construcción | Uso analítico |
|---|---:|---|
| **0–4** | edades 0 a 4 | primera infancia |
| **5** | edad 5 | transición previa a primaria |
| **6–11** | edades 6 a 11 | aproximación descriptiva a seis edades vinculadas con primaria |
| **12–17** | edades 12 a 17 | aproximación descriptiva a seis edades vinculadas con secundaria |
| **18–24** | edades 18 a 24 | juventud y transición educativa/laboral |
| **25–59** | edades 25 a 59 | tramo adulto amplio |
| **60+** | edades 60 a 100+ según disponibilidad | población mayor |

Estos cortes son **analíticos**, no categorías jurídicas ni evidencia de asistencia escolar.

---

## 6. Población de 5–17 años

Se calcula sumando las edades simples desde 5 hasta 17 años, inclusive:

\[
P_{5-17}=\sum_{a=5}^{17}P_a
\]

Su participación en la población total es:

\[
\%P_{5-17}=\frac{P_{5-17}}{P}\times100
\]

### Interpretación

Representa residentes en esas edades. **No equivale a matrícula, asistencia ni cobertura educativa.**

---

## 7. Edad mediana

La edad mediana es la edad en la que la suma acumulada de población alcanza al menos el 50 % del total.

Procedimiento:

1. ordenar la población desde edad 0 en adelante;
2. acumular personas por edad;
3. identificar la primera edad donde la acumulación alcanza la mitad de la población.

### Interpretación

Una edad mediana de 27 años significa, aproximadamente, que la mitad de la población tiene 27 años o menos y la otra mitad 27 años o más.

---

## 8. Índice de envejecimiento

Se calcula como:

\[
IE=\frac{P_{65+}}{P_{0-14}}\times100
\]

Donde:

- \(P_{65+}\) = población de 65 años o más;
- \(P_{0-14}\) = población menor de 15 años.

### Interpretación

Un valor de 30 indica aproximadamente **30 personas de 65 años o más por cada 100 menores de 15**.

No debe interpretarse como porcentaje de personas mayores sobre la población total.

---

## 9. Dependencia demográfica

Se calcula como:

\[
DD=\frac{P_{0-14}+P_{65+}}{P_{15-64}}\times100
\]

### Interpretación

Un valor de 60 significa que existen 60 personas en los grupos 0–14 o 65+ por cada 100 personas de 15–64 años.

Es una relación **demográfica**. No identifica dependencia económica individual, empleo ni transferencias intrahogar.

---

## 10. Razón de masculinidad

Se calcula como:

\[
RM=\frac{H}{M}\times100
\]

Donde:

- \(H\) = hombres;
- \(M\) = mujeres.

### Interpretación

Un valor de 98 significa aproximadamente 98 hombres por cada 100 mujeres.

---

## 11. Mediana de población por localidad

Para describir el tamaño de los registros territoriales sin que las ciudades de gran tamaño dominen la medida, se utiliza la mediana:

1. se ordenan las localidades/comunidades por población;
2. se identifica el valor central de la distribución.

Esta medida describe la **localidad registrada mediana**, no el tamaño del lugar en el que vive la persona mediana del país.

---

## 12. Ciudades de más de 100.000 habitantes

El dashboard identifica registros territoriales cuya población supera 100.000 personas:

\[
I_i = 1(P_i > 100000)
\]

Se utiliza como una medida descriptiva de concentración en grandes centros poblados. No pretende reemplazar una definición legal o administrativa de ciudad.

---

## 13. Área geográfica

Cuando el campo de área geográfica está disponible, los registros se agrupan de acuerdo con las categorías observadas, principalmente **RURAL** y **URBANO**.

La participación urbana se calcula como:

\[
U=\frac{P_{urbana}}{P_{urbana}+P_{rural}}\times100
\]

Los valores sin una clasificación utilizable se mantienen diferenciados cuando corresponde y no se redistribuyen artificialmente.

---

## 14. Unidades educativas y estudiantes registrados

El módulo educativo resume:

- número de unidades educativas;
- número de estudiantes registrados;
- dependencia administrativa;
- clasificación territorial de área;
- localización mediante coordenadas cuando están disponibles.

El total de estudiantes de una selección se obtiene como:

\[
E=\sum_{j=1}^{m}E_j
\]

Donde \(E_j\) es el número de estudiantes del registro de UE \(j\).

### Precaución

La comparación entre estudiantes registrados y población de 5–17 años se muestra como **contexto descriptivo**, no como tasa de cobertura. Las poblaciones de referencia, edades y momentos estadísticos pueden no ser idénticos.

---

## 15. Dependencia de las unidades educativas

Las categorías observadas en el dashboard son:

- **Fiscal**
- **Convenio**
- **Privada**

El gráfico cuenta UE y puede mostrar estudiantes asociados a cada categoría. Se trata de una distribución descriptiva de los registros disponibles.

---

## 16. Vínculo entre UE y localidad/comunidad

Para permitir una ficha territorial conjunta, el dashboard construye un vínculo analítico entre UE y localidad/comunidad.

La lógica general es:

1. restringir la búsqueda al mismo municipio/TIOC;
2. normalizar nombres de comunidad/localidad;
3. buscar una coincidencia territorial única;
4. asignar el vínculo solo cuando la coincidencia es inequívoca.

### UE vinculada

Una UE se considera vinculada cuando su referencia comunitaria puede asociarse de manera única a un registro territorial.

### UE sin vínculo único

Puede ocurrir por:

- nombres repetidos;
- diferencias ortográficas;
- variantes de escritura;
- ausencia de una coincidencia inequívoca.

**No significa que la UE no exista, que no tenga estudiantes o que no tenga coordenadas.** Significa únicamente que no se generó una asociación única con una localidad/comunidad específica.

---

## 17. Cartografía

### Polígonos municipales/TIOC

Los límites se utilizan como soporte geográfico para representar valores agregados. La fuente cartográfica es Lab TecnoSocial (2026).

### Coordenadas de UE

Cuando existen latitud y longitud válidas, las UE se representan como puntos.

### Sistema de referencia

La capa municipal utilizada está publicada en **WGS84 / EPSG:4326**.

---

## 18. Coropletas y cuantiles

Cuando el dashboard utiliza cuantiles:

1. se calcula el indicador para cada territorio visible;
2. se ordenan los valores;
3. se dividen en grupos con cantidades aproximadamente similares de territorios;
4. cada grupo recibe un nivel de intensidad visual.

### Interpretación

Los cuantiles muestran **posición relativa** dentro del conjunto visible. Dos clases consecutivas no necesariamente están separadas por la misma diferencia absoluta.

Por eso, las coropletas deben leerse junto con los valores numéricos y las tablas.

---

## 19. Tratamiento de valores faltantes

El dashboard evita imputar automáticamente información no observada.

En términos generales:

- valores faltantes no se convierten en cero salvo que la estructura de la variable lo justifique explícitamente;
- registros sin clasificación territorial se mantienen diferenciados;
- UE sin vínculo territorial único continúan en los totales educativos cuando el indicador no requiere esa asociación;
- los análisis que necesitan una localidad específica usan solo vínculos inequívocos.

---

## 20. Alcance inferencial

El dashboard es **descriptivo**. Permite identificar diferencias, concentraciones y patrones territoriales, pero no establece que una característica cause otra.

Ejemplos:

- una mayor cantidad de UE en un municipio no demuestra que la oferta educativa sea suficiente;
- una mayor razón de estudiantes por población de 5–17 años no demuestra mayor cobertura;
- una estructura más envejecida no identifica por sí sola las causas del envejecimiento;
- diferencias urbano-rurales no deben interpretarse causalmente sin un diseño de identificación adicional.

---

## 21. Reproducibilidad

La versión publicada del dashboard se conserva como `index.html`. El historial de Git registra los cambios sucesivos.

Para una auditoría metodológica se recomienda revisar conjuntamente:

1. este documento;
2. el [Diccionario de indicadores](diccionario_indicadores.md);
3. las [Fuentes](fuentes.md);
4. el historial de commits del repositorio.

---

## 22. Cita metodológica sugerida

> Cueto Tapia, M. (2026). _Metodología del Atlas Bolivia · CPV 2024_. En _Atlas Bolivia · CPV 2024: población, territorio y educación_. GitHub.
