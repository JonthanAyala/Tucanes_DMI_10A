import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario_model.dart';
import '../viewmodels/usuario_viewmodel.dart';
import '../utils/app_theme.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Vista de edición de usuario por admin - JonthanAyala
class EditarUsuarioView extends StatefulWidget {
  final Usuario usuario;

  const EditarUsuarioView({super.key, required this.usuario});

  @override
  State<EditarUsuarioView> createState() => _EditarUsuarioViewState();
}

class _EditarUsuarioViewState extends State<EditarUsuarioView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _emailController;
  late String _selectedRol;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.usuario.nombre);
    _emailController = TextEditingController(text: widget.usuario.email);
    _selectedRol = widget.usuario.rol;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _actualizarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final usuarioViewModel = context.read<UsuarioViewModel>();

    final usuarioActualizado = widget.usuario.copyWith(
      nombre: _nombreController.text.trim(),
      email: _emailController.text.trim(),
      rol: _selectedRol,
    );

    final success = await usuarioViewModel.actualizarUsuario(
      usuarioActualizado,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario actualizado correctamente'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(usuarioViewModel.errorMessage ?? 'Error al actualizar'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdminMaster = widget.usuario.id == 'ADMIN_MASTER';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Editar Usuario'),
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
                const Icon(Icons.edit, size: 80, color: AppTheme.primaryColor),
                const SizedBox(height: 16),
                const Text(
                  'Editar Usuario',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (isAdminMaster)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.warningColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber,
                          color: AppTheme.warningColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Este es el administrador principal. No se puede cambiar su rol.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
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

                // Campo de email (solo lectura)
                CustomTextField(
                  controller: _emailController,
                  label: 'Correo Electrónico',
                  hint: 'correo@ejemplo.com',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail,
                  enabled: false, // Email no se puede cambiar
                ),
                const SizedBox(height: 24),

                // Selector de rol
                const Text(
                  'Rol del usuario',
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
                  enabled: !isAdminMaster,
                ),
                const SizedBox(height: 12),
                _buildRolSelector(
                  AppConstants.rolRepartidor,
                  'Repartidor',
                  'Entrega paquetes',
                  Icons.delivery_dining,
                  enabled: !isAdminMaster,
                ),
                const SizedBox(height: 12),
                _buildRolSelector(
                  AppConstants.rolAdmin,
                  'Administrador',
                  'Gestiona todo',
                  Icons.admin_panel_settings,
                  enabled: !isAdminMaster,
                ),
                const SizedBox(height: 32),

                // Botón de actualizar
                Consumer<UsuarioViewModel>(
                  builder: (context, usuarioViewModel, _) {
                    return CustomButton(
                      text: 'Actualizar Usuario',
                      onPressed: _actualizarUsuario,
                      isLoading: usuarioViewModel.isLoading,
                      icon: Icons.save,
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
    IconData icono, {
    bool enabled = true,
  }) {
    final isSelected = _selectedRol == rol;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: enabled
            ? () {
                setState(() {
                  _selectedRol = rol;
                });
              }
            : null,
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
      ),
    );
  }
}
