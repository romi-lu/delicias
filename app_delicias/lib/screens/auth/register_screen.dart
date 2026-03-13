import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../providers/auth_provider.dart';
import '../../screens/app_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      telefono: _telefonoController.text.trim().isEmpty ? null : _telefonoController.text.trim(),
      direccion: _direccionController.text.trim().isEmpty ? null : _direccionController.text.trim(),
    );
    setState(() => _loading = false);

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registro exitoso ✅'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'No se pudo registrar'),
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
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  'Registro',
                  style: GoogleFonts.poppins(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Icon(Icons.bakery_dining, size: 56, color: AppColors.primary)
                          .animate()
                          .fadeIn(duration: 400.ms),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: AppShadows.card,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Crea tu cuenta',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _nombreController,
                                      decoration: const InputDecoration(labelText: 'Nombre'),
                                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _apellidoController,
                                      decoration: const InputDecoration(labelText: 'Apellido'),
                                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _telefonoController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(labelText: 'Teléfono (opcional)'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _direccionController,
                                decoration: const InputDecoration(labelText: 'Dirección (opcional)'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(labelText: 'Correo'),
                                validator: (v) {
                                  final e = (v ?? '').trim();
                                  if (e.isEmpty) return 'Requerido';
                                  if (!e.contains('@')) return 'Correo inválido';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                      color: AppColors.muted,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                ),
                                validator: (v) {
                                  final p = (v ?? '').trim();
                                  if (p.isEmpty) return 'Requerido';
                                  if (p.length < 6) return 'Mínimo 6 caracteres';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
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
                                        child: Text(
                                          'Registrarse',
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    '¿Ya tienes cuenta? Inicia sesión',
                                    style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
