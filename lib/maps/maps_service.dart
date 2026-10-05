import 'package:gabpharmamobile/maps/maps_config.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class LieuSuggestion {
  final String description;
  final String placeId;
  final LatLng? position;

  const LieuSuggestion({
    required this.description,
    required this.placeId,
    this.position,
  });
}

class ItineraireMaps {
  final List<LatLng> points;
  final double distanceKm;
  final int dureeMinutes;
  final String resume;

  const ItineraireMaps({
    required this.points,
    required this.distanceKm,
    required this.dureeMinutes,
    required this.resume,
  });
}

/// Service localisation / géocodage / Directions.
class MapsService {
  MapsService._();
  static final MapsService instance = MapsService._();
  final Geocoding _geocoding = Geocoding();

  Future<bool> assurerPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return false;
    }
    final service = await Geolocator.isLocationServiceEnabled();
    return service;
  }

  Future<LatLng> positionClient({bool force = false}) async {
    final ok = await assurerPermission();
    if (!ok) {
      return const LatLng(MapsConfig.defaultLat, MapsConfig.defaultLng);
    }
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    return LatLng(pos.latitude, pos.longitude);
  }

  Future<String?> adresseDepuis(LatLng point) async {
    try {
      final list = await _geocoding.placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (list.isEmpty) return null;
      final p = list.first;
      return [
        p.street,
        p.subLocality,
        p.locality,
        p.country,
      ].whereType<String>().where((e) => e.trim().isNotEmpty).join(', ');
    } catch (_) {
      return null;
    }
  }

  /// Recherche d'adresses (geocoding forward). Places Autocomplete si clé OK.
  Future<List<LieuSuggestion>> rechercherLieux(String query) async {
    final q = query.trim();
    if (q.length < 3) return [];

    if (MapsConfig.cleConfiguree) {
      try {
        final uri = Uri.https(
          'maps.googleapis.com',
          '/maps/api/place/autocomplete/json',
          {
            'input': q,
            'key': MapsConfig.apiKey,
            'components': 'country:ga',
            'language': 'fr',
          },
        );
        final res = await http.get(uri);
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          final preds = (data['predictions'] as List?) ?? [];
          return preds.map((e) {
            final m = e as Map<String, dynamic>;
            return LieuSuggestion(
              description: m['description'] as String? ?? '',
              placeId: m['place_id'] as String? ?? '',
            );
          }).toList();
        }
      } catch (_) {}
    }

    // Fallback geocoding (sans Places API)
    try {
      final locations = await _geocoding.locationFromAddress('$q, Gabon');
      return locations
          .take(5)
          .map(
            (l) => LieuSuggestion(
              description: q,
              placeId: '${l.latitude},${l.longitude}',
              position: LatLng(l.latitude, l.longitude),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<LatLng?> detailsLieu(LieuSuggestion lieu) async {
    if (lieu.position != null) return lieu.position;
    if (!MapsConfig.cleConfiguree || lieu.placeId.isEmpty) return null;
    try {
      final uri = Uri.https(
        'maps.googleapis.com',
        '/maps/api/place/details/json',
        {
          'place_id': lieu.placeId,
          'fields': 'geometry',
          'key': MapsConfig.apiKey,
        },
      );
      final res = await http.get(uri);
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final loc = data['result']?['geometry']?['location'];
      if (loc == null) return null;
      return LatLng(
        (loc['lat'] as num).toDouble(),
        (loc['lng'] as num).toDouble(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Itinéraire Google Directions (polyline). Fallback = ligne droite.
  Future<ItineraireMaps> itineraire({
    required LatLng origin,
    required LatLng destination,
  }) async {
    if (MapsConfig.cleConfiguree) {
      try {
        final uri = Uri.https(
          'maps.googleapis.com',
          '/maps/api/directions/json',
          {
            'origin': '${origin.latitude},${origin.longitude}',
            'destination':
                '${destination.latitude},${destination.longitude}',
            'mode': 'driving',
            'language': 'fr',
            'key': MapsConfig.apiKey,
          },
        );
        final res = await http.get(uri);
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body) as Map<String, dynamic>;
          final routes = data['routes'] as List?;
          if (routes != null && routes.isNotEmpty) {
            final route = routes.first as Map<String, dynamic>;
            final overview = route['overview_polyline']?['points'] as String?;
            final leg = (route['legs'] as List).first as Map<String, dynamic>;
            final distM = (leg['distance']?['value'] as num?)?.toDouble() ?? 0;
            final durS = (leg['duration']?['value'] as num?)?.toInt() ?? 0;
            final points = overview != null
                ? _decodePolyline(overview)
                : [origin, destination];
            return ItineraireMaps(
              points: points,
              distanceKm: distM / 1000,
              dureeMinutes: (durS / 60).round(),
              resume: leg['duration']?['text'] as String? ?? '',
            );
          }
        }
      } catch (_) {}
    }

    // Fallback sans clé API
    final d = Geolocator.distanceBetween(
          origin.latitude,
          origin.longitude,
          destination.latitude,
          destination.longitude,
        ) /
        1000;
    return ItineraireMaps(
      points: [origin, destination],
      distanceKm: d,
      dureeMinutes: (d / 0.4).round().clamp(5, 120),
      resume: 'Estimation locale',
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    var index = 0;
    var lat = 0;
    var lng = 0;
    while (index < encoded.length) {
      var shift = 0;
      var result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }
}
