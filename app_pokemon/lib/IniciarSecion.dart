import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigningIn = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isSigningIn = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isSigningIn = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
    } finally {
      setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Center(
        child:
            user != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bienvenido, ${user.displayName}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        setState(() {});
                      },
                      child: const Text('Cerrar Sesión'),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Inicia sesión con tu cuenta de Google'),
                    const SizedBox(height: 20),
                    _isSigningIn
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                          onPressed: _signInWithGoogle,
                          icon: const Icon(Icons.login),
                          label: const Text('Iniciar con Google'),
                        ),
                  ],
                ),
      ),
    );
  }
}
