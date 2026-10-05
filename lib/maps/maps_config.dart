/// Clé Google Maps — à remplacer par ta clé (Maps SDK Android/iOS + Directions + Geocoding).
///
/// Android : aussi dans AndroidManifest (meta-data com.google.android.geo.API_KEY)
/// iOS : aussi dans AppDelegate (GMSServices.provideAPIKey)
///
/// Ou lance avec :
/// flutter run --dart-define=GOOGLE_MAPS_API_KEY=ta_cle
class MapsConfig {
  MapsConfig._();

  static const String apiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'YOUR_GOOGLE_MAPS_API_KEY',
  );

  static bool get cleConfiguree =>
      apiKey.isNotEmpty && apiKey != 'YOUR_GOOGLE_MAPS_API_KEY';

  /// Libreville (centre Gabon) — fallback si GPS indisponible.
  static const double defaultLat = 0.4162;
  static const double defaultLng = 9.4673;
  static const double defaultZoom = 13;
}
