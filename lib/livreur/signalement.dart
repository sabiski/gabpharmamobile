import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_mission.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

enum NatureIncident {
  accident,
  panne,
  colisEndommage,
  clientAbsent,
  adresseIncorrecte,
  autre,
}

/// Signalement d'incident / transfert de livraison.
class SignalementLivreur extends StatefulWidget {
  const SignalementLivreur({super.key});

  @override
  State<SignalementLivreur> createState() => _SignalementLivreurState();
}

class _SignalementLivreurState extends State<SignalementLivreur> {
  final _c = Get.find<ControllerLivraisonLivreur>();
  final _description = TextEditingController();
  final _motifTransfert = TextEditingController();

  int _onglet = 0; // 0 incident, 1 transfert
  NatureIncident _nature = NatureIncident.accident;
  bool _photoAjoutee = false;

  @override
  void dispose() {
    _description.dispose();
    _motifTransfert.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: Column(
          children: [
            EnteteLivreur(onUrgence: _c.urgence),
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
                    Text(
                      'Signalement d\'incident / Transfert',
                      style: Design.h2,
                    ),
                    Text(
                      'Signalez un problème ou transférez la livraison à un autre livreur.',
                      style: Design.caption,
                    ),
                    const SizedBox(height: Design.s16),
                    Row(
                      children: [
                        Expanded(
                          child: _TabBtn(
                            label: 'Signaler un incident',
                            actif: _onglet == 0,
                            couleur: Design.primaire,
                            onTap: () => setState(() => _onglet = 0),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _TabBtn(
                            label: 'Transférer la livraison',
                            actif: _onglet == 1,
                            couleur: Design.secondaire,
                            onTap: () => setState(() => _onglet = 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Design.s16),
                    if (_onglet == 0) _formIncident() else _formTransfert(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formIncident() {
    return Obx(() {
      final l = _c.livraison.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '1. Informations sur la livraison',
            style: Design.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Design.s8),
          if (l != null) _CarteLivraison(l: l),
          const SizedBox(height: Design.s16),
          Text(
            '2. Nature de l\'incident',
            style: Design.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Design.s8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: [
              _NatureChip(
                label: 'Accident de la route',
                icone: Icons.car_crash_outlined,
                selected: _nature == NatureIncident.accident,
                onTap: () =>
                    setState(() => _nature = NatureIncident.accident),
              ),
              _NatureChip(
                label: 'Panne de véhicule',
                icone: Icons.build_outlined,
                selected: _nature == NatureIncident.panne,
                onTap: () => setState(() => _nature = NatureIncident.panne),
              ),
              _NatureChip(
                label: 'Colis endommagé',
                icone: Icons.inventory_2_outlined,
                selected: _nature == NatureIncident.colisEndommage,
                onTap: () =>
                    setState(() => _nature = NatureIncident.colisEndommage),
              ),
              _NatureChip(
                label: 'Client absent',
                icone: Icons.person_off_outlined,
                selected: _nature == NatureIncident.clientAbsent,
                onTap: () =>
                    setState(() => _nature = NatureIncident.clientAbsent),
              ),
              _NatureChip(
                label: 'Adresse incorrecte',
                icone: Icons.wrong_location_outlined,
                selected: _nature == NatureIncident.adresseIncorrecte,
                onTap: () => setState(
                  () => _nature = NatureIncident.adresseIncorrecte,
                ),
              ),
              _NatureChip(
                label: 'Autre problème',
                icone: Icons.more_horiz,
                selected: _nature == NatureIncident.autre,
                onTap: () => setState(() => _nature = NatureIncident.autre),
              ),
            ],
          ),
          const SizedBox(height: Design.s16),
          Text(
            '3. Description détaillée',
            style: Design.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Design.s8),
          TextField(
            controller: _description,
            maxLines: 4,
            style: Design.body1,
            decoration: InputDecoration(
              hintText: 'Ex : J\'ai eu un accident sur le boulevard…',
              hintStyle: Design.body1.copyWith(color: Design.texteSecondaire),
              filled: true,
              fillColor: Design.blanc,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Design.radiusMd),
              ),
            ),
          ),
          const SizedBox(height: Design.s16),
          Text(
            '4. Preuve (facultatif)',
            style: Design.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Design.s8),
          if (_photoAjoutee)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(Design.radiusMd),
                    border: Border.all(color: Design.bordure),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.two_wheeler,
                      size: 48,
                      color: Design.attention,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _photoAjoutee = false),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            )
          else
            OutlinedButton.icon(
              onPressed: () => setState(() => _photoAjoutee = true),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Ajouter une photo'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Design.primaire,
                side: const BorderSide(color: Design.primaire),
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          const SizedBox(height: Design.s16),
          Container(
            padding: const EdgeInsets.all(Design.s12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(Design.radiusMd),
            ),
            child: Text(
              '• Le support traite le signalement sous 15 min.\n'
              '• En cas de danger immédiat, utilisez le bouton Urgence.\n'
              '• Gardez le colis en sécurité si possible.',
              style: Design.caption.copyWith(height: 1.45, color: Design.texte),
            ),
          ),
          const SizedBox(height: Design.s24),
          BoutonSuivantLivreur(
            texte: 'Envoyer le signalement',
            onTap: () {
              if (_description.text.trim().isEmpty) {
                Get.snackbar(
                  'Description',
                  'Décrivez l\'incident.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.snackbar(
                'Signalement envoyé',
                'Le support a été notifié (API à brancher).',
                snackPosition: SnackPosition.BOTTOM,
              );
              Get.back();
            },
          ),
          const SizedBox(height: Design.s8),
          OutlinedButton.icon(
            onPressed: () => _c.appeler('+241 07 00 12 34'),
            icon: const Icon(Icons.phone_outlined, color: Design.erreur),
            label: Text(
              'Appeler le support',
              style: Design.body1.copyWith(color: Design.erreur),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Design.erreur),
              minimumSize: const Size.fromHeight(48),
            ),
          ),
          const SizedBox(height: Design.s12),
          FilledButton(
            onPressed: _c.urgence,
            style: FilledButton.styleFrom(
              backgroundColor: Design.erreur,
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Bouton d\'urgence'),
          ),
        ],
      );
    });
  }

  Widget _formTransfert() {
    return Obx(() {
      final l = _c.livraison.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Transférer la livraison',
            style: Design.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Un autre livreur de votre société pourra reprendre la mission.',
            style: Design.caption,
          ),
          const SizedBox(height: Design.s12),
          if (l != null) _CarteLivraison(l: l),
          const SizedBox(height: Design.s16),
          Text(
            'Motif du transfert *',
            style: Design.body1.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: Design.s8),
          TextField(
            controller: _motifTransfert,
            maxLines: 3,
            style: Design.body1,
            decoration: InputDecoration(
              hintText: 'Ex : Panne, indisponibilité…',
              filled: true,
              fillColor: Design.blanc,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Design.radiusMd),
              ),
            ),
          ),
          const SizedBox(height: Design.s24),
          BoutonSuivantLivreur(
            texte: 'Demander le transfert',
            onTap: () {
              if (_motifTransfert.text.trim().isEmpty) {
                Get.snackbar(
                  'Motif',
                  'Indiquez le motif du transfert.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.snackbar(
                'Transfert demandé',
                'En attente d\'un livreur disponible (API).',
                snackPosition: SnackPosition.BOTTOM,
              );
              Get.back();
            },
          ),
        ],
      );
    });
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final bool actif;
  final Color couleur;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.actif,
    required this.couleur,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: actif ? couleur : Design.blanc,
          borderRadius: BorderRadius.circular(Design.radiusMd),
          border: Border.all(color: actif ? couleur : Design.bordure),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Design.caption.copyWith(
            color: actif ? Design.blanc : Design.texte,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _NatureChip extends StatelessWidget {
  final String label;
  final IconData icone;
  final bool selected;
  final VoidCallback onTap;

  const _NatureChip({
    required this.label,
    required this.icone,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF5F3FF) : Design.blanc,
          borderRadius: BorderRadius.circular(Design.radiusMd),
          border: Border.all(
            color: selected ? Design.primaire : Design.bordure,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icone,
              size: 20,
              color: selected ? Design.primaire : Design.texteSecondaire,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Design.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Design.texte,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18,
              color: selected ? Design.primaire : Design.bordure,
            ),
          ],
        ),
      ),
    );
  }
}

class _CarteLivraison extends StatelessWidget {
  final LivraisonLivreur l;
  const _CarteLivraison({required this.l});

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
              Text(
                '#${l.reference}',
                style: Design.body1.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(Design.radiusPill),
                ),
                child: Text(
                  'En cours',
                  style: Design.caption.copyWith(
                    color: Design.secondaire,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l.pharmacie.nom, style: Design.body2.copyWith(color: Design.texte)),
          Text(l.client.nom, style: Design.body2.copyWith(color: Design.texte)),
          Text(l.client.adresse, style: Design.caption),
          const SizedBox(height: 4),
          Text(
            '${l.montantPercevoir} FCFA',
            style: Design.body1.copyWith(
              color: Design.secondaire,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(Routes.detailLivraisonLivreur),
            child: Text(
              'Voir le détail de la commande >',
              style: Design.caption.copyWith(
                color: Design.primaire,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
