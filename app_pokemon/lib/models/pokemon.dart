
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<PokemonStat> stats;
  final List<String> abilities;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? 
                json['sprites']['front_default'] ?? '',
      types: (json['types'] as List)
          .map((type) => type['type']['name'] as String)
          .toList(),
      height: json['height'],
      weight: json['weight'],
      stats: (json['stats'] as List)
          .map((stat) => PokemonStat.fromJson(stat))
          .toList(),
      abilities: (json['abilities'] as List)
          .map((ability) => ability['ability']['name'] as String)
          .toList(),
    );
  }

  // Método para obtener el color basado en el tipo principal
  String get primaryType => types.isNotEmpty ? types.first : 'normal';
  
  // Método para capitalizar el nombre
  String get capitalizedName => 
      name[0].toUpperCase() + name.substring(1);
}

class PokemonStat {
  final String name;
  final int baseStat;
  final int effort;

  PokemonStat({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']['name'],
      baseStat: json['base_stat'],
      effort: json['effort'],
    );
  }

  // Nombre legible de la estadística
  String get displayName {
    switch (name) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Ataque';
      case 'defense':
        return 'Defensa';
      case 'special-attack':
        return 'At. Esp.';
      case 'special-defense':
        return 'Def. Esp.';
      case 'speed':
        return 'Velocidad';
      default:
        return name;
    }
  }
}

// Modelo para la lista paginada de Pokémon
class PokemonListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonBasic> results;

  PokemonListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((pokemon) => PokemonBasic.fromJson(pokemon))
          .toList(),
    );
  }
}

class PokemonBasic {
  final String name;
  final String url;

  PokemonBasic({required this.name, required this.url});

  factory PokemonBasic.fromJson(Map<String, dynamic> json) {
    return PokemonBasic(
      name: json['name'],
      url: json['url'],
    );
  }

  // Extraer el ID de la URL
  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    return int.parse(segments[segments.length - 2]);
  }
}

// ========================
// SERVICIO DE POKÉAPI
// ========================



class PokemonApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';
  static const int _defaultLimit = 20;

  // Singleton pattern
  static final PokemonApiService _instance = PokemonApiService._internal();
  factory PokemonApiService() => _instance;
  PokemonApiService._internal();

  // Cache para almacenar Pokémon ya consultados
  final Map<int, Pokemon> _pokemonCache = {};
  final Map<String, Pokemon> _pokemonNameCache = {};

  // Obtener lista paginada de Pokémon
  Future<PokemonListResponse> getPokemonList({
    int offset = 0,
    int limit = _defaultLimit,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pokemon?offset=$offset&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PokemonListResponse.fromJson(data);
      } else {
        throw Exception('Error al cargar lista de Pokémon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener Pokémon por ID
  Future<Pokemon> getPokemonById(int id) async {
    // Verificar cache primero
    if (_pokemonCache.containsKey(id)) {
      return _pokemonCache[id]!;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pokemon/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pokemon = Pokemon.fromJson(data);
        
        // Guardar en cache
        _pokemonCache[id] = pokemon;
        _pokemonNameCache[pokemon.name.toLowerCase()] = pokemon;
        
        return pokemon;
      } else {
        throw Exception('Pokémon no encontrado');
      }
    } catch (e) {
      throw Exception('Error al obtener Pokémon: $e');
    }
  }

  // Obtener Pokémon por nombre
  Future<Pokemon> getPokemonByName(String name) async {
    final lowerName = name.toLowerCase().trim();
    
    // Verificar cache primero
    if (_pokemonNameCache.containsKey(lowerName)) {
      return _pokemonNameCache[lowerName]!;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/pokemon/$lowerName'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pokemon = Pokemon.fromJson(data);
        
        // Guardar en cache
        _pokemonCache[pokemon.id] = pokemon;
        _pokemonNameCache[lowerName] = pokemon;
        
        return pokemon;
      } else {
        throw Exception('Pokémon "$name" no encontrado');
      }
    } catch (e) {
      throw Exception('Error al buscar Pokémon: $e');
    }
  }

  // Obtener múltiples Pokémon por sus IDs (útil para cargar listas)
  Future<List<Pokemon>> getMultiplePokemon(List<int> ids) async {
    final List<Pokemon> pokemonList = [];
    
    // Procesar en lotes para evitar sobrecarga
    const batchSize = 10;
    for (int i = 0; i < ids.length; i += batchSize) {
      final batch = ids.skip(i).take(batchSize);
      final futures = batch.map((id) => getPokemonById(id));
      
      try {
        final results = await Future.wait(futures);
        pokemonList.addAll(results);
      } catch (e) {
        print('Error al cargar lote de Pokémon: $e');
        // Continuar con el siguiente lote
      }
    }
    
    return pokemonList;
  }

  // Buscar Pokémon por término de búsqueda
  Future<List<Pokemon>> searchPokemon(String searchTerm) async {
    if (searchTerm.isEmpty) return [];
    
    final lowerTerm = searchTerm.toLowerCase().trim();
    
    // Si es un número, buscar por ID
    final id = int.tryParse(lowerTerm);
    if (id != null && id > 0 && id <= 1010) { // Límite actual de Pokémon
      try {
        final pokemon = await getPokemonById(id);
        return [pokemon];
      } catch (e) {
        return [];
      }
    }
    
    // Buscar por nombre exacto
    try {
      final pokemon = await getPokemonByName(lowerTerm);
      return [pokemon];
    } catch (e) {
      // Si no encuentra coincidencia exacta, buscar coincidencias parciales
      return await _searchPartialMatches(lowerTerm);
    }
  }

  // Búsqueda de coincidencias parciales (limitada)
  Future<List<Pokemon>> _searchPartialMatches(String term) async {
    final matches = <Pokemon>[];
    
    // Lista de Pokémon populares para búsqueda rápida
    final popularPokemon = [
      'pikachu', 'charizard', 'blastoise', 'venusaur', 'mewtwo',
      'mew', 'lucario', 'garchomp', 'dragonite', 'gyarados',
      'alakazam', 'gengar', 'machamp', 'golem', 'arcanine'
    ];
    
    for (final name in popularPokemon) {
      if (name.contains(term)) {
        try {
          final pokemon = await getPokemonByName(name);
          matches.add(pokemon);
          if (matches.length >= 5) break; // Limitar resultados
        } catch (e) {
          continue;
        }
      }
    }
    
    return matches;
  }

  // Obtener Pokémon aleatorio
  Future<Pokemon> getRandomPokemon() async {
    final random = DateTime.now().millisecondsSinceEpoch % 898 + 1;
    return await getPokemonById(random);
  }

  // Limpiar cache (útil para liberar memoria)
  void clearCache() {
    _pokemonCache.clear();
    _pokemonNameCache.clear();
  }

  // Obtener estadísticas del cache
  Map<String, int> getCacheStats() {
    return {
      'pokemonCached': _pokemonCache.length,
      'namesCached': _pokemonNameCache.length,
    };
  }
}





