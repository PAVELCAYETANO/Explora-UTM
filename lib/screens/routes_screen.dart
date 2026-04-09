// lib/screens/routes_screen.dart

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../data/lugares_data.dart';
import '../models/lugar.dart';
import '../theme/app_theme.dart';
import '../widgets/lugar_card.dart';
import 'detail_screen.dart';

/// Modelo de un recorrido sugerido.
class RecorridoSugerido {
  final String id;
  final String nombre;
  final String descripcion;
  final String duracion; // Ej. "45 min"
  final String distancia; // Ej. "1.2 km"
  final String dificultad; // "Fácil", "Moderado", "Activo"
  final Color color;
  final IconData icono;
  final List<String> lugarIds; // IDs de lugares en orden

  const RecorridoSugerido({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.duracion,
    required this.distancia,
    required this.dificultad,
    required this.color,
    required this.icono,
    required this.lugarIds,
  });

  List<Lugar> get lugares =>
      lugarIds.map((id) => lugaresUTM.firstWhere((l) => l.id == id)).toList();
}

/// Recorridos predefinidos del campus UTM.
final List<RecorridoSugerido> recorridosUTM = [
  RecorridoSugerido(
    id: 'bienvenida',
    nombre: 'Recorrido de Bienvenida',
    descripcion:
        'El tour esencial para estudiantes de nuevo ingreso. Conoce los '
        'edificios principales, servicios y espacios que usarás cada día.',
    duracion: '30 min',
    distancia: '0.8 km',
    dificultad: 'Fácil',
    color: AppColors.azulPrimario,
    icono: Symbols.waving_hand,
    lugarIds: ['rectoría', 'biblioteca', 'cafeteria', 'laboratorio_computo'],
  ),
  RecorridoSugerido(
    id: 'academico',
    nombre: 'Ruta Académica',
    descripcion:
        'Explora todos los espacios de aprendizaje e investigación del campus. '
        'Ideal para conocer los recursos académicos disponibles.',
    duracion: '45 min',
    distancia: '1.1 km',
    dificultad: 'Fácil',
    color: AppColors.academico,
    icono: Symbols.school,
    lugarIds: [
      'biblioteca',
      'laboratorio_computo',
      'centro_cómputo_posgrado',
      'rectoría'
    ],
  ),
  RecorridoSugerido(
    id: 'cultural',
    nombre: 'Ruta Cultural Mixteca',
    descripcion:
        'Un recorrido para conectar con las raíces culturales de la región '
        'Mixteca a través de los espacios culturales y naturales del campus.',
    duracion: '50 min',
    distancia: '1.4 km',
    dificultad: 'Moderado',
    color: AppColors.cultural,
    icono: Symbols.palette,
    lugarIds: ['museo_mixteco', 'auditorio', 'jardin_botanico'],
  ),
  RecorridoSugerido(
    id: 'deportivo',
    nombre: 'Circuito Deportivo',
    descripcion:
        'Conoce todas las instalaciones deportivas y recreativas del campus. '
        'Perfecto para planear tu rutina de entrenamiento semanal.',
    duracion: '25 min',
    distancia: '0.9 km',
    dificultad: 'Activo',
    color: AppColors.deportivo,
    icono: Symbols.sports_soccer,
    lugarIds: ['gimnasio', 'cancha_futbol'],
  ),
  RecorridoSugerido(
    id: 'completo',
    nombre: 'Tour Completo UTM',
    descripcion: 'El recorrido definitivo por todos los rincones del campus. '
        'Recomendado para visitantes y para quienes quieran explorarlo todo.',
    duracion: '90 min',
    distancia: '2.5 km',
    dificultad: 'Moderado',
    color: AppColors.dorado,
    icono: Symbols.explore,
    lugarIds: [
      'rectoría',
      'biblioteca',
      'auditorio',
      'laboratorio_computo',
      'cafeteria',
      'museo_mixteco',
      'jardin_botanico',
      'centro_cómputo_posgrado',
      'gimnasio',
      'cancha_futbol',
    ],
  ),
];

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? _recorridoExpandido;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: AppColors.azulPrimario,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recorridos Sugeridos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Descubre el campus con rutas guiadas',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.azulPrimario),
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Opacity(
                      opacity: 0.08,
                      child: Icon(
                        Symbols.route,
                        size: 140,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Banner informativo ──
          SliverToBoxAdapter(
            child: _BannerInfo(),
          ),

          // ── Lista de recorridos ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList.builder(
              itemCount: recorridosUTM.length,
              itemBuilder: (context, i) => _RecorridoCard(
                recorrido: recorridosUTM[i],
                expandido: _recorridoExpandido == i,
                onToggle: () => setState(() {
                  _recorridoExpandido = _recorridoExpandido == i ? null : i;
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _BannerInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dorado.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dorado.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(Symbols.info, color: AppColors.doradoOscuro, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Selecciona un recorrido y toca "Iniciar" para ver las paradas en el mapa.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.doradoOscuro,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecorridoCard extends StatelessWidget {
  final RecorridoSugerido recorrido;
  final bool expandido;
  final VoidCallback onToggle;

  const _RecorridoCard({
    required this.recorrido,
    required this.expandido,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: expandido ? recorrido.color : AppColors.borde,
          width: expandido ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: expandido
                ? recorrido.color.withOpacity(0.12)
                : const Color(0x08003366),
            blurRadius: expandido ? 12 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Encabezado del recorrido ──
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Ícono del recorrido
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: recorrido.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(recorrido.icono, color: recorrido.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  // Texto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recorrido.nombre,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        // Métricas
                        Row(
                          children: [
                            _MetricaBadge(
                              icon: Symbols.schedule,
                              texto: recorrido.duracion,
                              color: AppColors.textoClaro,
                            ),
                            const SizedBox(width: 8),
                            _MetricaBadge(
                              icon: Symbols.route,
                              texto: recorrido.distancia,
                              color: AppColors.textoClaro,
                            ),
                            const SizedBox(width: 8),
                            _DificultadBadge(dificultad: recorrido.dificultad),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Flecha de expansión
                  AnimatedRotation(
                    turns: expandido ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Symbols.keyboard_arrow_down,
                      color: AppColors.textoClaro,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Contenido expandible ──
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _RecorridoDetalle(recorrido: recorrido),
            crossFadeState: expandido
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _RecorridoDetalle extends StatelessWidget {
  final RecorridoSugerido recorrido;

  const _RecorridoDetalle({required this.recorrido});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppColors.borde),
          const SizedBox(height: 12),

          // Descripción
          Text(
            recorrido.descripcion,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          const SizedBox(height: 16),

          // Paradas del recorrido
          Text(
            'Paradas del recorrido (${recorrido.lugares.length})',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: recorrido.color),
          ),
          const SizedBox(height: 10),

          // Lista de paradas con línea de tiempo
          ...recorrido.lugares.asMap().entries.map(
                (entry) => _Parada(
                  numero: entry.key + 1,
                  lugar: entry.value,
                  esUltima: entry.key == recorrido.lugares.length - 1,
                  colorRuta: recorrido.color,
                ),
              ),

          const SizedBox(height: 12),

          // Botón de inicio
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '¡Recorrido "${recorrido.nombre}" iniciado en el mapa!'),
                    backgroundColor: recorrido.color,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              icon: const Icon(Symbols.play_arrow, size: 18),
              label: const Text('Iniciar Recorrido'),
              style: ElevatedButton.styleFrom(
                backgroundColor: recorrido.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Parada en la línea de tiempo del recorrido.
class _Parada extends StatelessWidget {
  final int numero;
  final Lugar lugar;
  final bool esUltima;
  final Color colorRuta;

  const _Parada({
    required this.numero,
    required this.lugar,
    required this.esUltima,
    required this.colorRuta,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(lugar: lugar)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Línea de tiempo
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: colorRuta,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$numero',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (!esUltima)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: colorRuta.withOpacity(0.25),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Contenido de la parada
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: esUltima ? 0 : 12),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.fondo,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borde),
                  ),
                  child: Row(
                    children: [
                      Text(
                        lugar.categoria.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lugar.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              lugar.descripcionCorta,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Symbols.chevron_right,
                        size: 16,
                        color: AppColors.textoClaro,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricaBadge extends StatelessWidget {
  final IconData icon;
  final String texto;
  final Color color;

  const _MetricaBadge({
    required this.icon,
    required this.texto,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 2),
        Text(
          texto,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DificultadBadge extends StatelessWidget {
  final String dificultad;

  const _DificultadBadge({required this.dificultad});

  Color get _color {
    switch (dificultad) {
      case 'Fácil':
        return AppColors.exito;
      case 'Moderado':
        return AppColors.advertencia;
      case 'Activo':
        return AppColors.dorado;
      default:
        return AppColors.textoClaro;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        dificultad,
        style: TextStyle(
          fontSize: 10,
          color: _color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
