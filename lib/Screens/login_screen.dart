import 'dart:ui';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bubbleScaleAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Size> _backgroundExpansionAnimation;
  late Animation<Offset> _formSlideAnimation;
  late Animation<Alignment> _logoAlignAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Inicializamos con valores por defecto, se actualizarán en el build
    _bubbleScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );

    _backgroundExpansionAnimation =
        Tween<Size>(
          begin: const Size(150, 50),
          end: const Size(0, 0), // Se actualizará en el build
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
          ),
        );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _formSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
          ),
        );

    _logoAlignAnimation =
        AlignmentTween(
          begin: const Alignment(0.0, 0.0),
          end: const Alignment(0.0, -0.45), // Ajustado para que sea visible
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
          ),
        );

    // Iniciamos la animación después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          // Actualizamos el tamaño final con el contexto disponible
          final mediaQuery = MediaQuery.of(context);
          _backgroundExpansionAnimation =
              Tween<Size>(
                begin: const Size(150, 50),
                end: Size(mediaQuery.size.width, mediaQuery.size.height),
              ).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
                ),
              );

          _controller.forward();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            // Esto permite que el contenido se desplace cuando aparece el teclado
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // Animación del fondo expandiéndose desde burbuja
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final size = _backgroundExpansionAnimation.value;
                        return Align(
                          alignment: _logoAlignAnimation.value,
                          child: Container(
                            width: size.width,
                            height: size.height,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.inversePrimary,
                              borderRadius: BorderRadius.circular(
                                lerpDouble(
                                      30,
                                      0,
                                      _controller.value.clamp(0.3, 0.7),
                                    ) ??
                                    0,
                              ),
                            ),
                            alignment: const Alignment(0.0, -0.3),
                            child: Image.asset('assets/logo.png', height: 80),
                          ),
                        );
                      },
                    ),

                    // Contenido principal (inputs y botones)
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: SlideTransition(
                        position: _formSlideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(flex: 2),

                              // Usuario
                              TextField(
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.color,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Usuario',
                                  labelStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.color,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Contraseña
                              TextField(
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.color,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  labelStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.color,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Botones
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Registrarse'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const HomeScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Iniciar Sesión'),
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(flex: 1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
