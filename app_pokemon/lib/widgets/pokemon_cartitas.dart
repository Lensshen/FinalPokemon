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
            mainAxisSize:
                MainAxisSize.min, // IMPORTANTE: Esto evita que se expanda
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Usar Flexible para la imagen
              Flexible(
                flex: 3, // Dale más espacio a la imagen
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight: 140, // Máximo 140px de altura
                      ),
                      child: Image.network(
                        widget.pokemon.imagenUrl,
                        fit: BoxFit.contain, // Cambiado de cover a contain
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            child: Icon(
                              Icons.catching_pokemon,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: IconButton(
                        icon: Icon(
                          _esFavorito ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                          size: 20, // Icono más pequeño
                        ),
                        onPressed: _alternarFavorito,
                        padding: EdgeInsets.all(4), // Menos padding
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6), // Menos espacio
              // Usar Flexible para el texto del nombre
              Flexible(
                child: Text(
                  widget.pokemon.nombre.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12, // Texto más pequeño
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Máximo 2 líneas
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              // Usar Flexible para los badges de tipos
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        widget.pokemon.tipos
                            .map(
                              (tipo) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                child: TipoInsignia(tipo: tipo),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
