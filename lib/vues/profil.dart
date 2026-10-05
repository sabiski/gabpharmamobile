import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_auth.dart';
import 'package:gabpharmamobile/controllers/controller_navigation.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/models/user_model.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<ControllerAuth>();
    final nav = Get.find<ControllerNavigation>();

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        backgroundColor: Design.blanc,
        surfaceTintColor: Design.blanc,
        automaticallyImplyLeading: false,
        title: Text(
          'Mon profil',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.snackbar(
                'Réglages',
                'Paramètres application à venir.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Obx(() {
            final u = auth.utilisateur.value ??
                const UserModel(
                  firstName: 'Jean',
                  lastName: 'Daniel',
                  email: 'jean.daniel@email.com',
                  role: 'client',
                );
            return _EnTeteProfil(user: u);
          }),
          const SizedBox(height: 16),
          _BandeauForfaits(
            onTap: () => Get.toNamed(Routes.forfaits),
          ),
          const SizedBox(height: 20),
          _SectionTitre('Mon compte'),
          const SizedBox(height: 8),
          _MenuGroupe(
            items: [
              _MenuItemData(
                icone: Icons.person_outline,
                titre: 'Informations personnelles',
                sousTitre: 'Gérer vos informations de base',
                onTap: () => _bientot('Informations personnelles'),
              ),
              _MenuItemData(
                icone: Icons.location_on_outlined,
                titre: 'Adresse de livraison',
                sousTitre: 'Gérer vos adresses enregistrées',
                onTap: () => _bientot('Adresses'),
              ),
              _MenuItemData(
                icone: Icons.credit_card_outlined,
                titre: 'Moyens de paiement',
                sousTitre: 'Gérer vos cartes et portefeuilles',
                onTap: () => _bientot('Paiements'),
              ),
              _MenuItemData(
                icone: Icons.receipt_long_outlined,
                titre: 'Historique des commandes',
                sousTitre: 'Voir toutes vos commandes',
                onTap: nav.commandes,
              ),
              _MenuItemData(
                icone: Icons.favorite_border,
                titre: 'Favoris',
                sousTitre: 'Vos pharmacies et médicaments préférés',
                onTap: nav.favoris,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitre('Préférences'),
          const SizedBox(height: 8),
          _MenuGroupe(
            items: [
              _MenuItemData(
                icone: Icons.notifications_outlined,
                titre: 'Notifications',
                sousTitre: 'Gérer vos préférences de notifications',
                onTap: () => Get.toNamed(Routes.notifications),
              ),
              _MenuItemData(
                icone: Icons.language,
                titre: 'Langue',
                sousTitre: 'Français',
                trailing: const Text('🇫🇷', style: TextStyle(fontSize: 18)),
                onTap: () => _bientot('Langue'),
              ),
              _MenuItemData(
                icone: Icons.wb_sunny_outlined,
                titre: 'Thème',
                sousTitre: 'Clair',
                onTap: () => _bientot('Thème'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitre('Sécurité'),
          const SizedBox(height: 8),
          _MenuGroupe(
            items: [
              _MenuItemData(
                icone: Icons.lock_outline,
                titre: 'Sécurité du compte',
                sousTitre: 'Mot de passe, authentification…',
                onTap: () => _bientot('Sécurité'),
              ),
              _MenuItemData(
                icone: Icons.privacy_tip_outlined,
                titre: 'Confidentialité',
                sousTitre: 'Gérer vos données personnelles',
                onTap: () => _bientot('Confidentialité'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Material(
            color: Design.blanc,
            borderRadius: BorderRadius.circular(Design.radiusMd),
            child: InkWell(
              onTap: () {
                Get.defaultDialog(
                  title: 'Déconnexion',
                  middleText: 'Voulez-vous vraiment vous déconnecter ?',
                  textCancel: 'Annuler',
                  textConfirm: 'Se déconnecter',
                  confirmTextColor: Design.blanc,
                  buttonColor: Design.alerte,
                  onConfirm: () {
                    Get.back();
                    auth.deconnexion();
                  },
                );
              },
              borderRadius: BorderRadius.circular(Design.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Design.alerte),
                    const SizedBox(width: 12),
                    Text(
                      'Se déconnecter',
                      style: Design.body1.copyWith(
                        color: Design.alerte,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bientot(String label) {
    Get.snackbar(
      label,
      'Écran à développer à l\'étape suivante.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class _EnTeteProfil extends StatelessWidget {
  final UserModel user;

  const _EnTeteProfil({required this.user});

  @override
  Widget build(BuildContext context) {
    final initiales = user.nomComplet.isNotEmpty
        ? user.nomComplet
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map((e) => e[0].toUpperCase())
            .join()
        : 'JD';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusLg),
        border: Border.all(color: Design.bordure),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Design.primaire.withValues(alpha: 0.15),
            child: Text(
              initiales,
              style: Design.h3.copyWith(
                color: Design.primaire,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.nomComplet.isEmpty
                            ? 'Jean Daniel'
                            : user.nomComplet,
                        style: Design.h3.copyWith(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Design.primaire.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(Design.radiusPill),
                      ),
                      child: Text(
                        'Client',
                        style: Design.caption.copyWith(
                          color: Design.primaire,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? 'jean.daniel@email.com',
                  style: Design.body2,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: Design.secondaire,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Compte vérifié',
                      style: Design.caption.copyWith(
                        color: Design.secondaire,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Membre depuis juin 2024', style: Design.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BandeauForfaits extends StatelessWidget {
  final VoidCallback onTap;

  const _BandeauForfaits({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Design.primaire.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.primaire.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Design.primaire.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: Design.primaire,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profitez de nos avantages exclusifs !',
                  style: Design.body2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Design.texte,
                  ),
                ),
                Text(
                  'Pass, Standard ou Premium',
                  style: Design.caption,
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: Design.primaire,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Voir les forfaits',
              style: Design.caption.copyWith(
                color: Design.blanc,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitre extends StatelessWidget {
  final String titre;

  const _SectionTitre(this.titre);

  @override
  Widget build(BuildContext context) {
    return Text(
      titre,
      style: Design.h3.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _MenuItemData {
  final IconData icone;
  final String titre;
  final String sousTitre;
  final VoidCallback onTap;
  final Widget? trailing;

  const _MenuItemData({
    required this.icone,
    required this.titre,
    required this.sousTitre,
    required this.onTap,
    this.trailing,
  });
}

class _MenuGroupe extends StatelessWidget {
  final List<_MenuItemData> items;

  const _MenuGroupe({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _LigneMenu(item: items[i]),
            if (i < items.length - 1)
              const Divider(height: 1, color: Design.bordure, indent: 56),
          ],
        ],
      ),
    );
  }
}

class _LigneMenu extends StatelessWidget {
  final _MenuItemData item;

  const _LigneMenu({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Design.primaire.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(item.icone, color: Design.primaire, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titre,
                    style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(item.sousTitre, style: Design.caption),
                ],
              ),
            ),
            if (item.trailing != null) ...[
              item.trailing!,
              const SizedBox(width: 4),
            ],
            const Icon(Icons.chevron_right, color: Design.texteSecondaire),
          ],
        ),
      ),
    );
  }
}
