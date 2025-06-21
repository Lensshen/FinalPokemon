import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelitos/PokemonModelitos.dart';

class PokeServicio {
  final String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<PokemonModelito>> obtener({int limite = 20}) async {
    final url = Uri.parse('$_baseUrl/pokemon?limit=$limite');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al cargar la lista de Pokémon');
    }

    final data = json.decode(response.body);
    final List resultados = data['results'];

    List<PokemonModelito> pokemones = [];

    for (var item in resultados) {
      final detalle = await _obtenerDetallePokemon(item['url']);
      pokemones.add(detalle);
    }

    return pokemones;
  }

  Future<PokemonModelito> _obtenerDetallePokemon(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Error al obtener detalles del Pokémon');
    }

    final data = json.decode(response.body);

    final nombre = data['name'];
    final imagenUrl =
        data['sprites']['other']['official-artwork']['front_default'] ??
        data['sprites']['front_default'];
    final tipos =
        (data['types'] as List)
            .map((tipo) => tipo['type']['name'].toString())
            .toList();

    final peso = data['weight'];
    final altura = data['height'];

    final movimientos =
        (data['moves'] as List)
            .take(5)
            .map((m) => m['move']['name'].toString())
            .toList();

    final statsMap = <String, int>{};
    for (var stat in data['stats']) {
      final nombreStat = stat['stat']['name'];
      final valor = stat['base_stat'];
      statsMap[nombreStat] = valor;
    }

    return PokemonModelito(
      nombre: nombre,
      imagenUrl: imagenUrl,
      tipos: tipos,
      peso: peso,
      altura: altura,
      movimientos: movimientos,
      stats: statsMap,
    );
  }

  Future<PokemonModelito?> buscar(String nombre) async {
    try {
      final url = Uri.parse('$_baseUrl/pokemon/$nombre');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final nombre = data['name'];
        final imagenUrl =
            data['sprites']['other']['official-artwork']['front_default'] ??
            data['sprites']['front_default'];
        final tipos =
            (data['types'] as List)
                .map((tipo) => tipo['type']['name'].toString())
                .toList();

        final peso = data['weight'];
        final altura = data['height'];

        final movimientos =
            (data['moves'] as List)
                .take(5)
                .map((m) => m['move']['name'].toString())
                .toList();

        final statsMap = <String, int>{};
        for (var stat in data['stats']) {
          final nombreStat = stat['stat']['name'];
          final valor = stat['base_stat'];
          statsMap[nombreStat] = valor;
        }

        return PokemonModelito(
          nombre: nombre,
          imagenUrl: imagenUrl,
          tipos: tipos,
          peso: peso,
          altura: altura,
          movimientos: movimientos,
          stats: statsMap,
        );
      } else {
        return null;
      }
    } catch (e) {
      print(' Error al buscar Pokémon por nombre: $e');
      return null;
    }
  }

  Future<List<PokemonModelito>> obtenerPorTipo(String tipo) async {
    final url = Uri.parse('$_baseUrl/type/$tipo');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al obtener Pokémon por tipo');
    }

    final data = json.decode(response.body);
    final List pokemones = data['pokemon'];

    List<PokemonModelito> lista = [];

    for (var entry in pokemones) {
      final pokemonData = entry['pokemon'];
      if (pokemonData == null || pokemonData['url'] == null) continue;

      final pokemonUrl = pokemonData['url'] as String;
      try {
        final detalle = await _obtenerDetallePokemon(pokemonUrl);
        lista.add(detalle);
      } catch (e) {
        print('⚠️ Error al obtener detalles del Pokémon: $e');
        continue;
      }
    }

    return lista;
  }
}
