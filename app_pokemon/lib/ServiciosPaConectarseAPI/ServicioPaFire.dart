import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modelitos/PokemonModelitos.dart';

class ServicioPaFire {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> agregarAFavoritos(PokemonModelito pokemon) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("Usuario no autenticado");

    final docRef = _db
        .collection('usuarios')
        .doc(uid)
        .collection('favoritos')
        .doc(pokemon.nombre);

    await docRef.set(pokemon.toMap());
  }

  Future<bool> estaEnFavoritos(String nombrePokemon) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    final doc =
        await _db
            .collection('usuarios')
            .doc(uid)
            .collection('favoritos')
            .doc(nombrePokemon)
            .get();

    return doc.exists;
  }

  Future<List<PokemonModelito>> obtenerFavoritos() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("Usuario no autenticado");

    final snapshot =
        await _db.collection('usuarios').doc(uid).collection('favoritos').get();

    return snapshot.docs
        .map((doc) => PokemonModelito.fromMap(doc.data()))
        .toList();
  }

  Future<void> eliminarDeFavoritos(String nombrePokemon) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("Usuario no autenticado");

    await _db
        .collection('usuarios')
        .doc(uid)
        .collection('favoritos')
        .doc(nombrePokemon)
        .delete();
  }

  Future<void> actualizarPerfilUsuario({
    required String nombre,
    String? fotoUrl,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("Usuario no autenticado");

    await _db.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'fotoUrl': fotoUrl ?? '',
    }, SetOptions(merge: true));
  }
}
