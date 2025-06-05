import 'package:flutter/material.dart';

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

  // Método adicional para obtener el emoji del tipo
  static String getTypeEmoji(String type) {
    const typeEmojis = {
      'normal': '⚪',
      'fire': '🔥',
      'water': '💧',
      'electric': '⚡',
      'grass': '🌿',
      'ice': '❄️',
      'fighting': '👊',
      'poison': '☠️',
      'ground': '🌍',
      'flying': '🪶',
      'psychic': '🔮',
      'bug': '🐛',
      'rock': '🪨',
      'ghost': '👻',
      'dragon': '🐉',
      'dark': '🌙',
      'steel': '⚙️',
      'fairy': '🧚',
    };
    return typeEmojis[type.toLowerCase()] ?? '❓';
  }

  // Método para verificar si un tipo es efectivo contra otro
  static double getTypeEffectiveness(String attackType, String defenseType) {
    const effectiveness = {
      'fire': {'grass': 2.0, 'ice': 2.0, 'bug': 2.0, 'steel': 2.0, 'water': 0.5, 'fire': 0.5, 'rock': 0.5, 'dragon': 0.5},
      'water': {'fire': 2.0, 'ground': 2.0, 'rock': 2.0, 'water': 0.5, 'grass': 0.5, 'dragon': 0.5},
      'electric': {'water': 2.0, 'flying': 2.0, 'electric': 0.5, 'grass': 0.5, 'dragon': 0.5, 'ground': 0.0},
      'grass': {'water': 2.0, 'ground': 2.0, 'rock': 2.0, 'fire': 0.5, 'grass': 0.5, 'poison': 0.5, 'flying': 0.5, 'bug': 0.5, 'dragon': 0.5, 'steel': 0.5},
      // Agregar más según necesites...
    };

    return effectiveness[attackType.toLowerCase()]?[defenseType.toLowerCase()] ?? 1.0;
  }
}