import 'package:flutter/material.dart';
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
    _cargarFavoritos();
  }

  void _cargarFavoritos() {
    _favoritos = ServicioPaFire().obtenerFavoritos();
  }

  void _refrescar() {
    setState(() {
      _cargarFavoritos();
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
        return RefreshIndicator(
          onRefresh: () async {
            _refrescar();
          },
          child: GridView.builder(
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
          ),
        );
      },
    );
  }
}
