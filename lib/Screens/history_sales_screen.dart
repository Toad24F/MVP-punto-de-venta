// history_sales_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas y monedas

class HistorySalesScreen extends StatefulWidget {
  const HistorySalesScreen({super.key});

  @override
  State<HistorySalesScreen> createState() => _HistorySalesScreenState();
}

class _HistorySalesScreenState extends State<HistorySalesScreen> {
  // Lista completa de ventas pasadas (simulada)
  // En una aplicación real, esto provendría de una base de datos o API
  final List<Map<String, dynamic>> _allSalesHistory = [
    {
      'id': 'V001',
      'date': DateTime(2025, 7, 23, 10, 30),
      'total': 125.75,
      'paymentMethod': 'Efectivo',
      'userId': 'user_abc123', // Agregado campo de usuario
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
      'userId': 'user_def456',
      'items': [
        {'name': 'Leche Lala Entera 1L', 'quantity': 2, 'price': 28.00},
        {'name': 'Café Nescafé Clásico 50g', 'quantity': 1, 'price': 45.00},
      ],
    },
    {
      'id': 'V003',
      'date': DateTime(2025, 7, 23, 9, 15), // Otra venta el 23 de julio
      'total': 42.50,
      'paymentMethod': 'Efectivo',
      'userId': 'user_abc123',
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
      'userId': 'user_ghi789',
      'items': [
        {'name': 'Arroz La Merced 1kg', 'quantity': 2, 'price': 25.00},
        {'name': 'Frijol La Costeña 500g', 'quantity': 3, 'price': 18.00},
        {'name': 'Aceite Nutrioli 900ml', 'quantity': 1, 'price': 50.00},
        {'name': 'Pasta Barilla Espagueti', 'quantity': 4, 'price': 15.00},
      ],
    },
    {
      'id': 'V005',
      'date': DateTime(2025, 7, 24, 11, 00), // Venta de hoy (24 de julio)
      'total': 75.00,
      'paymentMethod': 'Efectivo',
      'userId': 'user_abc123',
      'items': [
        {'name': 'Chicles Trident', 'quantity': 5, 'price': 5.00},
        {'name': 'Sabritas Grandes', 'quantity': 2, 'price': 25.00},
      ],
    },
  ];

  // Lista de ventas que se mostrará en la UI (filtrada)
  List<Map<String, dynamic>> _filteredSales = [];
  // Fecha seleccionada para el filtro
  DateTime? _selectedDate;

  // Controlador para el campo de texto del filtro de fecha
  final TextEditingController _dateFilterController = TextEditingController();

  // Formateadores para fecha y moneda
  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');
  final DateFormat _dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');
  final NumberFormat _currencyFormatter = NumberFormat.currency(locale: 'es_MX', symbol: '\$');

  @override
  void initState() {
    super.initState();
    // Al iniciar, muestra todas las ventas y las ordena por fecha (más reciente primero)
    _filteredSales = List.from(_allSalesHistory);
    _filteredSales.sort((a, b) => b['date'].compareTo(a['date']));
  }

  @override
  void dispose() {
    _dateFilterController.dispose();
    super.dispose();
  }

