class PokemonModelito {
  final String nombre;
  final String imagenUrl;
  final List<String> tipos;

  PokemonModelito({
    required this.nombre,
    required this.imagenUrl,
    required this.tipos,
  });

  factory PokemonModelito.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> detalles,
  ) {
    final nombre = json['name'];
    final imagen = detalles['sprites']['front_default'];
    final tipos =
        (detalles['types'] as List)
            .map((tipo) => tipo['type']['name'].toString())
            .toList();

    return PokemonModelito(nombre: nombre, imagenUrl: imagen, tipos: tipos);
  }

  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'imagenUrl': imagenUrl, 'tipos': tipos};
  }

  factory PokemonModelito.fromMap(Map<String, dynamic> map) {
    return PokemonModelito(
      nombre: map['nombre'],
      imagenUrl: map['imagenUrl'],
      tipos: List<String>.from(map['tipos']),
    );
  }
}
