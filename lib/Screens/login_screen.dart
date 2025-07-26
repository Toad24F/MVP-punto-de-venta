import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for email, password, and fullName text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController(); // New controller for fullName

  // State to control if an operation is in progress (e.g., login, register)
  bool _isLoading = false;
  // State to store and display error messages
  String? _errorMessage;
  // NEW STATE: Controls whether the user is in registration mode
  bool _isRegistering = false;

  // Base URL for your NestJS API (ADJUST THIS TO YOUR REAL URL!)
  // For example, if your backend is running locally on port 3000:
  final String _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000'; // Default value if not found

  // Function to show a SnackBar (temporary message at the bottom)
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Function to handle user login
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear any previous error message
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Basic field validation
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa email y contraseña.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'), // Adjust the endpoint if different
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      // Accept statusCode 200 (OK) or 201 (Created) as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successful login
        final responseBody = jsonDecode(response.body);

        // Extract the token from the response
        final String? token = responseBody['token'];

        if (token != null) {
          // Store the token persistently with shared_preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          print('Token stored: $token'); // For debugging

          _showSnackBar('¡Inicio de sesión exitoso!');
          print('Login successful: $responseBody'); // For debugging

          // Navigate to HomeScreen and replace the current screen
          // Pass the token to HomeScreen if needed immediately there
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(authToken: token), // Pass the token to HomeScreen
            ),
          );
        } else {
          // If the token is not present in the response
          setState(() {
            _errorMessage = 'Inicio de sesión exitoso, pero no se recibió un token.';
          });
          _showSnackBar('Error: No se recibió token.', isError: true);
          print('Login successful but no token received: $responseBody');
        }
      } else {
        // Login error (e.g., invalid credentials or any other server error)
        final errorBody = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorBody['message'] ?? 'Error desconocido al iniciar sesión.';
        });
        _showSnackBar('Error al iniciar sesión: ${_errorMessage!}', isError: true);
        print('Login failed: ${response.statusCode} - ${response.body}'); // For debugging
      }
    } catch (e) {
      // Network error or any other exception
      setState(() {
        _errorMessage = 'No se pudo conectar al servidor. Verifica tu conexión.';
      });
      _showSnackBar('Error de conexión: ${_errorMessage!}', isError: true);
      print('Error during login: $e'); // For debugging
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to handle user registration
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear any previous error message
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _fullNameController.text.trim(); // Get fullName from the new controller

    // Basic field validation for all fields
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa email, contraseña y nombre completo.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/register'), // Adjust the endpoint if different
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
          'fullName': fullName, // Include fullName in the request body
        }),
      );

      if (response.statusCode == 201) { // 201 Created is common for successful registration
        // Successful registration
        final responseBody = jsonDecode(response.body);
        _showSnackBar('¡Registro exitoso! Ahora puedes iniciar sesión.');
        print('Registration successful: $responseBody'); // For debugging
        // Optionally, you can automatically log in or clear the fields
        _emailController.clear();
        _passwordController.clear();
        _fullNameController.clear(); // Clear fullName field as well
        setState(() {
          _isRegistering = false; // Return to login mode after successful registration
        });
      } else {
        // Registration error
        final errorBody = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorBody['message'] ?? 'Error desconocido al registrar.';
        });
        _showSnackBar('Error al registrar: ${_errorMessage!}', isError: true);
        print('Registration failed: ${response.statusCode} - ${response.body}'); // For debugging
      }
    } catch (e) {
      // Network error or any other exception
      setState(() {
        _errorMessage = 'No se pudo conectar al servidor. Verifica tu conexión.';
      });
      _showSnackBar('Error de conexión: ${_errorMessage!}', isError: true);
      print('Error during registration: $e'); // For debugging
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose(); // Dispose the new controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                // Background with logo
                Align(
                  alignment: const Alignment(0.0, -0.45),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).colorScheme.inversePrimary,
                    alignment: const Alignment(0.0, -0.3),
                    child: Image.asset('assets/logo.png', height: 80),
                  ),
                ),

                // Main content (inputs and buttons)
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // Error message (if exists)
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Email
                      TextField(
                        controller: _emailController, // Associate the controller
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email', // Label updated to 'Email'
                          labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.email, // Changed icon to email for clarity
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password
                      TextField(
                        controller: _passwordController, // Associate the controller
                        obscureText: true, // To hide the password
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ),

                      // Conditionally show Full Name field
                      if (_isRegistering) ...[ // Use spread operator to include multiple widgets
                        const SizedBox(height: 16), // Spacing for the new field
                        // Full Name - NEW TEXT FIELD
                        TextField(
                          controller: _fullNameController, // Associate the controller
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Nombre Completo', // Label for full name
                            labelStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.person, // Icon for person
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Buttons
                      Row(
                        children: [
                          // "Registrarse" button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                if (_isRegistering) {
                                  _register(); // If already in register mode, call register
                                } else {
                                  setState(() {
                                    _isRegistering = true; // Switch to register mode
                                    _errorMessage = null; // Clear error message when switching modes
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Theme.of(context).colorScheme.inverseSurface,
                                      width: 2.0,
                                    )
                                ),
                                backgroundColor:
                                Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Text(_isRegistering ? 'Confirmar Registro' : 'Registrarse'), // Text changes
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Conditionally show "Iniciar Sesión" or "Cancelar" button
                          if (!_isRegistering) // Show "Iniciar Sesión" only if not in registering mode
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login, // Disable if loading
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Theme.of(context).colorScheme.inverseSurface,
                                      width: 2.0,
                                    ),
                                  ),
                                  backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white) // Loading indicator
                                    : const Text('Iniciar Sesión'),
                              ),
                            )
                          else // Show "Cancelar" button if in registering mode
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                  setState(() {
                                    _isRegistering = false; // Exit register mode
                                    _emailController.clear(); // Clear fields
                                    _passwordController.clear();
                                    _fullNameController.clear();
                                    _errorMessage = null; // Clear error message
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                        color: Theme.of(context).colorScheme.inverseSurface,
                                        width: 2.0,
                                      )
                                  ),
                                  backgroundColor:
                                  Color(0xFFBC1615), // Different color for cancel
                                  foregroundColor:
                                  Theme.of(context).colorScheme.inverseSurface, // Text color for cancel
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Cancelar'),
                              ),
                            ),
                        ],
                      ),

                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
