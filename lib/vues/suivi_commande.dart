import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_suivi_commande.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/maps/controller_cartes.dart';
import 'package:gabpharmamobile/maps/widgets/carte_gabpharma.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

String _prixFcfa(int montant) {
  final raw = montant.toString();
  final buf = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buf.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(' ');
  }
  return '${buf.toString()} FCFA';
}

String _dateFr(DateTime d) {
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

/// Onglet liste des commandes.
class Commandes extends StatelessWidget {
  const Commandes({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ControllerListeCommandes());

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        backgroundColor: Design.blanc,
        surfaceTintColor: Design.blanc,
        automaticallyImplyLeading: false,
        title: Text(
          'Mes commandes',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        if (c.isLoading.value && c.commandes.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Design.primaire),
          );
        }
        if (c.commandes.isEmpty) {
          return Center(
            child: Text('Aucune commande', style: Design.body1),
          );
        }
        return RefreshIndicator(
          color: Design.primaire,
          onRefresh: c.charger,
          child: ListView.separated(
            padding: const EdgeInsets.all(Design.s16),
            itemCount: c.commandes.length,
            separatorBuilder: (_, __) => const SizedBox(height: Design.s8),
            itemBuilder: (context, index) {
              final cmd = c.commandes[index];
              return _CarteListeCommande(
                commande: cmd,
                onTap: () => Get.toNamed(
                  Routes.detailCommande,
                  arguments: {'id': cmd.id},
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _CarteListeCommande extends StatelessWidget {
  final SuiviCommandeModel commande;
  final VoidCallback onTap;

  const _CarteListeCommande({required this.commande, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Design.blanc,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(color: Design.bordure),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Design.primaire.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Design.radiusSm),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Design.primaire,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Commande #${commande.reference}',
                      style: Design.body1.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(_dateFr(commande.date), style: Design.caption),
                    const SizedBox(height: 4),
                    _BadgeStatutCommande(label: commande.statutLabel),
                  ],
                ),
              ),
              Text(
                _prixFcfa(commande.totalFcfa),
                style: Design.body2.copyWith(
                  color: Design.primaire,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.chevron_right, color: Design.texteSecondaire),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeStatutCommande extends StatelessWidget {
  final String label;

  const _BadgeStatutCommande({required this.label});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (label) {
      case 'Livrée':
        bg = const Color(0xFFDCFCE7);
        fg = Design.secondaire;
      case 'Annulée':
        bg = const Color(0xFFFEE2E2);
        fg = Design.alerte;
      case 'En préparation':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
      default:
        bg = Design.primaire.withValues(alpha: 0.12);
        fg = Design.primaire;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Design.radiusPill),
      ),
      child: Text(
        label,
        style: Design.caption.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Écran suivi détaillé.
class DetailCommande extends StatelessWidget {
  const DetailCommande({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerSuiviCommande>();

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        backgroundColor: Design.blanc,
        surfaceTintColor: Design.blanc,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: Text(
          'Suivi de commande',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () => Get.toNamed(Routes.notifications),
                icon: const Icon(Icons.notifications_outlined),
              ),
              Obx(() {
                final n = c.notificationsNonLues.value;
                if (n <= 0) return const SizedBox.shrink();
                return Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Design.alerte,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$n',
                      style: Design.caption.copyWith(
                        color: Design.blanc,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value && c.suivi.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Design.primaire),
          );
        }
        final s = c.suivi.value;
        if (s == null) {
          return Center(
            child: Text('Commande introuvable', style: Design.body1),
          );
        }
        return ListView(
          padding: const EdgeInsets.only(bottom: Design.s32),
          children: [
            Container(
              width: double.infinity,
              color: Design.surface,
              padding: const EdgeInsets.symmetric(
                horizontal: Design.s16,
                vertical: 10,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.near_me_outlined,
                    size: 16,
                    color: Design.secondaire,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Suivez votre commande en temps réel',
                    style: Design.caption.copyWith(
                      color: Design.secondaire,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Design.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CarteResume(commande: s),
                  const SizedBox(height: Design.s24),
                  Text(
                    'État de la livraison',
                    style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: Design.s16),
                  _StepperLivraison(etapes: s.etapes),
                  const SizedBox(height: Design.s24),
                  const _CarteSuiviLivraison(),
                  const SizedBox(height: Design.s16),
                  if (s.livreur != null) ...[
                    _CarteLivreur(
                      livreur: s.livreur!,
                      onAppeler: c.appelerLivreur,
                      onMessage: c.messageLivreur,
                    ),
                    const SizedBox(height: Design.s16),
                  ],
                  Text(
                    'Informations de livraison',
                    style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: Design.s12),
                  _InfosLivraison(
                    commande: s,
                    onAdresse: c.modifierAdresse,
                    onInstructions: c.modifierInstructions,
                  ),
                  const SizedBox(height: Design.s16),
                  _AideCard(onTap: c.contacterSupport),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CarteResume extends StatelessWidget {
  final SuiviCommandeModel commande;

  const _CarteResume({required this.commande});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Design.primaire.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(Design.radiusSm),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Design.primaire,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commande #${commande.reference}',
                  style: Design.body1.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(_dateFr(commande.date), style: Design.caption),
                Text(
                  '${commande.nombreArticles} articles · ${_prixFcfa(commande.totalFcfa)}',
                  style: Design.body2.copyWith(color: Design.texte),
                ),
              ],
            ),
          ),
          Text(
            'Voir détails',
            style: Design.caption.copyWith(
              color: Design.primaire,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: Design.primaire),
        ],
      ),
    );
  }
}

class _StepperLivraison extends StatelessWidget {
  final List<EtapeSuivi> etapes;

  const _StepperLivraison({required this.etapes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(etapes.length * 2 - 1, (i) {
            if (i.isOdd) {
              final left = etapes[i ~/ 2];
              final done = left.terminee || left.active;
              return Expanded(
                child: Container(
                  height: 3,
                  color: done ? Design.secondaire : Design.bordure,
                ),
              );
            }
            final e = etapes[i ~/ 2];
            return _StepDot(etape: e);
          }),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: etapes
              .map(
                (e) => Expanded(
                  child: Column(
                    children: [
                      Text(
                        e.label,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Design.caption.copyWith(
                          fontWeight: e.active || e.terminee
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: e.active
                              ? Design.primaire
                              : e.terminee
                                  ? Design.texte
                                  : Design.texteSecondaire,
                          fontSize: 10,
                          height: 1.2,
                        ),
                      ),
                      if (e.heure != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          e.heure!,
                          style: Design.caption.copyWith(fontSize: 10),
                        ),
                      ],
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final EtapeSuivi etape;

  const _StepDot({required this.etape});

  @override
  Widget build(BuildContext context) {
    if (etape.terminee) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Design.secondaire,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Design.blanc, size: 16),
      );
    }
    if (etape.active) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Design.primaire,
          shape: BoxShape.circle,
          border: Border.all(color: Design.blanc, width: 2),
          boxShadow: [
            BoxShadow(
              color: Design.primaire.withValues(alpha: 0.35),
              blurRadius: 8,
            ),
          ],
        ),
        child: const Icon(
          Icons.delivery_dining,
          color: Design.blanc,
          size: 16,
        ),
      );
    }
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Design.blanc,
        shape: BoxShape.circle,
        border: Border.all(color: Design.bordure, width: 2),
      ),
    );
  }
}

class _CarteSuiviLivraison extends StatelessWidget {
  const _CarteSuiviLivraison();

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ControllerCarteSuivi());

    return Obx(() {
      if (c.isLoading.value && c.client.value == null) {
        return Container(
          height: 220,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Design.blanc,
            borderRadius: BorderRadius.circular(Design.radiusMd),
          ),
          child: const CircularProgressIndicator(color: Design.primaire),
        );
      }

      final points = c.points
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suivi GPS en direct',
            style: Design.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          CarteGabPharma(
            points: points,
            origineItineraire: c.pharmacie.value,
            destinationItineraire: c.client.value,
            height: 240,
            afficherDistance: true,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: const [
              _LegendeMaps(color: Design.secondaire, label: 'Pharmacie'),
              _LegendeMaps(color: Color(0xFF2563EB), label: 'Livreur'),
              _LegendeMaps(color: Design.primaire, label: 'Client'),
            ],
          ),
        ],
      );
    });
  }
}

class _LegendeMaps extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendeMaps({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Design.caption),
      ],
    );
  }
}

