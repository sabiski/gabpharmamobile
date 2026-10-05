import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TypeMarqueurMaps { client, pharmacie, livreur }

/// Marqueurs personnalisés (bitmap colorés).
class MapsMarkers {
  MapsMarkers._();

  static final Map<TypeMarqueurMaps, BitmapDescriptor> _cache = {};

  static Future<BitmapDescriptor> descriptor(TypeMarqueurMaps type) async {
    final cached = _cache[type];
    if (cached != null) return cached;

    final Color color;
    final IconData icon;
    switch (type) {
      case TypeMarqueurMaps.client:
        color = Design.primaire;
        icon = Icons.home;
      case TypeMarqueurMaps.pharmacie:
        color = Design.secondaire;
        icon = Icons.local_pharmacy;
      case TypeMarqueurMaps.livreur:
        color = const Color(0xFF2563EB);
        icon = Icons.delivery_dining;
    }

    final bytes = await _dessinerMarqueur(color: color, icon: icon);
    final desc = BitmapDescriptor.bytes(bytes);
    _cache[type] = desc;
    return desc;
  }

  static Future<Uint8List> _dessinerMarqueur({
    required Color color,
    required IconData icon,
  }) async {
    const size = 96.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = const Offset(size / 2, size / 2 - 4);

    // Ombre
    canvas.drawCircle(
      const Offset(size / 2, size - 10),
      10,
      Paint()..color = const Color(0x33000000),
    );

    // Pin
    final path = Path()
      ..moveTo(center.dx, size - 14)
      ..quadraticBezierTo(size * 0.18, size * 0.55, size * 0.18, size * 0.38)
      ..arcToPoint(
        Offset(size * 0.82, size * 0.38),
        radius: const Radius.circular(size * 0.32),
        clockwise: true,
      )
      ..quadraticBezierTo(size * 0.82, size * 0.55, center.dx, size - 14)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawCircle(Offset(center.dx, size * 0.36), size * 0.18, Paint()..color = Colors.white);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 28,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        size * 0.36 - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}

/// Distance haversine (km) sans API.
double distanceKm(LatLng a, LatLng b) {
  const r = 6371.0;
  final dLat = _rad(b.latitude - a.latitude);
  final dLng = _rad(b.longitude - a.longitude);
  final lat1 = _rad(a.latitude);
  final lat2 = _rad(b.latitude);
  final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLng / 2) * math.sin(dLng / 2);
  return 2 * r * math.asin(math.sqrt(h));
}

double _rad(double deg) => deg * math.pi / 180;
