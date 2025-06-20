class PokemonModelito {
  final String nombre;
  final String imagenUrl;
  final List<String> tipos;
  final int peso;
  final int altura;
  final List<String> movimientos;
  final Map<String, int> stats;

  PokemonModelito({
    required this.nombre,
    required this.imagenUrl,
    required this.tipos,
    required this.peso,
    required this.altura,
    required this.movimientos,
    required this.stats,
  });

  factory PokemonModelito.fromMap(Map<String, dynamic> map) {
    return PokemonModelito(
      nombre: map['nombre'],
      imagenUrl: map['imagenUrl'],
      tipos: List<String>.from(map['tipos']),
      peso: map['peso'],
      altura: map['altura'],
      movimientos: List<String>.from(map['movimientos']),
      stats: Map<String, int>.from(map['stats']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'imagenUrl': imagenUrl,
      'tipos': tipos,
      'peso': peso,
      'altura': altura,
      'movimientos': movimientos,
      'stats': stats,
    };
  }
}
