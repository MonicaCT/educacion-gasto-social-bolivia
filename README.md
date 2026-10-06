# Educación y Gasto Social · Bolivia

**Dashboards, análisis y visualizaciones para el análisis de políticas públicas**

Autora: **Mónica Cueto Tapia** · Actualización del repositorio: **6 de octubre de 2026**

## Abrir el portafolio

### [Visitar el portal público](https://monicact.github.io/educacion-gasto-social-bolivia/)

Los dashboards y presentaciones se abren directamente en el navegador, en computadora o celular. **No es necesario ejecutar R, Python ni instalar herramientas.** Abra el enlace del producto en la tabla.

## Objetivo y temas

Repositorio central y portafolio público de trabajos sobre educación y gasto social en Bolivia: presupuesto y financiamiento educativo, DDE y nivel distrital, evaluación y muestreo, gestión territorial, transformación digital y gasto por estudiante. Los análisis latinoamericanos se incorporan por su contenido educativo y su inclusión de Bolivia, con alcance regional explícito.

## Productos disponibles

| Producto | Tipo | Período | Recursos |
|---|---|---|---|
| [Gasto de las DDE 2016–2025](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/gasto-dde-2016-2025/index.html) | Dashboard | 2016–2025 | [Datos](datos/gasto-dde/) · [Código](codigo/gasto-dde/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/gasto-dde-2016-2025.html) |
| [Gasto asociado al nivel distrital](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/gasto-dded-bolivia/index.html) | Dashboard | 2016–2025 | [Datos](datos/gasto-dded/) · [Código](codigo/gasto-dded/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/gasto-dded-bolivia.html) |
| [Propuesta de muestra nacional para evaluaciones educativas](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/muestra-educativa-bolivia/index.html) | Dashboard | Marco educativo 2024 | [Datos](datos/muestra-educativa/) · [Código](codigo/muestra-educativa/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/muestra-educativa-bolivia.html) |
| [Atlas Bolivia · población, territorio y educación](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/atlas-educacion-bolivia/index.html) | Dashboard | CPV 2024 | [Datos](datos/atlas-educacion/) · [Código](codigo/atlas-educacion/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/atlas-educacion-bolivia.html) |
| [Gasto educativo en el contexto regional](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/gasto-educativo-regional/index.html) | Análisis | 1990–2020 | [Datos](datos/gasto-educativo-regional/) · [Código](codigo/gasto-educativo-regional/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/gasto-educativo-regional.html) |

| [Bolivia · Costo estimado por estudiante vs presupuesto devengado](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/costo-estudiante-vs-devengado/index.html) | Dashboard interactivo | Según el producto | [Datos](datos/costo-estudiante-vs-devengado/) · [Código](codigo/costo-estudiante-vs-devengado/) · [Método](documentacion/metodologia/costo-estudiante-vs-devengado.html) |
| [Diploma de Bachiller Digital: impacto en las DDE](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/diploma-bachiller-digital-impacto-dde/index.html) | Dashboard interactivo | Según el producto | [Datos](datos/diploma-bachiller-digital-impacto-dde/) · [Código](codigo/diploma-bachiller-digital-impacto-dde/) · [Método](documentacion/metodologia/diploma-bachiller-digital-impacto-dde.html) |

## Estructura

```text
index.html                         Portal principal
dashboards/                        Productos finales y recursos web
datos/                             Datos disponibles y extracciones documentadas
codigo/                            Copias de proyectos, scripts y licencias originales
documentacion/metodologia/          Alcance, supuestos y límites por producto
documentacion/fuentes/              Fuentes y procedencia
documentacion/informes/             Inventario, manifiesto y control de calidad
assets/                            Estilos, búsqueda, identidad y catálogo del portal
LICENSE                            Condiciones de uso y licencias por componente
```

Los proyectos complejos se conservan completos dentro de `codigo/` para mantener sus rutas de reproducción. Las páginas finales de esos proyectos están en `dashboards/`. Solo se muestra un acceso principal por producto; los archivos de apoyo permanecen en el proyecto conservado.

## Fuentes de datos


- MEFP: Presupuesto Abierto, recursos y gastos 2016–2025.
- Ministerio de Educación: SEIE 2024 y fuentes citadas en los productos vigentes.
- INE: Censo de Población y Vivienda 2024; cartografía de Lab TecnoSocial y referencias conservadas en cada producto.

Consulte [fuentes](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/fuentes/index.html) y las notas de cada producto. Los períodos no se homogeneizan artificialmente. La fecha del portal **no implica actualización de las bases**.

## Metodología y reproducibilidad

Se copian las versiones públicas identificadas por commit; la muestra educativa incluye además Excel, presentación PPTX, GeoJSON original, CSV, metodología y selección en Python extraídos de sus descargas integradas; se conservan datos, scripts, documentación, avisos y archivos finales disponibles. El [manifiesto](documentacion/informes/manifest-migracion.json) documenta origen y destino. Los repositorios originales permanecen intactos.

La migración no vuelve a estimar resultados. Montos corrientes, universos distintos, datos faltantes, proyecciones y asociaciones estadísticas mantienen las advertencias de cada trabajo. Los HTML vigentes con datos embebidos se preservan, con sus notas y límites de interpretación. La ausencia de un script original no se sustituye por uno inventado.

Limitaciones: el análisis espacial requiere un objeto `world` no suministrado; los dashboards DDE y DDEd no publican sus procesos originales de limpieza; la muestra educativa sí incluye un paquete de reproducción recuperado de sus descargas, con siete resultados reproducidos e idénticos al original.

## GitHub Pages

Publicación estática desde la rama `main`, carpeta raíz `/`, con `.nojekyll`. Los enlaces del portal son relativos. URL: https://monicact.github.io/educacion-gasto-social-bolivia/

## Licencias

Consulte [LICENSE](LICENSE): se conservan las licencias existentes por proyecto y las atribuciones de bibliotecas, datos y cartografía. No se aplica una licencia nueva de manera indiscriminada.

## Inventario y calidad

[Repositorios revisados y decisiones](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/informes/inventario.html) · [Metodología general](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/index.html)

[Control de calidad y verificaciones](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/informes/control-calidad.html)


El 6 de octubre de 2026 se retiraron el dashboard «Gasto educativo por estudiante en Bolivia» y la presentación «Diploma de Bachiller Digital», junto con sus recursos asociados. Permanecen los nuevos dashboards de costo estimado frente al devengado e impacto del Diploma en las DDE.
