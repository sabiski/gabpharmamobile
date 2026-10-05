import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/maps/maps_config.dart';
import 'package:gabpharmamobile/maps/maps_markers.dart';
import 'package:gabpharmamobile/maps/maps_service.dart';
import 'package:gabpharmamobile/maps/maps_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PointCarte {
  final String id;
  final String titre;
  final String? sousTitre;
  final LatLng position;
  final TypeMarqueurMaps type;

  const PointCarte({
    required this.id,
    required this.titre,
    required this.position,
    required this.type,
    this.sousTitre,
  });
}

/// Carte Google Maps réutilisable (suivi, pharmacies, recherche).
class CarteGabPharma extends StatefulWidget {
  final List<PointCarte> points;
  final LatLng? origineItineraire;
  final LatLng? destinationItineraire;
  final bool afficherDistance;
  final bool myLocationEnabled;
  final double height;
  final bool pleinEcran;
  final void Function(LatLng)? onTapCarte;
  final void Function(PointCarte)? onTapMarqueur;

  const CarteGabPharma({
    super.key,
    this.points = const [],
    this.origineItineraire,
    this.destinationItineraire,
    this.afficherDistance = true,
    this.myLocationEnabled = true,
    this.height = 220,
    this.pleinEcran = false,
    this.onTapCarte,
    this.onTapMarqueur,
  });

  @override
  State<CarteGabPharma> createState() => _CarteGabPharmaState();
}

class _CarteGabPharmaState extends State<CarteGabPharma> {
  GoogleMapController? _controller;
  final _markers = <Marker>{};
  final _polylines = <Polyline>{};
  ItineraireMaps? _itineraire;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _preparer();
  }

  @override
  void didUpdateWidget(covariant CarteGabPharma oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.points != widget.points ||
        oldWidget.origineItineraire != widget.origineItineraire ||
        oldWidget.destinationItineraire != widget.destinationItineraire) {
      _preparer();
    }
  }

  Future<void> _preparer() async {
    setState(() => _loading = true);
    final markers = <Marker>{};

    for (final p in widget.points) {
      final icon = await MapsMarkers.descriptor(p.type);
      markers.add(
        Marker(
          markerId: MarkerId(p.id),
          position: p.position,
          icon: icon,
          infoWindow: InfoWindow(title: p.titre, snippet: p.sousTitre),
          onTap: () => widget.onTapMarqueur?.call(p),
        ),
      );
    }

    ItineraireMaps? itineraire;
    final polylines = <Polyline>{};
    final o = widget.origineItineraire;
    final d = widget.destinationItineraire;
    if (o != null && d != null) {
      itineraire = await MapsService.instance.itineraire(
        origin: o,
        destination: d,
      );
      polylines.add(
        Polyline(
          polylineId: const PolylineId('itineraire'),
          points: itineraire.points,
          color: Design.primaire,
          width: 5,
          patterns: const [],
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _markers
        ..clear()
        ..addAll(markers);
      _polylines
        ..clear()
        ..addAll(polylines);
      _itineraire = itineraire;
      _loading = false;
    });

    await _fitBounds();
  }

  Future<void> _fitBounds() async {
    final c = _controller;
    if (c == null) return;
    final pts = <LatLng>[
      ...widget.points.map((e) => e.position),
      if (widget.origineItineraire != null) widget.origineItineraire!,
      if (widget.destinationItineraire != null) widget.destinationItineraire!,
      ...?_itineraire?.points,
    ];
    if (pts.isEmpty) return;
    if (pts.length == 1) {
      await c.animateCamera(
        CameraUpdate.newLatLngZoom(pts.first, 14),
      );
      return;
    }
    var minLat = pts.first.latitude;
    var maxLat = pts.first.latitude;
    var minLng = pts.first.longitude;
    var maxLng = pts.first.longitude;
    for (final p in pts) {
      minLat = minLat < p.latitude ? minLat : p.latitude;
      maxLat = maxLat > p.latitude ? maxLat : p.latitude;
      minLng = minLng < p.longitude ? minLng : p.longitude;
      maxLng = maxLng > p.longitude ? maxLng : p.longitude;
    }
    await c.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        56,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.points.isNotEmpty
        ? widget.points.first.position
        : const LatLng(MapsConfig.defaultLat, MapsConfig.defaultLng);

    final map = ClipRRect(
      borderRadius: widget.pleinEcran
          ? BorderRadius.zero
          : BorderRadius.circular(Design.radiusMd),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initial,
              zoom: MapsConfig.defaultZoom,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: widget.myLocationEnabled,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
            style: MapsStyle.gabPharmaClair,
            onMapCreated: (controller) async {
              _controller = controller;
              await _fitBounds();
            },
            onTap: widget.onTapCarte,
          ),
          if (_loading)
            const Positioned.fill(
              child: ColoredBox(
                color: Color(0x66FFFFFF),
                child: Center(
                  child: CircularProgressIndicator(color: Design.primaire),
                ),
              ),
            ),
          if (widget.afficherDistance && _itineraire != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: _BandeauDistance(itineraire: _itineraire!),
            ),
          if (!MapsConfig.cleConfiguree)
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Design.attention.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Clé Google Maps non configurée — mode démo (Libreville).',
                  style: Design.caption.copyWith(
                    color: Design.blanc,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (widget.pleinEcran) return map;
    return SizedBox(height: widget.height, width: double.infinity, child: map);
  }
}

class _BandeauDistance extends StatelessWidget {
  final ItineraireMaps itineraire;

  const _BandeauDistance({required this.itineraire});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      color: Design.blanc,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.route, color: Design.primaire, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${itineraire.distanceKm.toStringAsFixed(1)} km · ~${itineraire.dureeMinutes} min',
                style: Design.body2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Design.texte,
                ),
              ),
            ),
            if (itineraire.resume.isNotEmpty)
              Text(
                itineraire.resume,
                style: Design.caption.copyWith(color: Design.texteSecondaire),
              ),
          ],
        ),
      ),
    );
  }
}
