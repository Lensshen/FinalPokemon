import 'package:flutter/material.dart';
import '../modelitos/PokemonModelitos.dart';
import '../ServiciosPaConectarseAPI/PokeServicio.dart';
import '../widgets/pokemon_cartitas.dart';

class PokemonClasificacionPantallita extends StatefulWidget {
  const PokemonClasificacionPantallita({Key? key}) : super(key: key);

  @override
  State<PokemonClasificacionPantallita> createState() =>
      _PokemonClasificacionPantallitaState();
}

class _PokemonClasificacionPantallitaState
    extends State<PokemonClasificacionPantallita> {
  final tipos = [
    'fire',
    'water',
    'grass',
    'electric',
    'ice',
    'dragon',
    'psychic',
    'normal',
  ];

  List<PokemonModelito> _todosDelTipo = [];
  List<PokemonModelito> _visibles = [];
  String _tipoSeleccionado = 'fire';
  bool _cargando = true;
  int _cantidadVisible = 10;

  @override
  void initState() {
    super.initState();
    _cargarPorTipo(_tipoSeleccionado);
  }

  Future<void> _cargarPorTipo(String tipo) async {
    setState(() {
      _cargando = true;
      _tipoSeleccionado = tipo;
      _cantidadVisible = 10;
      _visibles = [];
    });

    final listaCompleta = await PokeServicio().obtenerPorTipo(tipo);
    setState(() {
      _todosDelTipo = listaCompleta;
      _visibles = _todosDelTipo.take(_cantidadVisible).toList();
      _cargando = false;
    });
  }

  void _cargarMas() {
    final nuevoLimite = _cantidadVisible + 10;
    setState(() {
      _cantidadVisible = nuevoLimite;
      _visibles = _todosDelTipo.take(_cantidadVisible).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children:
                  tipos.map((tipo) {
                    final esSeleccionado = tipo == _tipoSeleccionado;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(tipo.toUpperCase()),
                        selected: esSeleccionado,
                        onSelected: (_) => _cargarPorTipo(tipo),
                      ),
                    );
                  }).toList(),
            ),
          ),
          Expanded(
            child:
                _cargando
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _visibles.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.50,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemBuilder:
                          (_, index) =>
                              PokemonCartita(pokemon: _visibles[index]),
                    ),
          ),
        ],
      ),
      floatingActionButton:
          (!_cargando && _visibles.length < _todosDelTipo.length)
              ? FloatingActionButton.small(
                onPressed: _cargarMas,
                tooltip: 'Cargar más',
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}