import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/maps/controller_cartes.dart';
import 'package:gabpharmamobile/maps/widgets/carte_gabpharma.dart';
import 'package:gabpharmamobile/maps/widgets/recherche_lieu.dart';
import 'package:get/get.dart';

class Pharmacies extends StatelessWidget {
  const Pharmacies({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ControllerCartePharmacies());

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        backgroundColor: Design.blanc,
        surfaceTintColor: Design.blanc,
        title: Text(
          'Pharmacies à proximité',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (c.isLoading.value && c.pharmacies.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Design.primaire),
          );
        }
        final points = c.tousLesPoints
            .map(
              (p) => PointCarte(
                id: p.id,
                titre: p.titre,
                sousTitre: p.sousTitre,
                position: p.position,
                type: p.type,
              ),
            )
            .toList();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: RechercheLieuField(
                hint: 'Rechercher une adresse ou un quartier…',
                onSelection: (pos, label) {
                  c.client.value = pos;
                  Get.snackbar(
                    'Position',
                    label,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                  child: CarteGabPharma(
                    points: points,
                    pleinEcran: true,
                    afficherDistance: false,
                    onTapMarqueur: (p) {
                      PointCarteData? match;
                      for (final e in c.pharmacies) {
                        if (e.id == p.id) {
                          match = e;
                          break;
                        }
                      }
                      if (match != null) c.selectionner(match);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: c.pharmacies.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final p = c.pharmacies[index];
                  final dist = c.distanceVers(p);
                  final selected = c.selection.value?.id == p.id;
                  return Material(
                    color: Design.blanc,
                    borderRadius: BorderRadius.circular(Design.radiusMd),
                    child: InkWell(
                      onTap: () => c.selectionner(p),
                      borderRadius: BorderRadius.circular(Design.radiusMd),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Design.radiusMd),
                          border: Border.all(
                            color: selected
                                ? Design.primaire
                                : Design.bordure,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Design.surface,
                                borderRadius:
                                    BorderRadius.circular(Design.radiusSm),
                              ),
                              child: const Icon(
                                Icons.local_pharmacy,
                                color: Design.secondaire,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.titre,
                                    style: Design.body1.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    p.sousTitre ?? '',
                                    style: Design.caption,
                                  ),
                                  if (dist != null)
                                    Text(
                                      'À ${dist.toStringAsFixed(1)} km',
                                      style: Design.caption.copyWith(
                                        color: Design.primaire,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: Design.texteSecondaire,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
