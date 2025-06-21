class UsuarioModelito {
  final String uid;
  final String? nombre;
  final String? email;
  final String? fotoUrl;

  UsuarioModelito({required this.uid, this.nombre, this.email, this.fotoUrl});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'nombre': nombre, 'email': email, 'fotoUrl': fotoUrl};
  }

  factory UsuarioModelito.fromMap(Map<String, dynamic> map) {
    return UsuarioModelito(
      uid: map['uid'] ?? '',
      nombre: map['nombre'],
      email: map['email'],
      fotoUrl: map['fotoUrl'],
    );
  }
}
