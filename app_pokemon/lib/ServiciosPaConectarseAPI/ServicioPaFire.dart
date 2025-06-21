import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modelitos/PokemonModelitos.dart';
import '../modelitos/usuario_modelitos.dart';

class ServicioPaFire {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<bool> usuarioExisteEnFirestore(String uid) async {
    final doc = await _db.collection('usuarios').doc(uid).get();
    return doc.exists;
  }

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

  Future<UsuarioModelito?> obtenerPerfilUsuario() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _db.collection('usuarios').doc(uid).get();
    if (!doc.exists) return null;

    return UsuarioModelito.fromMap(doc.data()!);
  }

  Future<void> actualizarPerfilUsuario({required String nombre}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'email': _auth.currentUser?.email,
      'fotoUrl': _auth.currentUser?.photoURL,
      'uid': uid,
    }, SetOptions(merge: true));
  }

  Future<void> guardarPerfilCompleto(UsuarioModelito usuario) async {
    await _db
        .collection('usuarios')
        .doc(usuario.uid)
        .set(usuario.toMap(), SetOptions(merge: true));
  }
}
