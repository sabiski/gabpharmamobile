import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_livreur.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Détail de la livraison (Écran 6 livreur).
class DetailLivraisonLivreur extends StatelessWidget {
  const DetailLivraisonLivreur({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerLivraisonLivreur>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F9),
      appBar: AppBar(
        title: const Text('Détail de la livraison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined),
            onPressed: c.urgence,
          ),
        ],
      ),
      body: Obx(() {
        final l = c.livraison.value;
        if (l == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Livraison #${l.reference}',
                                style: Design.h3.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Créée le ${_fmtDate(l.creeeLe)}',
                                style: Design.caption,
                              ),
                            ],
                          ),
                        ),
                        if (l.priorite == PrioriteLivraison.haute)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(
                                Design.radiusPill,
                              ),
                            ),
                            child: Text(
                              '🔥 Haute priorité',
                              style: Design.caption.copyWith(
                                color: Design.erreur,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: Design.s16),
                    _CarteContact(
                      icone: Icons.local_pharmacy,
                      couleurIcone: Design.secondaire,
                      titre: l.pharmacie.nom,
                      badge: l.pharmacie.note != null
                          ? '★ ${l.pharmacie.note!.toStringAsFixed(1).replaceAll('.', ',')} (${l.pharmacie.avis})'
                          : null,
                      adresse: l.pharmacie.adresse,
                      telephone: l.pharmacie.telephone,
                      onAppeler: () => c.appeler(l.pharmacie.telephone),
                    ),
                    const SizedBox(height: Design.s12),
                    _CarteContact(
                      icone: Icons.person_outline,
                      couleurIcone: Design.primaire,
                      titre: l.client.nom,
                      adresse: l.client.adresse,
                      telephone: l.client.telephone,
                      onAppeler: () => c.appeler(l.client.telephone),
                    ),
                    const SizedBox(height: Design.s16),
                    _LigneInfo(
                      icone: Icons.straighten,
                      label: 'Distance totale',
                      valeur: '${l.distanceKm.toStringAsFixed(1).replaceAll('.', ',')} km',
                    ),
                    _LigneInfo(
                      icone: Icons.schedule,
                      label: 'Temps estimé',
                      valeur: '≈ ${l.dureeMinutes} min',
                    ),
                    _LigneInfo(
                      icone: Icons.access_time,
                      label: 'À récupérer avant',
                      valeur: '${l.recupererAvant} (${l.delaiRecuperation})',
                      valeurColor: Design.erreur,
                    ),
                    _LigneInfo(
                      icone: Icons.payments_outlined,
                      label: 'Paiement',
                      valeur: l.payeEnLigne ? 'Payé en ligne' : 'À encaisser',
                      valeurColor:
                          l.payeEnLigne ? Design.secondaire : Design.texte,
                    ),
                    _LigneInfo(
                      icone: Icons.account_balance_wallet_outlined,
                      label: 'Montant à percevoir',
                      valeur: '${_fmtMontant(l.montantPercevoir)} FCFA',
                    ),
                    const SizedBox(height: Design.s16),
                    Text(
                      'Articles à livrer (${l.articles.length})',
                      style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: Design.s8),
                    ...l.articles.map(
                      (a) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(Design.s12),
                        decoration: BoxDecoration(
                          color: Design.blanc,
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                          border: Border.all(color: Design.bordure),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F3FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.medication_outlined,
                                color: Design.primaire,
                              ),
                            ),
                            const SizedBox(width: Design.s12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.nom,
                                    style: Design.body1.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(a.detail, style: Design.caption),
                                ],
                              ),
                            ),
                            Text(
                              'Qté ${a.quantite}',
                              style: Design.body2.copyWith(
                                color: Design.primaire,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Design.s8),
                    Container(
                      padding: const EdgeInsets.all(Design.s12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Design.attention,
                            size: 20,
                          ),
                          const SizedBox(width: Design.s8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Instructions de la pharmacie',
                                  style: Design.body2.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Design.texte,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l.instructionsPharmacie,
                                  style: Design.caption.copyWith(
                                    color: Design.texte,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Design.s24),
                    Text(
                      'Suivi',
                      style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: Design.s12),
                    _TimelineLivraison(
                      etapeActive: c.indexEtape(l.etape),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Design.s16,
                  0,
                  Design.s16,
                  Design.s12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BoutonSuivantLivreur(
                      texte: l.etape.index >= EtapeLivraison.enCours.index
                          ? 'Voir la carte'
                          : 'Démarrer la livraison',
                      onTap: () {
                        if (l.etape.index >= EtapeLivraison.enCours.index) {
                          Get.toNamed(Routes.carteSuiviLivreur);
                        } else {
                          c.demarrerLivraison();
                        }
                      },
                    ),
                    const SizedBox(height: Design.s8),
                    OutlinedButton(
                      onPressed: c.contacterPharmacie,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Design.primaire,
                        side: const BorderSide(color: Design.primaire),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                        ),
                      ),
                      child: Text(
                        'Contacter la pharmacie',
                        style: Design.body2.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Design.primaire,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _fmtDate(DateTime d) {
    const mois = [
      '',
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${mois[d.month]} ${d.year} à $h:$m';
  }

  String _fmtMontant(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _CarteContact extends StatelessWidget {
  final IconData icone;
  final Color couleurIcone;
  final String titre;
  final String? badge;
  final String adresse;
  final String telephone;
  final VoidCallback onAppeler;

  const _CarteContact({
    required this.icone,
    required this.couleurIcone,
    required this.titre,
    required this.adresse,
    required this.telephone,
    required this.onAppeler,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Design.s16),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: couleurIcone.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icone, color: couleurIcone, size: 22),
              ),
              const SizedBox(width: Design.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titre,
                      style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (badge != null)
                      Text(
                        badge!,
                        style: Design.caption.copyWith(
                          color: Design.attention,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Design.s8),
          Text(adresse, style: Design.body2.copyWith(color: Design.texte)),
          const SizedBox(height: 4),
          Text(telephone, style: Design.body2.copyWith(color: Design.texte)),
          const SizedBox(height: Design.s12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAppeler,
              icon: const Icon(Icons.phone_outlined, size: 18),
              label: const Text('Appeler'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Design.primaire,
                side: const BorderSide(color: Design.primaire),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Design.radiusMd),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LigneInfo extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;
  final Color? valeurColor;

  const _LigneInfo({
    required this.icone,
    required this.label,
    required this.valeur,
    this.valeurColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icone, size: 20, color: Design.texteSecondaire),
          const SizedBox(width: Design.s12),
          Expanded(child: Text(label, style: Design.body1)),
          Text(
            valeur,
            style: Design.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: valeurColor ?? Design.texte,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineLivraison extends StatelessWidget {
  final int etapeActive;

  const _TimelineLivraison({required this.etapeActive});

  static const _etapes = [
    ('Demande acceptée', '09:16', null),
    (
      'Commande à récupérer',
      '09:16',
      'Rendez-vous à la pharmacie pour récupérer le colis',
    ),
    ('En cours de livraison', null, null),
    ('Livrée au client', null, null),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_etapes.length, (i) {
        final done = i <= etapeActive;
        final (titre, heure, sous) = _etapes[i];
        final last = i == _etapes.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? Design.primaire : Design.blanc,
                        border: Border.all(
                          color: done ? Design.primaire : Design.bordure,
                          width: 2,
                        ),
                      ),
                      child: done
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Design.blanc,
                            )
                          : null,
                    ),
                    if (!last)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: i < etapeActive
                              ? Design.primaire
                              : Design.bordure,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: Design.s12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: last ? 0 : Design.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              titre,
                              style: Design.body1.copyWith(
                                fontWeight: FontWeight.w600,
                                color: done
                                    ? Design.texte
                                    : Design.texteSecondaire,
                              ),
                            ),
                          ),
                          if (heure != null && done)
                            Text(heure, style: Design.caption),
                        ],
                      ),
                      if (sous != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(sous, style: Design.caption),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
