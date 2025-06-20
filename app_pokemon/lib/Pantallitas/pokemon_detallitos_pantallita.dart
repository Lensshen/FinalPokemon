import 'package:flutter/material.dart';
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
    extends State<PokemonDetallitosPantallita> {
  bool _esFavorito = false;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.nombre.toUpperCase()),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(widget.pokemon.imagenUrl, height: 150)),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                spacing: 8,
                children:
                    widget.pokemon.tipos
                        .map((tipo) => TipoInsignia(tipo: tipo))
                        .toList(),
              ),
            ),
            const SizedBox(height: 24),
            Text("📏 Altura: ${widget.pokemon.altura / 10} m"),
            Text("⚖️ Peso: ${widget.pokemon.peso / 10} kg"),
            const SizedBox(height: 16),
            const Text(
              "📊 Estadísticas:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...widget.pokemon.stats.entries.map(
              (e) => Text("${e.key}: ${e.value}"),
            ),
            const SizedBox(height: 16),
            const Text(
              "🎯 Movimientos principales:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...widget.pokemon.movimientos.take(5).map((mov) => Text("• $mov")),
          ],
        ),
      ),
    );
  }
}
