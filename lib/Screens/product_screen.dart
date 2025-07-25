// products_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear monedas

// --- Modelo de Producto (lo ideal es tenerlo en un archivo separado como models/product.dart) ---
// Por simplicidad, lo incluimos aquí por ahora.
class Product {
  String id;
  String name;
  double price;
  int stock;
  String? category; // Opcional

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.category,
  });
}

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Lista simulada de productos
  // Usamos el modelo Product para una mejor estructura
  final List<Product> _products = [
    Product(id: 'P001', name: 'Coca-Cola 600ml', price: 18.00, stock: 150, category: 'Bebidas'),
    Product(id: 'P002', name: 'Pan Bimbo Blanco', price: 35.50, stock: 50, category: 'Panadería'),
    Product(id: 'P003', name: 'Leche Lala Entera 1L', price: 28.00, stock: 80, category: 'Lácteos'),
    Product(id: 'P004', name: 'Galletas Oreo', price: 15.00, stock: 120, category: 'Snacks'),
    Product(id: 'P005', name: 'Jugo Del Valle Naranja 1L', price: 22.00, stock: 70, category: 'Bebidas'),
    Product(id: 'P006', name: 'Café Nescafé Clásico 50g', price: 45.00, stock: 40, category: 'Abarrotes'),
  ];

  // Controlador para el campo de búsqueda (si se implementa en el futuro)
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Formateador de moneda
  final NumberFormat _currencyFormatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

  // --- Función para mostrar el formulario de agregar/editar producto ---
  void _showProductForm({Product? productToEdit}) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: productToEdit?.name);
    final _priceController = TextEditingController(text: productToEdit?.price.toString());
    final _stockController = TextEditingController(text: productToEdit?.stock.toString());
    String? _selectedCategory = productToEdit?.category;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Importante para que el teclado no cubra los campos
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Ajusta padding para el teclado
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Se ajusta al tamaño del contenido
              children: [
                Text(
                  productToEdit == null ? 'Agregar Nuevo Producto' : 'Editar Producto',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Producto',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un nombre.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un precio.';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Ingresa un precio válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stock Inicial',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el stock.';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Ingresa un número entero válido para el stock.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Categoría (Opcional)',
                    border: OutlineInputBorder(),
                  ),
                  items: <String>['Bebidas', 'Panadería', 'Lácteos', 'Snacks', 'Abarrotes', 'Limpieza', 'Otros']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Lógica para guardar o actualizar el producto
                        final newName = _nameController.text;
                        final newPrice = double.parse(_priceController.text);
                        final newStock = int.parse(_stockController.text);

                        setState(() {
                          if (productToEdit == null) {
                            // Añadir nuevo producto
                            _products.add(Product(
                              id: 'P${(_products.length + 1).toString().padLeft(3, '0')}', // ID simple
                              name: newName,
                              price: newPrice,
                              stock: newStock,
                              category: _selectedCategory,
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Producto agregado con éxito!')),
                            );
                          } else {
                            // Actualizar producto existente
                            productToEdit.name = newName;
                            productToEdit.price = newPrice;
                            productToEdit.stock = newStock;
                            productToEdit.category = _selectedCategory;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Producto actualizado con éxito!')),
                            );
                          }
                        });
                        Navigator.pop(context); // Cerrar el BottomSheet
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: Text(productToEdit == null ? 'Guardar Producto' : 'Actualizar Producto'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Función para confirmar la eliminación de un producto ---
  void _confirmDeleteProduct(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content: Text('¿Estás seguro de que quieres eliminar "${_products[index].name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _products.removeAt(index);
                });
                Navigator.of(context).pop(); // Cerrar el diálogo
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto eliminado.')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Buscador de productos ---
            TextField(
              controller: _searchController,
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
                  'No hay productos registrados.\nPresiona "+" para añadir uno.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  textAlign: TextAlign.center,
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
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Código: ${product.id}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 4),
                                if (product.category != null && product.category!.isNotEmpty)
                                  Text(
                                    'Categoría: ${product.category}',
                                    style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                                  ),
                                const SizedBox(height: 4),
                                Text(
                                  'Precio: ${_currencyFormatter.format(product.price)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stock: ${product.stock} unidades',
                                  style: TextStyle(
                                    color: product.stock < 10 && product.stock > 0 ? Colors.orange : // Stock bajo
                                    product.stock == 0 ? Colors.red : // Sin stock
                                    Colors.green, // Stock suficiente
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Botón de edición
                          IconButton(
                            icon: Icon(Icons.edit, color: colorScheme.secondary),
                            onPressed: () {
                              _showProductForm(productToEdit: product); // Pasar el producto para editar
                            },
                          ),
                          // Botón de eliminar
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDeleteProduct(index); // Confirmar antes de eliminar
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
          _showProductForm(); // Llamar al formulario para agregar
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