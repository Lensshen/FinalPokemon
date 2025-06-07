import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modelitos/PokemonModelitos.dart';

class ServicioPaFire {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> agregarAFavoritos(PokemonModelito pokemon) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("Usuario no autenticado");

      await _db
          .collection('usuarios')
          .doc(uid)
          .collection('favoritos')
          .doc(pokemon.nombre)
          .set(pokemon.toMap());
    } catch (e) {
      print("Error al guardar favorito: $e");
      rethrow;
    }
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
}
