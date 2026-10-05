import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_auth_livreur.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_mission.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Profil livreur (Écran 10).
class ProfilLivreur extends StatelessWidget {
  const ProfilLivreur({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.isRegistered<ControllerAuthLivreur>()
        ? Get.find<ControllerAuthLivreur>()
        : null;
    final liv = Get.find<ControllerLivraisonLivreur>();

    final nom = auth?.nomComplet.text.trim().isNotEmpty == true
        ? auth!.nomComplet.text.trim()
        : (auth?.nomLivreurInscrit.value.isNotEmpty == true
            ? auth!.nomLivreurInscrit.value
            : 'Jean-Paul Moukagni');
    final tel = auth?.telephoneLivreur.text.trim().isNotEmpty == true
        ? '+241 ${auth!.telephoneLivreur.text.trim()}'
        : '+241 06 12 34 56';
    final email = auth?.emailLivreur.text.trim().isNotEmpty == true
        ? auth!.emailLivreur.text.trim()
        : 'jp.moukagni@email.ga';

    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: Column(
          children: [
            EnteteLivreur(
              onUrgence: liv.urgence,
              onRetour: () {},
              badgeNotifs: 5,
            ),
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
                    Text('Mon profil', style: Design.h2),
                    Text(
                      'Gérez vos informations et paramètres',
                      style: Design.caption,
                    ),
                    const SizedBox(height: Design.s16),
                    Container(
                      padding: const EdgeInsets.all(Design.s16),
                      decoration: BoxDecoration(
                        color: Design.blanc,
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                        border: Border.all(color: Design.bordure),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: Color(0xFFF5F3FF),
                            child: Icon(
                              Icons.person,
                              size: 36,
                              color: Design.primaire,
                            ),
                          ),
                          const SizedBox(width: Design.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(
                                      Design.radiusPill,
                                    ),
                                  ),
                                  child: Text(
                                    'Livreur actif',
                                    style: Design.caption.copyWith(
                                      color: Design.secondaire,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  nom,
                                  style: Design.body1.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(tel, style: Design.caption),
                                Text(email, style: Design.caption),
                                Text(
                                  'Moto · BA 123-AA',
                                  style: Design.caption.copyWith(
                                    color: Design.texte,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'Modifier',
                                'Édition profil à brancher.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: Text(
                              'Modifier',
                              style: Design.body2.copyWith(
                                color: Design.primaire,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Design.s16),
                    Row(
                      children: const [
                        Expanded(
                          child: _StatCard(valeur: '128', label: 'Livraisons'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(valeur: '4,8', label: 'Note'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(valeur: '8 mois', label: 'Membre'),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(valeur: '100%', label: 'Achèvement'),
                        ),
                      ],
                    ),
                    const SizedBox(height: Design.s24),
                    _MenuItem(
                      icone: Icons.person_outline,
                      titre: 'Informations personnelles',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icone: Icons.two_wheeler_outlined,
                      titre: 'Véhicule & documents',
                      onTap: () => Get.toNamed(Routes.vehiculeDocumentsLivreur),
                    ),
                    _MenuItem(
                      icone: Icons.payments_outlined,
                      titre: 'Moyens de paiement',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icone: Icons.tune,
                      titre: 'Préférences de livraison',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icone: Icons.notifications_outlined,
                      titre: 'Notifications',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icone: Icons.lock_outline,
                      titre: 'Sécurité',
                      sousTitre: 'Modifier le mot de passe',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icone: Icons.privacy_tip_outlined,
                      titre: 'Confidentialité',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icone: Icons.language,
                      titre: 'Langue',
                      trailing: 'Français',
                      onTap: () {},
                    ),
                    _MenuItem(
                      icone: Icons.help_outline,
                      titre: 'Aide & Support',
                      onTap: () => Get.toNamed(Routes.aideSupportLivreur),
                    ),
                    _MenuItem(
                      icone: Icons.report_problem_outlined,
                      titre: 'Signaler un incident',
                      onTap: () => Get.toNamed(Routes.signalementLivreur),
                    ),
                    _MenuItem(
                      icone: Icons.info_outline,
                      titre: 'À propos',
                      trailing: 'v 1.0.0',
                      onTap: () {},
                    ),
                    const SizedBox(height: Design.s16),
                    Container(
                      padding: const EdgeInsets.all(Design.s16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Besoin d\'aide ?',
                            style: Design.body1.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'En cas d\'urgence pendant une livraison, contactez le support immédiatement.',
                            style: Design.caption.copyWith(height: 1.35),
                          ),
                          const SizedBox(height: Design.s12),
                          FilledButton.icon(
                            onPressed: liv.urgence,
                            style: FilledButton.styleFrom(
                              backgroundColor: Design.erreur,
                              minimumSize: const Size.fromHeight(44),
                            ),
                            icon: const Icon(Icons.phone),
                            label: const Text('Bouton d\'urgence'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Design.s16),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (auth != null) {
                          auth.deconnexion();
                        } else {
                          Get.offAllNamed('/connexion-livreur');
                        }
                      },
                      icon: const Icon(Icons.logout, color: Design.erreur),
                      label: Text(
                        'Se déconnecter',
                        style: Design.body1.copyWith(
                          color: Design.erreur,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Design.erreur),
                        minimumSize: const Size.fromHeight(50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String valeur;
  final String label;

  const _StatCard({required this.valeur, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Design.s12, horizontal: 4),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Column(
        children: [
          Text(
            valeur,
            style: Design.body1.copyWith(
              fontWeight: FontWeight.w700,
              color: Design.primaire,
            ),
          ),
          Text(
            label,
            style: Design.caption.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String? sousTitre;
  final String? trailing;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icone,
    required this.titre,
    required this.onTap,
    this.sousTitre,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icone, color: Design.primaire),
        title: Text(
          titre,
          style: Design.body1.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: sousTitre == null
            ? null
            : Text(sousTitre!, style: Design.caption),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailing != null)
              Text(
                trailing!,
                style: Design.caption.copyWith(color: Design.texteSecondaire),
              ),
            const Icon(Icons.chevron_right, color: Design.texteSecondaire),
          ],
        ),
      ),
    );
  }
}
