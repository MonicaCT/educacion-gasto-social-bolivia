# Configuración recomendada del repositorio

[← Documentación](README.md) · [Volver al repositorio](../README.md)

## 1. Identidad

- **Nombre:** `atlas-bolivia-cpv2024`
- **Propietaria:** `MonicaCT`
- **Visibilidad:** Public
- **Rama principal:** `main`
- **Descripción sugerida:** `Atlas interactivo de población, territorio y educación en Bolivia con referencia al Censo de Población y Vivienda 2024.`

---

## 2. GitHub Pages

Configuración recomendada:

1. Abrir **Settings**.
2. Entrar a **Pages**.
3. En **Build and deployment**, elegir **Deploy from a branch**.
4. Seleccionar la rama **main**.
5. Seleccionar la carpeta **/(root)**.
6. Guardar.

La dirección esperada será:

**https://monicact.github.io/atlas-bolivia-cpv2024/**

`index.html` debe permanecer en la raíz del repositorio.

El archivo `.nojekyll` evita procesamiento innecesario de Jekyll y permite servir el proyecto como sitio estático simple.

---

## 3. Funciones de GitHub

### Activar

- **Issues:** sí. Útil para registrar errores, mejoras y tareas.
- **Releases:** sí. Útil para versiones estables.

### Opcionales / no prioritarias

- **Discussions:** no necesario inicialmente.
- **Wiki:** no necesario; la documentación vive en `docs/`.
- **Projects:** puede activarse más adelante si el desarrollo crece.

---

## 4. Topics sugeridos

Añadir los siguientes topics al repositorio:

`bolivia`

`cpv-2024`

`censo`

`demografia`

`educacion`

`analisis-territorial`

`data-visualization`

`public-policy`

`dashboard`

---

## 5. Versionado

Se recomienda **Semantic Versioning**:

- `v1.0.0`: primera publicación estable;
- `v1.1.0`: mejoras compatibles o nuevos gráficos;
- `v1.2.0`: nuevos indicadores compatibles;
- `v2.0.0`: cambios importantes de metodología, estructura o compatibilidad.

No crear múltiples archivos HTML para representar versiones. Mantener siempre la versión vigente como `index.html` y dejar que Git conserve el historial.

---

## 6. Release inicial

### Tag

`v1.0.0`

### Título

`Atlas Bolivia CPV 2024 · v1.0.0`

### Texto sugerido

> Primera publicación estable del Atlas Bolivia · CPV 2024. Incluye panorama nacional, análisis territorial, demografía, educación, explorador de localidades/comunidades, mapas municipales/TIOC y documentación metodológica.

---

## 7. Commits

Usar mensajes breves y descriptivos. Ejemplos:

- `Publicar versión inicial del dashboard`
- `Corregir navegación por pestañas`
- `Actualizar metodología de indicadores demográficos`
- `Mejorar mapa municipal y leyenda`
- `Actualizar referencias y fuentes`

Evitar mensajes como `cambios`, `final`, `final2` o `arreglado`.

---

## 8. Archivos que no deben subirse

Evitar:

- copias locales duplicadas del dashboard;
- archivos temporales;
- rutas de la computadora personal;
- bases de datos que no deban redistribuirse;
- archivos de credenciales;
- claves API;
- archivos generados automáticamente que no sean necesarios para la publicación.

El archivo `.gitignore` incluido ayuda a prevenir parte de estos casos.

---

## 9. Documentación legible al abrir

GitHub renderiza automáticamente los archivos `.md`.

Para mejorar la navegación:

- `README.md` se muestra automáticamente en la portada del repositorio;
- `docs/README.md` se muestra automáticamente al entrar a `docs/`;
- `assets/README.md` se muestra automáticamente al entrar a `assets/`;
- cada documento incluye enlaces de retorno y navegación superior.

No es necesario descargar los `.md` para leerlos.

---

## 10. Cita del repositorio

El archivo `CITATION.cff` permite que GitHub muestre la opción **Cite this repository** y genere formatos de citación automáticamente.
