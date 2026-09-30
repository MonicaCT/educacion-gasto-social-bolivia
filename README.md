# Educación y Gasto Social · Bolivia

**Dashboards, análisis y visualizaciones para el análisis de políticas públicas**

Autora: **Mónica Cueto Tapia** · Actualización del repositorio: **30 de septiembre de 2026**

## Abrir el portafolio

### [Visitar el portal público](https://monicact.github.io/educacion-gasto-social-bolivia/)

Los dashboards y presentaciones se abren directamente en el navegador, en computadora o celular. **No es necesario ejecutar R, Python ni instalar herramientas.** Abra el enlace del producto en la tabla. La presentación del Diploma también puede descargarse y abrirse como HTML.

## Objetivo y temas

Repositorio central y portafolio público de trabajos sobre educación y gasto social en Bolivia: presupuesto y financiamiento educativo, DDE y nivel distrital, evaluación y muestreo, gestión territorial, transformación digital y protección social. Los análisis latinoamericanos se incorporan por su contenido educativo o social y su inclusión de Bolivia, con alcance regional explícito.

## Productos disponibles

| Producto | Tipo | Período | Recursos |
|---|---|---|---|
| [Gasto de las DDE 2016–2025](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/gasto-dde-2016-2025/index.html) | Dashboard | 2016–2025 | [Datos](datos/gasto-dde/) · [Código](codigo/gasto-dde/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/gasto-dde-2016-2025.html) |
| [Gasto asociado al nivel distrital](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/gasto-dded-bolivia/index.html) | Dashboard | 2016–2025 | [Datos](datos/gasto-dded/) · [Código](codigo/gasto-dded/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/gasto-dded-bolivia.html) |
| [Propuesta de muestra nacional para evaluaciones educativas](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/muestra-educativa-bolivia/index.html) | Dashboard | Marco educativo 2024 | [Datos](datos/muestra-educativa/) · [Código](codigo/muestra-educativa/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/muestra-educativa-bolivia.html) |
| [Atlas Bolivia · población, territorio y educación](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/atlas-educacion-bolivia/index.html) | Dashboard | CPV 2024 | [Datos](datos/atlas-educacion/) · [Código](codigo/atlas-educacion/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/atlas-educacion-bolivia.html) |
| [Gasto educativo en el contexto regional](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/gasto-educativo-regional/index.html) | Análisis | 1990–2020 | [Datos](datos/gasto-educativo-regional/) · [Código](codigo/gasto-educativo-regional/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/gasto-educativo-regional.html) |
| [Diploma de Bachiller Digital](https://monicact.github.io/educacion-gasto-social-bolivia/presentaciones/diploma-bachiller-digital/index.html) | Presentación | Histórico 2011–2025 · proyección 2026–2030 | [Datos](datos/diploma-bachiller/) · [Código](codigo/diploma-bachiller/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/diploma-bachiller-digital.html) |
| [Pobreza, informalidad y protección social](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/proteccion-social/dashboard/index.html) | Dashboard | Ventana analítica 2000–2023 | [Datos](datos/proteccion-social/) · [Código](codigo/proteccion-social/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/proteccion-social.html) |
| [Vulnerabilidad estructural y política social](https://monicact.github.io/educacion-gasto-social-bolivia/dashboards/vulnerabilidad-social/dashboard.html) | Análisis | 2000–2023 | [Datos](datos/vulnerabilidad-social/) · [Código](codigo/vulnerabilidad-social/) · [Método](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/vulnerabilidad-social.html) |

## Estructura

```text
index.html                         Portal principal
presentaciones/diploma-bachiller-digital/index.html
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
- Ministerio de Educación: SEIE 2024, documentación institucional y fuentes citadas en el Diploma de Bachiller.
- INE: Censo de Población y Vivienda 2024; cartografía de Lab TecnoSocial y referencias conservadas en cada producto.
- Estudios regionales: paneles y diccionarios de SEDLAC, ILOSTAT, WDI, ASPIRE y otras fuentes declaradas por los proyectos. La base del estudio espacial no presenta una atribución institucional completa.

Consulte [fuentes](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/fuentes/index.html) y las notas de cada producto. Los períodos no se homogeneizan artificialmente. La fecha del portal **no implica actualización de las bases**.

## Metodología y reproducibilidad

Se copian las versiones públicas identificadas por commit; la muestra educativa incluye además Excel, presentación PPTX, GeoJSON original, CSV, metodología y selección en Python extraídos de sus descargas integradas; se conservan datos, scripts, documentación, avisos y archivos finales disponibles. El [manifiesto](documentacion/informes/manifest-migracion.json) documenta origen y destino. Los repositorios originales permanecen intactos.

La migración no vuelve a estimar resultados. Montos corrientes, universos distintos, datos faltantes, proyecciones y asociaciones estadísticas mantienen las advertencias de cada trabajo. Los HTML con datos embebidos se preservan; en el Diploma se reparó el alcance del controlador de descarga Excel y el ajuste de referencias en móvil, sin cambiar textos, cifras o cálculos; las extracciones de esos datos se identifican expresamente. La ausencia de un script original no se sustituye por uno inventado.

Limitaciones: el análisis espacial requiere un objeto `world` no suministrado; los dashboards DDE y DDEd no publican sus procesos originales de limpieza; la muestra educativa sí incluye un paquete de reproducción recuperado de sus descargas, con siete resultados reproducidos e idénticos al original. El documento interno citado por la presentación del Diploma no fue proporcionado como fuente separada. Sus descargas `.xls` son tablas HTML compatibles con Excel, conservadas tal como fueron entregadas.

## GitHub Pages

Publicación estática desde la rama `main`, carpeta raíz `/`, con `.nojekyll`. Los enlaces del portal son relativos. URL: https://monicact.github.io/educacion-gasto-social-bolivia/

## Licencias

Consulte [LICENSE](LICENSE): se conservan las licencias existentes por proyecto y las atribuciones de bibliotecas, datos y cartografía. No se aplica una licencia nueva de manera indiscriminada.

## Inventario y calidad

[Repositorios revisados y decisiones](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/informes/inventario.html) · [Metodología general](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/metodologia/index.html)

[Control de calidad y verificaciones](https://monicact.github.io/educacion-gasto-social-bolivia/documentacion/informes/control-calidad.html)
