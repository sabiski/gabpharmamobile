import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_mission.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Aide & Support livreur (Écran 11).
class AideSupportLivreur extends StatefulWidget {
  const AideSupportLivreur({super.key});

  @override
  State<AideSupportLivreur> createState() => _AideSupportLivreurState();
}

class _AideSupportLivreurState extends State<AideSupportLivreur> {
  final _recherche = TextEditingController();

  @override
  void dispose() {
    _recherche.dispose();
    super.dispose();
  }

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
                    Text('Aide & Support', style: Design.h2),
                    Text(
                      'Comment pouvons-nous vous aider ?',
                      style: Design.caption,
                    ),
                    const SizedBox(height: Design.s16),
                    TextField(
                      controller: _recherche,
                      style: Design.body1,
                      decoration: InputDecoration(
                        hintText: 'Rechercher une aide, un problème...',
                        hintStyle: Design.body1.copyWith(
                          color: Design.texteSecondaire,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Design.texteSecondaire,
                        ),
                        filled: true,
                        fillColor: Design.blanc,
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
                          borderSide: const BorderSide(
                            color: Design.primaire,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Design.s16),
                    Text(
                      'Contacter le support',
                      style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: Design.s12),
                    Row(
                      children: [
                        Expanded(
                          child: _ContactCard(
                            icone: Icons.phone_outlined,
                            couleur: Design.secondaire,
                            titre: 'Appeler',
                            ligne1: '07 00 12 34',
                            ligne2: 'Appel gratuit',
                            onTap: () => liv.appeler('+241 07 00 12 34'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ContactCard(
                            icone: Icons.chat_bubble_outline,
                            couleur: Design.primaire,
                            titre: 'Chat',
                            ligne1: 'Réponse immédiate',
                            ligne2: '● En ligne',
                            ligne2Color: Design.secondaire,
                            onTap: () {
                              Get.snackbar(
                                'Chat',
                                'Chat support à brancher.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ContactCard(
                            icone: Icons.mail_outline,
                            couleur: Design.information,
                            titre: 'E-mail',
                            ligne1: 'support@…',
                            ligne2: 'Sous 24h',
                            onTap: () {
                              Get.snackbar(
                                'E-mail',
                                'support@gabpharma.ga',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Design.s24),
                    Text(
                      'Questions fréquentes',
                      style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: Design.s12),
                    _FaqItem(
                      icone: Icons.shopping_bag_outlined,
                      couleur: Design.secondaire,
                      titre: 'Comment accepter une livraison ?',
                      onTap: () => _ouvrirFaq(
                        'Accepter une livraison',
                        'Ouvrez l\'onglet Livraisons, consultez le détail puis acceptez la mission.',
                      ),
                    ),
                    _FaqItem(
                      icone: Icons.phone_outlined,
                      couleur: Design.information,
                      titre: 'Comment contacter le client ?',
                      onTap: () => _ouvrirFaq(
                        'Contacter le client',
                        'Depuis le détail ou la carte, utilisez les boutons Appeler / Message.',
                      ),
                    ),
                    _FaqItem(
                      icone: Icons.warning_amber_rounded,
                      couleur: Design.attention,
                      titre: 'Que faire en cas de problème avec une livraison ?',
                      onTap: () =>
                          Get.toNamed(Routes.signalementLivreur),
                    ),
                    _FaqItem(
                      icone: Icons.account_balance_wallet_outlined,
                      couleur: Design.primaire,
                      titre: 'Comment retirer mes gains ?',
                      onTap: () => _ouvrirFaq(
                        'Gains',
                        'Les retraits seront disponibles dans l\'onglet Gains (API à brancher).',
                      ),
                    ),
                    _FaqItem(
                      icone: Icons.emergency,
                      couleur: Design.erreur,
                      titre: 'Comment fonctionne le bouton d\'urgence ?',
                      onTap: () => _ouvrirFaq(
                        'Urgence',
                        'Le bouton Urgence contacte immédiatement le support Gab\'Pharma 24/7.',
                      ),
                    ),
                    const SizedBox(height: Design.s16),
                    Container(
                      padding: const EdgeInsets.all(Design.s16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.smart_toy_outlined,
                            color: Design.information,
                            size: 32,
                          ),
                          const SizedBox(width: Design.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vous n\'avez pas trouvé la réponse ?',
                                  style: Design.body2.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Design.texte,
                                  ),
                                ),
                                Text(
                                  'Parlez à notre assistant virtuel.',
                                  style: Design.caption,
                                ),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              Get.snackbar(
                                'Assistant',
                                'Chatbot à brancher.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Design.primaire,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              minimumSize: const Size(0, 36),
                            ),
                            child: Text(
                              'Démarrer',
                              style: Design.caption.copyWith(
                                color: Design.blanc,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Design.s12),
                    Container(
                      padding: const EdgeInsets.all(Design.s16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                        border: Border.all(color: const Color(0xFFFED7AA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Signaler un problème',
                            style: Design.body1.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bug, accident ou incident de livraison ? Signalez-le-nous.',
                            style: Design.caption.copyWith(height: 1.35),
                          ),
                          const SizedBox(height: Design.s12),
                          OutlinedButton.icon(
                            onPressed: () =>
                                Get.toNamed(Routes.signalementLivreur),
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Design.attention,
                            ),
                            label: Text(
                              'Signaler',
                              style: Design.body1.copyWith(
                                color: Design.attention,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Design.attention),
                              minimumSize: const Size.fromHeight(44),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Design.s12),
                    Container(
                      padding: const EdgeInsets.all(Design.s16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.menu_book_outlined,
                                color: Design.secondaire,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Centre d\'aide',
                                style: Design.body1.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Consultez nos articles, guides et conseils.',
                            style: Design.caption.copyWith(height: 1.35),
                          ),
                          const SizedBox(height: Design.s12),
                          OutlinedButton.icon(
                            onPressed: () {
                              Get.snackbar(
                                'Centre d\'aide',
                                'Articles à brancher.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            icon: const Icon(
                              Icons.open_in_new,
                              color: Design.secondaire,
                              size: 18,
                            ),
                            label: Text(
                              'Visiter le centre d\'aide',
                              style: Design.body2.copyWith(
                                color: Design.secondaire,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Design.secondaire),
                              minimumSize: const Size.fromHeight(44),
                            ),
                          ),
                        ],
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

  void _ouvrirFaq(String titre, String corps) {
    Get.dialog(
      AlertDialog(
        title: Text(titre, style: Design.h3),
        content: Text(corps, style: Design.body1.copyWith(height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icone;
  final Color couleur;
  final String titre;
  final String ligne1;
  final String ligne2;
  final Color? ligne2Color;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icone,
    required this.couleur,
    required this.titre,
    required this.ligne1,
    required this.ligne2,
    required this.onTap,
    this.ligne2Color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(Design.s12),
        decoration: BoxDecoration(
          color: Design.blanc,
          borderRadius: BorderRadius.circular(Design.radiusMd),
          border: Border.all(color: Design.bordure),
        ),
        child: Column(
          children: [
            Icon(icone, color: couleur, size: 26),
            const SizedBox(height: 6),
            Text(
              titre,
              style: Design.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: Design.texte,
              ),
            ),
            Text(
              ligne1,
              style: Design.caption.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              ligne2,
              style: Design.caption.copyWith(
                fontSize: 10,
                color: ligne2Color ?? Design.texteSecondaire,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final IconData icone;
  final Color couleur;
  final String titre;
  final VoidCallback onTap;

  const _FaqItem({
    required this.icone,
    required this.couleur,
    required this.titre,
    required this.onTap,
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
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icone, color: couleur, size: 22),
        ),
        title: Text(
          titre,
          style: Design.body2.copyWith(
            fontWeight: FontWeight.w500,
            color: Design.texte,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Design.texteSecondaire),
      ),
    );
  }
}
