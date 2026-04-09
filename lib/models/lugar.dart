// lib/models/lugar.dart

import 'package:latlong2/latlong.dart';

/// Categorías disponibles para filtrar el mapa y la lista de zonas.
enum CategoriaLugar {
  academico,
  servicios,
  deportivo,
  cultural,
  naturaleza,
}

extension CategoriaLugarExtension on CategoriaLugar {
  String get nombre {
    switch (this) {
      case CategoriaLugar.academico:
        return 'Académico';
      case CategoriaLugar.servicios:
        return 'Servicios';
      case CategoriaLugar.deportivo:
        return 'Deportivo';
      case CategoriaLugar.cultural:
        return 'Cultural';
      case CategoriaLugar.naturaleza:
        return 'Naturaleza';
    }
  }

  String get emoji {
    switch (this) {
      case CategoriaLugar.academico:
        return '🏛️';
      case CategoriaLugar.servicios:
        return '🛎️';
      case CategoriaLugar.deportivo:
        return '⚽';
      case CategoriaLugar.cultural:
        return '🎭';
      case CategoriaLugar.naturaleza:
        return '🌿';
    }
  }
}

/// Dato curioso o información adicional asociada a un lugar.
class DatoCurioso {
  final String titulo;
  final String descripcion;
  final String icono; // emoji o código de símbolo

  const DatoCurioso({
    required this.titulo,
    required this.descripcion,
    required this.icono,
  });
}

/// Modelo principal de un Lugar de interés dentro del campus UTM.
class Lugar {
  final String id;
  final String nombre;
  final String descripcionCorta;
  final String descripcionLarga;
  final LatLng coordenadas;
  final String imagenUrl;
  final CategoriaLugar categoria;
  final List<DatoCurioso> datosCuriosos;
  final String? horario;
  final bool accesible; // accesibilidad para personas con discapacidad

  const Lugar({
    required this.id,
    required this.nombre,
    required this.descripcionCorta,
    required this.descripcionLarga,
    required this.coordenadas,
    required this.imagenUrl,
    required this.categoria,
    this.datosCuriosos = const [],
    this.horario,
    this.accesible = true,
  });

  /// Devuelve la distancia en metros desde unas coordenadas dadas.
  double distanciaDesde(LatLng origen) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, origen, coordenadas);
  }
}
