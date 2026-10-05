import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_mission.dart';
import 'package:get/get.dart';

/// Véhicules et documents livreur.
class VehiculeDocumentsLivreur extends StatefulWidget {
  const VehiculeDocumentsLivreur({super.key});

  @override
  State<VehiculeDocumentsLivreur> createState() =>
      _VehiculeDocumentsLivreurState();
}

class _VehiculeDocumentsLivreurState extends State<VehiculeDocumentsLivreur> {
  int _onglet = 0; // 0 véhicule, 1 documents

  @override
  Widget build(BuildContext context) {
    final liv = Get.find<ControllerLivraisonLivreur>();

    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: Column(
          children: [
            EnteteLivreur(onUrgence: liv.urgence),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  Design.s16,
                  Design.s8,
                  Design.s16,
                  Design.s24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.two_wheeler,
                            color: Design.primaire,
                          ),
                        ),
                        const SizedBox(width: Design.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Véhicules et documents',
                                style: Design.h2,
                              ),
                              Text(
                                'Gérez vos véhicules et maintenez vos documents à jour.',
                                style: Design.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Design.s16),
                    Row(
                      children: [
                        Expanded(
                          child: _SegTab(
                            icone: Icons.directions_car_outlined,
                            label: 'Véhicule',
                            actif: _onglet == 0,
                            onTap: () => setState(() => _onglet = 0),
                          ),
                        ),
                        Expanded(
                          child: _SegTab(
                            icone: Icons.description_outlined,
                            label: 'Documents',
                            actif: _onglet == 1,
                            onTap: () => setState(() => _onglet = 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Design.s16),
                    if (_onglet == 0) _sectionVehicule() else _sectionDocuments(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionVehicule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Mon véhicule principal',
          style: Design.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Design.s8),
        Container(
          padding: const EdgeInsets.all(Design.s16),
          decoration: BoxDecoration(
            color: Design.blanc,
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(color: Design.bordure),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(Design.radiusPill),
                ),
                child: Text(
                  'Véhicule actif',
                  style: Design.caption.copyWith(
                    color: Design.secondaire,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: Design.s12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.two_wheeler,
                      size: 40,
                      color: Design.texte,
                    ),
                  ),
                  const SizedBox(width: Design.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yamaha XTZ 125',
                          style: Design.body1.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.pin_outlined,
                              size: 14,
                              color: Design.texteSecondaire,
                            ),
                            const SizedBox(width: 4),
                            Text('GA-123-AA', style: Design.caption),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F3FF),
                                borderRadius: BorderRadius.circular(
                                  Design.radiusPill,
                                ),
                              ),
                              child: Text(
                                'Moto',
                                style: Design.caption.copyWith(
                                  color: Design.primaire,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'No. Châssis : 9C6KE0920L0001234',
                          style: Design.caption,
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Get.snackbar(
                        'Modifier',
                        'Édition véhicule à brancher.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: Text(
                      'Modifier',
                      style: Design.caption.copyWith(color: Design.primaire),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Design.s16),
              Row(
                children: const [
                  Expanded(
                    child: _Spec(
                      icone: Icons.calendar_today_outlined,
                      label: 'Année',
                      valeur: '2021',
                    ),
                  ),
                  Expanded(
                    child: _Spec(
                      icone: Icons.water_drop_outlined,
                      label: 'Carburant',
                      valeur: 'Essence',
                    ),
                  ),
                  Expanded(
                    child: _Spec(
                      icone: Icons.speed,
                      label: 'Cylindrée',
                      valeur: '125 cc',
                    ),
                  ),
                  Expanded(
                    child: _Spec(
                      icone: Icons.palette_outlined,
                      label: 'Couleur',
                      valeur: 'Noir',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: Design.s16),
        OutlinedButton(
          onPressed: () {
            Get.snackbar(
              'Véhicule',
              'Ajout d\'un véhicule à brancher.',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Design.primaire,
            side: const BorderSide(color: Design.primaire),
            minimumSize: const Size.fromHeight(48),
          ),
          child: const Text('+ Ajouter un autre véhicule'),
        ),
        const SizedBox(height: Design.s16),
        _alerteDocuments(),
      ],
    );
  }

  Widget _sectionDocuments() {
    const docs = [
      _Doc(
        'Permis de conduire',
        'PC-2024-8841',
        '31/12/2027',
        Icons.badge_outlined,
        Design.secondaire,
      ),
      _Doc(
        'Assurance',
        'ASS-GA-5521',
        '15/06/2026',
        Icons.shield_outlined,
        Design.information,
      ),
      _Doc(
        'Carte grise',
        'CG-9C6KE092',
        '—',
        Icons.description_outlined,
        Design.primaire,
      ),
      _Doc(
        'Contrôle technique',
        'CT-2025-011',
        '01/03/2026',
        Icons.fact_check_outlined,
        Design.attention,
      ),
      _Doc(
        'Attestation de formation',
        'AF-GP-2024',
        '—',
        Icons.school_outlined,
        Design.erreur,
      ),
      _Doc(
        'Carte professionnelle',
        'CP-LV-0156',
        '31/12/2026',
        Icons.credit_card_outlined,
        Color(0xFF0D9488),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Mes documents',
          style: Design.body1.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: Design.s12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (_, i) {
            final d = docs[i];
            return InkWell(
              onTap: () {
                Get.snackbar(
                  d.titre,
                  'Détail document à brancher.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              borderRadius: BorderRadius.circular(Design.radiusMd),
              child: Container(
                padding: const EdgeInsets.all(Design.s12),
                decoration: BoxDecoration(
                  color: Design.blanc,
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                  border: Border.all(color: Design.bordure),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(d.icone, color: d.couleur, size: 22),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(
                              Design.radiusPill,
                            ),
                          ),
                          child: Text(
                            'Valide',
                            style: Design.caption.copyWith(
                              fontSize: 9,
                              color: Design.secondaire,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      d.titre,
                      style: Design.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Design.texte,
                      ),
                      maxLines: 2,
                    ),
                    Text(d.numero, style: Design.caption.copyWith(fontSize: 10)),
                    Text(
                      'Exp. ${d.expiration}',
                      style: Design.caption.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: Design.s16),
        _alerteDocuments(),
      ],
    );
  }

  Widget _alerteDocuments() {
    return Container(
      padding: const EdgeInsets.all(Design.s16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(Design.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gardez vos documents à jour. Des documents expirés peuvent entraîner la suspension de votre compte.',
            style: Design.caption.copyWith(height: 1.4, color: Design.texte),
          ),
          const SizedBox(height: Design.s8),
          TextButton.icon(
            onPressed: () {
              Get.snackbar(
                'Exigences',
                'Liste des documents requis à brancher.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.info_outline, size: 18),
            label: Text(
              'Voir les exigences',
              style: Design.body2.copyWith(
                color: Design.information,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegTab extends StatelessWidget {
  final IconData icone;
  final String label;
  final bool actif;
  final VoidCallback onTap;

  const _SegTab({
    required this.icone,
    required this.label,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icone,
                size: 18,
                color: actif ? Design.primaire : Design.texteSecondaire,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Design.body2.copyWith(
                  fontWeight: FontWeight.w600,
                  color: actif ? Design.primaire : Design.texteSecondaire,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            color: actif ? Design.primaire : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;

  const _Spec({
    required this.icone,
    required this.label,
    required this.valeur,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icone, size: 16, color: Design.texteSecondaire),
        const SizedBox(height: 4),
        Text(
          valeur,
          style: Design.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: Design.texte,
          ),
        ),
        Text(label, style: Design.caption.copyWith(fontSize: 9)),
      ],
    );
  }
}

class _Doc {
  final String titre;
  final String numero;
  final String expiration;
  final IconData icone;
  final Color couleur;

  const _Doc(this.titre, this.numero, this.expiration, this.icone, this.couleur);
}
