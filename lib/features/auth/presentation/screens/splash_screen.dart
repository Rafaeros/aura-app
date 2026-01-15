import 'package:flutter/material.dart';

import 'package:aura/core/presentation/widgets/layout/aura_neon_logo.dart';
import 'package:aura/features/auth/presentation/controllers/splash_controller.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Inicia a verificação de autenticação/primeira vez
    _checkAuth();
  }

  void _checkAuth() async {
    final controller = context.read<SplashController>();
    // Essa função agora decide se vai pra Welcome, Login ou Home
    final route = await controller.checkAuthStatus();

    if (mounted) {
      // Pequena animação de fade ao trocar de tela
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuraNativeAnimatedLogo(size: 250),

            SizedBox(height: 50),

            SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white10,
                color: Colors.cyanAccent,
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
