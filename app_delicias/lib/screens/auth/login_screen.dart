import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../providers/auth_provider.dart';
import '../../screens/app_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Completa todos los campos'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(email, password);
    setState(() => _loading = false);

    if (!mounted) return;
    if (ok) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Error al iniciar sesión'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bgGradientStart, AppColors.bgGradientEnd],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                // Logo y título
                Icon(Icons.bakery_dining, size: 72, color: AppColors.primary)
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 16),
                Text(
                  'Delicias del Centro',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                Text(
                  'Panadería y repostería artesanal',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.muted,
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 48),

                // Card de login
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Iniciar sesión',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      const SizedBox(height: 8),
                      Text(
                        'Ingresa tus credenciales para continuar',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.muted,
                        ),
                      ).animate().fadeIn(delay: 450.ms),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.05, end: 0),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outlined, color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.muted,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ).animate().fadeIn(delay: 550.ms).slideX(begin: -0.05, end: 0),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: _loading
                            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                            : ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: Text('Ingresar', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                              ),
                      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes cuenta?  ',
                            style: GoogleFonts.poppins(color: AppColors.muted, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            ),
                            child: Text(
                              'Regístrate',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 650.ms),
                    ],
                  ),
                ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
