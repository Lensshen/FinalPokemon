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
  late Future<List<PokemonModelito>> _pokemonesFuture;
  List<PokemonModelito> _pokemones = [];
  List<PokemonModelito> _filtrados = [];

  final TextEditingController _searchController = TextEditingController();
  bool _cargandoDesdeApi = false;

  @override
  void initState() {
    super.initState();
    _cargarPokemones();
    _searchController.addListener(_filtrar);
  }

  void _cargarPokemones() {
    _pokemonesFuture = PokeServicio().obtener().then((lista) {
      _pokemones = lista;
      _filtrados = lista;
      return lista;
    });
  }

  Future<void> _filtrar() async {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _filtrados = _pokemones;
      });
      return;
    }

    final encontrados =
        _pokemones
            .where((p) => p.nombre.toLowerCase().contains(query))
            .toList();

    if (encontrados.isNotEmpty) {
      setState(() {
        _filtrados = encontrados;
      });
    } else {
      setState(() {
        _cargandoDesdeApi = true;
      });

      final pokemonApi = await PokeServicio().buscar(query);

      setState(() {
        _cargandoDesdeApi = false;
        if (pokemonApi != null) {
          _filtrados = [pokemonApi];
        } else {
          _filtrados = [];
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PokemonModelito>>(
      future: _pokemonesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CargandoIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron Pokémon.'));
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar Pokémon por nombre',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child:
                  _cargandoDesdeApi
                      ? const CargandoIndicator()
                      : _filtrados.isEmpty
                      ? const Center(child: Text('No hay coincidencias.'))
                      : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.5,
                            ),
                        itemCount: _filtrados.length,
                        itemBuilder: (context, index) {
                          return PokemonCartita(pokemon: _filtrados[index]);
                        },
                      ),
            ),
          ],
        );
      },
    );
  }
}
