import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/paquete_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/paquete_viewmodel.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/validators.dart';
import '../utils/app_theme.dart';

// Vista de creación de paquete - Aserejex22
class CrearPaqueteView extends StatefulWidget {
  const CrearPaqueteView({super.key});

  @override
  State<CrearPaqueteView> createState() => _CrearPaqueteViewState();
}

class _CrearPaqueteViewState extends State<CrearPaqueteView> {
  final _formKey = GlobalKey<FormState>();
  final _destinatarioController = TextEditingController();
  final _direccionController = TextEditingController();
  final _pesoController = TextEditingController();
  File? _foto;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _destinatarioController.dispose();
    _direccionController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFoto(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _foto = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar foto: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _crearPaquete() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = context.read<AuthViewModel>();
      final paqueteViewModel = context.read<PaqueteViewModel>();
      final usuario = authViewModel.usuario;

      if (usuario == null) return;

      final paquete = Paquete(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        destinatario: _destinatarioController.text.trim(),
        direccion: _direccionController.text.trim(),
        peso: double.parse(_pesoController.text),
        estado: 'pendiente',
        fechaCreacion: DateTime.now(),
        clienteId: usuario.id,
      );

      final success = await paqueteViewModel.crearPaquete(paquete, _foto);

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paquete creado correctamente'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              paqueteViewModel.errorMessage ?? 'Error al crear paquete',
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Nuevo Paquete'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Foto del paquete
              GestureDetector(
                onTap: () => _mostrarOpcionesFoto(),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.textSecondary.withOpacity(0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _foto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(_foto!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: AppTheme.textSecondary,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Toca para agregar foto',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Campos del formulario
              CustomTextField(
                label: 'Destinatario',
                hint: 'Nombre del destinatario',
                controller: _destinatarioController,
                validator: (value) =>
                    Validators.validateRequired(value, 'El destinatario'),
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Dirección',
                hint: 'Dirección de entrega',
                controller: _direccionController,
                validator: (value) =>
                    Validators.validateRequired(value, 'La dirección'),
                prefixIcon: Icons.location_on,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Peso (kg)',
                hint: '0.0',
                controller: _pesoController,
                validator: Validators.validatePeso,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.scale,
              ),
              const SizedBox(height: 32),

              // Botón de crear
              Consumer<PaqueteViewModel>(
                builder: (context, viewModel, _) {
                  return CustomButton(
                    text: 'Crear Paquete',
                    onPressed: _crearPaquete,
                    isLoading: viewModel.isLoading,
                    icon: Icons.check,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarOpcionesFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _seleccionarFoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de galería'),
                onTap: () {
                  Navigator.pop(context);
                  _seleccionarFoto(ImageSource.gallery);
                },
              ),
              if (_foto != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: AppTheme.errorColor),
                  title: const Text('Eliminar foto'),
                  onTap: () {
                    setState(() {
                      _foto = null;
                    });
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
