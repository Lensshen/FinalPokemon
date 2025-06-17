import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Pantallitas/pokemon_listita_pantallita.dart';
import 'Pantallitas/favoritosGuardaditos_pantallita.dart';
import 'Pantallitas/perfil_pantallita.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message, {Color backgroundColor = Colors.blue}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: Colors.blue.shade100,
        colorScheme: ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.blue,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Demo Pokémon"),
          backgroundColor: Colors.yellow,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.red,
            tabs: const [
              Tab(icon: Icon(Icons.catching_pokemon), text: "Inicio"),
              Tab(icon: Icon(Icons.category), text: "Clasificación"),
              Tab(icon: Icon(Icons.favorite), text: "Favoritos"),
              Tab(icon: Icon(Icons.settings), text: "Ajustes"),
              Tab(icon: Icon(Icons.person), text: "Perfil"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                _showSnackBar(context, 'Notificaciones presionadas', backgroundColor: Colors.amber.shade700);
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.red),
                child: Text(
                  'Menú Pokémon',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.catching_pokemon, color: Colors.yellow),
                title: const Text("Inicio"),
                onTap: () {
                  _tabController.animateTo(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.category, color: Colors.orange),
                title: const Text("Clasificación"),
                onTap: () {
                  _tabController.animateTo(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text("Favoritos"),
                onTap: () {
                  _tabController.animateTo(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.blue),
                title: const Text("Ajustes"),
                onTap: () {
                  _tabController.animateTo(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.purple),
                title: const Text("Perfil"),
                onTap: () {
                  _tabController.animateTo(4);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
           
            const PokemonListitaPantallita(),

            ListView(
              padding: const EdgeInsets.all(12.0),
              children: [
                CustomCard(
                  title: 'Pokemones Hielo',
                  description: 'Favoritos de tipo Hielo',
                  onPressed: () {
                    _showSnackBar(context, 'Tarjeta Hielo presionada', backgroundColor: Colors.lightBlue);
                  },
                  icon: Icons.ac_unit,
                  iconColor: Colors.lightBlue,
                ),
                const SizedBox(height: 12.0),
                CustomCard(
                  title: 'Pokemones Fuego',
                  description: 'Favoritos de tipo Fuego',
                  onPressed: () {
                    _showSnackBar(context, 'Tarjeta Fuego presionada', backgroundColor: Colors.orange);
                  },
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                ),
                const SizedBox(height: 12.0),
                CustomCard(
                  title: 'Pokemones Agua',
                  description: 'Favoritos de tipo Agua',
                  onPressed: () {
                    _showSnackBar(context, 'Tarjeta Agua presionada', backgroundColor: Colors.blue);
                  },
                  icon: Icons.water_drop,
                  iconColor: Colors.blue,
                ),
              ],
            ),

            const FavoritosGuardaditosPantallita(),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Pantalla de Ajustes', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showSnackBar(context, 'Ajustes guardados', backgroundColor: Colors.green);
                    },
                    child: const Text('Guardar ajustes'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Cerrar sesión'),
                  ),
                ],
              ),
            ),

            
            const PerfilPantallita(),
          ],
        ),
      ),
    );
  }
}


class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;

  const CustomCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 48, color: iconColor),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6.0),
                  Text(description, style: const TextStyle(fontSize: 14.0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}