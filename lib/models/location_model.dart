import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  final String placeName;
  final String placeId;
  final LatLng coordinates;
  final String? address;
  final double? latitude;
  final double? longitude;

  LocationModel({
    required this.placeName,
    required this.placeId,
    required this.coordinates,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      placeName: json['name'] ?? '',
      placeId: json['place_id'] ?? '',
      coordinates: LatLng(
        json['geometry']['location']['lat'],
        json['geometry']['location']['lng'],
      ),
      address: json['formatted_address'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
    );
  }

  @override
  String toString() => 'LocationModel(placeName: $placeName, coordinates: $coordinates)';
}
