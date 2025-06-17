import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ServiciosPaConectarseAPI/ServicioPaFire.dart';
import '../modelitos/usuario_modelitos.dart';
import '../widgets/cargando_indicator.dart';

class PerfilPantallita extends StatefulWidget {
  const PerfilPantallita({Key? key}) : super(key: key);

  @override
  State<PerfilPantallita> createState() => _PerfilPantallitaState();
}

class _PerfilPantallitaState extends State<PerfilPantallita> {
  final _formKey = GlobalKey<FormState>();
  String? _nombre;
  UsuarioModelito? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final perfil = await ServicioPaFire().obtenerPerfilUsuario();
    setState(() {
      _usuario = perfil;
      _nombre = perfil?.nombre;
    });
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      await ServicioPaFire().actualizarPerfilUsuario(nombre: _nombre!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Perfil actualizado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_usuario == null) {
      return const CargandoIndicator();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_usuario?.fotoUrl != null)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(_usuario!.fotoUrl!),
                ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
                onChanged: (value) => _nombre = value,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'El nombre no puede estar vacío'
                            : null,
              ),
              const SizedBox(height: 20),
              Text('Email: ${_usuario?.email ?? "no disponible"}'),
              const Spacer(),
              ElevatedButton(
                onPressed: _guardar,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
