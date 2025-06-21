import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'menu.dart';
import 'Pantallitas/completar_perfil_pantallita.dart';
import 'ServiciosPaConectarseAPI/ServicioPaFire.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await FirebaseAuth.instance.signInWithPopup(
          googleProvider,
        );
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }

      final user = userCredential.user;
      if (user == null) {
        print('❌ No se obtuvo el usuario de FirebaseAuth');
        return;
      }

      print('✅ Usuario autenticado: ${user.uid} - ${user.email}');

      // Verificar en Firestore
      final yaExiste = await ServicioPaFire().usuarioExisteEnFirestore(
        user.uid,
      );
      print('📦 ¿Usuario existe en Firestore? $yaExiste');

      if (yaExiste) {
        print('➡️ Navegando a Menu');
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Menu()),
        );
      } else {
        print('📝 Usuario nuevo. Navegando a CompletarPerfilPantallita');
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => CompletarPerfilPantallita(
                  uid: user.uid,
                  emailGoogle: user.email ?? '',
                  fotoGoogle: user.photoURL ?? '',
                ),
          ),
        );
      }
    } catch (e) {
      print("🛑 Error en Google Sign-In: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 114, 235),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Iniciar Sesión',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text('Inicia sesión con tu cuenta de Google'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Iniciar con Google"),
                onPressed: () => _signInWithGoogle(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 130, 243, 168),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
