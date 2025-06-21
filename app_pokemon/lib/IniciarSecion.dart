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
        print(' No se obtuvo el usuario de FirebaseAuth');
        return;
      }

      print(' Usuario autenticado: ${user.uid} - ${user.email}');

      final yaExiste = await ServicioPaFire().usuarioExisteEnFirestore(
        user.uid,
      );
      print(' ¿Usuario existe en Firestore? $yaExiste');

      if (yaExiste) {
        print(' Navegando a Menu');
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Menu()),
        );
      } else {
        print(' Usuario nuevo. Navegando a CompletarPerfilPantallita');
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CompletarPerfilPantallita(
              uid: user.uid,
              emailGoogle: user.email ?? '',
              fotoGoogle: user.photoURL ?? '',
            ),
          ),
        );
      }
    } catch (e) {
      print(" Error en Google Sign-In: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: 1.5, 
            child: Image.asset(
              'assets/imagenes/mapa.png',
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.high,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/imagenes/logo.png',
                    height: 150,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    '¡Bienvenido Entrenador!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Inicia sesión para comenzar tu aventura Pokemon.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.login, color: Colors.white),
                    label: const Text(
                      "Iniciar con Google",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _signInWithGoogle(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
