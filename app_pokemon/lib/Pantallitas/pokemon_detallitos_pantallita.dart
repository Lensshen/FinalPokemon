import 'package:flutter/material.dart';
import '../modelitos/PokemonModelitos.dart';
import '../widgets/tipo_insignias.dart';

class PokemonDetallitosPantallita extends StatelessWidget {
  final PokemonModelito pokemon;

  const PokemonDetallitosPantallita({Key? key, required this.pokemon})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.nombre.toUpperCase()),
        backgroundColor: Colors.deepPurple,
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
              '¡Aquí podrías mostrar más detalles como estadísticas, habilidades, evolución, etc.!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