class _CarteLivreur extends StatelessWidget {
  final LivreurInfo livreur;
  final VoidCallback onAppeler;
  final VoidCallback onMessage;

  const _CarteLivreur({
    required this.livreur,
    required this.onAppeler,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Design.primaire.withValues(alpha: 0.15),
                child: Text(
                  livreur.nom.isNotEmpty ? livreur.nom[0].toUpperCase() : 'L',
                  style: Design.h3.copyWith(color: Design.primaire),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livreur.nom,
                      style: Design.body1.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '★ ${livreur.note} · ${livreur.livraisons} livraisons',
                      style: Design.caption,
                    ),
                    Text(livreur.role, style: Design.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAppeler,
                  icon: const Icon(Icons.phone_outlined, size: 16),
                  label: const Text('Appeler'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Design.secondaire,
                    side: const BorderSide(color: Design.secondaire),
                    minimumSize: const Size.fromHeight(42),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMessage,
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Message'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Design.primaire,
                    side: const BorderSide(color: Design.primaire),
                    minimumSize: const Size.fromHeight(42),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfosLivraison extends StatelessWidget {
  final SuiviCommandeModel commande;
  final VoidCallback onAdresse;
  final VoidCallback onInstructions;

  const _InfosLivraison({
    required this.commande,
    required this.onAdresse,
    required this.onInstructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Column(
        children: [
          _InfoLigne(
            icon: Icons.schedule,
            label: 'Livraison estimée',
            value: commande.livraisonEstimee,
          ),
          const Divider(height: 20, color: Design.bordure),
          _InfoLigne(
            icon: Icons.location_on_outlined,
            label: 'Adresse de livraison',
            value: commande.adresseLivraison,
            action: 'Modifier',
            onAction: onAdresse,
          ),
          const Divider(height: 20, color: Design.bordure),
          _InfoLigne(
            icon: Icons.notes_outlined,
            label: 'Instructions pour le livreur',
            value: commande.instructions,
            action: 'Modifier',
            onAction: onInstructions,
          ),
        ],
      ),
    );
  }
}

class _InfoLigne extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? action;
  final VoidCallback? onAction;

  const _InfoLigne({
    required this.icon,
    required this.label,
    required this.value,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Design.primaire),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Design.caption),
              const SizedBox(height: 2),
              Text(
                value,
                style: Design.body2.copyWith(
                  color: Design.texte,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: Design.caption.copyWith(
                color: Design.secondaire,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _AideCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AideCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Design.blanc,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(color: Design.bordure),
          ),
          child: Row(
            children: [
              const Icon(Icons.support_agent, color: Design.primaire),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Besoin d\'aide avec votre livraison ?',
                  style: Design.body2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Design.texte,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Design.texteSecondaire),
            ],
          ),
        ),
      ),
    );
  }
}
