import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cabxigo/models/route_model.dart';
import 'package:cabxigo/services/maps_service_impl.dart';

class RouteProvider extends ChangeNotifier {
  final MapsServiceImpl _mapsService = MapsServiceImpl();

  RouteModel? _route;
  bool _isLoading = false;
  String? _error;
  Polyline? _polyline;

  // Getters
  RouteModel? get route => _route;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Polyline? get polyline => _polyline;

  /// Calculate route between two points
  Future<void> calculateRoute(LatLng origin, LatLng destination) async {
    _isLoading = true;
    _error = null;
    _route = null;
    _polyline = null;
    notifyListeners();

    try {
      final route = await _mapsService.getRoute(origin, destination);
      if (route != null) {
        _route = route;
        // Create polyline for the route
        _polyline = Polyline(
          polylineId: const PolylineId('route'),
          points: route.polylinePoints,
          color: const Color(0xFF1F77F3),
          width: 5,
          geodesic: true,
        );
      } else {
        _error = 'Unable to calculate route';
      }
    } catch (e) {
      _error = 'Error calculating route: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear route
  void clearRoute() {
    _route = null;
    _polyline = null;
    _error = null;
    notifyListeners();
  }
}
