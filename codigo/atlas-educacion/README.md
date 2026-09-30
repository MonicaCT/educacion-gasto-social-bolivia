# Atlas Bolivia · CPV 2024

**Dashboard interactivo para explorar población, territorio, estructura demográfica y registros educativos en Bolivia con referencia al Censo de Población y Vivienda 2024 (CPV 2024).**

[**Abrir dashboard interactivo**](https://monicact.github.io/atlas-bolivia-cpv2024/) · [Metodología](docs/metodologia.md) · [Fuentes](docs/fuentes.md) · [Diccionario de indicadores](docs/diccionario_indicadores.md)

> **Estado del proyecto:** versión inicial preparada para publicación pública en GitHub Pages.  
> **Cobertura:** Bolivia, con navegación por departamento, provincia y municipio/TIOC, además de localidades/comunidades cuando la información lo permite.

---

## 1. Objetivo

Atlas Bolivia · CPV 2024 busca convertir información censal territorial en una herramienta de lectura rápida para análisis económico, social y de política pública. El énfasis está en tres principios:

1. **Lectura sencilla:** cada indicador incluye una interpretación breve.
2. **Rigor:** los indicadores derivados se calculan a partir de variables observadas y sus fórmulas se documentan.
3. **Transparencia territorial:** los mapas distinguen la fuente estadística de la fuente cartográfica.

El dashboard no pretende sustituir los tabulados, documentos metodológicos ni sistemas oficiales del Instituto Nacional de Estadística. Su función es facilitar la exploración y comparación territorial.

---

## 2. ¿Qué contiene el dashboard?

El sitio se organiza en cinco módulos:

| Módulo | Propósito |
|---|---|
| **Panorama nacional** | Resume población, estructura territorial, edades de interés y patrones generales. |
| **Territorio** | Compara municipios/TIOC, tamaños de localidades y distribución espacial de la población. |
| **Demografía** | Analiza edad simple, grupos etarios, envejecimiento, dependencia demográfica y razón de masculinidad. |
| **Educación** | Explora unidades educativas, estudiantes registrados, dependencia administrativa y localización geográfica. |
| **Explorador** | Permite buscar una localidad/comunidad y consultar su ficha territorial y las UE vinculadas. |

Los filtros permiten cambiar de escala territorial sin modificar la lógica de cálculo de los indicadores.

---

## 3. Indicadores principales

Entre los indicadores presentados se encuentran:

- población total;
- hombres y mujeres;
- población de 5 a 17 años;
- número de localidades/comunidades registradas;
- municipios/TIOC con registros;
- mediana de población por localidad;
- ciudades con más de 100.000 habitantes;
- edad mediana;
- índice de envejecimiento;
- dependencia demográfica;
- razón de masculinidad;
- unidades educativas (UE);
- estudiantes registrados;
- UE con clasificación territorial de área;
- dependencia administrativa de las UE;
- vínculo analítico entre UE y localidades/comunidades.

Las definiciones, fórmulas y advertencias de interpretación están desarrolladas en el [Diccionario de indicadores](docs/diccionario_indicadores.md).

---

## 4. Cobertura territorial

La navegación territorial utiliza la jerarquía disponible para el CPV 2024:

**Bolivia → departamento → provincia → municipio/TIOC → localidad/comunidad**.

La cartografía municipal empleada como soporte visual incluye **343 unidades territoriales del nivel municipal: 340 municipios y 3 TIOC**, de acuerdo con la capa de Lab TecnoSocial construida para compatibilidad con la codificación del CPV 2024.

> Los límites cartográficos son una referencia para visualización y agregación. No deben utilizarse para resolver controversias jurisdiccionales.

---

## 5. Mapas

Los mapas cumplen dos funciones distintas:

- **Coropletas:** representan indicadores agregados por municipio/TIOC mediante una escala ordenada de colores.
- **Puntos:** muestran unidades educativas que cuentan con coordenadas utilizables.

Los valores estadísticos representados en los mapas provienen de la información utilizada por el dashboard. La geometría de los polígonos se documenta por separado como **fuente cartográfica**.

Cuando un mapa utiliza cuantiles, los colores permiten comparar posiciones relativas dentro de la vista seleccionada. Un color más intenso significa un valor mayor dentro de esa distribución, no necesariamente una distancia absoluta constante entre clases.

---

## 6. Fuente principal

**Instituto Nacional de Estadística (INE), Censo de Población y Vivienda 2024 (CPV 2024).**

El INE presentó los resultados oficiales del Censo 2024 en 2025 y publica tabulados, resultados temáticos y documentación metodológica en el portal oficial del CPV 2024.

La referencia completa y los enlaces institucionales se encuentran en [Fuentes](docs/fuentes.md).

---

## 7. Fuente cartográfica

Para los límites municipales/TIOC se utiliza:

**Lab TecnoSocial (2026). _Unidades territoriales del nivel municipal de Bolivia — 343 (CPV-2024)._**

La capa está publicada en WGS84 / EPSG:4326 y utiliza códigos compatibles con la organización territorial del CPV 2024. Su licencia declarada es **Creative Commons Atribución 4.0 Internacional (CC BY 4.0)**.

Más información: [Fuentes](docs/fuentes.md).

---

## 8. Metodología

Los cálculos se realizan en el navegador a partir de la información incorporada en el dashboard. Entre las transformaciones analíticas se encuentran:

- suma de población y estudiantes dentro de los filtros activos;
- agregación de edades simples en grupos analíticos;
- cálculo de edad mediana;
- cálculo de razones demográficas;
- agrupación territorial por códigos administrativos;
- clasificación rural/urbana cuando el campo correspondiente está disponible;
- vinculación analítica de UE con localidades/comunidades mediante territorio y normalización de nombres;
- representación cartográfica mediante polígonos municipales/TIOC y coordenadas de UE.

La metodología completa se encuentra en [`docs/metodologia.md`](docs/metodologia.md).

---

## 9. Estructura del repositorio

```text
atlas-bolivia-cpv2024/
│
├── index.html
├── README.md
├── LICENSE
├── CITATION.cff
├── .gitignore
├── .nojekyll
│
├── docs/
│   ├── README.md
│   ├── metodologia.md
│   ├── fuentes.md
│   ├── diccionario_indicadores.md
│   └── configuracion_repositorio.md
│
└── assets/
    └── README.md
```

### Archivo principal

`index.html` contiene la aplicación web y es el archivo que GitHub Pages sirve como página inicial.

### Documentación

La carpeta `docs/` concentra la metodología, las fuentes y las definiciones. Al abrir la carpeta en GitHub, `docs/README.md` se muestra automáticamente como portada de la documentación.

---

## 10. Cómo abrir el dashboard

### En GitHub Pages

Una vez activado GitHub Pages:

**https://monicact.github.io/atlas-bolivia-cpv2024/**

### En una computadora

También puede abrirse `index.html` directamente en un navegador moderno. Para una experiencia más consistente, especialmente cuando se cargan recursos externos, es preferible servir el repositorio mediante un servidor web local o GitHub Pages.

---

## 11. Reproducibilidad y control de versiones

El repositorio utiliza Git para mantener el historial de cambios. Por ello, no es necesario crear archivos como `dashboard_final2.html`, `dashboard_corregido.html` o similares.

La versión estable debe permanecer como:

`index.html`

Los cambios importantes deben registrarse mediante commits y versiones etiquetadas. Esquema recomendado:

- **v1.0.0** — primera publicación estable;
- **v1.1.0** — mejoras compatibles, nuevos gráficos o ajustes de mapas;
- **v1.2.0** — nuevos indicadores sin ruptura metodológica;
- **v2.0.0** — cambio metodológico o estructural importante.

---

## 12. Limitaciones de interpretación

El dashboard es una herramienta descriptiva. En particular:

- una asociación territorial no demuestra causalidad;
- la población de 5–17 años no equivale a matrícula o asistencia escolar;
- la comparación entre estudiantes registrados y población de 5–17 años no debe interpretarse automáticamente como tasa de cobertura;
- la mediana por localidad describe la distribución de registros territoriales, no el lugar donde vive la “persona típica”;
- las razones demográficas describen estructura poblacional y no dependencia económica individual;
- la ausencia de una UE vinculada a una localidad no demuestra que no exista una UE en ese lugar;
- los polígonos cartográficos se utilizan con fines analíticos y de visualización.

---

## 13. Cómo citar

### Proyecto

> Cueto Tapia, M. (2026). _Atlas Bolivia · CPV 2024: población, territorio y educación_ (versión 1.0.0) [Dashboard interactivo]. GitHub. https://github.com/MonicaCT/atlas-bolivia-cpv2024

### Fuente estadística

> Instituto Nacional de Estadística. (2025). _Censo de Población y Vivienda 2024: características de la población y la vivienda_. Estado Plurinacional de Bolivia. https://cpv2024.ine.gob.bo/index.php/principal/publicaciones-final-2025/

### Fuente cartográfica

> Lab TecnoSocial. (2026). _Unidades territoriales del nivel municipal de Bolivia — 343 (CPV-2024)_. https://github.com/lab-tecnosocial/municipios-bolivia-2024

GitHub también puede mostrar la opción **“Cite this repository”** mediante el archivo [`CITATION.cff`](CITATION.cff).

---

## 14. Licencia

El código y la documentación original de este repositorio se distribuyen bajo la **Licencia MIT**, salvo indicación expresa en contrario.

La licencia del repositorio **no modifica las condiciones de uso de datos, cartografía u otros materiales de terceros**. Cada fuente conserva sus propios términos y licencias. La cartografía de Lab TecnoSocial declara licencia **CC BY 4.0**.

Consulta [Fuentes y condiciones de uso](docs/fuentes.md) antes de redistribuir materiales de terceros.

---

## 15. Autoría

**Mónica Cueto Tapia**  
Economía aplicada · análisis cuantitativo de políticas públicas · desarrollo inclusivo · análisis territorial

GitHub: [@MonicaCT](https://github.com/MonicaCT)

---

## 16. Temas sugeridos para GitHub

`bolivia` · `cpv-2024` · `censo` · `demografia` · `educacion` · `analisis-territorial` · `data-visualization` · `public-policy` · `dashboard`
