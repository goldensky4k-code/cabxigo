import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cabxigo/models/location_model.dart';
import 'package:cabxigo/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  LocationModel? _pickupLocation;
  LocationModel? _dropLocation;
  LatLng? _userLocation;
  bool _isLoading = false;
  String? _error;

  // Getters
  LocationModel? get pickupLocation => _pickupLocation;
  LocationModel? get dropLocation => _dropLocation;
  LatLng? get userLocation => _userLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize and get current user location
  Future<void> initializeLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();
      if (location != null) {
        _userLocation = location;
        // Set pickup location as current location
        final address = await _locationService.getAddressFromCoordinates(location);
        _pickupLocation = LocationModel(
          placeName: address ?? 'Current Location',
          placeId: 'current_location',
          coordinates: location,
          address: address,
          latitude: location.latitude,
          longitude: location.longitude,
        );
      }
    } catch (e) {
      _error = 'Failed to get location: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set pickup location
  void setPickupLocation(LocationModel location) {
    _pickupLocation = location;
    notifyListeners();
  }

  /// Set drop location
  void setDropLocation(LocationModel location) {
    _dropLocation = location;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Swap pickup and drop locations
  void swapLocations() {
    final temp = _pickupLocation;
    _pickupLocation = _dropLocation;
    _dropLocation = temp;
    notifyListeners();
  }
}
