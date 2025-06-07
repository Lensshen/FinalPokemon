import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Pantallitas/pokemon_listita_pantallita.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> favoritos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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


  void agregarQuitarFavorito(String pokemon) {
    setState(() {
      if (favoritos.contains(pokemon)) {
        favoritos.remove(pokemon);
        _showSnackBar(context, "$pokemon eliminado de favoritos", backgroundColor: Colors.red);
      } else {
        favoritos.add(pokemon);
        _showSnackBar(context, "$pokemon agregado a favoritos", backgroundColor: Colors.green);
      }
    });
  }

  void mostrarFavoritos(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: favoritos.isEmpty
              ? const Center(child: Text("No hay Pokémon favoritos", style: TextStyle(fontSize: 18)))
              : ListView(
                  children: favoritos.map((pokemon) {
                    return ListTile(
                      title: Text(pokemon, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          agregarQuitarFavorito(pokemon);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }).toList(),
                ),
        );
      },
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
            tabs: const [
              Tab(icon: Icon(Icons.home), text: "Inicio"),
              Tab(icon: Icon(Icons.favorite), text: "Favoritos"),
              Tab(icon: Icon(Icons.settings), text: "Ajustes"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                _showSnackBar(context, 'Notificaciones presionadas', backgroundColor: Colors.yellow.shade700);
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
                leading: const Icon(Icons.home, color: Colors.yellow),
                title: const Text("Inicio"),
                onTap: () {
                  _tabController.animateTo(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: const Text("Favoritos"),
                onTap: () {
                  _tabController.animateTo(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.blue),
                title: const Text("Ajustes"),
                onTap: () {
                  _tabController.animateTo(2);
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
              padding: const EdgeInsets.all(16.0),
              children: [
                CustomCard(
                  title: 'Pokémon Eléctrico',
                  description: 'Favoritos de tipo eléctrico',
                  onPressed: () {
                    agregarQuitarFavorito('Pokémon Eléctrico');
                  },
                  icon: Icons.bolt,
                  iconColor: Colors.yellow.shade600,
                  backgroundColor: Colors.yellow.shade300,
                ),
                const SizedBox(height: 16.0),
                CustomCard(
                  title: 'Pokémon Fuego',
                  description: 'Favoritos de tipo fuego',
                  onPressed: () {
                    agregarQuitarFavorito('Pokémon Fuego');
                  },
                  icon: Icons.local_fire_department,
                  iconColor: Colors.red.shade600,
                  backgroundColor: Colors.red.shade300,
                ),
                const SizedBox(height: 16.0),
                CustomCard(
                  title: 'Pokémon Agua',
                  description: 'Favoritos de tipo agua',
                  onPressed: () {
                    agregarQuitarFavorito('Pokémon Agua');
                  },
                  icon: Icons.water_drop,
                  iconColor: Colors.blue.shade600,
                  backgroundColor: Colors.blue.shade300,
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pantalla de Ajustes',
                    style: TextStyle(fontSize: 24),
                  ),
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            mostrarFavoritos(context);
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.favorite, color: Colors.white),
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
  final Color backgroundColor;

  const CustomCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              color: backgroundColor,
              alignment: Alignment.center,
              child: Icon(icon, size: 60, color: iconColor),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}