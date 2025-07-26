import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Screens/login_screen.dart';

Future<void> main() async {
  // Asegura que los widgets de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();
  // Carga las variables de entorno desde el archivo .env
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x5E22BE10), // color base
          primary: Color(0xFF036B17),   // color primario personalizado
          secondary: Color(0xFFFFFFFF), // color secundario personalizado
        ),
        useMaterial3: true, // si estás usando Material 3
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Color(0xFF78BB6F),
          primary: Color(0xFF154B19),
          secondary: Color(0xFFFFFFFF),
        ),
      ),
      themeMode: ThemeMode.system, // cambia según modo claro/oscuro del sistema
      title: 'Punto de Venta',
      home: LoginScreen(),
    );
  }


}
