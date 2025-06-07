import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ServiciosPaConectarseAPI/ServicioPaFire.dart';
import '../modelitos/PokemonModelitos.dart';
import '../widgets/pokemon_cartitas.dart';
import '../widgets/cargando_indicator.dart';

class FavoritosGuardaditosPantallita extends StatefulWidget {
  const FavoritosGuardaditosPantallita({Key? key}) : super(key: key);

  @override
  State<FavoritosGuardaditosPantallita> createState() =>
      _FavoritosGuardaditosPantallitaState();
}

class _FavoritosGuardaditosPantallitaState
    extends State<FavoritosGuardaditosPantallita> {
  late Future<List<PokemonModelito>> _favoritos;

  @override
  void initState() {
    super.initState();
    _favoritos = ServicioPaFire().obtenerFavoritos();
  }

  Future<void> _eliminar(String nombre) async {
    await ServicioPaFire().eliminarDeFavoritos(nombre);
    setState(() {
      _favoritos = ServicioPaFire().obtenerFavoritos(); // Recargar la lista
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PokemonModelito>>(
      future: _favoritos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CargandoIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tienes favoritos guardados.'));
        }

        final lista = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: lista.length,
          itemBuilder: (context, index) {
            final pokemon = lista[index];
            return Stack(
              children: [
                PokemonCartita(pokemon: pokemon),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _eliminar(pokemon.nombre),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
