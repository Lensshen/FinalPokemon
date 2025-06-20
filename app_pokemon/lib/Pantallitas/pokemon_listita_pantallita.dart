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
  final _pokeServicio = PokeServicio();
  final TextEditingController _searchController = TextEditingController();

  List<PokemonModelito> _pokemones = [];
  List<PokemonModelito> _filtrados = [];
  int _limite = 10;
  bool _cargando = true;
  bool _cargandoDesdeApi = false;

  @override
  void initState() {
    super.initState();
    _cargarPokemones();
    _searchController.addListener(_filtrar);
  }

  Future<void> _cargarPokemones() async {
    setState(() => _cargando = true);
    final nuevos = await _pokeServicio.obtener(limite: _limite);
    setState(() {
      _pokemones = nuevos;
      _filtrados = nuevos;
      _cargando = false;
    });
  }

  void _cargarMas() {
    setState(() {
      _limite += 10;
    });
    _cargarPokemones();
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
      setState(() => _cargandoDesdeApi = true);

      final pokemonApi = await _pokeServicio.buscar(query);

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
    return Scaffold(
      body:
          _cargando
              ? const CargandoIndicator()
              : Column(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.5,
                                  ),
                              itemCount: _filtrados.length,
                              itemBuilder: (context, index) {
                                return PokemonCartita(
                                  pokemon: _filtrados[index],
                                );
                              },
                            ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: _cargarMas,
        tooltip: 'Cargar más Pokémon',
        child: const Icon(Icons.add),
      ),
    );
  }
}
