import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final List<LatLng> polylinePoints;
  final double distance; // in kilometers
  final double duration; // in minutes
  final String durationText;
  final String distanceText;

  RouteModel({
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.durationText,
    required this.distanceText,
  });

  double get estimatedFare {
    // Fare calculation: Base fare + distance fare + time fare
    const double baseFare = 2.0; // Base fare in USD
    const double distanceFarePerKm = 1.5; // Per km fare
    const double timeFarePerMin = 0.25; // Per minute fare

    double distanceFare = distance * distanceFarePerKm;
    double timeFare = duration * timeFarePerMin;
    double totalFare = baseFare + distanceFare + timeFare;

    // Round to nearest 0.5
    return (totalFare * 2).roundToDouble() / 2;
  }

  String get estimatedFareText => '\$${estimatedFare.toStringAsFixed(2)}';
}