  // --- Función para seleccionar fecha (abre el DatePicker) ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Usa la fecha actual si no hay una seleccionada
      firstDate: DateTime(2020), // Rango de fechas seleccionable
      lastDate: DateTime(2030),
      helpText: 'Selecciona una fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        // Personaliza el tema del DatePicker para que coincida con tu app
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary, // Color del encabezado del DatePicker
              onPrimary: Colors.white, // Color del texto en el encabezado
              onSurface: Colors.black, // Color del texto en el calendario
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary, // Color de los botones del DatePicker
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateFilterController.text = _dateFormatter.format(_selectedDate!); // Actualiza el campo de texto
        _applyFilter(); // Aplica el filtro inmediatamente
      });
    }
  }

  // --- Función para aplicar el filtro de fecha a la lista de ventas ---
  void _applyFilter() {
    setState(() {
      if (_selectedDate == null) {
        _filteredSales = List.from(_allSalesHistory); // Si no hay fecha seleccionada, muestra todas
      } else {
        // Filtra las ventas cuya fecha coincida con la fecha seleccionada (día, mes, año)
        _filteredSales = _allSalesHistory.where((sale) {
          final saleDate = sale['date'] as DateTime;
          return saleDate.year == _selectedDate!.year &&
              saleDate.month == _selectedDate!.month &&
              saleDate.day == _selectedDate!.day;
        }).toList();
      }
      // Asegura que la lista filtrada también esté ordenada por fecha
      _filteredSales.sort((a, b) => b['date'].compareTo(a['date']));
    });
  }

  // --- Función para limpiar el filtro de fecha ---
  void _clearFilter() {
    setState(() {
      _selectedDate = null; // Limpia la fecha seleccionada
      _dateFilterController.clear(); // Limpia el campo de texto
      _applyFilter(); // Vuelve a mostrar todas las ventas
    });
  }

  // --- Función para calcular el total vendido de las ventas actualmente filtradas ---
  double _calculateTotalSoldFiltered() {
    return _filteredSales.fold(0.0, (sum, sale) => sum + (sale['total'] as double));
  }

  // --- Función para simular la descarga en PDF ---
  void _downloadPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulando descarga de PDF...'),
        backgroundColor: Colors.blueAccent,
      ),
    );
    print('Simulando descarga de PDF del historial de ventas.');
    // En una aplicación real, aquí integrarías una librería para generar PDF
    // (ej. `pdf` o `printing`) y guardar el archivo en el dispositivo.
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Filtro por fecha ---
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateFilterController,
                    readOnly: true, // No permitir escribir directamente en el campo
                    decoration: InputDecoration(
                      labelText: 'Filtrar por Fecha',
                      hintText: 'Selecciona una fecha',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    ),
                    onTap: () => _selectDate(context), // Abrir el selector de fecha al tocar
                  ),
                ),
                // Mostrar el botón de limpiar solo si hay una fecha seleccionada
                if (_selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: _clearFilter,
                    tooltip: 'Limpiar filtro de fecha', // Texto de ayuda al pasar el mouse
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // --- Total vendido por día/filtro (Extras útiles) ---
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1), // Fondo semitransparente del color primario
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colorScheme.primary), // Borde del color primario
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // Texto dinámico según si hay filtro de fecha
                    _selectedDate == null ? 'Total Vendido (Todas las ventas):' : 'Total Vendido el ${_dateFormatter.format(_selectedDate!)}:',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _currencyFormatter.format(_calculateTotalSoldFiltered()), // Muestra el total de las ventas filtradas
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Lista de ventas ---
            Expanded(
              child: _filteredSales.isEmpty
                  ? Center(
                child: Text(
                  // Mensaje dinámico según si hay filtro de fecha
                  _selectedDate == null
                      ? 'No hay ventas registradas en el historial.'
                      : 'No hay ventas para la fecha seleccionada (${_dateFormatter.format(_selectedDate!)}).',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                itemCount: _filteredSales.length,
                itemBuilder: (context, index) {
                  final sale = _filteredSales[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ExpansionTile(
                      // Borde de la tarjeta del ExpansionTile
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          width: 2.0,
                        ),
                      ),
                      // Título de la venta
                      title: Text(
                        'Venta #${sale['id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorScheme.primary,
                        ),
                      ),
                      // Subtítulo con fecha, usuario y método de pago
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fecha: ${_dateTimeFormatter.format(sale['date'])}'),
                          Text('Usuario: ${sale['userId']}'), // Mostrar el usuario
                          Text('Método de Pago: ${sale['paymentMethod']}'),
                        ],
                      ),
                      // Total de la venta en el lado derecho
                      trailing: Text(
                        _currencyFormatter.format(sale['total']),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.green, // Color verde para el total
                        ),
                      ),
                      children: [
                        // Contenido que se muestra al expandir: detalles de productos
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Productos Vendidos:',
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
                                        Text(_currencyFormatter.format(item['quantity'] * item['price'])),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const Divider(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Total de Venta: ${_currencyFormatter.format(sale['total'])}',
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
      // --- Botón flotante para descargar PDF (Extras útiles) ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _downloadPdf,
        icon: const Icon(Icons.download),
        label: const Text('Descargar PDF'),
        backgroundColor: colorScheme.primary, // Un color diferente para distinguirlo
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}