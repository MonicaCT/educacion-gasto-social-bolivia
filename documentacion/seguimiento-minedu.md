# Seguimiento MINEDU · Documentos privados del comité

## Responsables: enviar sin cuenta de GitHub

1. Ingrese al perfil Responsable con su nombre y abra **Adjuntos relevantes**.
2. Pegue su código personal y pulse **Conectar envío**.
3. Seleccione el compromiso y los archivos (máximo 10 MB por archivo).
4. Pulse **Enviar documentos al comité** y espere la confirmación.

Cada documento se cifra antes de salir del navegador y se guarda automáticamente en el repositorio privado `MonicaCT/minedu-documentos-privados`. No hace falta una cuenta de GitHub ni un token. El código de responsable solo permite enviar: el servidor rechaza listados, consultas y descargas.

Si una carga múltiple se interrumpe, el mensaje indica cuántos archivos se confirmaron. Seleccione nuevamente solo los restantes.

## Comité: consultar

1. Ingrese al perfil **Comité de seguimiento** y abra **Adjuntos relevantes**.
2. Seleccione su archivo privado de acceso y pulse **Abrir acceso del comité**.
3. Pulse **Descargar documento**. El archivo se descifra en el navegador.
4. Pulse **Cerrar acceso** al terminar. Recargar o cerrar la página también elimina el acceso de la sesión.

Entrar al perfil con la contraseña del prototipo NO concede acceso a los documentos: también hace falta el archivo privado del comité. Ni los responsables ni el perfil Ministro pueden consultar los adjuntos. El remitente conserva, naturalmente, su archivo original.

## Administración

La administradora recibe cinco códigos separados, uno por responsable, y un archivo privado para el comité. Entregue a cada responsable únicamente su propio código. Comparta el archivo privado exclusivamente con integrantes del comité y conserve un respaldo seguro. Quien obtenga ese archivo podrá leer los documentos. Si pierde la llave privada y no hay respaldo, no es posible recuperar el contenido cifrado.

Los códigos y la llave privada no se publican en GitHub. Los códigos del servicio y la credencial de escritura de GitHub se configuran como variables secretas de Sites. El navegador conserva sus accesos solo en memoria, sin localStorage ni IndexedDB.

El punto de recepción es accesible por internet para funcionar desde GitHub Pages sin cuentas de los participantes. Todas las operaciones de documentos exigen un código válido. Los códigos de envío no permiten leer y el código del comité no permite subir. El repositorio privado guarda cifrados el contenido y los metadatos (nombre, autor y compromiso). Solo la llave pública de envío se publica en el dashboard.

Se utiliza AES-256-GCM con una clave nueva por documento y RSA-OAEP de 3072 bits para entregar esa clave al comité. La integridad vincula el identificador del documento y distingue archivo y metadatos. El sobre cifrado y el contenido se guardan juntos en un commit. No hay enlaces públicos de descarga.

Para revocar un código, elimínelo o sustitúyalo en la variable secreta `DOCUMENT_ACCESS_CODES` del servicio y publique la nueva revisión. El comité comparte un acceso de grupo: para revocar a alguien que ya recibió su llave hay que rotar la llave y el acceso del comité. No se pueden retirar las copias descargadas previamente.

## Avances y documentos

Los avances y observaciones de las fichas conservan el funcionamiento anterior: se guardan localmente y la administradora puede sincronizarlos al repositorio público con **Administración · sincronizar avances con GitHub**. Esa opción no es necesaria para enviar documentos.

No escriba información confidencial ni enlaces públicos a documentos en las fichas. Esta protección se aplica a los documentos enviados mediante **Adjuntos relevantes**. Los archivos guardados anteriormente en un navegador permanecen en ese equipo y deben seleccionarse de nuevo para enviarlos al almacenamiento privado.

La comprobación inicial no encontró documentos en la carpeta pública de adjuntos del repositorio.
