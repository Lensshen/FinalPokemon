import 'package:flutter/material.dart';
import '../ServiciosPaConectarseAPI/ServicioPaFire.dart';
import '../modelitos/usuario_modelitos.dart';
import '../menu.dart';

class CompletarPerfilPantallita extends StatefulWidget {
  final String uid;
  final String emailGoogle;
  final String fotoGoogle;

  const CompletarPerfilPantallita({
    Key? key,
    required this.uid,
    required this.emailGoogle,
    required this.fotoGoogle,
  }) : super(key: key);

  @override
  State<CompletarPerfilPantallita> createState() =>
      _CompletarPerfilPantallitaState();
}

class _CompletarPerfilPantallitaState extends State<CompletarPerfilPantallita> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _emailController = TextEditingController(text: widget.emailGoogle);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _guardarPerfil() async {
    if (_formKey.currentState!.validate()) {
      final usuario = UsuarioModelito(
        uid: widget.uid,
        nombre: _nombreController.text.trim(),
        email: _emailController.text.trim(),
        fotoUrl: widget.fotoGoogle,
      );

      await ServicioPaFire().guardarPerfilCompleto(usuario);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => Scaffold(
                appBar: AppBar(title: const Text('TEST de navegación')),
                body: const Center(child: Text('La navegación funciona')),
              ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Menu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completa tu perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (widget.fotoGoogle.isNotEmpty)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.fotoGoogle),
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de usuario',
                ),
                validator:
                    (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Ingresa tu nombre'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (value) =>
                        value == null || !value.contains('@')
                            ? 'Correo inválido'
                            : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _guardarPerfil,
                child: const Text('Guardar y continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
