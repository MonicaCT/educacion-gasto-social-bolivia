# Verificación del portal

Comprobaciones estáticas, con Python 3 sin dependencias:

```sh
python codigo/verificacion/verificar_sitio.py
```

Pruebas funcionales opcionales: requieren Node.js, Playwright y Chromium. Ejecute `node codigo/verificacion/pruebas_navegador.cjs`. CHROME_PATH permite indicar un navegador instalado. QA_BASE permite probar la URL pública; sin esa variable se sirve la copia local en el puerto 8765. Los informes se guardan en el directorio temporal del sistema.

Las pruebas de descarga escriben los archivos exportados en datos/ de la copia local. No suba exportaciones de escenarios o filtros de prueba sin revisar su alcance.
