import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Para rastrear la pestaña seleccionada
  late PageController _pageController; // Para controlar el PageView

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Lista de widgets para las diferentes pantallas/pestañas
  static const List<Widget> _widgetOptions = <Widget>[
    PlaceholderScreen(title: 'Punto de Venta (Registrar Venta)'),
    PlaceholderScreen(title: 'Pantalla de Productos'),
    PlaceholderScreen(title: 'Pantalla de Historial de Ventas'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // El título del AppBar podría cambiar según la pestaña seleccionada
        title: Text(_getTitleForIndex(_selectedIndex)),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged, // Actualiza el índice cuando se desliza
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Ventas', // Etiqueta corta para la barra
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary, // Color del ítem seleccionado
        onTap: _onItemTapped, // Cambia de página al tocar un ítem
      ),
    );
  }

  // Método auxiliar para obtener el título basado en el índice
  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Punto de Venta';
      case 1:
        return 'Productos';
      case 2:
        return 'Historial de Ventas';
      default:
        return 'Mi App';
    }
  }
}

// Widget Placeholder simple para cada pantalla
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
