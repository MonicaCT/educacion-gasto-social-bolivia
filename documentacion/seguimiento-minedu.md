# Seguimiento MINEDU

Abra [el dashboard](https://monicact.github.io/educacion-gasto-social-bolivia/Seguimiento_MINEDU.html).

1. Cree un token específico de GitHub, limitado a este repositorio, con Contents: Read and write.
2. Ingréselo en Almacenamiento en GitHub y pulse Conectar y cargar datos. El token permanece solo en memoria; nunca se incluye en los archivos publicados.
3. Registre avances o seleccione documentos en Adjuntos relevantes.
4. Pulse Guardar datos y adjuntos en GitHub. Espere el mensaje de confirmación con el identificador del commit.
5. Desde otra computadora, conecte y cargue para recuperar la información compartida.

Los datos se guardan en datos/seguimiento-minedu/estado.json y los documentos en datos/seguimiento-minedu/adjuntos/. Cada guardado genera un único commit. Si otra persona cambió los datos, se rechaza el guardado: exporte su respaldo, cargue la versión actual y vuelva a aplicar sus cambios. No se fusionan automáticamente.

El repositorio es público: datos, documentos e historial son públicos. Los perfiles y contraseñas del HTML son de demostración, no autenticación ni control de acceso; la escritura real depende del token de GitHub. No cargue documentación confidencial.

Guardar borrador conserva información local; la publicación en GitHub requiere el botón Guardar datos y adjuntos en GitHub. Los documentos preparados que aún no se guardaron se mantienen en memoria y se pierden al cerrar la página. Los documentos locales antiguos de IndexedDB deben seleccionarse otra vez para subirlos.

Límite de cada documento: 20 MB. GitHub Pages puede tardar en reflejar los cambios; la carga compartida usa directamente la API de GitHub. Las reglas de protección de main pueden impedir el guardado directo.
