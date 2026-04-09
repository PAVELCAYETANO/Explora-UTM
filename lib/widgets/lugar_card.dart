// lib/widgets/lugar_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../models/lugar.dart';
import '../theme/app_theme.dart';
import '../screens/detail_screen.dart';

/// Tarjeta horizontal compacta para listas (Zonas, Recorridos).
class LugarCardHorizontal extends StatelessWidget {
  final Lugar lugar;
  final double? distanciaMetros;

  const LugarCardHorizontal({
    super.key,
    required this.lugar,
    this.distanciaMetros,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorCategoria(lugar.categoria);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailScreen(lugar: lugar)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borde),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A003366),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: lugar.imagenUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 100,
                  height: 100,
                  color: color.withOpacity(0.1),
                  child: Icon(Symbols.image, color: color.withOpacity(0.4)),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: color.withOpacity(0.1),
                  child:
                      Icon(Symbols.broken_image, color: color.withOpacity(0.4)),
                ),
              ),
            ),
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chip de categoría
                    _CategoriaChip(lugar: lugar, color: color),
                    const SizedBox(height: 6),
                    // Nombre
                    Text(
                      lugar.nombre,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Descripción corta
                    Text(
                      lugar.descripcionCorta,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Distancia (si aplica)
                    if (distanciaMetros != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Symbols.near_me,
                            size: 12,
                            color: AppColors.azulPrimario,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            distanciaMetros! < 1000
                                ? '${distanciaMetros!.toStringAsFixed(0)} m'
                                : '${(distanciaMetros! / 1000).toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.azulPrimario,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Flecha
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Symbols.chevron_right,
                color: AppColors.textoClaro,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta vertical para el carrusel de la pantalla Home.
class LugarCardVertical extends StatelessWidget {
  final Lugar lugar;
  final VoidCallback? onTap;

  const LugarCardVertical({super.key, required this.lugar, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = colorCategoria(lugar.categoria);

    return GestureDetector(
      onTap: onTap ??
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetailScreen(lugar: lugar)),
              ),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borde),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A003366),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: lugar.imagenUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 100,
                  color: color.withOpacity(0.1),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 100,
                  color: color.withOpacity(0.1),
                  child:
                      Icon(Symbols.broken_image, color: color.withOpacity(0.4)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CategoriaChip(lugar: lugar, color: color),
                  const SizedBox(height: 6),
                  Text(
                    lugar.nombre,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 13,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip de categoría pequeño.
class _CategoriaChip extends StatelessWidget {
  final Lugar lugar;
  final Color color;

  const _CategoriaChip({required this.lugar, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${lugar.categoria.emoji} ${lugar.categoria.nombre}',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
