// lib/widgets/featured_place_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../models/lugar.dart';
import '../theme/app_theme.dart';
import '../screens/detail_screen.dart';

/// Tarjeta emergente de "Lugar Destacado" que aparece en la parte inferior
/// del mapa al tocar un marcador.
class FeaturedPlaceCard extends StatelessWidget {
  final Lugar lugar;
  final VoidCallback onClose;

  const FeaturedPlaceCard({
    super.key,
    required this.lugar,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorCategoria(lugar.categoria);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borde),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20003366),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Imagen con overlay de gradiente sólido (sin blur)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: lugar.imagenUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 140,
                    color: color.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color,
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 140,
                    color: color.withOpacity(0.2),
                    child: Icon(Symbols.image_not_supported,
                        color: color, size: 32),
                  ),
                ),
              ),
              // Gradiente sólido sobre la imagen (NO glassmorphism)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.55),
                      ],
                    ),
                  ),
                ),
              ),
              // Chip de categoría sobre la imagen
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${lugar.categoria.emoji} ${lugar.categoria.nombre}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // Botón cerrar
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Symbols.close,
                      size: 16,
                      color: AppColors.textoOscuro,
                    ),
                  ),
                ),
              ),
              // Nombre sobre la imagen
              Positioned(
                bottom: 10,
                left: 12,
                right: 12,
                child: Text(
                  lugar.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Cuerpo de la tarjeta
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lugar.descripcionCorta,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // Horario (si existe)
                if (lugar.horario != null) ...[
                  Row(
                    children: [
                      Icon(
                        Symbols.schedule,
                        size: 14,
                        color: AppColors.textoClaro,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lugar.horario!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const Spacer(),
                      // Icono accesibilidad
                      if (lugar.accesible)
                        Icon(
                          Symbols.accessible,
                          size: 16,
                          color: AppColors.exito,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                // Botón ver detalle
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(lugar: lugar),
                      ),
                    ),
                    icon: const Icon(Symbols.arrow_forward, size: 18),
                    label: const Text('Ver más detalles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azulPrimario,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
