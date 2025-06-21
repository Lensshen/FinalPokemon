import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'IniciarSecion.dart';
import 'Menu.dart';
import 'Pantallitas/completar_perfil_pantallita.dart';
import 'ServiciosPaConectarseAPI/ServicioPaFire.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conexión de autenticación con menú',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;

            
            return FutureBuilder<bool>(
              future: ServicioPaFire().usuarioExisteEnFirestore(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError || !(snapshot.data ?? false)) {
                 
                  return CompletarPerfilPantallita(
                    uid: user.uid,
                    emailGoogle: user.email ?? '',
                    fotoGoogle: user.photoURL ?? '',
                  );
                }

              
                return const Menu();
              },
            );
          }

          return const LoginScreen(); 
        },
      ),
    );
  }
}