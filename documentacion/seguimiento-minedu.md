# Seguimiento MINEDU

La herramienta permite registrar avances, revisar compromisos y consultar la versión convalidada para el ministro.

## Lectura de tablas

Las filas alternan fondos para facilitar el seguimiento horizontal. Los encabezados diferencian las columnas de identificación, revisión y avance. Cada etapa tiene color, icono y texto: Borrador, En revisión, Observado y Validado. Las tablas de hitos tienen encabezados violeta y los reportes impresos, encabezados ocre.

Los colores no reemplazan las etiquetas. El botón de etapa abre su historial; Situación reportada abre la ficha; Observaciones muestra solicitudes y plazos.

## Gráficos

Los gráficos y la tabla usan los mismos filtros y el mismo conjunto de temas. Muestran la cantidad de temas por etapa y por intervalo de avance. Sin reporte identifica los temas sin descripción de situación actual y sin un avance mayor que cero; no significa automáticamente retraso.

El comité dispone además de un gráfico con las alertas originales de la fuente. Si hay avances reportados y más de una unidad seleccionada, se muestra el avance promedio por unidad, con una escala común de 0 a 100 % y el mismo peso por tema. Los temas sin avance reportado aportan 0 %.

El perfil Ministro utiliza los avances de la última versión convalidada. Una etapa actual En revisión puede coexistir con una versión convalidada anterior.

Los indicadores superiores resumen todos los temas; los gráficos y la tabla describen la selección filtrada. Cuando no hay temas, se muestra un mensaje explícito.

## Trabajo por perfil

- Responsable: identifíquese, localice el compromiso y abra Situación reportada. Actualice avance, situación, riesgos, próximo paso y seguimiento de hitos. Guarde el borrador o envíelo al comité.
- Comité: revise las fichas, asuma revisiones, comunique observaciones y plazos, y convalide los avances para el ministro.
- Ministro: consulte los avances convalidados y registre orientaciones.

## Diagramas por perfil

Al ingresar se muestra el apartado Procedimiento e instrucciones con el diagrama correspondiente a Responsable, Comité de seguimiento o Ministro. Despliegue el apartado para ver la imagen. El botón Instrucciones de uso también incluye el mismo diagrama junto con los pasos escritos.

Use Abrir diagrama en tamaño completo para leer o descargar la imagen con más detalle.

## Guardado

Los cambios se guardan en este navegador. Los perfiles comparten los registros únicamente en este mismo navegador: no hay sincronización entre computadoras ni navegadores diferentes. El panel de conexión, los campos de token y las opciones de sincronización fueron retirados.

Los registros e historiales existentes se mantienen. La aplicación sigue permitiendo guardar borradores, enviar temas al comité, convalidar avances y registrar orientaciones dentro del almacenamiento local.

## Tablero del Señor Ministro: tres vistas

**Resumen:** matriz Importante vs. Urgente, semáforo original, cruce de marcas políticas con semáforo y alertas de seguimiento. Cada tema de la selección aparece una sola vez en la matriz. Pulse un tema para abrir su ficha y una categoría del semáforo para filtrar.

**Por unidad:** cantidad de temas y composición del semáforo por unidad, y carga por persona. Las asignaciones compartidas con / se cuentan en cada unidad o persona: estos totales no son aditivos. Pulse una unidad o persona para explorar sus temas. La etiqueta superior permite retirar la selección del gráfico.

**Detalle por tema:** ficha con producto, responsable, fecha final, situación, observación original y último hito definido. Incluye proporción de hitos, cronograma parcial, seguimiento y orientaciones del Señor Ministro. Imprimir genera las fichas de la selección, o la ficha actual si está en Detalle por tema.

### Alcance y fuentes

El tablero incluye los 25 temas de la base original, incluso sin versión convalidada. La situación original se identifica como tal; los avances de gestión proceden únicamente de la versión convalidada. Nunca se muestra un borrador de gestión. Los indicadores superiores se refieren a la selección actual en las tres vistas.

El número mostrado es A, no el identificador interno del navegador. En la base actual falta el 21; no se crea un tema ficticio ni se renumeran los siguientes. Los 16 temas sin W permanecen Sin evaluar.

### Regla de prioridad

Importancia = 1 punto por anunciado (D) y 1 por potencial conflicto (E); importante si suma al menos 1.

Urgencia = 1 punto por entrega 2026 (F), 2 si hay una fecha final (G) o hito con año explícito vencido o en los próximos 30 días, más 2 si W es rojo o 1 si es ámbar. Urgente si suma al menos 2. Es una regla de priorización, no una recalificación del semáforo ni una medida de cumplimiento. Las fechas con año supuesto no suman puntos ni generan alertas.

### Fechas y avance por hitos

En la base hay 2 temas con hitos descritos. Las fechas finales G son fechas completas; los hitos escritos como 9 de noviembre no especifican año. Por defecto no se posicionan esos hitos como fechas completas. La opción Usar 2026 permite ubicarlos solo cuando F indica entrega en 2026; se señalan con asterisco y marcador discontinuo.

La línea de tiempo marca la fecha de consulta en America/La_Paz. Se representan fechas objetivo y no se inventan duraciones para un Gantt. Los hitos sin fecha permanecen en la tabla de seguimiento.

La proporción U de 0.25 equivale al 25 %, y si hay 4 hitos definidos, a 1/4 aritméticamente. No identifica qué hito está cumplido; no se marca uno por inferencia. Si existen confirmaciones en los hitos de una versión convalidada, se utilizan esas confirmaciones. Sin U ni confirmación se muestra Sin información, no 0 %.

### Alertas y calidad

Alertas de seguimiento reúne hasta 5 temas rojos de W, con hitos de fecha completa vencida sin confirmación, o con retraso positivo consignado en V. Un hito de cumplimiento desconocido se etiqueta sin confirmación, no incumplido. W carece de fecha de evaluación: el tablero no presenta esos rojos como eventos nuevos de la semana.

U, V y W conservan sus significados separados. En la base U tiene 2 valores (0 y 0.25) y V tiene 2 valores (ambos 0); esa cobertura no permite sustituir W por una evaluación automática.

La base está incorporada al dashboard. No hay una conexión automática con un archivo Excel externo ni se reintroduce carga de adjuntos. Actualizar la base requiere actualizar los datos incorporados; los cambios de gestión siguen guardándose en el navegador como antes.
