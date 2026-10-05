import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_auth_livreur.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Écran après inscription : en attente de validation admin (web).
class CompteEnAttenteLivreur extends StatelessWidget {
  const CompteEnAttenteLivreur({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerAuthLivreur>();

    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Design.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  shape: BoxShape.circle,
                  border: Border.all(color: Design.attention, width: 2),
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 44,
                  color: Design.attention,
                ),
              ),
              const SizedBox(height: Design.s24),
              Text(
                'Compte en attente de validation',
                style: Design.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Design.s12),
              Obx(
                () => Text(
                  c.nomLivreurInscrit.value.isEmpty
                      ? 'Votre dossier livreur a été envoyé.'
                      : 'Bonjour ${c.nomLivreurInscrit.value}, votre dossier a été envoyé.',
                  style: Design.body1.copyWith(
                    color: Design.texteSecondaire,
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Design.s16),
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
                    _ligne(
                      Icons.badge_outlined,
                      'Rôle enregistré',
                      'Livreur (connu dès l\'inscription)',
                    ),
                    const Divider(height: 24),
                    _ligne(
                      Icons.admin_panel_settings_outlined,
                      'Validation admin',
                      'Un administrateur doit valider votre compte sur le back-office web avant toute connexion.',
                    ),
                    const Divider(height: 24),
                    _ligne(
                      Icons.notifications_active_outlined,
                      'Ensuite',
                      'Dès validation, vous pourrez vous connecter. Le système saura déjà que vous êtes livreur.',
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Démo UI uniquement — retiré quand l'API admin est branchée.
              OutlinedButton(
                onPressed: () {
                  c.simulerValidationAdmin();
                  Get.offAllNamed(Routes.connexionLivreur);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Design.secondaire,
                  side: const BorderSide(color: Design.secondaire),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Design.radiusMd),
                  ),
                ),
                child: Text(
                  'Simuler validation admin (démo)',
                  style: Design.body1.copyWith(
                    color: Design.secondaire,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: Design.s12),
              FilledButton(
                onPressed: () => Get.offAllNamed(Routes.connexionLivreur),
                style: FilledButton.styleFrom(
                  backgroundColor: Design.primaire,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Design.radiusMd),
                  ),
                ),
                child: Text(
                  'Retour à la connexion',
                  style: Design.h4.copyWith(
                    color: Design.blanc,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ligne(IconData icon, String titre, String texte) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Design.primaire, size: 22),
        const SizedBox(width: Design.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titre,
                style: Design.body1.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                texte,
                style: Design.caption.copyWith(height: 1.4, color: Design.texte),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
