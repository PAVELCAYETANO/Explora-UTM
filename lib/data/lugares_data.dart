// lib/data/lugares_data.dart

import 'package:latlong2/latlong.dart';
import '../models/lugar.dart';

/// Centro del campus UTM — Huajuapan de León, Oaxaca.
const LatLng kCentroUTM = LatLng(17.8022, -97.7297);

/// Lista completa de los 10 puntos de interés del campus.
const List<Lugar> lugaresUTM = [
  Lugar(
    id: 'rectoría',
    nombre: 'Rectoría UTM',
    descripcionCorta: 'Edificio administrativo principal de la universidad.',
    descripcionLarga:
        'La Rectoría es el corazón administrativo de la Universidad Tecnológica '
        'de la Mixteca. Desde aquí se coordina la gestión académica, '
        'investigación y vinculación con la comunidad mixteca. El edificio '
        'alberga las oficinas del Rector, secretarías generales y departamentos '
        'de servicios escolares.',
    coordenadas: LatLng(17.8025, -97.7295),
    imagenUrl:
        'https://images.unsplash.com/photo-1562774053-701939374585?w=800&q=80',
    categoria: CategoriaLugar.academico,
    horario: 'Lun–Vie 8:00–18:00',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Fundación',
        descripcion:
            'La UTM fue fundada en 1990 con el objetivo de impulsar el desarrollo tecnológico de la región Mixteca.',
        icono: '📅',
      ),
      DatoCurioso(
        titulo: 'Reconocimiento',
        descripcion:
            'Está reconocida como una de las mejores universidades tecnológicas del sureste de México.',
        icono: '🏆',
      ),
    ],
  ),
  Lugar(
    id: 'biblioteca',
    nombre: 'Biblioteca Central',
    descripcionCorta:
        'Acervo bibliográfico y digital con más de 50,000 títulos.',
    descripcionLarga:
        'La Biblioteca Central "Ing. Margarito Montes Parra" es el principal '
        'repositorio de conocimiento del campus. Cuenta con sala de lectura, '
        'cubículos de estudio, acceso a bases de datos internacionales como '
        'IEEE Xplore y ScienceDirect, y una colección especializada en '
        'ingeniería y tecnología.',
    coordenadas: LatLng(17.8018, -97.7290),
    imagenUrl:
        'https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=800&q=80',
    categoria: CategoriaLugar.academico,
    horario: 'Lun–Vie 7:00–21:00 / Sáb 8:00–14:00',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Colección digital',
        descripcion:
            'Acceso a más de 15,000 libros electrónicos y revistas científicas internacionales.',
        icono: '💻',
      ),
      DatoCurioso(
        titulo: 'Cubículos',
        descripcion:
            'Dispone de 30 cubículos de estudio individual y 10 salas de trabajo en equipo.',
        icono: '📚',
      ),
    ],
  ),
  Lugar(
    id: 'auditorio',
    nombre: 'Auditorio Universitario',
    descripcionCorta: 'Espacio cultural con capacidad para 500 personas.',
    descripcionLarga:
        'El Auditorio Universitario es el principal espacio para eventos '
        'académicos, culturales y de extensión de la UTM. Cuenta con equipo '
        'audiovisual de última generación, cabinas de traducción simultánea '
        'y escenario profesional. Aquí se celebran las ceremonias de titulación, '
        'congresos nacionales e internacionales y presentaciones artísticas.',
    coordenadas: LatLng(17.8030, -97.7300),
    imagenUrl:
        'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
    categoria: CategoriaLugar.cultural,
    horario: 'Según programación',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Tecnología',
        descripcion:
            'Sistema de sonido Dolby y pantalla LED de 8 metros de diagonal.',
        icono: '🎙️',
      ),
    ],
  ),
  Lugar(
    id: 'laboratorio_computo',
    nombre: 'Laboratorio de Cómputo',
    descripcionCorta:
        'Infraestructura tecnológica de vanguardia para los estudiantes.',
    descripcionLarga:
        'El Laboratorio de Cómputo principal cuenta con 120 estaciones de trabajo '
        'con procesadores de última generación, acceso a software especializado '
        'como MATLAB, AutoCAD, y entornos de desarrollo para IA y Machine Learning. '
        'Operativo las 24 horas durante épocas de exámenes.',
    coordenadas: LatLng(17.8015, -97.7285),
    imagenUrl:
        'https://images.unsplash.com/photo-1573164713988-8665fc963095?w=800&q=80',
    categoria: CategoriaLugar.academico,
    horario: 'Lun–Vie 7:00–22:00',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Conectividad',
        descripcion:
            'Red de fibra óptica con velocidad de 10 Gbps en todo el campus.',
        icono: '🌐',
      ),
      DatoCurioso(
        titulo: 'Software',
        descripcion:
            'Licencias institucionales de más de 40 paquetes de software profesional.',
        icono: '💾',
      ),
    ],
  ),
  Lugar(
    id: 'cafeteria',
    nombre: 'Cafetería Central',
    descripcionCorta:
        'Comedor universitario con opciones nutritivas y accesibles.',
    descripcionLarga:
        'La Cafetería Central ofrece desayunos, comidas y cenas a precios '
        'accesibles para la comunidad universitaria. El menú incluye platillos '
        'tradicionales de la Mixteca, opciones vegetarianas y la tradicional '
        'tlayuda oaxaqueña. Es el punto de encuentro social más concurrido del campus.',
    coordenadas: LatLng(17.8020, -97.7305),
    imagenUrl:
        'https://images.unsplash.com/photo-1567521464027-f127ff144326?w=800&q=80',
    categoria: CategoriaLugar.servicios,
    horario: 'Lun–Vie 7:30–20:00',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Gastronomía local',
        descripcion:
            'Incluye platillos típicos de la región Mixteca como memelas, tlayudas y mole negro.',
        icono: '🌽',
      ),
    ],
  ),
  Lugar(
    id: 'cancha_futbol',
    nombre: 'Cancha de Fútbol',
    descripcionCorta: 'Cancha de pasto sintético reglamentaria.',
    descripcionLarga:
        'La cancha de fútbol del campus tiene dimensiones reglamentarias y cuenta '
        'con pasto sintético de última generación, iluminación LED para juegos '
        'nocturnos y tribunas con capacidad para 300 espectadores. Sede de los '
        'torneos interfacultades y campeonatos regionales universitarios.',
    coordenadas: LatLng(17.8010, -97.7310),
    imagenUrl:
        'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?w=800&q=80',
    categoria: CategoriaLugar.deportivo,
    horario: 'Lun–Dom 6:00–22:00',
    accesible: false,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Campeonatos',
        descripcion:
            'El equipo UTM ha ganado 5 campeonatos regionales universitarios en la última década.',
        icono: '🥇',
      ),
    ],
  ),
  Lugar(
    id: 'gimnasio',
    nombre: 'Gimnasio Universitario',
    descripcionCorta:
        'Instalaciones deportivas completas para la comunidad UTM.',
    descripcionLarga:
        'El Gimnasio Universitario cuenta con área de pesas, cardio, cancha de '
        'basquetbol, voleibol y ajedrez. Ofrece clases de acondicionamiento físico, '
        'yoga y artes marciales. Está disponible para todos los estudiantes, '
        'docentes y personal administrativo con credencial vigente.',
    coordenadas: LatLng(17.8008, -97.7295),
    imagenUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80',
    categoria: CategoriaLugar.deportivo,
    horario: 'Lun–Sáb 6:00–21:00',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Equipamiento',
        descripcion:
            'Más de 80 equipos de entrenamiento funcional renovados en 2023.',
        icono: '🏋️',
      ),
    ],
  ),
  Lugar(
    id: 'jardin_botanico',
    nombre: 'Jardín Botánico',
    descripcionCorta: 'Colección de flora endémica de la región Mixteca.',
    descripcionLarga:
        'El Jardín Botánico "Prof. Crisóforo Pacheco" es un espacio de '
        'investigación y conservación que alberga más de 200 especies de plantas '
        'endémicas de la Mixteca oaxaqueña. Incluye zona de cactáceas, plantas '
        'medicinales y árboles nativos. Es un pulmón verde del campus y escenario '
        'frecuente para sesiones de estudio al aire libre.',
    coordenadas: LatLng(17.8035, -97.7285),
    imagenUrl:
        'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800&q=80',
    categoria: CategoriaLugar.naturaleza,
    horario: 'Lun–Dom 7:00–18:00',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Biodiversidad',
        descripcion:
            'Contiene 45 especies de cactus y suculentas únicas del Valle de Huajuapan.',
        icono: '🌵',
      ),
      DatoCurioso(
        titulo: 'Investigación',
        descripcion:
            'Base de estudios etnobotánicos que han producido 12 publicaciones científicas.',
        icono: '🔬',
      ),
    ],
  ),
  Lugar(
    id: 'centro_cómputo_posgrado',
    nombre: 'Centro de Posgrado e Investigación',
    descripcionCorta:
        'Hub de investigación y programas de maestría y doctorado.',
    descripcionLarga:
        'El Centro de Posgrado alberga los programas de Maestría en Ciencias en '
        'Computación, Electrónica, Mecatrónica y el Doctorado en Ciencias. '
        'Cuenta con laboratorios especializados en Robótica, Visión Artificial '
        'e Inteligencia Artificial, y es sede del grupo de investigación GCTI.',
    coordenadas: LatLng(17.8028, -97.7278),
    imagenUrl:
        'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800&q=80',
    categoria: CategoriaLugar.academico,
    horario: 'Lun–Vie 8:00–20:00',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Proyectos',
        descripcion:
            'Más de 30 proyectos de investigación activos con financiamiento del CONACYT.',
        icono: '🤖',
      ),
    ],
  ),
  Lugar(
    id: 'museo_mixteco',
    nombre: 'Sala de Cultura Mixteca',
    descripcionCorta:
        'Espacio dedicado a la historia y tradiciones de la Mixteca.',
    descripcionLarga:
        'La Sala de Cultura Mixteca es un espacio museográfico que honra la '
        'herencia prehispánica y contemporánea de la región. Exhibe piezas '
        'arqueológicas en réplica, textiles, orfebrería y documentos históricos. '
        'Organiza talleres de lengua mixteca y actividades culturales durante '
        'el año para preservar la identidad regional.',
    coordenadas: LatLng(17.8022, -97.7270),
    imagenUrl:
        'https://images.unsplash.com/photo-1518998053901-5348d3961a04?w=800&q=80',
    categoria: CategoriaLugar.cultural,
    horario: 'Mar–Dom 9:00–17:00',
    accesible: true,
    datosCuriosos: [
      DatoCurioso(
        titulo: 'Lengua Mixteca',
        descripcion:
            'El mixteco es una familia lingüística con más de 30 variantes dialectales en Oaxaca.',
        icono: '🗣️',
      ),
      DatoCurioso(
        titulo: 'Orfebrería',
        descripcion:
            'Los mixtecos son reconocidos mundialmente por su maestría en la orfebrería prehispánica.',
        icono: '💎',
      ),
    ],
  ),
];
