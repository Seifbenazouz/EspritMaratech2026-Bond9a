import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Résultat du choix du lieu (adresse + coordonnées).
class LieuPickerResult {
  final String lieu;
  final double latitude;
  final double longitude;

  const LieuPickerResult({
    required this.lieu,
    required this.latitude,
    required this.longitude,
  });
}

/// Écran pour choisir un lieu sur la carte (OpenStreetMap).
/// Un tap sur la carte place un marqueur et récupère l'adresse (géocodage inverse).
class LieuPickerScreen extends StatefulWidget {
  /// Position initiale (ex. Tunis).
  final LatLng? initialCenter;
  /// Coordonnées déjà sélectionnées (affiche le marqueur au départ).
  final double? initialLat;
  final double? initialLng;

  const LieuPickerScreen({
    super.key,
    this.initialCenter,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<LieuPickerScreen> createState() => _LieuPickerScreenState();
}

class _LieuPickerScreenState extends State<LieuPickerScreen> {
  static const _defaultCenter = LatLng(36.8065, 10.1815); // Tunis
  final MapController _mapController = MapController();
  LatLng? _selectedPoint;
  String? _selectedAddress;
  bool _loadingAddress = false;
  String? _error;

  LatLng get _center {
    if (widget.initialLat != null && widget.initialLng != null) {
      return LatLng(widget.initialLat!, widget.initialLng!);
    }
    return widget.initialCenter ?? _defaultCenter;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedPoint = LatLng(widget.initialLat!, widget.initialLng!);
      _fetchAddress(_selectedPoint!);
    }
  }

  Future<void> _fetchAddress(LatLng point) async {
    setState(() {
      _loadingAddress = true;
      _error = null;
    });
    try {
      // Nominatim (OpenStreetMap) - géocodage inverse. User-Agent requis.
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?'
        'lat=${point.latitude}&lon=${point.longitude}&format=json',
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'RunningClubTunis/1.0'},
      );
      if (!mounted) return;
      if (response.statusCode != 200) {
        setState(() {
          _loadingAddress = false;
          _error = 'Impossible de récupérer l\'adresse';
          _selectedAddress = '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
        });
        return;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final displayName = data['display_name'] as String? ?? '${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}';
      setState(() {
        _selectedAddress = displayName;
        _loadingAddress = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingAddress = false;
        _error = e.toString().replaceFirst('Exception: ', '');
        _selectedAddress = _selectedPoint != null
            ? '${_selectedPoint!.latitude.toStringAsFixed(5)}, ${_selectedPoint!.longitude.toStringAsFixed(5)}'
            : null;
      });
    }
  }

  void _onTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _selectedPoint = point;
      _error = null;
    });
    _fetchAddress(point);
  }

  void _confirm() {
    if (_selectedPoint == null || _selectedAddress == null) return;
    Navigator.of(context).pop(LieuPickerResult(
      lieu: _selectedAddress!,
      latitude: _selectedPoint!.latitude,
      longitude: _selectedPoint!.longitude,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choisir le lieu sur la carte'),
        actions: [
          if (_selectedPoint != null && _selectedAddress != null)
            TextButton.icon(
              onPressed: _loadingAddress ? null : _confirm,
              icon: const Icon(Icons.check),
              label: const Text('Valider'),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 14,
                onTap: _onTap,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // OSM bloque "com.example.app" et les User-Agent non identifiés (policy tile.openstreetmap.org)
                  userAgentPackageName: 'tn.runningclubtunis.app',
                ),
                if (_selectedPoint != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedPoint!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.place,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Material(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Appuyez sur la carte pour placer le lieu de rencontre',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (_loadingAddress)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: LinearProgressIndicator(),
                    ),
                  if (_selectedAddress != null && !_loadingAddress) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.place, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _selectedAddress!,
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
