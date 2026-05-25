# Cabxigo - Flutter Taxi Booking App

A modern, feature-rich Flutter taxi booking application with Google Maps integration, route optimization, and dynamic fare estimation.

## Features

✅ **Home Screen with Google Maps** - Interactive map with current location tracking
✅ **Location Selection** - Easy pickup and drop-off point selection
✅ **Route Drawing** - Visual polyline between pickup and destination
✅ **Fare Estimation** - Dynamic fare calculation based on:
   - Base fare
   - Distance traveled
   - Estimated travel time

✅ **Clean Modern UI** - Material Design 3 with smooth animations
✅ **Real-time Updates** - Location and route updates using providers
✅ **Marker Management** - Color-coded markers (blue for pickup, red for drop)

## Project Structure

```
cabxigo/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── theme/
│   │   └── app_theme.dart        # Theme configuration
│   ├── models/
│   │   ├── location_model.dart   # Location data model
│   │   └── route_model.dart      # Route and fare model
│   ├── services/
│   │   ├── location_service.dart # Location services
│   │   └── maps_service_impl.dart # Maps and routing services
│   ├── providers/
│   │   ├── location_provider.dart # Location state management
│   │   └── route_provider.dart   # Route state management
│   ├── screens/
│   │   └── home_screen.dart      # Main home screen
│   └── widgets/
│       ├── map_widget.dart       # Google Map widget
│       ├── location_selection_card.dart  # Location card widget
│       └── fare_card.dart        # Fare details card
└── pubspec.yaml                  # Dependencies
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Google Maps API Key
- Android Studio / Xcode (for emulator)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/goldensky4k-code/cabxigo.git
   cd cabxigo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Google Maps API Key**
   
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project
   - Enable Maps SDK for Android and iOS
   - Create an API key
   - Update the API key in `lib/services/maps_service_impl.dart`:
   ```dart
   static const String _googleMapsApiKey = 'YOUR_API_KEY';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### Android Setup

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Add your Google Maps API key to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY" />
```

### iOS Setup

Add to `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to show it on the map</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs your location to show it on the map</string>
```

## Dependencies

- **google_maps_flutter** - Google Maps integration
- **geolocator** - Location services
- **geocoding** - Address to coordinates conversion
- **provider** - State management
- **intl** - Internationalization
- **flutter_svg** - SVG support
- **lottie** - Animations
- **http** - HTTP requests for API calls

## How It Works

### 1. Location Selection
- Users can select pickup and drop-off locations
- Locations are managed through `LocationProvider`
- Current location is automatically detected on app start

### 2. Route Calculation
- When both locations are selected, Google Directions API calculates the route
- `RouteProvider` manages route state and polyline data
- Route is displayed as a polyline on the map

### 3. Fare Estimation
- **Base Fare**: $2.00 (starting fare)
- **Distance Fare**: $1.50 per km
- **Time Fare**: $0.25 per minute
- **Formula**: Base Fare + (Distance × $1.50) + (Duration × $0.25)

### 4. UI Updates
- Markers update in real-time as locations change
- Fare card appears after route is calculated
- Clean card-based design for easy interaction

## Architecture

The app follows **Clean Architecture** principles with:
- **Models** - Data structures
- **Services** - Business logic and API calls
- **Providers** - State management (Provider pattern)
- **Widgets** - UI components
- **Screens** - Full page layouts

## Future Enhancements

- [ ] Driver acceptance and tracking
- [ ] Real-time driver location updates
- [ ] Payment gateway integration
- [ ] Booking history
- [ ] Driver reviews and ratings
- [ ] Multiple vehicle options (Eco, Comfort, Premium)
- [ ] Promo codes and discounts
- [ ] Dark mode support
- [ ] Push notifications
- [ ] Ride sharing option

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@cabxigo.com or open an issue in the GitHub repository.

---

**Made with ❤️ by Cabxigo Team**
