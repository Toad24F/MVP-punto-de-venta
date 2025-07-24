// history_sales_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas y monedas

class HistorySalesScreen extends StatefulWidget {
  const HistorySalesScreen({super.key});

  @override
  State<HistorySalesScreen> createState() => _HistorySalesScreenState();
}

class _HistorySalesScreenState extends State<HistorySalesScreen> {
  // Lista simulada de ventas pasadas
  // En una aplicación real, esto provendría de una base de datos o API
  final List<Map<String, dynamic>> _salesHistory = [
    {
      'id': 'V001',
      'date': DateTime(2025, 7, 23, 10, 30),
      'total': 125.75,
      'paymentMethod': 'Efectivo',
      'items': [
        {'name': 'Coca-Cola 600ml', 'quantity': 2, 'price': 18.00},
        {'name': 'Pan Bimbo Blanco', 'quantity': 1, 'price': 35.50},
        {'name': 'Galletas Oreo', 'quantity': 3, 'price': 15.00},
      ],
    },
    {
      'id': 'V002',
      'date': DateTime(2025, 7, 22, 14, 05),
      'total': 85.00,
      'paymentMethod': 'Tarjeta de Crédito',
      'items': [
        {'name': 'Leche Lala Entera 1L', 'quantity': 2, 'price': 28.00},
        {'name': 'Café Nescafé Clásico 50g', 'quantity': 1, 'price': 45.00},
      ],
    },
    {
      'id': 'V003',
      'date': DateTime(2025, 7, 21, 09, 15),
      'total': 42.50,
      'paymentMethod': 'Efectivo',
      'items': [
        {'name': 'Jugo Del Valle Naranja 1L', 'quantity': 1, 'price': 22.00},
        {'name': 'Agua Bonafont 1L', 'quantity': 1, 'price': 20.50},
      ],
    },
    {
      'id': 'V004',
      'date': DateTime(2025, 7, 20, 18, 45),
      'total': 200.00,
      'paymentMethod': 'Transferencia',
      'items': [
        {'name': 'Arroz La Merced 1kg', 'quantity': 2, 'price': 25.00},
        {'name': 'Frijol La Costeña 500g', 'quantity': 3, 'price': 18.00},
        {'name': 'Aceite Nutrioli 900ml', 'quantity': 1, 'price': 50.00},
        {'name': 'Pasta Barilla Espagueti', 'quantity': 4, 'price': 15.00},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Buscador/Filtro de ventas (Opcional) ---
            TextField(
              decoration: InputDecoration(
                labelText: 'Buscar venta por ID, fecha o total...',
                hintText: 'Ej. V001, 23/07/2025',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              ),
              onChanged: (value) {
                // Aquí iría la lógica para filtrar la lista de ventas
                print('Buscando ventas: $value');
              },
            ),
            const SizedBox(height: 20),

            // --- Lista de ventas ---
            Expanded(
              child: _salesHistory.isEmpty
                  ? Center(
                child: Text(
                  'No hay ventas registradas en el historial.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _salesHistory.length,
                itemBuilder: (context, index) {
                  final sale = _salesHistory[index];
                  // Formateadores para fecha y moneda
                  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
                  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          width: 2.0,
                        ),),
                      // ExpansionTile permite expandir para ver detalles
                      title: Text(
                        'Venta #${sale['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorScheme.primary,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha: ${dateFormatter.format(sale['date'])}'),
                          Text('Método de Pago: ${sale['paymentMethod']}'),
                        ],
                      ),
                      trailing: Text(
                        currencyFormatter.format(sale['total']),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green, // Color para el total
                        ),
                      ),
                      children: [
                        // Contenido que se muestra al expandir
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Productos:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              // Lista de ítems de la venta
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (sale['items'] as List<dynamic>).map<Widget>((item) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${item['quantity']}x ${item['name']}'),
                                        Text(currencyFormatter.format(item['quantity'] * item['price'])),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const Divider(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Total de Venta: ${currencyFormatter.format(sale['total'])}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}