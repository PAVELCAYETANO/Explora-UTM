# Explora UTM

**Explora UTM** es una aplicación móvil interactiva diseñada para guiar a los estudiantes de nuevo ingreso a través del campus de la Universidad Tecnológica de la Mixteca. La app combina navegación GPS, información detallada de edificios y dinámicas lúdicas para facilitar la adaptación al entorno universitario.

## Integrantes:
* **Jose Pavel Cayetano Lopez**.

## Tecnologías a Utilizar
* **Framework:** [Flutter](https://flutter.dev/) (Dart).
* **Mapas:** [Google Maps SDK for Flutter](https://pub.dev/packages/google_maps_flutter) o [Flutter Map](https://pub.dev/packages/flutter_map).
* **Geolocalización:** [Geolocator](https://pub.dev/packages/geolocator) para ubicación en tiempo real.
* **Estado:** [Provider](https://pub.dev/packages/provider) o [Riverpod].
* **Almacenamiento:** Firebase para datos dinámicos de los puntos de interés.

## Prototipo de Pantallas

A continuación se describen las pantallas principales del prototipo actual:

1.  **Pantalla de Exploración (Home):** Un mapa interactivo con filtros rápidos (Laboratorios, Biblioteca) y una tarjeta de "Lugar Destacado" (como el auditorio) que muestra un resumen y un boton "Ver detalles" para ir a la pantalla de detalle del lugar.
<br>
<img src="screenshots/inicio_explora_pantalla.png" width="300" alt="Pantalla Principal">

2.  **Zonas y Lugares Cercanos:** Pantalla en la que se muestra informacion extendida y los detalles de cada una de las zonas de la universidad, funcionalidad para saber como llegar a ese lugar, horarios de atencion, datos curiosos, tarjetas de lugares cercanos.
<br>
<img src="screenshots/lugares_cercanos_pantalla.png" width="300" alt="Pantalla de Lugares Cercanos">

4.  **Rutas y Senderos:** Sugerencias de recorridos dentro del campus, como el "Circuito Deportivo" o el camino al "Mirador del Atardecer", indicando tiempo estimado y dificultad.
<br>
<img src="screenshots/rutas_pantalla.png" width="300" alt="Pantalla de Rutas">

5.  **Trivia:** Pantalla en la que se muestra un juego de trivia sobre la universidad, con preguntas y respuestas sobre la historia, cultura y lugares emblemáticos de la UTM.
<br>
<img src="screenshots/trivia_pantalla.png" width="300" alt="Pantalla de Trivia">


## Actividades o Juegos:

* **[Trivia academica]:** Ubicado en la carpeta `/propuesta/trivia-pavel/`.