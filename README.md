# Semana

Organizador de tareas semanal: tareas puntuales y recurrentes, arrastrar para ordenar y mover de día, temas.

- `assets/index.html`: toda la app (HTML + CSS + JS, sin dependencias).
- `src/`: carcasa Android (WebView + guardado en `tareas.json`).
- `build.sh`: compila el APK con el SDK por línea de comandos (aapt2, javac, d8, apksigner). La firma (`release.keystore`) no está en el repo: si falta se genera una nueva, pero un APK firmado con otra clave no se instala encima del anterior.
