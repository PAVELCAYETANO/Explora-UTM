// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../models/lugar.dart';
import '../theme/app_theme.dart';

/// Pantalla de detalle de un lugar. Accesible desde el mapa,
/// la lista de zonas y los recorridos.
class DetailScreen extends StatelessWidget {
  final Lugar lugar;

  const DetailScreen({super.key, required this.lugar});

  @override
  Widget build(BuildContext context) {
    final color = colorCategoria(lugar.categoria);

    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: CustomScrollView(
        slivers: [
          // ── App bar con imagen ──
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.azulPrimario,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Symbols.arrow_back, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                lugar.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: lugar.imagenUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: color.withOpacity(0.3)),
                    errorWidget: (_, __, ___) =>
                        Container(color: color.withOpacity(0.3)),
                  ),
                  // Gradiente sólido — sin blur
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.65),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Contenido ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chips de categoría y accesibilidad
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${lugar.categoria.emoji} ${lugar.categoria.nombre}',
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (lugar.accesible) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.exito.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Symbols.accessible,
                                  size: 12, color: AppColors.exito),
                              const SizedBox(width: 4),
                              Text(
                                'Accesible',
                                style: TextStyle(
                                  color: AppColors.exito,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nombre completo
                  Text(
                    lugar.nombre,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),

                  // Horario
                  if (lugar.horario != null)
                    _InfoRow(
                      icon: Symbols.schedule,
                      texto: lugar.horario!,
                    ),
                  const SizedBox(height: 4),

                  // Coordenadas
                  _InfoRow(
                    icon: Symbols.location_on,
                    texto:
                        '${lugar.coordenadas.latitude.toStringAsFixed(4)}°N, '
                        '${lugar.coordenadas.longitude.toStringAsFixed(4)}°O',
                  ),

                  const SizedBox(height: 20),

                  // Descripción larga
                  _Seccion(titulo: 'Descripción'),
                  const SizedBox(height: 8),
                  Text(
                    lugar.descripcionLarga,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),

                  // Datos curiosos
                  if (lugar.datosCuriosos.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _Seccion(titulo: '¿Sabías que...?'),
                    const SizedBox(height: 12),
                    ...lugar.datosCuriosos.map(
                      (dato) => _DatoCuriosoCard(dato: dato),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Botón de acción principal
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Symbols.directions, size: 18),
                      label: const Text('Cómo llegar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.azulPrimario,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Symbols.share, size: 18),
                      label: const Text('Compartir lugar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.azulPrimario,
                        side: const BorderSide(color: AppColors.azulPrimario),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String texto;

  const _InfoRow({required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textoClaro),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            texto,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  const _Seccion({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.dorado,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(titulo, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _DatoCuriosoCard extends StatelessWidget {
  final DatoCurioso dato;
  const _DatoCuriosoCard({required this.dato});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.azulPrimario.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.azulPrimario.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dato.icono, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dato.titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.azulPrimario,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  dato.descripcion,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
