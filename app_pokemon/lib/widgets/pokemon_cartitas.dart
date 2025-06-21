import 'package:flutter/material.dart';
import '../modelitos/PokemonModelitos.dart';
import '../ServiciosPaConectarseAPI/ServicioPaFire.dart';
import '../widgets/tipo_insignias.dart';
import '../Pantallitas/pokemon_detallitos_pantallita.dart';

class PokemonCartita extends StatefulWidget {
  final PokemonModelito pokemon;

  const PokemonCartita({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonCartita> createState() => _PokemonCartitaState();
}

class _PokemonCartitaState extends State<PokemonCartita> {
  bool _esFavorito = false;

  @override
  void initState() {
    super.initState();
    _verificarFavorito();
  }

  Future<void> _verificarFavorito() async {
    try {
      final existe = await ServicioPaFire().estaEnFavoritos(
        widget.pokemon.nombre,
      );
      setState(() {
        _esFavorito = existe;
      });
    } catch (e) {
      print("Error al verificar favorito: $e");
    }
  }

  Future<void> _alternarFavorito() async {
    try {
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
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.network(
                    widget.pokemon.imagenUrl,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: Icon(
                      _esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: Colors.redAccent,
                    ),
                    onPressed: _alternarFavorito,
                  ),
                ],
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
            ],
          ),
        ),
      ),
    );
  }
}
