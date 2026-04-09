// lib/data/trivia_data.dart

/// Modelo de una pregunta de trivia.
class PreguntaTrivia {
  final String pregunta;
  final List<String> opciones;
  final int respuestaCorrecta; // índice 0-3
  final String explicacion;
  final String categoria;
  final int puntos;

  const PreguntaTrivia({
    required this.pregunta,
    required this.opciones,
    required this.respuestaCorrecta,
    required this.explicacion,
    required this.categoria,
    this.puntos = 10,
  });
}

final List<PreguntaTrivia> preguntasTrivia = [
  // --- HISTORIA UTM ---
  const PreguntaTrivia(
    pregunta:
        '¿En qué año fue fundada la Universidad Tecnológica de la Mixteca?',
    opciones: ['1985', '1990', '1995', '2000'],
    respuestaCorrecta: 1,
    explicacion:
        'La UTM fue fundada en 1990 como parte de una iniciativa federal para '
        'impulsar el desarrollo científico y tecnológico del sur de México.',
    categoria: 'Historia UTM',
    puntos: 10,
  ),
  const PreguntaTrivia(
    pregunta: '¿En qué ciudad del estado de Oaxaca se ubica la UTM?',
    opciones: [
      'Oaxaca de Juárez',
      'Tehuantepec',
      'Huajuapan de León',
      'Tuxtepec'
    ],
    respuestaCorrecta: 2,
    explicacion:
        'La UTM está ubicada en Huajuapan de León, conocida como la "Heroica Ciudad", '
        'capital de la región Mixteca y corazón económico del noroeste oaxaqueño.',
    categoria: 'Historia UTM',
    puntos: 10,
  ),
  const PreguntaTrivia(
    pregunta:
        '¿Cuál es el lema oficial de la Universidad Tecnológica de la Mixteca?',
    opciones: [
      '"Por la ciencia y la humanidad"',
      '"Ciencia y Tecnología para el Desarrollo"',
      '"Educar para transformar"',
      '"Por México y para México"',
    ],
    respuestaCorrecta: 1,
    explicacion:
        '"Ciencia y Tecnología para el Desarrollo" refleja el compromiso de la UTM '
        'con la vinculación entre la investigación académica y el progreso regional.',
    categoria: 'Historia UTM',
    puntos: 15,
  ),

  // --- GEOGRAFÍA MIXTECA ---
  const PreguntaTrivia(
    pregunta:
        '¿Cuántos municipios conforman aproximadamente la región Mixteca en Oaxaca?',
    opciones: ['50', '155', '217', '570'],
    respuestaCorrecta: 1,
    explicacion:
        'La Mixteca oaxaqueña está compuesta por aproximadamente 155 municipios, '
        'siendo una de las regiones más extensas y con mayor diversidad cultural del estado.',
    categoria: 'Geografía Mixteca',
    puntos: 10,
  ),
  const PreguntaTrivia(
    pregunta:
        '¿Qué civilización prehispánica habitó principalmente la región Mixteca?',
    opciones: ['Aztecas', 'Zapotecas', 'Mixtecos', 'Olmecas'],
    respuestaCorrecta: 2,
    explicacion:
        'Los Mixtecos o "Ñuu Savi" (Pueblo de la Lluvia) desarrollaron una de las '
        'civilizaciones más sofisticadas de Mesoamérica, famosa por su orfebrería y códices.',
    categoria: 'Geografía Mixteca',
    puntos: 10,
  ),
  const PreguntaTrivia(
    pregunta:
        '¿Por qué nombre se conoce a la lengua indígena que se habla en la región Mixteca?',
    opciones: ['Náhuatl', 'Zapoteco', 'Mixteco (Ñuu Savi)', 'Mazateco'],
    respuestaCorrecta: 2,
    explicacion:
        'El Mixteco o Ñuu Savi es una familia de lenguas otomangues con más de 30 '
        'variantes dialectales, reconocida por la UNESCO como lengua en riesgo de extinción.',
    categoria: 'Cultura Mixteca',
    puntos: 10,
  ),

  // --- CIENCIA Y TECNOLOGÍA ---
  const PreguntaTrivia(
    pregunta:
        '¿Qué biblioteca de código abierto para mapas se usa en esta app?',
    opciones: ['Google Maps SDK', 'Mapbox', 'flutter_map', 'OpenStreetMap API'],
    respuestaCorrecta: 2,
    explicacion:
        'flutter_map es una biblioteca de código abierto para Flutter basada en '
        'Leaflet.js que utiliza tiles de OpenStreetMap, sin costos de licencia.',
    categoria: 'Tecnología',
    puntos: 15,
  ),
  const PreguntaTrivia(
    pregunta:
        '¿Qué tipo de arquitectura de datos usa esta aplicación para mantener el estado del mapa?',
    opciones: ['Redux', 'IndexedStack', 'BLoC', 'Provider con streams'],
    respuestaCorrecta: 1,
    explicacion:
        'IndexedStack permite mantener todas las pantallas en memoria simultáneamente, '
        'evitando que el mapa se reinicie al navegar entre pestañas.',
    categoria: 'Tecnología',
    puntos: 15,
  ),

  // --- CAMPUS UTM ---
  const PreguntaTrivia(
    pregunta:
        '¿Cuántos puntos de interés destacados tiene el campus UTM en esta app?',
    opciones: ['5', '8', '10', '15'],
    respuestaCorrecta: 2,
    explicacion:
        'ExploraUTM mapea 10 puntos de interés del campus incluyendo la Rectoría, '
        'Biblioteca, Auditorio, Jardín Botánico, laboratorios y espacios deportivos.',
    categoria: 'Campus UTM',
    puntos: 10,
  ),
  const PreguntaTrivia(
    pregunta:
        '¿Qué espacio del campus UTM alberga especies endémicas de la Mixteca oaxaqueña?',
    opciones: [
      'El Auditorio Universitario',
      'La Sala de Cultura Mixteca',
      'El Jardín Botánico',
      'El Centro de Posgrado',
    ],
    respuestaCorrecta: 2,
    explicacion:
        'El Jardín Botánico "Prof. Crisóforo Pacheco" conserva más de 200 especies '
        'de plantas nativas de la Mixteca, incluyendo 45 tipos de cactáceas únicas.',
    categoria: 'Campus UTM',
    puntos: 10,
  ),
];
