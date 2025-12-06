import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario_model.dart';
import '../viewmodels/usuario_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'crear_usuario_view.dart';
import 'editar_usuario_view.dart';

// Vista de gestión de usuarios - JonthanAyala
// Solo accesible para administradores
class GestionUsuariosView extends StatefulWidget {
  const GestionUsuariosView({super.key});

  @override
  State<GestionUsuariosView> createState() => _GestionUsuariosViewState();
}

class _GestionUsuariosViewState extends State<GestionUsuariosView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsuarioViewModel>().cargarUsuarios();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final usuarioViewModel = context.watch<UsuarioViewModel>();

    // Solo admins pueden ver esta pantalla
    if (authViewModel.usuario?.rol != AppConstants.rolAdmin) {
      return const Scaffold(body: Center(child: Text('Acceso denegado')));
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => usuarioViewModel.cargarUsuarios(),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o email',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          usuarioViewModel.cargarUsuarios();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                usuarioViewModel.buscarUsuarios(value);
              },
            ),
          ),

          // Filtros por rol
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFiltroChip('Todos', 'todos', usuarioViewModel),
                const SizedBox(width: 8),
                _buildFiltroChip(
                  'Clientes',
                  AppConstants.rolCliente,
                  usuarioViewModel,
                ),
                const SizedBox(width: 8),
                _buildFiltroChip(
                  'Repartidores',
                  AppConstants.rolRepartidor,
                  usuarioViewModel,
                ),
                const SizedBox(width: 8),
                _buildFiltroChip(
                  'Admins',
                  AppConstants.rolAdmin,
                  usuarioViewModel,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de usuarios
          Expanded(
            child: usuarioViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : usuarioViewModel.usuarios.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay usuarios',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.textSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => usuarioViewModel.cargarUsuarios(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: usuarioViewModel.usuarios.length,
                      itemBuilder: (context, index) {
                        final usuario = usuarioViewModel.usuarios[index];
                        return _buildUsuarioCard(usuario, usuarioViewModel);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearUsuarioView()),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Crear Usuario'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildFiltroChip(
    String label,
    String valor,
    UsuarioViewModel viewModel,
  ) {
    final isSelected = viewModel.filtroRol == valor;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          viewModel.filtrarPorRol(valor);
        }
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  Widget _buildUsuarioCard(Usuario usuario, UsuarioViewModel viewModel) {
    final authViewModel = context.read<AuthViewModel>();
    final usuarioActual = authViewModel.usuario;

    final isAdminMaster = usuario.id == 'ADMIN_MASTER';
    final esMismoUsuario = usuario.id == usuarioActual?.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRolColor(usuario.rol).withOpacity(0.2),
          child: Icon(
            _getRolIcon(usuario.rol),
            color: _getRolColor(usuario.rol),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                usuario.nombre,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (isAdminMaster)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'MASTER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.warningColor,
                  ),
                ),
              ),
            if (esMismoUsuario && !isAdminMaster)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'TÚ',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(usuario.email),
            const SizedBox(height: 4),
            Text(
              _getRolTexto(usuario.rol),
              style: TextStyle(
                color: _getRolColor(usuario.rol),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            // Solo mostrar editar si NO es el mismo usuario
            if (!esMismoUsuario)
              const PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text('Editar'),
                  ],
                ),
              ),
            // Solo mostrar eliminar si NO es admin master Y NO es el mismo usuario
            if (!isAdminMaster && !esMismoUsuario)
              const PopupMenuItem(
                value: 'eliminar',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: AppTheme.errorColor),
                    SizedBox(width: 8),
                    Text(
                      'Eliminar',
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                  ],
                ),
              ),
          ],
          onSelected: (value) {
            if (value == 'editar') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarUsuarioView(usuario: usuario),
                ),
              );
            } else if (value == 'eliminar') {
              _confirmarEliminar(usuario, viewModel);
            }
          },
        ),
      ),
    );
  }

  void _confirmarEliminar(Usuario usuario, UsuarioViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${usuario.nombre}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await viewModel.eliminarUsuario(usuario.id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuario eliminado correctamente'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      viewModel.errorMessage ?? 'Error al eliminar',
                    ),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRolColor(String rol) {
    switch (rol) {
      case AppConstants.rolCliente:
        return AppTheme.secondaryColor;
      case AppConstants.rolRepartidor:
        return AppTheme.accentColor;
      case AppConstants.rolAdmin:
        return AppTheme.warningColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getRolIcon(String rol) {
    switch (rol) {
      case AppConstants.rolCliente:
        return Icons.shopping_bag;
      case AppConstants.rolRepartidor:
        return Icons.delivery_dining;
      case AppConstants.rolAdmin:
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  String _getRolTexto(String rol) {
    switch (rol) {
      case AppConstants.rolCliente:
        return 'Cliente';
      case AppConstants.rolRepartidor:
        return 'Repartidor';
      case AppConstants.rolAdmin:
        return 'Administrador';
      default:
        return rol;
    }
  }
}
