import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ubicacion_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/paquete_viewmodel.dart';
import '../services/location_service.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

// Vista de ubicación simple sin Google Maps - BojitaNoir
// Muestra coordenadas y lista de paquetes con enlaces a Google Maps web
class MapaView extends StatefulWidget {
  const MapaView({super.key});

  @override
  State<MapaView> createState() => _MapaViewState();
}

class _MapaViewState extends State<MapaView> {
  final LocationService _locationService = LocationService();
  Ubicacion? _currentLocation;
  bool _isLoading = true;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      setState(() {
        _currentLocation = location;
        _isLoading = false;
      });
      _loadPaquetes();
    } else {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener la ubicación'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _loadPaquetes() async {
    final authViewModel = context.read<AuthViewModel>();
    final paqueteViewModel = context.read<PaqueteViewModel>();
    final usuario = authViewModel.usuario;

    if (usuario == null) return;

    // Cargar paquetes según rol (sin await porque son void)
    if (usuario.rol == AppConstants.rolCliente) {
      paqueteViewModel.cargarPaquetesPorCliente(usuario.id);
    } else if (usuario.rol == AppConstants.rolRepartidor) {
      paqueteViewModel.cargarPaquetesPorRepartidor(usuario.id);
    }
  }

  Future<void> _abrirEnMaps(double lat, double lng, String label) async {
    final url = Uri.parse('https://www.google.com/maps?q=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir Google Maps'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
    });

    if (_isTracking) {
      // Iniciar seguimiento continuo
      _locationService.watchLocation().listen((ubicacion) {
        if (mounted) {
          setState(() {
            _currentLocation = ubicacion;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentLocation == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 80,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(height: 16),
              const Text(
                'No se pudo obtener la ubicación',
                style: TextStyle(fontSize: 18, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _initializeLocation,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Ubicación'),
        backgroundColor: AppTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(_isTracking ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleTracking,
            tooltip: _isTracking
                ? 'Detener seguimiento'
                : 'Iniciar seguimiento',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeLocation,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card de ubicación actual
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.my_location,
                          color: AppTheme.primaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Mi Ubicación',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        if (_isTracking)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: AppTheme.successColor,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'En vivo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.successColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow(
                      'Latitud',
                      _currentLocation!.latitud.toStringAsFixed(6),
                      Icons.north,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Longitud',
                      _currentLocation!.longitud.toStringAsFixed(6),
                      Icons.east,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Actualizado',
                      _formatTimestamp(_currentLocation!.timestamp),
                      Icons.access_time,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _abrirEnMaps(
                          _currentLocation!.latitud,
                          _currentLocation!.longitud,
                          'Mi ubicación',
                        ),
                        icon: const Icon(Icons.map),
                        label: const Text('Ver en Google Maps'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Lista de paquetes
            Consumer<PaqueteViewModel>(
              builder: (context, paqueteViewModel, _) {
                final paquetes = paqueteViewModel.paquetes
                    .where((p) => p.estado != AppConstants.estadoEntregado)
                    .toList();

                if (paquetes.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 60,
                            color: AppTheme.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay paquetes pendientes',
                            style: TextStyle(
                              color: AppTheme.textSecondary.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        'Paquetes Pendientes (${paquetes.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    ...paquetes.map(
                      (paquete) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                paquete.estado == AppConstants.estadoPendiente
                                ? AppTheme.warningColor.withOpacity(0.2)
                                : AppTheme.secondaryColor.withOpacity(0.2),
                            child: Icon(
                              Icons.inventory_2,
                              color:
                                  paquete.estado == AppConstants.estadoPendiente
                                  ? AppTheme.warningColor
                                  : AppTheme.secondaryColor,
                            ),
                          ),
                          title: Text(
                            paquete.destinatario,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            paquete.direccion,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.map),
                            color: AppTheme.primaryColor,
                            onPressed: () {
                              // Por ahora usar ubicación actual como ejemplo
                              // En producción, los paquetes deberían tener coordenadas
                              _abrirEnMaps(
                                _currentLocation!.latitud,
                                _currentLocation!.longitud,
                                paquete.destinatario,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'Hace ${diff.inSeconds}s';
    } else if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
