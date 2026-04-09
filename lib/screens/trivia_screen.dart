// lib/screens/trivia_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../data/trivia_data.dart';
import '../theme/app_theme.dart';

// ── Estados del juego ────────────────────────────────────────────────────────

enum EstadoJuego { inicio, jugando, respondida, finalizado }

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key});

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ── Estado del juego ──
  EstadoJuego _estado = EstadoJuego.inicio;
  List<PreguntaTrivia> _preguntasBarajadas = [];
  int _indicePregunta = 0;
  int _puntaje = 0;
  int _respuestasCorrectas = 0;
  int? _opcionSeleccionada;
  bool _respondioCorrectamente = false;

  // ── Temporizador (15 segundos por pregunta) ──
  static const int _tiempoTotal = 15;
  int _tiempoRestante = _tiempoTotal;
  Timer? _timer;

  // ── Getters ──
  PreguntaTrivia get _preguntaActual => _preguntasBarajadas[_indicePregunta];
  bool get _esUltimaPregunta =>
      _indicePregunta == _preguntasBarajadas.length - 1;

  // ── Ciclo de vida ────────────────────────────────────────────────────────
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Lógica del juego ─────────────────────────────────────────────────────
  void _iniciarJuego() {
    final preguntas = List<PreguntaTrivia>.from(preguntasTrivia)..shuffle();
    setState(() {
      _preguntasBarajadas = preguntas;
      _indicePregunta = 0;
      _puntaje = 0;
      _respuestasCorrectas = 0;
      _opcionSeleccionada = null;
      _estado = EstadoJuego.jugando;
      _tiempoRestante = _tiempoTotal;
    });
    _iniciarTimer();
  }

  void _iniciarTimer() {
    _timer?.cancel();
    _tiempoRestante = _tiempoTotal;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _tiempoRestante--);

      if (_tiempoRestante <= 0) {
        timer.cancel();
        // Tiempo agotado: marcar como respondida sin respuesta correcta
        setState(() {
          _estado = EstadoJuego.respondida;
          _opcionSeleccionada = -1; // ninguna seleccionada
          _respondioCorrectamente = false;
        });
      }
    });
  }

  void _responder(int opcionIndex) {
    if (_estado != EstadoJuego.jugando) return;
    _timer?.cancel();

    final esCorrecto = opcionIndex == _preguntaActual.respuestaCorrecta;
    final puntosObtenidos = esCorrecto
        ? _preguntaActual.puntos +
            (_tiempoRestante > 8 ? 5 : 0) // bonus por rapidez
        : 0;

    setState(() {
      _opcionSeleccionada = opcionIndex;
      _respondioCorrectamente = esCorrecto;
      _estado = EstadoJuego.respondida;
      if (esCorrecto) {
        _puntaje += puntosObtenidos;
        _respuestasCorrectas++;
      }
    });
  }

  void _siguientePregunta() {
    if (_esUltimaPregunta) {
      setState(() => _estado = EstadoJuego.finalizado);
      return;
    }
    setState(() {
      _indicePregunta++;
      _opcionSeleccionada = null;
      _estado = EstadoJuego.jugando;
    });
    _iniciarTimer();
  }

  void _reiniciarJuego() {
    _timer?.cancel();
    setState(() => _estado = EstadoJuego.inicio);
  }

  // ── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: switch (_estado) {
        EstadoJuego.inicio => _PantallaInicio(onIniciar: _iniciarJuego),
        EstadoJuego.jugando || EstadoJuego.respondida => _PantallaJuego(
            pregunta: _preguntaActual,
            indicePregunta: _indicePregunta,
            totalPreguntas: _preguntasBarajadas.length,
            puntaje: _puntaje,
            opcionSeleccionada: _opcionSeleccionada,
            respondioCorrectamente: _respondioCorrectamente,
            tiempoRestante: _tiempoRestante,
            estadoJuego: _estado,
            onResponder: _responder,
            onSiguiente: _siguientePregunta,
          ),
        EstadoJuego.finalizado => _PantallaResultados(
            puntaje: _puntaje,
            correctas: _respuestasCorrectas,
            totalPreguntas: _preguntasBarajadas.length,
            onReintentar: _iniciarJuego,
            onSalir: _reiniciarJuego,
          ),
      },
    );
  }
}

