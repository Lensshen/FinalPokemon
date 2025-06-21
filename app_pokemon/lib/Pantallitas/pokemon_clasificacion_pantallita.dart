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

  Widget _buildStatBar(String label, int value, {int max = 150}) {
    final double porcentaje = (value / max).clamp(0.0, 1.0);
    Color color;
    if (value >= 120) {
      color = Colors.green.shade600;
    } else if (value >= 80) {
      color = Colors.lightGreen;
    } else if (value >= 50) {
      color = Colors.amber;
    } else {
      color = Colors.redAccent;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: porcentaje,
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('$value'),
        ],
      ),
    );
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
                      itemBuilder: (_, index) {
                        final pokemon = _visibles[index];
                        return PokemonCartita(pokemon: pokemon);
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton:
          (!_cargando && _visibles.length < _todosDelTipo.length)
              ? FloatingActionButton.small(
                onPressed: _cargarMas,
                tooltip: 'Cargar mas',
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
