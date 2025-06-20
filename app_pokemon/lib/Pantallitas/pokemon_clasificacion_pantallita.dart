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

  List<PokemonModelito> _lista = [];
  String _tipoSeleccionado = 'fire';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPorTipo(_tipoSeleccionado);
  }

  Future<void> _cargarPorTipo(String tipo) async {
    setState(() {
      _cargando = true;
      _tipoSeleccionado = tipo;
    });
    final pokes = await PokeServicio().obtenerPorTipo(tipo);
    setState(() {
      _lista = pokes;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    itemCount: _lista.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.50,
                          mainAxisSpacing: 7,
                          crossAxisSpacing: 7,
                        ),
                    itemBuilder:
                        (_, index) => PokemonCartita(pokemon: _lista[index]),
                  ),
        ),
      ],
    );
  }
}
