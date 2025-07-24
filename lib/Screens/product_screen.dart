// products_screen.dart
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Lista simulada de productos
  // En una aplicación real, esto provendría de una base de datos o API
  final List<Map<String, dynamic>> _products = [
    {'id': 'P001', 'name': 'Coca-Cola 600ml', 'price': 18.00, 'stock': 150},
    {'id': 'P002', 'name': 'Pan Bimbo Blanco', 'price': 35.50, 'stock': 50},
    {'id': 'P003', 'name': 'Leche Lala Entera 1L', 'price': 28.00, 'stock': 80},
    {'id': 'P004', 'name': 'Galletas Oreo', 'price': 15.00, 'stock': 120},
    {'id': 'P005', 'name': 'Jugo Del Valle Naranja 1L', 'price': 22.00, 'stock': 70},
    {'id': 'P006', 'name': 'Café Nescafé Clásico 50g', 'price': 45.00, 'stock': 40},
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // No necesitamos un AppBar aquí porque la HomeScreen ya tiene uno
      // y esta es una "pestaña" del PageView.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Buscador de productos ---
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar producto...',
                hintText: 'Ej. Leche, Café',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              onChanged: (value) {
                // Aquí iría la lógica para filtrar la lista de productos
                print('Buscando productos: $value');
              },
            ),
            const SizedBox(height: 20),

            // --- Lista de productos ---
            Expanded(
              child: _products.isEmpty
                  ? Center(
                child: Text(
                  'No hay productos registrados.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Código: ${product['id']}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Precio: \$${product['price'].toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stock: ${product['stock']} unidades',
                                  style: TextStyle(
                                    color: product['stock'] < 10 ? Colors.red : Colors.green, // Alerta si stock es bajo
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botón de edición (Opcional)
                          IconButton(
                            icon: Icon(Icons.edit, color: colorScheme.secondary),
                            onPressed: () {
                              // Lógica para editar el producto
                              print('Editar producto: ${product['name']}');
                              // Aquí podrías abrir un diálogo o navegar a una pantalla de edición
                            },
                          ),
                          // Botón de eliminar (Opcional)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Lógica para eliminar el producto
                              print('Eliminar producto: ${product['name']}');
                              // En una app real, mostrarías un diálogo de confirmación
                              setState(() {
                                _products.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // --- Botón flotante para agregar nuevo producto ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Lógica para agregar un nuevo producto
          print('Botón "Agregar Producto" presionado');
          // Aquí podrías navegar a una nueva pantalla o mostrar un diálogo
          // para ingresar los datos del nuevo producto.
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar Producto'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}