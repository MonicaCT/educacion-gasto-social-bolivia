# Muestra nacional propuesta para futuras evaluaciones educativas

Fecha de preparación: 17 de septiembre de 2026. Fuente administrativa: SEIE, gestión 2024.

## Resultado y alcance

Se seleccionaron **120 escuelas distintas y 24 reservas iniciales**. La lista principal contiene 60 escuelas para evaluar primaria y 60 para secundaria. Todas requieren verificación de vigencia. No se contactó a escuelas, no se confirmó participación y no se asignó tratamiento o control.

El universo provisional tiene 15.442 escuelas. De los 16.099 registros originales se apartaron 609 escuelas con oferta solo inicial y 48 con matrícula total cero. Una escuela con matrícula total positiva aún puede no tener estudiantes en el nivel principal de evaluación, por lo que se requiere confirmación por nivel y grado.

El tamaño de 120 es un supuesto de planificación. Sin programa, resultado, efecto mínimo relevante ni plazo, no hay cálculo de potencia válido que garantice su suficiencia. La propuesta busca preparar comparaciones nacionales separadas por nivel. No permite prometer estimaciones de impacto por departamento, dependencia o área.

## Distribución realizada

| Departamento | Primaria | Secundaria | Total principal | Reservas |
|---|---:|---:|---:|---:|
| Chuquisaca | 6 | 6 | 12 | 2 |
| La Paz | 10 | 10 | 20 | 4 |
| Cochabamba | 8 | 8 | 16 | 4 |
| Oruro | 4 | 6 | 10 | 2 |
| Potosí | 8 | 6 | 14 | 2 |
| Tarija | 6 | 4 | 10 | 2 |
| Santa Cruz | 8 | 10 | 18 | 4 |
| Beni | 6 | 6 | 12 | 2 |
| Pando | 4 | 4 | 8 | 2 |
| **Total** | **60** | **60** | **120** | **24** |

La muestra principal contiene 67 escuelas rurales y 53 urbanas, 89 fiscales y 31 privadas. Incluye 53 escuelas que ofrecen ambos niveles, cada una con un solo nivel principal de evaluación. La fuente agrupa dependencia en fiscal y privada. No se identificó ni inventó una categoría independiente de convenio.

## Método ejecutado

### A. Preparación

Se conservaron los códigos como texto, se verificó su unicidad y se aplicaron las exclusiones indicadas. Se mantuvieron todos los departamentos, áreas y dependencias. No se excluyeron escuelas por tamaño positivo, distancia, vulnerabilidad ni local compartido.

### B. Escuelas que ofrecen primaria y secundaria

Para evitar duplicaciones, se dividieron aleatoriamente las escuelas mixtas dentro de cada combinación de departamento, área y dependencia. Si hay m escuelas mixtas, piso(m/2) pasan al marco de primaria y el resto al de secundaria. Todos los grupos mixtos observados tienen al menos dos escuelas, por lo que ambos destinos tienen probabilidad positiva.

Las escuelas de primaria sin secundaria pasan a primaria. Las de secundaria sin primaria pasan a secundaria. La oferta de inicial junto con alguno de esos niveles no las excluye.

Esta división fija el número de escuelas de cada marco por estrato, pero decide al azar cuáles escuelas mixtas pertenecen a cada uno. No es una asignación de intervención.

### C. Cuotas

Por cada nivel se asignaron dos pares mínimos a cada departamento: cuatro escuelas. Los 12 pares restantes se repartieron proporcionalmente al tamaño del marco de ese nivel mediante restos mayores. Así se alcanzan 30 pares administrativos o 60 escuelas por nivel. **No se han formado parejas de escuelas**: la expresión «pares» solo indica que las cuotas departamentales son números pares.

Dentro de cada departamento y nivel se reservó al menos una escuela por combinación existente de área y dependencia. El resto se distribuyó proporcionalmente por restos mayores, respetando la disponibilidad. Los empates se resuelven por la clave del grupo. El mínimo por combinación introduce sobrerrepresentación de grupos pequeños, especialmente privadas. Es una decisión para asegurar cobertura, no una distribución proporcional nacional.

Por nivel, las 12 reservas iniciales se repartieron con un mínimo de una por departamento y tres adicionales proporcionales. Dentro de cada departamento se distribuyeron proporcionalmente por estrato, respetando la capacidad restante. No se impuso una reserva por cada estrato: 24 reservas no alcanzan para esa cobertura.

### D. Sorteo reproducible

Semilla fija: `SEIE-2024-MUESTRA-20260917-V1`.

Se ordenan los registros por el valor hexadecimal SHA-256 del texto UTF-8 `semilla|etapa|codigo_ue`. La etapa `nivel` determina la división de mixtas y `seleccion` determina el orden de selección. Son ordenamientos pseudoaleatorios reproducibles, sin depender de la versión de un generador estadístico. Con códigos únicos y sin colisiones observadas, el orden es unívoco. No se buscaron semillas alternativas para obtener una muestra preferida.

Dentro de cada estrato, las primeras n escuelas son principales; las siguientes r son reservas iniciales. El resto conserva su orden para consultas posteriores. Los registros seleccionados no se sustituyeron por motivos de conveniencia.

### E. Probabilidades y pesos

Para el nivel al que se asignó la escuela:

