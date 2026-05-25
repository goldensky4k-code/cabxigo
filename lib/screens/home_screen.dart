import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cabxigo/models/location_model.dart';
import 'package:cabxigo/providers/location_provider.dart';
import 'package:cabxigo/providers/route_provider.dart';
import 'package:cabxigo/widgets/map_widget.dart';
import 'package:cabxigo/widgets/location_selection_card.dart';
import 'package:cabxigo/widgets/fare_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  bool _showFareCard = false;

  @override
  void initState() {
    super.initState();
    // Initialize location when screen loads
    Future.microtask(() {
      context.read<LocationProvider>().initializeLocation();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _handleCalculateRoute() {
    final locationProvider = context.read<LocationProvider>();
    final routeProvider = context.read<RouteProvider>();

    if (locationProvider.pickupLocation != null &&
        locationProvider.dropLocation != null) {
      routeProvider.calculateRoute(
        locationProvider.pickupLocation!.coordinates,
        locationProvider.dropLocation!.coordinates,
      );
      setState(() {
        _showFareCard = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both pickup and drop locations')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Widget
          MapWidget(onMapCreated: _onMapCreated),

          // Top Location Selection Cards
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: Column(
              children: [
                LocationSelectionCard(
                  icon: Icons.location_on,
                  title: 'Pickup Location',
                  onTap: () => _showLocationPicker(context, isPickup: true),
                  isPickup: true,
                ),
                const SizedBox(height: 12),
                LocationSelectionCard(
                  icon: Icons.location_on_outlined,
                  title: 'Drop Location',
                  onTap: () => _showLocationPicker(context, isPickup: false),
                  isPickup: false,
                ),
              ],
            ),
          ),

          // Swap Button
          Positioned(
            top: 160,
            right: 30,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.read<LocationProvider>().swapLocations();
                  },
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.swap_vert_circle,
                      color: Color(0xFF1F77F3),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Buttons and Fare Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Consumer<RouteProvider>(
              builder: (context, routeProvider, _) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_showFareCard && routeProvider.route != null)
                        FareCard(route: routeProvider.route!)
                      else if (routeProvider.isLoading)
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1F77F3),
                            ),
                          ),
                        )
                      else if (routeProvider.error != null)
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            routeProvider.error!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _handleCalculateRoute,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1F77F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Estimate Fare',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker(BuildContext context, {required bool isPickup}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LocationPickerSheet(
        isPickup: isPickup,
        onLocationSelected: (location) {
          if (isPickup) {
            context.read<LocationProvider>().setPickupLocation(location);
          } else {
            context.read<LocationProvider>().setDropLocation(location);
          }
          Navigator.pop(context);
        },
      ),
    );
  }
}

class LocationPickerSheet extends StatefulWidget {
  final bool isPickup;
  final Function(LocationModel) onLocationSelected;

  const LocationPickerSheet({
    Key? key,
    required this.isPickup,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationModel> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.isPickup ? 'Select Pickup Location' : 'Select Drop Location',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                // In a real app, you would call a location search API
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            if (_searchResults.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Type to search for locations',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final location = _searchResults[index];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(location.placeName),
                    subtitle: Text(location.address ?? ''),
                    onTap: () => widget.onLocationSelected(location),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