class PokemonTypeHelper {
  static const Map<String, Color> typeColors = {
    'normal': Color(0xFFA8A878),
    'fire': Color(0xFFF08030),
    'water': Color(0xFF6890F0),
    'electric': Color(0xFFF8D030),
    'grass': Color(0xFF78C850),
    'ice': Color(0xFF98D8D8),
    'fighting': Color(0xFFC03028),
    'poison': Color(0xFFA040A0),
    'ground': Color(0xFFE0C068),
    'flying': Color(0xFFA890F0),
    'psychic': Color(0xFFF85888),
    'bug': Color(0xFFA8B820),
    'rock': Color(0xFFB8A038),
    'ghost': Color(0xFF705898),
    'dragon': Color(0xFF7038F8),
    'dark': Color(0xFF705848),
    'steel': Color(0xFFB8B8D0),
    'fairy': Color(0xFFEE99AC),
  };

  static Color getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? typeColors['normal']!;
  }

  static List<Color> getGradientColors(List<String> types) {
    if (types.isEmpty) return [typeColors['normal']!, typeColors['normal']!];
    if (types.length == 1) {
      final color = getTypeColor(types[0]);
      return [color, color.withOpacity(0.7)];
    }
    return [getTypeColor(types[0]), getTypeColor(types[1])];
  }

  static String getTypeDisplayName(String type) {
    const typeNames = {
      'normal': 'Normal',
      'fire': 'Fuego',
      'water': 'Agua',
      'electric': 'Eléctrico',
      'grass': 'Planta',
      'ice': 'Hielo',
      'fighting': 'Lucha',
      'poison': 'Veneno',
      'ground': 'Tierra',
      'flying': 'Volador',
      'psychic': 'Psíquico',
      'bug': 'Bicho',
      'rock': 'Roca',
      'ghost': 'Fantasma',
      'dragon': 'Dragón',
      'dark': 'Siniestro',
      'steel': 'Acero',
      'fairy': 'Hada',
    };
    return typeNames[type.toLowerCase()] ?? type;
  }
}