- q = probabilidad de entrar a ese marco. Es 1 para escuelas que ofrecen solo uno de los dos niveles. En mixtas es piso(m/2)/m para primaria y el complemento para secundaria.
- N = número de escuelas del estrato después de dividir mixtas.
- n = cuota principal del estrato.
- Probabilidad de selección, condicionada a ese marco: n/N.
- Probabilidad de inclusión en la muestra del nivel: q × n/N.
- Peso inicial para escuelas de ese nivel: 1/(q × n/N).

Las cuotas y tamaños por celda no cambian con la identidad de las mixtas sorteadas porque su cantidad asignada es fija. Esto permite calcular las probabilidades marginales anteriores. Los pesos son específicos del nivel evaluado y no pesos de estudiantes. No deben sumarse ambos niveles para estimar un total nacional de escuelas únicas, porque las escuelas mixtas pertenecen a los universos de ambos niveles.

Los pesos entregados son iniciales: no incorporan actualización del marco, rechazo, no respuesta, activación de reservas ni selección de estudiantes. Los pesos que aparecen para reservas corresponden a su probabilidad bajo la cuota principal original, **no a una probabilidad válida tras su activación**. Antes de usarlos en un análisis final hay que revisar las sustituciones y el diseño efectivo.

## Protocolo de verificación y reservas

La revisión geográfica para la presentación conserva 15.393 de las 15.442 escuelas del marco: 42 no tienen ambas coordenadas y siete tienen valores fuera del intervalo de control de latitud [-23, -9] y longitud [-70, -57]. Ese intervalo es una revisión de plausibilidad, no una delimitación oficial. No se excluyeron del sorteo por este motivo. El gráfico usa proyección Mercator y muestra 118 principales: 60 de primaria y 58 de secundaria. Las UE `81980545` (ANGELA PINCKERT TARDE) y `81980702` (LAS AMERICAS II) carecen de coordenadas en el original y permanecen seleccionadas.

1. Confirmar actividad, oferta del nivel asignado, matrícula por nivel y grado, dependencia y disposición a participar. Registrar fecha y fuente institucional.
2. Revisar el local compartido. Hay 27 escuelas principales cuyo código de local se repite con otras escuelas elegibles. Los códigos de local `71180016` y `81230101` se repiten dentro del conjunto de principales y reservas. Esto es una señal administrativa, no una confirmación de interacción entre escuelas.
3. Si una escuela no es elegible o rechaza participar antes de asignar tratamiento, registrar el motivo. Buscar el mismo `estrato` y la menor `prioridad_suplencia` disponible. No utilizar una reserva de otro departamento, nivel, área o dependencia por simple conveniencia.
4. Si ese estrato no tiene reserva inicial, consultar su orden completo en Universo elegible. Si se agota, revisar cuotas y probabilidades antes de sustituir. Un estrato con selección de todas sus escuelas puede no tener sustitutos.
5. Mantener un historial por código de escuela: salida, motivo, fecha, sustituta y responsable. La hoja Verificación permite registrar hechos y observaciones; no activa reservas automáticamente ni cambia las listas sorteadas.
6. No sustituir automáticamente escuelas que abandonen después de asignar tratamiento. Eso modifica el experimento y requiere un protocolo específico.

«Preverificación completa» en Excel requiere respuesta Sí en actividad, oferta, participación y revisión del local, matrícula numérica positiva, fecha y fuente. Es un control de documentación preliminar. No significa que el programa, la potencia o la asignación estén aprobados.

## Lo que falta antes de evaluar una política

Definir intervención, grados, resultado principal, horizonte y efecto mínimo relevante. Actualizar el marco. Calcular potencia por nivel considerando correlación dentro de escuelas y pérdidas. Determinar si la política se puede asignar por escuela o requiere municipios/distritos. Recoger línea de base, formar parejas y sortear tratamiento si corresponde.

La matrícula total 2024 no sustituye resultados de aprendizaje ni matrícula por nivel. Una política universal aplicada simultáneamente no genera un control mediante este procedimiento. La presencia de todos los departamentos no convierte por sí sola a la muestra sin ponderar en representativa del país.

## Reproducción

Se requiere Python 3.10 o superior, sin paquetes externos:

```text
python seleccionar_muestra.py --base seie_matricula_ue_2024.csv --salida resultados
```

El programa produce muestra, reservas, universo con orden completo, exclusiones, distribución, comparación y validación. La hoja de Excel presenta esos resultados y añade campos manuales de verificación. No se recalcula un sorteo al abrir el Excel.

SHA-256 de la base: `adf8a81e3136adef3b4b0b73bbe9fec076b7f3876c9bc625deb050eb8cfbde80`.

La carpeta de reproducción conserva base, código y resultados. Una segunda ejecución debe producir archivos idénticos. La validación comprueba 120 principales, 24 reservas, 144 códigos únicos, 60+60 principales, 12+12 reservas, coherencia de niveles y cuotas departamentales pares.

## Fuentes

- SEIE Matrícula Educativa: https://seie.minedu.gob.bo/reportes/estadisticas/grupo1/matricula
- SEIE mapa de unidades educativas, fuente de la descarga: https://seie.minedu.gob.bo/reportes/mapas_unidades_educativas/
- El archivo FUENTE_Y_METODO.md conserva el origen exacto del GeoJSON, su gestión y las validaciones de matrícula.
- Referencia para la etapa posterior de potencia: https://www.povertyactionlab.org/resource/power-calculations

La revisión de composición compara las listas sin ponderar con los marcos asignados a cada nivel. No prueba equilibrio experimental ni validez de un futuro efecto causal.
