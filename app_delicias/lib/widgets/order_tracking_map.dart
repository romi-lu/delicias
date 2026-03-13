import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/location_service.dart';

class OrderTrackingMap extends StatefulWidget {
  final LatLng? destination;
  final LatLng? store;
  final double height;

  const OrderTrackingMap({
    super.key,
    required this.destination,
    this.store,
    this.height = 220,
  });

  @override
  State<OrderTrackingMap> createState() => _OrderTrackingMapState();
}

class _OrderTrackingMapState extends State<OrderTrackingMap> {
  final _location = LocationService();
  final Completer<GoogleMapController> _controller = Completer();

  StreamSubscription? _sub;
  LatLng? _courier;
  Object? _error;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    try {
      await _location.ensurePermissions();

      final last = await _location.lastKnown();
      if (mounted && last != null) {
        setState(() => _courier = LatLng(last.latitude, last.longitude));
      }

      _sub = _location
          .stream(accuracy: LocationAccuracy.high, distanceFilterMeters: 15)
          .listen((p) async {
        final next = LatLng(p.latitude, p.longitude);
        if (!mounted) return;
        setState(() {
          _courier = next;
          _error = null;
          _ready = true;
        });
        await _fitBoundsIfPossible();
      });

      if (mounted) setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _ready = true;
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _fitBoundsIfPossible() async {
    final controller = await _controller.future;
    final points = <LatLng>[
      if (widget.store != null) widget.store!,
      if (widget.destination != null) widget.destination!,
      if (_courier != null) _courier!,
    ];
    if (points.length < 2) return;

    double? minLat, maxLat, minLng, maxLng;
    for (final p in points) {
      minLat = (minLat == null) ? p.latitude : (p.latitude < minLat ? p.latitude : minLat);
      maxLat = (maxLat == null) ? p.latitude : (p.latitude > maxLat ? p.latitude : maxLat);
      minLng = (minLng == null) ? p.longitude : (p.longitude < minLng ? p.longitude : minLng);
      maxLng = (maxLng == null) ? p.longitude : (p.longitude > maxLng ? p.longitude : maxLng);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );

    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 56));
  }

  @override
  Widget build(BuildContext context) {
    final dest = widget.destination;
    if (dest == null) {
      return _card(
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Text('No hay ubicación de entrega para mostrar en el mapa.'),
        ),
      );
    }

    if (!_ready) {
      return _card(
        child: const SizedBox(
          height: 220,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_error != null) {
      return _card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('No se pudo acceder a la ubicación.'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () => _location.openLocationSettings(),
                    child: const Text('Activar ubicación'),
                  ),
                  OutlinedButton(
                    onPressed: () => _location.openAppSettings(),
                    child: const Text('Permisos'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('dest'),
        position: dest,
        infoWindow: const InfoWindow(title: 'Entrega'),
      ),
      if (widget.store != null)
        Marker(
          markerId: const MarkerId('store'),
          position: widget.store!,
          infoWindow: const InfoWindow(title: 'Tienda'),
        ),
      if (_courier != null)
        Marker(
          markerId: const MarkerId('courier'),
          position: _courier!,
          infoWindow: const InfoWindow(title: 'Repartidor'),
        ),
    };

    final polylinePoints = <LatLng>[
      if (widget.store != null) widget.store!,
      if (_courier != null) _courier!,
      dest,
    ];

    final polylines = <Polyline>{
      if (polylinePoints.length >= 2)
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylinePoints,
          width: 5,
          color: Colors.brown,
        ),
    };

    final initialTarget = _courier ?? dest;

    return _card(
      child: SizedBox(
        height: widget.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markers,
            polylines: polylines,
            initialCameraPosition: CameraPosition(target: initialTarget, zoom: 14),
            onMapCreated: (c) async {
              if (!_controller.isCompleted) _controller.complete(c);
              await _fitBoundsIfPossible();
            },
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(blurRadius: 18, color: Color(0x14000000), offset: Offset(0, 8))],
      ),
      child: child,
    );
  }
}

