# Matrícula por unidad educativa — SEIE, gestión 2024

Descarga realizada el 17 de septiembre de 2026. Fuente: Ministerio de Educación de Bolivia, Sistema de Estadísticas e Indicadores Educativos (SEIE).

## Archivos

- `seie_unidades_original.geojson`: respuesta original del servicio público que alimenta la ventana de datos del mapa SEIE, conservada sin modificaciones. Contiene geometrías y atributos.
- `seie_matricula_ue_2024.csv`: copia limpia, una fila por código de unidad educativa, codificación UTF-8 con BOM, separador coma y encabezados en la primera fila.
- `validacion.json`: conteos, faltantes, totales departamentales y huellas SHA-256 de los archivos.

## Fuente y gestión

Página solicitada: [SEIE — Matrícula Educativa](https://seie.minedu.gob.bo/reportes/estadisticas/grupo1/matricula).

En la fecha de consulta, 2024 es la gestión más reciente de su selector. El reporte permite filtrar una ubicación o unidad educativa y descargar la tabla del resumen correspondiente. La consulta nacional no devuelve filas de todas las escuelas.

Para obtener una base nacional por escuela se utilizó el [mapa de unidades educativas del mismo SEIE](https://seie.minedu.gob.bo/reportes/mapas_unidades_educativas/), rotulado **BOLIVIA GESTIÓN 2024**. Su función «Ventana de datos» y su exportación CSV consultan la capa pública `minedu:vw_unidad_geo7`. Se descargó directamente esa misma respuesta, incluyendo los atributos adicionales de provincia, área, dependencia y niveles que el CSV de la interfaz no muestra.

URL exacta del original:

https://seie.minedu.gob.bo/geoserver/minedu/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=minedu%3Avw_unidad_geo7&outputFormat=application%2Fjson&CQL_FILTER=INCLUDE&maxFeatures=20000

Solicitud GET, sin filtros geográficos, de área, dependencia o nivel. El servicio declaró 16.099 registros coincidentes y devolvió los 16.099, por debajo del límite de 20.000. No hubo truncamiento según estos metadatos.

El atributo `gestion` no existe dentro del GeoJSON. Se añadió 2024 al CSV a partir del rótulo del mapa, corroborado mediante coincidencia exacta del total nacional y de los nueve totales departamentales con el módulo de matrícula 2024. La capa no lleva año en su nombre y puede actualizarse: para reproducir esta versión debe conservarse el original entregado.

También se revisó el [portal SIE de reportes estadísticos](https://reportes.sie.gob.bo/reporteestadistico/), que muestra gestión 2026. Es un portal distinto; esta entrega no afirma que 2024 sea el último dato existente en todo el Ministerio. Se mantuvo la fuente SEIE solicitada y no se mezclaron gestiones.

## Variables y transformaciones

| Columnas CSV | Atributos originales | Tratamiento |
|---|---|---|
| codigo_ue, nombre_ue | cod_ue, des_ue | Identificador y nombre, sin espacios exteriores |
| codigo_departamento, departamento | cod_pol_dep, des_dep | Código y nombre |
| codigo_provincia, provincia | cod_pol_pro, des_pro | Código y nombre |
| codigo_municipio, municipio | cod_pol_mun, des_sec | Código y nombre |
| codigo_distrito, distrito_educativo | cod_dis, des_dis | Código y nombre; se conservan nombres faltantes |
| area_codigo, area | area | U = Urbana, R = Rural |
| dependencia_codigo, dependencia | depend | 0 = Privada, 1 = Fiscal, según el selector del mapa |
| nivel_codigo, niveles_ofertados | nivel | Niveles que ofrece la escuela, según selector del mapa |
| matricula_total | matricula | Número original de estudiantes; no se redistribuyó |
| codigo_local_educativo | cod_le | Identificador del local educativo |
| turno_codigo | turnoals | Código original, sin interpretación adicional |
| gestion | No existe en el original | 2024, conforme a la verificación descrita arriba |

Correspondencia de nivel: 1 Inicial; 2 Primaria; 3 Inicial y Primaria; 4 Secundaria; 5 Inicial y Secundaria; 6 Primaria y Secundaria; 7 Inicial, Primaria y Secundaria.

Se eliminaron únicamente espacios exteriores de textos. No se corrigieron nombres ni se descartaron registros. Se ordenó por código de departamento, municipio y unidad educativa. El GeoJSON conserva todos los campos originales, incluidos los que no se trasladaron al CSV.

**Límites del detalle:** la descarga nacional contiene matrícula total por escuela. No contiene sexo ni grado, ni matrícula separada por nivel. `niveles_ofertados` no equivale a matrícula por nivel: no se debe repetir el total para cada nivel. El módulo de matrícula ofrece consultas individuales por sexo, pero no se reconstruyó una base nacional mediante miles de consultas individuales. Tampoco se distingue dependencia de convenio como categoría separada en esta capa. No se inventaron estas desagregaciones.

Al importar el CSV en Excel, seleccionar UTF-8 y coma como separador, y tratar los códigos como texto.

## Verificación

- 16.099 registros y 16.099 códigos UE distintos.
- 2.940.515 estudiantes: coincide exactamente con el módulo SEIE Matrícula 2024.
- Los nueve totales departamentales coinciden exactamente con ese módulo.
- Sin matrícula nula. Se conservan 48 unidades con matrícula cero.
- 38 registros carecen de nombre de distrito educativo, aunque tienen código. Se mantienen en blanco.
- Sin filtros para excluir privadas, niveles o áreas. Esta es la base descargada; no es una muestra de tratamiento y control.

| Departamento | Matrícula 2024 |
|---|---:|
| Chuquisaca | 144317 |
| La Paz | 729891 |
| Cochabamba | 543644 |
| Oruro | 143835 |
| Potosí | 218139 |
| Tarija | 137579 |
| Santa Cruz | 831349 |
| Beni | 154583 |
| Pando | 37178 |

La coincidencia de totales valida la conciliación de esta descarga con el reporte publicado, no constituye una auditoría independiente de la exactitud de cada registro administrativo.
