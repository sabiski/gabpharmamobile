import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/maps/maps_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Champ de recherche d'adresses / lieux.
class RechercheLieuField extends StatefulWidget {
  final String hint;
  final void Function(LatLng position, String label) onSelection;

  const RechercheLieuField({
    super.key,
    required this.onSelection,
    this.hint = 'Rechercher une adresse…',
  });

  @override
  State<RechercheLieuField> createState() => _RechercheLieuFieldState();
}

class _RechercheLieuFieldState extends State<RechercheLieuField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  List<LieuSuggestion> _suggestions = [];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _onChanged(String value) async {
    if (value.trim().length < 3) {
      setState(() => _suggestions = []);
      return;
    }
    setState(() => _loading = true);
    final list = await MapsService.instance.rechercherLieux(value);
    if (!mounted) return;
    setState(() {
      _suggestions = list;
      _loading = false;
    });
  }

  Future<void> _select(LieuSuggestion s) async {
    final pos = await MapsService.instance.detailsLieu(s);
    if (pos == null || !mounted) return;
    _controller.text = s.description;
    setState(() => _suggestions = []);
    _focus.unfocus();
    widget.onSelection(pos, s.description);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focus,
          onChanged: _onChanged,
          style: Design.body1,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: Design.body2,
            filled: true,
            fillColor: Design.blanc,
            prefixIcon: const Icon(Icons.search, color: Design.texteSecondaire),
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : (_controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() => _suggestions = []);
                        },
                        icon: const Icon(Icons.close, size: 18),
                      )
                    : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Design.radiusMd),
              borderSide: const BorderSide(color: Design.bordure),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Design.radiusMd),
              borderSide: const BorderSide(color: Design.bordure),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Design.radiusMd),
              borderSide: const BorderSide(color: Design.primaire),
            ),
          ),
        ),
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Design.blanc,
              borderRadius: BorderRadius.circular(Design.radiusMd),
              border: Border.all(color: Design.bordure),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Design.bordure),
              itemBuilder: (context, index) {
                final s = _suggestions[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.place_outlined,
                    color: Design.primaire,
                    size: 20,
                  ),
                  title: Text(s.description, style: Design.body2),
                  onTap: () => _select(s),
                );
              },
            ),
          ),
      ],
    );
  }
}
