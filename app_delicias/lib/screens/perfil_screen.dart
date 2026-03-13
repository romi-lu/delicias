import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_shadows.dart';
import '../providers/auth_provider.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nombreController.text = user.nombre;
      _apellidoController.text = user.apellido;
      _telefonoController.text = user.telefono ?? '';
      _direccionController.text = user.direccion ?? '';
    }
  }

  Future<void> _save() async {
    if (_nombreController.text.isEmpty || _apellidoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nombre y apellido son requeridos'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Perfil actualizado con éxito'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.success,
      ),
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No hay sesión')));
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                    child: Icon(Icons.person_rounded, size: 56, color: AppColors.primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.nombreCompleto,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  _infoRow('Nombre', _isEditing ? _nombreController.text : user.nombre, 0),
                  _infoRow('Apellido', _isEditing ? _apellidoController.text : user.apellido, 1),
                  _infoRow('Correo', user.email, 2),
                  _infoRow('Teléfono', _isEditing ? _telefonoController.text : (user.telefono ?? '-'), 3),
                  _infoRow('Dirección', _isEditing ? _direccionController.text : (user.direccion ?? '-'), 4),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0),
            const SizedBox(height: 24),
            if (_isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Guardar Cambios', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              ).animate().fadeIn(delay: 300.ms)
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => setState(() => _isEditing = true),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Editar Perfil', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value, int index) {
    final isEditable = _isEditing && title != 'Correo';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$title:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.text,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: isEditable
                ? TextField(
                    controller: title == 'Nombre'
                        ? _nombreController
                        : title == 'Apellido'
                            ? _apellidoController
                            : title == 'Teléfono'
                                ? _telefonoController
                                : _direccionController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese su $title',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                  )
                : Text(
                    value.isEmpty ? '-' : value,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.muted,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
