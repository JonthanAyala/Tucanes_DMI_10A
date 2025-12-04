import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/usuario_viewmodel.dart';
import '../utils/app_theme.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Vista de creación de usuario por admin - JonthanAyala
class CrearUsuarioView extends StatefulWidget {
  const CrearUsuarioView({super.key});

  @override
  State<CrearUsuarioView> createState() => _CrearUsuarioViewState();
}

class _CrearUsuarioViewState extends State<CrearUsuarioView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRol = AppConstants.rolCliente;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _crearUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final usuarioViewModel = context.read<UsuarioViewModel>();

    final success = await usuarioViewModel.crearUsuario(
      nombre: _nombreController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rol: _selectedRol,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario creado correctamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            usuarioViewModel.errorMessage ?? 'Error al crear usuario',
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Crear Usuario'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nuevo Usuario',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Completa los datos del nuevo usuario',
                  style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Campo de nombre
                CustomTextField(
                  controller: _nombreController,
                  label: 'Nombre Completo',
                  hint: 'Ingresa el nombre',
                  prefixIcon: Icons.person,
                  validator: (value) =>
                      Validators.validateRequired(value, 'El nombre'),
                ),
                const SizedBox(height: 16),

                // Campo de email
                CustomTextField(
                  controller: _emailController,
                  label: 'Correo Electrónico',
                  hint: 'correo@ejemplo.com',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),

                // Campo de contraseña
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  hint: 'Mínimo 6 caracteres',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),

                // Campo de confirmar contraseña
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Contraseña',
                  hint: 'Repite la contraseña',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor confirma la contraseña';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Selector de rol
                const Text(
                  'Selecciona el rol',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRolSelector(
                  AppConstants.rolCliente,
                  'Cliente',
                  'Envía paquetes',
                  Icons.shopping_bag,
                ),
                const SizedBox(height: 12),
                _buildRolSelector(
                  AppConstants.rolRepartidor,
                  'Repartidor',
                  'Entrega paquetes',
                  Icons.delivery_dining,
                ),
                const SizedBox(height: 12),
                _buildRolSelector(
                  AppConstants.rolAdmin,
                  'Administrador',
                  'Gestiona todo',
                  Icons.admin_panel_settings,
                ),
                const SizedBox(height: 32),

                // Botón de crear
                Consumer<UsuarioViewModel>(
                  builder: (context, usuarioViewModel, _) {
                    return CustomButton(
                      text: 'Crear Usuario',
                      onPressed: _crearUsuario,
                      isLoading: usuarioViewModel.isLoading,
                      icon: Icons.person_add,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRolSelector(
    String rol,
    String titulo,
    String descripcion,
    IconData icono,
  ) {
    final isSelected = _selectedRol == rol;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRol = rol;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.textSecondary.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icono,
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.textSecondary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