// ── Pantallas del juego ──────────────────────────────────────────────────────

/// Pantalla de inicio / bienvenida.
class _PantallaInicio extends StatelessWidget {
  final VoidCallback onIniciar;
  const _PantallaInicio({required this.onIniciar});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Ícono principal
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.azulPrimario.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Symbols.quiz,
                size: 52,
                color: AppColors.azulPrimario,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Trivia UTM',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '¿Cuánto sabes sobre la Universidad Tecnológica de la Mixteca y su entorno?',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Tarjetas informativas
            _InfoCard(
              icon: Symbols.help,
              titulo: '${preguntasTrivia.length} Preguntas',
              descripcion:
                  'Historia, cultura Mixteca, tecnología y datos del campus UTM.',
              color: AppColors.azulPrimario,
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Symbols.timer,
              titulo: '15 segundos',
              descripcion:
                  'Por pregunta. Responde más rápido para obtener puntos bonus.',
              color: AppColors.dorado,
            ),
            const SizedBox(height: 12),
            _InfoCard(
              icon: Symbols.emoji_events,
              titulo: 'Puntuación',
              descripcion:
                  'Cada respuesta correcta vale 10 pts. +5 pts de bonus por velocidad.',
              color: AppColors.exito,
            ),
            const SizedBox(height: 40),

