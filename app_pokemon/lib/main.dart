import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Mi Primera App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.blue,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo de Flutter"),
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
              _showSnackBar(context, 'Notificaciones han sido presionadas');
            },
          ),
        ],
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          // Primer tab - Inicio con GestureDetector
          Center(
            child: GestureDetector(
              onTap: () {
                _showSnackBar(context, 'Contenedor presionado');
              },
              onDoubleTap: () {
                setState(() {
                  _scale = _scale == 1.0 ? 1.5 : 1.0;
                });
                _showSnackBar(
                  context,
                  'Contenedor escalado: ${_scale == 1.5 ? 'Ampliado' : 'Normal'}',
                  backgroundColor: Colors.green,
                );
              },
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.touch_app, size: 50, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          // Segundo tab - Favoritos con Widget personalizado
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CustomCard(
                title: 'Pokemones Hielo',
                description: 'Favoritos de tipo Hielo',
                onPressed: () {
                  _showSnackBar(
                    context,
                    'Tarjeta 1 presionada',
                    backgroundColor: Colors.lightBlue,
                  );
                },
                useIcon: true,
                icon: Icons.ac_unit,
                iconColor: Colors.lightBlue,
              ),
              const SizedBox(height: 16.0),
              CustomCard(
                title: 'Pokemones tipo Fuego',
                description: 'Favoritos de tipo Fuego',
                onPressed: () {
                  _showSnackBar(
                    context,
                    'Tarjeta 2 presionada',
                    backgroundColor: Colors.orange,
                  );
                },
                useIcon: true,
                icon: Icons.fire_extinguisher,
                iconColor: Colors.red,
              ),
              const SizedBox(height: 16.0),
              CustomCard(
                title: 'Pokemones tipo Agua',
                description: 'Favoritos de tipo Agua',
                onPressed: () {
                  _showSnackBar(
                    context,
                    'Tarjeta 3 presionada',
                    backgroundColor: Colors.blue,
                  );
                },
                useIcon: true,
                icon: Icons.water,
                iconColor: Colors.blue,
              ),
            ],
          ),
          // Tercer tab - Ajustes
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
                    _showSnackBar(
                      context,
                      'Ajustes guardados',
                      backgroundColor: Colors.green,
                    );
                  },
                  child: const Text('Guardar ajustes'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSnackBar(
            context,
            'Floating ha sido presionado en la tab: ${_tabController.index + 1}',
          );
        },
        child: const Icon(Icons.add),
        tooltip: "Agregar",
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu Drawer',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Inicio"),
              onTap: () {
                _tabController.animateTo(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favoritos"),
              onTap: () {
                _tabController.animateTo(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Ajustes"),
              onTap: () {
                _tabController.animateTo(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget personalizado (CustomCard)
class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;
  final bool useIcon;
  final IconData icon;
  final Color iconColor;

  const CustomCard({
    Key? key,
    required this.title,
    required this.description,
    required this.onPressed,
    this.useIcon = false,
    this.icon = Icons.star,
    this.iconColor = Colors.amber,
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
            if (useIcon)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                ),
                child: Icon(icon, size: 60, color: iconColor),
                alignment: Alignment.center,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

