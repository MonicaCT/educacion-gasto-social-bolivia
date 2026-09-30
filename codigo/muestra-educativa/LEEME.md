# Entrega de la muestra educativa

La propuesta contiene 120 escuelas principales y 24 reservas, seleccionadas con datos SEIE 2024. Hay 60 principales y 12 reservas por nivel de evaluación. Las escuelas mixtas aparecen una sola vez.

## Por dónde empezar

1. Abrir `Muestra_educativa_Bolivia.xlsx` y revisar la hoja Resumen.
2. Consultar Muestra propuesta y Reservas para ver las escuelas.
3. Completar las celdas amarillas de Verificación con información actual y su fuente. No cambiar las listas sorteadas sin documentar y revisar el diseño.
4. Leer `Metodo_de_seleccion.md` para entender las cuotas, pesos, escuelas mixtas, reservas y límites.
5. Usar `Presentacion_muestra_educativa.pptx` para explicar la propuesta a autoridades.

**La asignación a tratamiento y control permanece pendiente.** También están pendientes la confirmación de funcionamiento, matrícula por nivel, participación y la validación estadística del tamaño. No se contactó a las escuelas.

## Reproducción del sorteo

El archivo `Reproduccion_muestra.zip` contiene la base limpia, el original GeoJSON, el código y los resultados en CSV. Extraerlo en una carpeta y ejecutar con Python 3.10 o superior:

```text
python seleccionar_muestra.py --base seie_matricula_ue_2024.csv --salida nueva_ejecucion
```

No se necesitan paquetes adicionales. Los resultados deben coincidir con la carpeta `resultados`, con la misma base y semilla.

Los pesos iniciales sirven para la muestra principal por nivel. Antes de analizar un programa hay que revisar no respuesta, reemplazos, marco actualizado y selección de estudiantes. No usar las 120 escuelas sin ponderar como si fueran una muestra proporcional del país.
