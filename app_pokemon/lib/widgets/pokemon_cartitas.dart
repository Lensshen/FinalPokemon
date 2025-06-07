import 'package:flutter/material.dart';
import '../modelitos/PokemonModelitos.dart';
import 'tipo_insignias.dart';

class PokemonCartita extends StatelessWidget {
  final PokemonModelito pokemon;

  const PokemonCartita({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Image.network(pokemon.imagenUrl, height: 100, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              pokemon.nombre.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children:
                  pokemon.tipos
                      .map((tipo) => TipoInsignia(tipo: tipo))
                      .toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
