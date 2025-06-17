import 'package:flutter/material.dart';
import '../ServiciosPaConectarseAPI/PokeServicio.dart';
import '../modelitos/PokemonModelitos.dart';
import '../widgets/pokemon_cartitas.dart';
import '../widgets/cargando_indicator.dart';

class PokemonListitaPantallita extends StatefulWidget {
  const PokemonListitaPantallita({Key? key}) : super(key: key);

  @override
  State<PokemonListitaPantallita> createState() =>
      _PokemonListitaPantallitaState();
}

class _PokemonListitaPantallitaState extends State<PokemonListitaPantallita> {
  late Future<List<PokemonModelito>> _pokemones;

  @override
  void initState() {
    super.initState();
    _pokemones = PokeServicio().obtenerPokemones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PokemonModelito>>(
        future: _pokemones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CargandoIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron Pokémon.'));
          } else {
            final lista = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return PokemonCartita(pokemon: lista[index]);
              },
            );
          }
        },
      ),
    );
  }
}
