import 'package:flutter/material.dart';

class TipoInsignia extends StatelessWidget {
  final String tipo;

  const TipoInsignia({Key? key, required this.tipo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: _colorPorTipo(tipo).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tipo.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _colorPorTipo(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      case 'psychic':
        return Colors.purple;
      case 'ice':
        return Colors.cyan;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black87;
      case 'fairy':
        return Colors.pinkAccent;
      case 'steel':
        return Colors.blueGrey;
      case 'flying':
        return Colors.lightBlue;
      case 'bug':
        return Colors.lightGreen;
      case 'normal':
        return Colors.grey;
      case 'fighting':
        return Colors.brown;
      case 'poison':
        return Colors.deepPurpleAccent;
      case 'ground':
        return Colors.brown.shade300;
      case 'rock':
        return Colors.grey.shade700;
      case 'ghost':
        return Colors.deepPurple;
      default:
        return Colors.teal;
    }
  }
}
