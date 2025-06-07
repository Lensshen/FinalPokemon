import 'package:flutter/material.dart';
import '../modelitos/PokemonModelitos.dart';
import '../widgets/tipo_insignias.dart';
import '../Pantallitas/pokemon_detallitos_pantallita.dart';
import '../ServiciosPaConectarseAPI/ServicioPaFire.dart';

class PokemonCartita extends StatefulWidget {
  final PokemonModelito pokemon;

  const PokemonCartita({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonCartita> createState() => _PokemonCartitaState();
}

class _PokemonCartitaState extends State<PokemonCartita> {
  bool _yaEsFavorito = false;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

  Future<void> _verificarFavorito() async {
    final existe = await ServicioPaFire().estaEnFavoritos(
      widget.pokemon.nombre,
    );
    setState(() {
      _yaEsFavorito = existe;
    });
  }

  Future<void> _agregarAFavoritos() async {
    try {
      await ServicioPaFire().agregarAFavoritos(widget.pokemon);
      setState(() {
        _yaEsFavorito = true;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Agregado a favoritos')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      PokemonDetallitosPantallita(pokemon: widget.pokemon),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.network(
                widget.pokemon.imagenUrl,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                widget.pokemon.nombre.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children:
                    widget.pokemon.tipos
                        .map((tipo) => TipoInsignia(tipo: tipo))
                        .toList(),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: Icon(
                  _yaEsFavorito ? Icons.check_circle : Icons.favorite_border,
                ),
                label: Text(_yaEsFavorito ? "Ya en favoritos" : "Favorito"),
                onPressed: _yaEsFavorito ? null : _agregarAFavoritos,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _yaEsFavorito ? Colors.grey : Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(36),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
