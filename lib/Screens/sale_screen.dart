// sales_screen.dart
import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  // Lista simulada de productos en el carrito.
  // En una aplicación real, esto se manejaría con un estado más complejo
  // y posiblemente un modelo de datos.
  final List<Map<String, dynamic>> _cartItems = [
    {'name': 'Coca-Cola 600ml', 'quantity': 2, 'price': 18.00},
    {'name': 'Pan Bimbo Blanco', 'quantity': 1, 'price': 35.50},
    {'name': 'Leche Lala Entera 1L', 'quantity': 1, 'price': 28.00},
  ];

  // Controlador para el campo de búsqueda de productos
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Métodos auxiliares para calcular totales (solo para demostración del UI)
  double _calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['quantity'] * item['price']));
  }

  double _calculateTax() {
    // Simulando un 16% de IVA
    return _calculateSubtotal() * 0.16;
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateTax();
  }

  @override
  Widget build(BuildContext context) {
    // Tema actual para acceder a colores
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // --- Buscador de productos ---
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Buscar producto (nombre o código)',
              hintText: 'Ej. Coca-Cola, 7500123456789',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            ),
            onChanged: (value) {
              // Aquí se implementaría la lógica de búsqueda en una app real
              print('Buscando: $value');
            },
          ),
          const SizedBox(height: 20),

          // --- Lista de productos seleccionados (carrito) ---
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _cartItems.isEmpty
                  ? Center(
                child: Text(
                  'No hay productos en el carrito.\nUsa el buscador para añadir.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              item['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Botón para decrementar cantidad (Extras opcionales)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    // Lógica para decrementar cantidad (front-end)
                                    setState(() {
                                      if (item['quantity'] > 1) {
                                        item['quantity']--;
                                      } else {
                                        // Opcional: eliminar si la cantidad llega a 0
                                        _cartItems.removeAt(index);
                                      }
                                    });
                                    print('Cantidad de ${item['name']} decremented to ${item['quantity']}');
                                  },
                                ),
                                Text('${item['quantity']}'), // Cantidad editable
                                // Botón para incrementar cantidad (Extras opcionales)
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 20),
                                  color: Colors.green,
                                  onPressed: () {
                                    // Lógica para incrementar cantidad (front-end)
                                    setState(() {
                                      item['quantity']++;
                                    });
                                    print('Cantidad de ${item['name']} incremented to ${item['quantity']}');
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '\$${(item['quantity'] * item['price']).toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Botón "Eliminar producto del carrito" (Extras opcionales)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _cartItems.removeAt(index);
                              });
                              print('Producto ${item['name']} eliminado del carrito');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Resumen de la venta: Subtotal, Impuestos, Total ---
          _buildSummaryRow('Subtotal:', _calculateSubtotal(), colorScheme.onSurface),
          _buildSummaryRow('Impuestos (IVA 16%):', _calculateTax(), colorScheme.onSurface),
          const Divider(thickness: 1, height: 10),
          _buildSummaryRow('Total a Pagar:', _calculateTotal(), colorScheme.primary, fontSize: 22.0, fontWeight: FontWeight.bold),
          const SizedBox(height: 20),

          // --- Selector de método de pago (Extras opcionales) ---
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Método de Pago',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            ),
            value: 'Efectivo', // Valor inicial
            items: const <String>['Efectivo', 'Tarjeta de Crédito', 'Tarjeta de Débito', 'Transferencia']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              print('Método de pago seleccionado: $newValue');
              // Aquí se guardaría el método de pago seleccionado
            },
          ),
          const SizedBox(height: 20),

          // --- Botón “Cobrar” ---
          SizedBox(
            width: double.infinity, // Ocupa todo el ancho disponible
            child: ElevatedButton.icon(
              onPressed: () {
                // Lógica de cobro (solo front-end por ahora)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡Venta Cobrada! Total: \$${_calculateTotal().toStringAsFixed(2)}'),
                    backgroundColor: Colors.green,
                  ),
                );
                print('Botón "Cobrar" presionado. Total: \$${_calculateTotal().toStringAsFixed(2)}');
                // En una app real, aquí se resetearía el carrito, se registraría la venta, etc.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary, // Color principal del tema
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.payment),
              label: const Text('Cobrar'),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para construir las filas de resumen de venta
  Widget _buildSummaryRow(String label, double value, Color textColor, {double fontSize = 18.0, FontWeight fontWeight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}