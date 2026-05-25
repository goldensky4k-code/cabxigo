import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cabxigo/models/route_model.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class MapsServiceImpl {
  static final MapsServiceImpl _instance = MapsServiceImpl._internal();
  static const String _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key

  factory MapsServiceImpl() {
    return _instance;
  }

  MapsServiceImpl._internal();

  /// Calculate route between two points
  Future<RouteModel?> getRoute(LatLng origin, LatLng destination) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${origin.latitude},${origin.longitude}'
          '&destination=${destination.latitude},${destination.longitude}'
          '&key=$_googleMapsApiKey';

      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final results = json['routes'][0];
        final legs = results['legs'][0];

        // Extract distance and duration
        final distance = legs['distance']['value'] / 1000; // Convert to km
        final duration = legs['duration']['value'] / 60; // Convert to minutes
        final durationText = legs['duration']['text'];
        final distanceText = legs['distance']['text'];

        // Decode polyline
        final List<LatLng> polylinePoints = _decodePolyline(results['overview_polyline']['points']);

        return RouteModel(
          polylinePoints: polylinePoints,
          distance: distance,
          duration: duration,
          durationText: durationText,
          distanceText: distanceText,
        );
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      print('Error getting route: $e');
      return null;
    }
  }

  /// Decode polyline from Google Maps API
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, lat = 0, lng = 0;

    while (index < polyline.length) {
      int result = 0;
      int shift = 0;
      int b;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      result = 0;
      shift = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  /// Calculate distance between two coordinates using Haversine formula
  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Radius of the earth in km
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLon = _degreesToRadians(end.longitude - start.longitude);
    double a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            (sin(dLon / 2) * sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
