# Fuentes y condiciones de uso

[← Documentación](README.md) · [Metodología](metodologia.md) · [Diccionario](diccionario_indicadores.md) · [Abrir dashboard](https://monicact.github.io/atlas-bolivia-cpv2024/)

## 1. Principio de atribución

El proyecto separa explícitamente dos funciones:

- **Fuente estadística:** aporta los valores utilizados en indicadores, tablas y gráficos.
- **Fuente cartográfica:** aporta geometrías para representar esos valores en mapas.

La geometría cartográfica no debe interpretarse como una fuente adicional de cifras demográficas.

---

## 2. Fuente estadística principal

### Instituto Nacional de Estadística (INE)

**Censo de Población y Vivienda 2024 (CPV 2024), Estado Plurinacional de Bolivia.**

El INE publica los resultados oficiales, tabulados, temáticas y documentación metodológica del Censo 2024 en su portal institucional.

### Referencia APA sugerida

> Instituto Nacional de Estadística. (2025). _Censo de Población y Vivienda 2024: características de la población y la vivienda_. Estado Plurinacional de Bolivia. https://cpv2024.ine.gob.bo/index.php/principal/publicaciones-final-2025/

### Enlaces oficiales

- Resultados del Censo 2024: https://cpv2024.ine.gob.bo/index.php/resultados/
- Publicaciones finales: https://cpv2024.ine.gob.bo/index.php/principal/publicaciones-final-2025/
- Portal principal del CPV 2024: https://cpv2024.ine.gob.bo/

### Uso dentro del dashboard

El dashboard utiliza esta referencia para presentar información territorial y demográfica y para construir indicadores derivados como:

- población total;
- población por sexo;
- población por edad simple;
- grupos etarios;
- población de 5–17 años;
- edad mediana;
- índice de envejecimiento;
- dependencia demográfica;
- razón de masculinidad;
- distribución territorial.

El módulo educativo presenta los registros incorporados en la información utilizada por el proyecto bajo la referencia CPV 2024. Las comparaciones con variables demográficas se consideran descriptivas y no se interpretan automáticamente como indicadores oficiales de cobertura educativa.

---

## 3. Fuente cartográfica

### Lab TecnoSocial

**Unidades territoriales del nivel municipal de Bolivia — 343 (CPV-2024).**

Repositorio: https://github.com/lab-tecnosocial/municipios-bolivia-2024

Sitio del recurso: https://lab-tecnosocial.github.io/municipios-bolivia-2024/

La capa proporciona geometrías municipales/TIOC compatibles con la codificación utilizada para el CPV 2024.

Según la documentación del repositorio, contiene:

- **343 unidades territoriales del nivel municipal**;
- **340 municipios**;
- **3 TIOC**;
- geometrías en **WGS84 / EPSG:4326**;
- códigos territoriales preparados para vincularse con información del CPV 2024.

### Referencia APA sugerida

> Lab TecnoSocial. (2026). _Unidades territoriales del nivel municipal de Bolivia — 343 (CPV-2024)_. https://github.com/lab-tecnosocial/municipios-bolivia-2024

### Licencia declarada por la fuente

**Creative Commons Atribución 4.0 Internacional (CC BY 4.0).**

Esto permite reutilizar la capa, incluso con fines comerciales, siempre que se otorgue la atribución correspondiente.

### Advertencia territorial

La propia documentación del recurso señala que las geometrías son de **uso referencial** y no constituyen una fuente autoritativa para resolver cuestiones jurisdiccionales o procesos de delimitación territorial.

---

## 4. Diferencia entre dato y geometría

Ejemplo de una coropleta municipal:

- el **valor** de población o indicador demográfico procede de la fuente estadística;
- el **polígono** que permite dibujar el municipio procede de la fuente cartográfica;
- el dashboard realiza la unión mediante códigos territoriales compatibles.

Esta separación evita atribuir a la capa cartográfica cifras que no produce.

---

## 5. Condiciones de uso del repositorio

El código y la documentación originales de **Atlas Bolivia · CPV 2024** se distribuyen bajo la **Licencia MIT**.

La Licencia MIT del repositorio no reemplaza ni amplía los derechos sobre:

- información del INE;
- cartografía de Lab TecnoSocial;
- cualquier material de terceros enlazado o utilizado como fuente.

Quien reutilice o redistribuya materiales de terceros debe revisar sus términos de uso originales.

---

## 6. Recomendación para citar una figura o resultado

Cuando una figura del dashboard utiliza valores censales y cartografía municipal, se recomienda una nota como:

> **Fuente:** elaboración propia con base en Instituto Nacional de Estadística (INE), Censo de Población y Vivienda 2024. Cartografía de referencia: Lab TecnoSocial (2026), _Unidades territoriales del nivel municipal de Bolivia — 343 (CPV-2024)_.

Para un gráfico sin cartografía:

> **Fuente:** elaboración propia con base en Instituto Nacional de Estadística (INE), Censo de Población y Vivienda 2024.

---

## 7. Fecha de consulta recomendada

Para trabajos académicos o institucionales, puede añadirse la fecha en la que se consultaron los portales web, especialmente si el contenido en línea cambia con el tiempo.

Ejemplo:

> Recuperado el 25 de septiembre de 2026 de https://cpv2024.ine.gob.bo/

---

## 8. Verificación

Antes de publicar una cifra fuera del dashboard se recomienda:

1. identificar el filtro territorial activo;
2. verificar la definición del indicador en el [Diccionario](diccionario_indicadores.md);
3. confirmar si se trata de una cifra observada o de un indicador derivado;
4. citar la fuente estadística;
5. añadir la fuente cartográfica únicamente cuando la figura utiliza geometrías externas.
