import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cabxigo/providers/location_provider.dart';
import 'package:cabxigo/providers/route_provider.dart';

class MapWidget extends StatefulWidget {
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({Key? key, required this.onMapCreated}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    widget.onMapCreated(controller);
    _updateMarkersAndPolylines();
  }

  void _updateMarkersAndPolylines() {
    _markers.clear();
    _polylines.clear();

    final locationProvider = context.read<LocationProvider>();
    final routeProvider = context.read<RouteProvider>();

    // Add pickup marker
    if (locationProvider.pickupLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: locationProvider.pickupLocation!.coordinates,
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: locationProvider.pickupLocation!.placeName,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add drop marker
    if (locationProvider.dropLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('drop'),
          position: locationProvider.dropLocation!.coordinates,
          infoWindow: InfoWindow(
            title: 'Drop',
            snippet: locationProvider.dropLocation!.placeName,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Add polyline if route exists
    if (routeProvider.polyline != null) {
      _polylines.add(routeProvider.polyline!);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationProvider, RouteProvider>(
      builder: (context, locationProvider, routeProvider, _) {
        // Update markers and polylines when providers change
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateMarkersAndPolylines();
        });

        final initialPosition = locationProvider.userLocation ??
            const LatLng(37.7749, -122.4194); // Default to San Francisco

        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 15,
          ),
          markers: _markers,
          polylines: _polylines,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          compassEnabled: true,
          trafficEnabled: false,
          indoorViewEnabled: true,
          mapType: MapType.normal,
        );
      },
    );
  }
}
