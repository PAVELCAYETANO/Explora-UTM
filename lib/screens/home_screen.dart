// lib/screens/home_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:latlong2/latlong.dart'; //Error de colisión con el hide Path
import 'package:latlong2/latlong.dart' hide Path;
import 'package:geolocator/geolocator.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../data/lugares_data.dart';
import '../models/lugar.dart';
import '../theme/app_theme.dart';
import '../widgets/featured_place_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  // Mantener el estado aunque el IndexedStack cambie de índice
  @override
  bool get wantKeepAlive => true;

  final MapController _mapController = MapController();

  // Estado de localización
  LatLng? _posicionUsuario;
  bool _cargandoUbicacion = false;

  // Estado de UI
  Lugar? _lugarSeleccionado;
  CategoriaLugar? _filtroActivo;

  // Lista filtrada de lugares
  List<Lugar> get _lugaresFiltrados => _filtroActivo == null
      ? lugaresUTM
      : lugaresUTM.where((l) => l.categoria == _filtroActivo).toList();

  @override
  void initState() {
    super.initState();
    _solicitarUbicacion();
  }

  //  Geolocalización :
  Future<void> _solicitarUbicacion() async {
    setState(() => _cargandoUbicacion = true);
    try {
      bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicioHabilitado) {
        _mostrarSnack('Activa el GPS para ver tu posición en el mapa.');
        return;
      }

      LocationPermission permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.deniedForever ||
          permiso == LocationPermission.denied) {
        _mostrarSnack('Permiso de ubicación denegado.');
        return;
      }

      final posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 10),
      );

      if (mounted) {
        setState(() {
          _posicionUsuario = LatLng(posicion.latitude, posicion.longitude);
        });
      }
    } catch (e) {
      if (mounted) _mostrarSnack('No se pudo obtener la ubicación.');
    } finally {
      if (mounted) setState(() => _cargandoUbicacion = false);
    }
  }

  void _centrarEnUTM() {
    _mapController.move(kCentroUTM, 17.0);
  }

  void _centrarEnUsuario() {
    if (_posicionUsuario != null) {
      _mapController.move(_posicionUsuario!, 17.0);
    } else {
      _solicitarUbicacion();
    }
  }

  void _mostrarSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.azulPrimario,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Marcadores ───────────────────────────────────────────────────────────
  List<Marker> _construirMarcadores() {
    final marcadores = <Marker>[];

    // Marcadores de lugares
    for (final lugar in _lugaresFiltrados) {
      final color = colorCategoria(lugar.categoria);
      final estaSeleccionado = _lugarSeleccionado?.id == lugar.id;

      marcadores.add(
        Marker(
          point: lugar.coordenadas,
          width: estaSeleccionado ? 48 : 38,
          height: estaSeleccionado ? 58 : 46,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _lugarSeleccionado =
                    _lugarSeleccionado?.id == lugar.id ? null : lugar;
              });
              _mapController.move(lugar.coordenadas, 17.5);
            },
            child: _PinMarcador(
              color: color,
              emoji: lugar.categoria.emoji,
              seleccionado: estaSeleccionado,
            ),
          ),
        ),
      );
    }

    // Marcador de posición del usuario
    if (_posicionUsuario != null) {
      marcadores.add(
        Marker(
          point: _posicionUsuario!,
          width: 20,
          height: 20,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.azulClaro,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.azulClaro.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return marcadores;
  }

  // ── Build ─
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          // ── Mapa principal ──
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: kCentroUTM,
              initialZoom: 16.5,
              maxZoom: 19.0,
              minZoom: 12.0,
              onTap: (_, __) => setState(() => _lugarSeleccionado = null),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'mx.utm.explora_utm',
              ),
              MarkerLayer(markers: _construirMarcadores()),
            ],
          ),

          // ── Header (AppBar) superpuesto ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _MapHeader(),
          ),

          // ── Filtros de categoría ──
          Positioned(
            top: 100 + MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: _FiltrosCategorias(
              filtroActivo: _filtroActivo,
              onFiltroChanged: (cat) => setState(() => _filtroActivo = cat),
            ),
          ),

          // ── Botones flotantes de control ──
          Positioned(
            right: 16,
            bottom: _lugarSeleccionado != null ? 280 : 100,
            child: Column(
              children: [
                _FABControl(
                  icon: Symbols.my_location,
                  onPressed: _centrarEnUsuario,
                  cargando: _cargandoUbicacion,
                  tooltip: 'Mi ubicación',
                ),
                const SizedBox(height: 8),
                _FABControl(
                  icon: Symbols.school,
                  onPressed: _centrarEnUTM,
                  tooltip: 'Centrar en UTM',
                ),
              ],
            ),
          ),

          // ── Tarjeta de lugar seleccionado ──
          if (_lugarSeleccionado != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: FeaturedPlaceCard(
                  lugar: _lugarSeleccionado!,
                  onClose: () => setState(() => _lugarSeleccionado = null),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

/// Header personalizado superpuesto sobre el mapa.
class _MapHeader extends StatelessWidget {
  const _MapHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 8, 16, 12),
      color: AppColors.azulPrimario,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Symbols.school, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ExploraUTM',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Campus Universidad Tecnológica de la Mixteca',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // Contador de lugares visibles
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.dorado,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${lugaresUTM.length} lugares',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Filtros de categoría en scroll horizontal.
class _FiltrosCategorias extends StatelessWidget {
  final CategoriaLugar? filtroActivo;
  final ValueChanged<CategoriaLugar?> onFiltroChanged;

  const _FiltrosCategorias({
    required this.filtroActivo,
    required this.onFiltroChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Opción "Todos"
          _FiltroChip(
            label: '🗺️ Todos',
            activo: filtroActivo == null,
            color: AppColors.azulPrimario,
            onTap: () => onFiltroChanged(null),
          ),
          ...CategoriaLugar.values.map(
            (cat) => _FiltroChip(
              label: '${cat.emoji} ${cat.nombre}',
              activo: filtroActivo == cat,
              color: colorCategoria(cat),
              onTap: () => onFiltroChanged(filtroActivo == cat ? null : cat),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltroChip extends StatelessWidget {
  final String label;
  final bool activo;
  final Color color;
  final VoidCallback onTap;

  const _FiltroChip({
    required this.label,
    required this.activo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: activo ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: activo ? color : AppColors.borde,
            width: activo ? 0 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: activo ? Colors.white : AppColors.textoMedio,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Botón de acción flotante de control del mapa.
class _FABControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool cargando;
  final String? tooltip;

  const _FABControl({
    required this.icon,
    required this.onPressed,
    this.cargando = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: const Color(0x20003366),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Tooltip(
          message: tooltip ?? '',
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: cargando
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.azulPrimario,
                    ),
                  )
                : Icon(icon, color: AppColors.azulPrimario, size: 22),
          ),
        ),
      ),
    );
  }
}

/// Widget visual del pin/marcador del mapa.
class _PinMarcador extends StatelessWidget {
  final Color color;
  final String emoji;
  final bool seleccionado;

  const _PinMarcador({
    required this.color,
    required this.emoji,
    required this.seleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: seleccionado ? 42 : 34,
          height: seleccionado ? 42 : 34,
          decoration: BoxDecoration(
            color: seleccionado ? color : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: seleccionado ? 0 : 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(seleccionado ? 0.5 : 0.25),
                blurRadius: seleccionado ? 12 : 6,
                spreadRadius: seleccionado ? 2 : 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: seleccionado ? 20 : 16),
            ),
          ),
        ),
        // Punta del pin
        CustomPaint(
          size: const Size(12, 8),
          painter: _PinPuntaPainter(color: seleccionado ? color : color),
        ),
      ],
    );
  }
}

class _PinPuntaPainter extends CustomPainter {
  final Color color;
  const _PinPuntaPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
