import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/animation.dart';
import '../modelitos/PokemonModelitos.dart';
import '../widgets/tipo_insignias.dart';
import '../ServiciosPaConectarseAPI/ServicioPaFire.dart';

class PokemonDetallitosPantallita extends StatefulWidget {
  final PokemonModelito pokemon;

  const PokemonDetallitosPantallita({Key? key, required this.pokemon})
      : super(key: key);

  @override
  State<PokemonDetallitosPantallita> createState() =>
      _PokemonDetallitosPantallitaState();
}

class _PokemonDetallitosPantallitaState
    extends State<PokemonDetallitosPantallita> with SingleTickerProviderStateMixin {
  bool _esFavorito = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verificarFavorito() async {
    final esta = await ServicioPaFire().estaEnFavoritos(widget.pokemon.nombre);
    setState(() {
      _esFavorito = esta;
    });
  }

  Future<void> _alternarFavorito() async {
    if (_esFavorito) {
      await ServicioPaFire().eliminarDeFavoritos(widget.pokemon.nombre);
    } else {
      await ServicioPaFire().agregarAFavoritos(widget.pokemon);
    }

    setState(() {
      _esFavorito = !_esFavorito;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _esFavorito ? 'Agregado a favoritos' : 'Eliminado de favoritos',
        ),
      ),
    );
  }

  Color _colorPorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'fire':
        return Colors.red.shade200;
      case 'water':
        return Colors.blue.shade200;
      case 'grass':
        return Colors.green.shade200;
      case 'electric':
        return Colors.yellow.shade200;
      case 'psychic':
        return Colors.purple.shade200;
      case 'ice':
        return Colors.cyan.shade100;
      case 'dragon':
        return Colors.indigo.shade300;
      case 'dark':
        return Colors.grey.shade800;
      case 'fairy':
        return Colors.pink.shade100;
      case 'steel':
        return Colors.blueGrey.shade300;
      case 'flying':
        return Colors.lightBlue.shade100;
      case 'bug':
        return Colors.lightGreen.shade300;
      case 'normal':
        return Colors.grey.shade300;
      case 'fighting':
        return Colors.brown.shade300;
      case 'poison':
        return Colors.deepPurpleAccent.shade100;
      case 'ground':
        return Colors.brown.shade200;
      case 'rock':
        return Colors.grey.shade600;
      case 'ghost':
        return Colors.deepPurple.shade200;
      default:
        return Colors.teal.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tipoPrincipal = widget.pokemon.tipos.isNotEmpty
        ? widget.pokemon.tipos.first
        : 'normal';

    return Scaffold(
      backgroundColor: _colorPorTipo(tipoPrincipal),
      appBar: AppBar(
        backgroundColor: _colorPorTipo(tipoPrincipal),
        title: Text(
          widget.pokemon.nombre.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _esFavorito ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: _alternarFavorito,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Image.network(widget.pokemon.imagenUrl, height: 180),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: widget.pokemon.tipos
                              .map((tipo) => TipoInsignia(tipo: tipo))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(" Altura: ${widget.pokemon.altura / 10} m",
                      style: const TextStyle(fontSize: 18)),
                  Text(" Peso: ${widget.pokemon.peso / 10} kg",
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  const Text(
                    " Estadísticas:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  ...widget.pokemon.stats.entries.map(
                    (e) => Text("${e.key.toUpperCase()}: ${e.value}",
                        style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    " Movimientos principales:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  ...widget.pokemon.movimientos
                      .take(5)
                      .map((mov) => Text("• $mov",
                          style: const TextStyle(fontSize: 16))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

