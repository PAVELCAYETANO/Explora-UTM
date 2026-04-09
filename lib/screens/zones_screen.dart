// lib/screens/zones_screen.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../data/lugares_data.dart';
import '../models/lugar.dart';
import '../theme/app_theme.dart';
import '../widgets/lugar_card.dart';

class ZonesScreen extends StatefulWidget {
  const ZonesScreen({super.key});

  @override
  State<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends State<ZonesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  LatLng? _posicionUsuario;
  CategoriaLugar? _categoriaActiva;
  String _textoBusqueda = '';
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    _obtenerUbicacion();
  }

  Future<void> _obtenerUbicacion() async {
    try {
      final permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 8),
      );
      if (mounted) {
        setState(() => _posicionUsuario = LatLng(pos.latitude, pos.longitude));
      }
    } catch (_) {}
  }

  List<Lugar> get _lugaresFiltrados {
    var lista = lugaresUTM.where((l) {
      final coincideCategoria =
          _categoriaActiva == null || l.categoria == _categoriaActiva;
      final coincideBusqueda = _textoBusqueda.isEmpty ||
          l.nombre.toLowerCase().contains(_textoBusqueda.toLowerCase()) ||
          l.descripcionCorta
              .toLowerCase()
              .contains(_textoBusqueda.toLowerCase());
      return coincideCategoria && coincideBusqueda;
    }).toList();

    // Ordenar por distancia si se tiene ubicación
    if (_posicionUsuario != null) {
      lista.sort(
        (a, b) => a.distanciaDesde(_posicionUsuario!).compareTo(
              b.distanciaDesde(_posicionUsuario!),
            ),
      );
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: CustomScrollView(
        slivers: [
          // ── AppBar personalizado ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppColors.azulPrimario,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Zonas del Campus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${lugaresUTM.length} lugares de interés',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              background: Container(color: AppColors.azulPrimario),
            ),
          ),

          // ── Buscador ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _BarraBusqueda(
                buscando: _buscando,
                onChanged: (v) => setState(() {
                  _textoBusqueda = v;
                  _buscando = v.isNotEmpty;
                }),
                onClear: () => setState(() {
                  _textoBusqueda = '';
                  _buscando = false;
                }),
              ),
            ),
          ),

          // ── Filtros de categoría ──
          SliverToBoxAdapter(
            child: _FiltrosCategoria(
              categoriaActiva: _categoriaActiva,
              onChanged: (cat) => setState(() => _categoriaActiva = cat),
            ),
          ),

          // ── Estadísticas rápidas ──
          if (!_buscando)
            SliverToBoxAdapter(
              child: _StatsRow(posicion: _posicionUsuario),
            ),

          // ── Lista de lugares ──
          _lugaresFiltrados.isEmpty
              ? SliverFillRemaining(
                  child: _EstadoVacio(textoBusqueda: _textoBusqueda),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  sliver: SliverList.builder(
                    itemCount: _lugaresFiltrados.length,
                    itemBuilder: (context, i) {
                      final lugar = _lugaresFiltrados[i];
                      return LugarCardHorizontal(
                        lugar: lugar,
                        distanciaMetros: _posicionUsuario != null
                            ? lugar.distanciaDesde(_posicionUsuario!)
                            : null,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _BarraBusqueda extends StatelessWidget {
  final bool buscando;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _BarraBusqueda({
    required this.buscando,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borde),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08003366),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Buscar lugares en el campus...',
          hintStyle: TextStyle(color: AppColors.textoClaro, fontSize: 14),
          prefixIcon:
              const Icon(Symbols.search, color: AppColors.textoClaro, size: 20),
          suffixIcon: buscando
              ? GestureDetector(
                  onTap: onClear,
                  child: const Icon(Symbols.close,
                      color: AppColors.textoClaro, size: 18),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _FiltrosCategoria extends StatelessWidget {
  final CategoriaLugar? categoriaActiva;
  final ValueChanged<CategoriaLugar?> onChanged;

  const _FiltrosCategoria({
    required this.categoriaActiva,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          _Chip(
            label: '📍 Todos',
            activo: categoriaActiva == null,
            color: AppColors.azulPrimario,
            onTap: () => onChanged(null),
          ),
          ...CategoriaLugar.values.map(
            (cat) => _Chip(
              label: '${cat.emoji} ${cat.nombre}',
              activo: categoriaActiva == cat,
              color: colorCategoria(cat),
              onTap: () => onChanged(categoriaActiva == cat ? null : cat),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool activo;
  final Color color;
  final VoidCallback onTap;

  const _Chip({
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
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: activo ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: activo ? color : AppColors.borde,
          ),
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

class _StatsRow extends StatelessWidget {
  final LatLng? posicion;
  const _StatsRow({required this.posicion});

  @override
  Widget build(BuildContext context) {
    // Calcular cuántos lugares hay por categoría
    final conteos = <CategoriaLugar, int>{};
    for (final cat in CategoriaLugar.values) {
      conteos[cat] = lugaresUTM.where((l) => l.categoria == cat).length;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _StatCard(
            valor: lugaresUTM.length.toString(),
            label: 'Total\nlugares',
            color: AppColors.azulPrimario,
            icon: Symbols.location_on,
          ),
          const SizedBox(width: 10),
          _StatCard(
            valor: (conteos[CategoriaLugar.academico] ?? 0).toString(),
            label: 'Espacios\nAcadémicos',
            color: AppColors.academico,
            icon: Symbols.school,
          ),
          const SizedBox(width: 10),
          _StatCard(
            valor: posicion != null ? 'Activa' : 'Inactiva',
            label: 'Ubicación\nGPS',
            color: posicion != null ? AppColors.exito : AppColors.textoClaro,
            icon: Symbols.gps_fixed,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String valor;
  final String label;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.valor,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    valor,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textoClaro,
                      fontSize: 10,
                      height: 1.3,
                    ),
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

class _EstadoVacio extends StatelessWidget {
  final String textoBusqueda;
  const _EstadoVacio({required this.textoBusqueda});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Symbols.search_off,
              size: 64,
              color: AppColors.textoClaro.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              textoBusqueda.isNotEmpty
                  ? 'Sin resultados para "$textoBusqueda"'
                  : 'No hay lugares en esta categoría',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textoClaro,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
