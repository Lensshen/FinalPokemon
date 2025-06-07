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
    final pokemon = widget.pokemon;

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.nombre.toUpperCase()),
        backgroundColor: Colors.deepPurple,
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(pokemon.imagenUrl, height: 150),
            const SizedBox(height: 24),
            Text(
              pokemon.nombre.toUpperCase(),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children:
                  pokemon.tipos
                      .map((tipo) => TipoInsignia(tipo: tipo))
                      .toList(),
            ),
            const SizedBox(height: 30),
            const Text(
              'Aquí podrías mostrar más detalles como habilidades, estadísticas, evolución, etc.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
