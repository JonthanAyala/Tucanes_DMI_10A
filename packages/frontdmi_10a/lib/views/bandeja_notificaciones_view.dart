import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/notificacion_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/notificacion_viewmodel.dart';
import '../utils/app_theme.dart';

// Vista de bandeja de notificaciones - JonthanAyala
class BandejaNotificacionesView extends StatefulWidget {
  const BandejaNotificacionesView({super.key});

  @override
  State<BandejaNotificacionesView> createState() =>
      _BandejaNotificacionesViewState();
}

class _BandejaNotificacionesViewState extends State<BandejaNotificacionesView> {
  @override
  void initState() {
    super.initState();
    // Configurar timeago en español
    timeago.setLocaleMessages('es', timeago.EsMessages());

    // Inicializar stream de notificaciones
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = context.read<AuthViewModel>();
      final notifViewModel = context.read<NotificacionViewModel>();

      if (authViewModel.usuario != null) {
        notifViewModel.inicializarStream(authViewModel.usuario!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final notifViewModel = context.watch<NotificacionViewModel>();
    final usuario = authViewModel.usuario;

    if (usuario == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          // Marcar todas como leídas
          if (notifViewModel.noLeidasCount > 0)
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: () => _marcarTodasComoLeidas(context, usuario.id),
              tooltip: 'Marcar todas como leídas',
            ),
          // Menú de opciones
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'eliminar_todas':
                  _confirmarEliminarTodas(context, usuario.id);
                  break;
                case 'limpiar_antiguas':
                  _limpiarAntiguas(context, usuario.id);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'eliminar_todas',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: AppTheme.errorColor),
                    SizedBox(width: 8),
                    Text('Eliminar todas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'limpiar_antiguas',
                child: Row(
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(width: 8),
                    Text('Limpiar antiguas'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => notifViewModel.recargarNotificaciones(usuario.id),
        child: notifViewModel.notificaciones.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: notifViewModel.notificaciones.length,
                itemBuilder: (context, index) {
                  final notificacion = notifViewModel.notificaciones[index];
                  return _buildNotificacionCard(context, notificacion);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: AppTheme.textSecondary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No tienes notificaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Las notificaciones aparecerán aquí',
                  style: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificacionCard(
    BuildContext context,
    Notificacion notificacion,
  ) {
    final notifViewModel = context.read<NotificacionViewModel>();

    return Dismissible(
      key: Key(notificacion.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppTheme.errorColor,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        notifViewModel.eliminarNotificacion(notificacion.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notificación eliminada'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: notificacion.leida ? 0 : 2,
        color: notificacion.leida
            ? AppTheme.surfaceColor
            : AppTheme.primaryColor.withOpacity(0.05),
        child: InkWell(
          onTap: () {
            if (!notificacion.leida) {
              notifViewModel.marcarComoLeida(notificacion.id);
            }
            // TODO: Navegar según el tipo de notificación
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono según tipo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTipoColor(notificacion.tipo).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      notificacion.icono,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notificacion.titulo,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notificacion.leida
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notificacion.leida)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notificacion.mensaje,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timeago.format(
                          notificacion.fechaCreacion,
                          locale: 'es',
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary.withOpacity(0.7),
                        ),
                      ),
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

  Color _getTipoColor(String tipo) {
    switch (tipo) {
      case 'paquete':
        return AppTheme.primaryColor;
      case 'asignacion':
        return AppTheme.secondaryColor;
      case 'entrega':
        return AppTheme.successColor;
      case 'alerta':
        return AppTheme.warningColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  Future<void> _marcarTodasComoLeidas(
    BuildContext context,
    String userId,
  ) async {
    final notifViewModel = context.read<NotificacionViewModel>();
    await notifViewModel.marcarTodasComoLeidas(userId);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todas las notificaciones marcadas como leídas'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  Future<void> _confirmarEliminarTodas(
    BuildContext context,
    String userId,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar todas'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar todas las notificaciones?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true && context.mounted) {
      final notifViewModel = context.read<NotificacionViewModel>();
      final success = await notifViewModel.eliminarTodas(userId);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todas las notificaciones eliminadas'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    }
  }

  Future<void> _limpiarAntiguas(BuildContext context, String userId) async {
    final notifViewModel = context.read<NotificacionViewModel>();
    await notifViewModel.limpiarAntiguas(userId);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificaciones antiguas eliminadas'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
}
