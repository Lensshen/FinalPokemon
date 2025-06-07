import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelitos/PokemonModelitos.dart';

class PokeServicio {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<PokemonModelito>> obtenerPokemones({int limite = 20}) async {
    final url = Uri.parse('$baseUrl/pokemon?limit=$limite');
    final respuesta = await http.get(url);

    if (respuesta.statusCode != 200) {
      throw Exception('Error al obtener la lista de Pokémon');
    }

    final data = jsonDecode(respuesta.body);
    final List resultados = data['results'];

    List<PokemonModelito> listaPokemon = [];

    for (var resultado in resultados) {
      final detalleUrl = Uri.parse(resultado['url']);
      final respuestaDetalle = await http.get(detalleUrl);

      if (respuestaDetalle.statusCode == 200) {
        final detalleJson = jsonDecode(respuestaDetalle.body);
        final pokemon = PokemonModelito.fromJson(resultado, detalleJson);
        listaPokemon.add(pokemon);
      }
    }

    return listaPokemon;
  }
}