            // Botón de inicio
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onIniciar,
                icon: const Icon(Symbols.play_arrow, size: 22),
                label: const Text('¡Comenzar Trivia!'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azulPrimario,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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

/// Pantalla de juego activo con pregunta, opciones y temporizador.
class _PantallaJuego extends StatelessWidget {
  final PreguntaTrivia pregunta;
  final int indicePregunta;
  final int totalPreguntas;
  final int puntaje;
  final int? opcionSeleccionada;
  final bool respondioCorrectamente;
  final int tiempoRestante;
  final EstadoJuego estadoJuego;
  final ValueChanged<int> onResponder;
  final VoidCallback onSiguiente;

  const _PantallaJuego({
    required this.pregunta,
    required this.indicePregunta,
    required this.totalPreguntas,
    required this.puntaje,
    required this.opcionSeleccionada,
    required this.respondioCorrectamente,
    required this.tiempoRestante,
    required this.estadoJuego,
    required this.onResponder,
    required this.onSiguiente,
  });

  @override
  Widget build(BuildContext context) {
    final respondida = estadoJuego == EstadoJuego.respondida;

    return SafeArea(
      child: Column(
        children: [
          // ── Header con progreso y puntaje ──
          _HeaderJuego(
            indicePregunta: indicePregunta,
            totalPreguntas: totalPreguntas,
            puntaje: puntaje,
            tiempoRestante: tiempoRestante,
            respondida: respondida,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Chip de categoría
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.azulPrimario.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '📌 ${pregunta.categoria}',
                      style: const TextStyle(
                        color: AppColors.azulPrimario,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Texto de la pregunta
                  Text(
                    pregunta.pregunta,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Opciones de respuesta
                  ...pregunta.opciones.asMap().entries.map(
                        (entry) => _OpcionRespuesta(
                          index: entry.key,
                          texto: entry.value,
                          opcionSeleccionada: opcionSeleccionada,
                          respuestaCorrecta: pregunta.respuestaCorrecta,
                          respondida: respondida,
                          onTap: onResponder,
                        ),
                      ),

                  // Panel de explicación (visible al responder)
                  if (respondida) ...[
                    const SizedBox(height: 16),
                    _ExplicacionPanel(
                      correcto: respondioCorrectamente,
                      explicacion: pregunta.explicacion,
                      tiempoAgotado: opcionSeleccionada == -1,
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Botón siguiente / continuar ──
          if (respondida)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onSiguiente,
                  icon: const Icon(Symbols.arrow_forward, size: 18),
                  label: Text(
                    indicePregunta == totalPreguntas - 1
                        ? 'Ver Resultados'
                        : 'Siguiente Pregunta',
                  ),
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
            ),
        ],
      ),
    );
  }
}

/// Header del juego con barra de progreso y temporizador.
class _HeaderJuego extends StatelessWidget {
  final int indicePregunta;
  final int totalPreguntas;
  final int puntaje;
  final int tiempoRestante;
  final bool respondida;

  const _HeaderJuego({
    required this.indicePregunta,
    required this.totalPreguntas,
    required this.puntaje,
    required this.tiempoRestante,
    required this.respondida,
  });

  Color get _colorTimer {
    if (tiempoRestante > 10) return AppColors.exito;
    if (tiempoRestante > 5) return AppColors.advertencia;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 12, 20, 16),
      color: AppColors.azulPrimario,
      child: Column(
        children: [
          Row(
            children: [
              // Progreso
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pregunta ${indicePregunta + 1} de $totalPreguntas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (indicePregunta + 1) / totalPreguntas,
                        backgroundColor: Colors.white.withAlpha(51),
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.dorado),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Puntaje
              Column(
                children: [
                  Text(
                    '$puntaje',
                    style: const TextStyle(
                      color: AppColors.dorado,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'puntos',
                    style: TextStyle(
                      color: Colors.white.withAlpha(179),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Temporizador
              if (!respondida)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _colorTimer.withAlpha(38),
                    shape: BoxShape.circle,
                    border: Border.all(color: _colorTimer, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$tiempoRestante',
                      style: TextStyle(
                        color: _colorTimer,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Botón de opción de respuesta con animación de estado.
class _OpcionRespuesta extends StatelessWidget {
  final int index;
  final String texto;
  final int? opcionSeleccionada;
  final int respuestaCorrecta;
  final bool respondida;
  final ValueChanged<int> onTap;

  const _OpcionRespuesta({
    required this.index,
    required this.texto,
    required this.opcionSeleccionada,
    required this.respuestaCorrecta,
    required this.respondida,
    required this.onTap,
  });

  _EstadoOpcion get _estado {
    if (!respondida) return _EstadoOpcion.normal;
    if (index == respuestaCorrecta) return _EstadoOpcion.correcta;
    if (index == opcionSeleccionada) return _EstadoOpcion.incorrecta;
    return _EstadoOpcion.neutral;
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final IconData? trailingIcon;

    switch (_estado) {
      case _EstadoOpcion.correcta:
        bgColor = AppColors.exito.withAlpha(26);
        borderColor = AppColors.exito;
        textColor = AppColors.exito;
        trailingIcon = Symbols.check_circle;
        break;
      case _EstadoOpcion.incorrecta:
        bgColor = AppColors.error.withAlpha(20);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        trailingIcon = Symbols.cancel;
        break;
      case _EstadoOpcion.neutral:
        bgColor = AppColors.fondo;
        borderColor = AppColors.borde;
        textColor = AppColors.textoClaro;
        trailingIcon = null;
        break;
      case _EstadoOpcion.normal:
        bgColor = Colors.white;
        borderColor = AppColors.borde;
        textColor = AppColors.textoOscuro;
        trailingIcon = null;
        break;
    }

    return GestureDetector(
      onTap: respondida ? null : () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            // Letra de opción
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: borderColor.withAlpha(31),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: borderColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, color: borderColor, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}

enum _EstadoOpcion { normal, correcta, incorrecta, neutral }

/// Panel que aparece tras responder con la explicación.
class _ExplicacionPanel extends StatelessWidget {
  final bool correcto;
  final String explicacion;
  final bool tiempoAgotado;

  const _ExplicacionPanel({
    required this.correcto,
    required this.explicacion,
    required this.tiempoAgotado,
  });

  @override
  Widget build(BuildContext context) {
    final color = tiempoAgotado
        ? AppColors.advertencia
        : correcto
            ? AppColors.exito
            : AppColors.error;
    final titulo = tiempoAgotado
        ? '⏱️ ¡Tiempo agotado!'
        : correcto
            ? '✅ ¡Correcto!'
            : '❌ ¡Casi!';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            explicacion,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.5,
                  color: AppColors.textoMedio,
                ),
          ),
        ],
      ),
    );
  }
}

/// Pantalla de resultados finales.
class _PantallaResultados extends StatelessWidget {
  final int puntaje;
  final int correctas;
  final int totalPreguntas;
  final VoidCallback onReintentar;
  final VoidCallback onSalir;

  const _PantallaResultados({
    required this.puntaje,
    required this.correctas,
    required this.totalPreguntas,
    required this.onReintentar,
    required this.onSalir,
  });

  String get _medalla {
    final pct = correctas / totalPreguntas;
    if (pct >= 0.9) return '🏆';
    if (pct >= 0.7) return '🥈';
    if (pct >= 0.5) return '🥉';
    return '📚';
  }

  String get _mensaje {
    final pct = correctas / totalPreguntas;
    if (pct >= 0.9) return '¡Extraordinario! Eres todo un experto UTM.';
    if (pct >= 0.7) return '¡Muy bien! Conoces bastante la UTM y la Mixteca.';
    if (pct >= 0.5) return 'Buen esfuerzo. Sigue explorando el campus.';
    return '¡No te rindas! Explora más el campus y vuelve a intentarlo.';
  }

  Color get _colorPuntaje {
    final pct = correctas / totalPreguntas;
    if (pct >= 0.9) return AppColors.dorado;
    if (pct >= 0.7) return AppColors.exito;
    if (pct >= 0.5) return AppColors.advertencia;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Medalla
            Text(_medalla, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 16),

            Text(
              '¡Juego terminado!',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _mensaje,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Tarjeta de puntaje principal
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _colorPuntaje.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _colorPuntaje.withAlpha(77)),
              ),
              child: Column(
                children: [
                  Text(
                    '$puntaje',
                    style: TextStyle(
                      color: _colorPuntaje,
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'puntos totales',
                    style: TextStyle(
                      color: _colorPuntaje,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Estadísticas detalladas
            Row(
              children: [
                _StatResultado(
                  valor: '$correctas/$totalPreguntas',
                  label: 'Correctas',
                  color: AppColors.exito,
                  icon: Symbols.check_circle,
                ),
                const SizedBox(width: 12),
                _StatResultado(
                  valor: '${totalPreguntas - correctas}/$totalPreguntas',
                  label: 'Incorrectas',
                  color: AppColors.error,
                  icon: Symbols.cancel,
                ),
                const SizedBox(width: 12),
                _StatResultado(
                  valor:
                      '${(correctas / totalPreguntas * 100).toStringAsFixed(0)}%',
                  label: 'Precisión',
                  color: AppColors.azulPrimario,
                  icon: Symbols.percent,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Botones
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onReintentar,
                icon: const Icon(Symbols.refresh, size: 18),
                label: const Text('Jugar de Nuevo'),
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
                onPressed: onSalir,
                icon: const Icon(Symbols.home, size: 18),
                label: const Text('Volver al Inicio'),
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
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descripcion;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.titulo,
    required this.descripcion,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borde),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  descripcion,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatResultado extends StatelessWidget {
  final String valor;
  final String label;
  final Color color;
  final IconData icon;

  const _StatResultado({
    required this.valor,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(51)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              valor,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textoClaro,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
