import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gabpharmamobile/composants/logo_gabpharma.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_auth_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_livreur.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Connexion livreur (Écran 3 maquette).
class ConnexionLivreur extends StatelessWidget {
  ConnexionLivreur({super.key});

  final ControllerAuthLivreur c = Get.find<ControllerAuthLivreur>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Design.s24,
                        Design.s8,
                        Design.s24,
                        0,
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.language,
                                size: 18,
                                color: Design.texteSecondaire,
                              ),
                              label: Text(
                                'Français',
                                style: Design.body2.copyWith(
                                  color: Design.texteSecondaire,
                                ),
                              ),
                            ),
                          ),
                          const LogoGabPharma(size: 72, showSlogan: false),
                          const SizedBox(height: Design.s12),
                          Text(
                            'Livreur',
                            style: Design.h1.copyWith(color: Design.primaire),
                          ),
                          Text(
                            'Livrez la santé, partout.',
                            style: Design.body1.copyWith(
                              color: Design.texteSecondaire,
                            ),
                          ),
                          const SizedBox(height: Design.s16),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Design.blanc,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Design.radiusXl),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        Design.s24,
                        Design.s24,
                        Design.s24,
                        Design.s16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Connexion', style: Design.h2),
                          const SizedBox(height: Design.s4),
                          Text(
                            'Connectez-vous à votre compte livreur',
                            style: Design.body1.copyWith(
                              color: Design.texteSecondaire,
                            ),
                          ),
                          const SizedBox(height: Design.s24),
                          ChampLabel(
                            label: 'Numéro de téléphone',
                            child: TextFormField(
                              controller: c.telephoneConnexion,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: Design.body1,
                              decoration: _decoTelephone(),
                            ),
                          ),
                          const SizedBox(height: Design.s16),
                          ChampLabel(
                            label: 'Mot de passe',
                            child: Obx(
                              () => TextFormField(
                                controller: c.motDePasseConnexion,
                                obscureText: !c.mdpConnexionVisible.value,
                                style: Design.body1,
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: Design.body1.copyWith(
                                    color: Design.texteSecondaire,
                                  ),
                                  filled: true,
                                  fillColor: Design.blanc,
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Design.texteSecondaire,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: c.basculerMdpConnexion,
                                    icon: Icon(
                                      c.mdpConnexionVisible.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Design.texteSecondaire,
                                    ),
                                  ),
                                  border: _bordure(),
                                  enabledBorder: _bordure(),
                                  focusedBorder: _bordure(focus: true),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: Design.s8),
                          Row(
                            children: [
                              Obx(
                                () => SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: c.seSouvenir.value,
                                    onChanged: c.basculerSeSouvenir,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Design.s8),
                              Expanded(
                                child: Text(
                                  'Se souvenir de moi',
                                  style: Design.body2.copyWith(
                                    color: Design.texte,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: c.motDePasseOublie,
                                child: Text(
                                  'Mot de passe oublié ?',
                                  style: Design.body2.copyWith(
                                    color: Design.primaire,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Design.s24),
                          Obx(
                            () => BoutonSuivantLivreur(
                              texte: 'Se connecter',
                              loading: c.chargementConnexion.value,
                              onTap: c.connexion,
                            ),
                          ),
                          const SizedBox(height: Design.s16),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Design.s12,
                                ),
                                child: Text('ou', style: Design.body2),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: Design.s12),
                          OutlinedButton.icon(
                            onPressed: c.connexionOtp,
                            icon: const Icon(
                              Icons.shield_outlined,
                              color: Design.primaire,
                            ),
                            label: Text(
                              'Connexion avec code OTP',
                              style: Design.body1.copyWith(
                                color: Design.primaire,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              side: const BorderSide(color: Design.primaire),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Design.radiusMd,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: Design.s24),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: "Vous n'avez pas de compte ? ",
                                style: Design.body1,
                                children: [
                                  TextSpan(
                                    text: 'Créer un compte',
                                    style: Design.body1.copyWith(
                                      color: Design.primaire,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Get.toNamed(
                                            Routes.inscriptionLivreur,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: Design.s16),
                          Container(
                            padding: const EdgeInsets.all(Design.s12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F3FF),
                              borderRadius: BorderRadius.circular(
                                Design.radiusMd,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Design.primaire,
                                  size: 20,
                                ),
                                const SizedBox(width: Design.s8),
                                Expanded(
                                  child: Text(
                                    'Besoin d\'aide ? Support 24/7',
                                    style: Design.caption.copyWith(
                                      color: Design.texte,
                                    ),
                                  ),
                                ),
                                Text(
                                  '+241 11 73 45 67',
                                  style: Design.caption.copyWith(
                                    color: Design.primaire,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Design.s8),
                          TextButton(
                            onPressed: () =>
                                Get.offAllNamed(Routes.connexion),
                            child: Text(
                              'Espace patient',
                              style: Design.body2.copyWith(
                                color: Design.texteSecondaire,
                              ),
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

  InputDecoration _decoTelephone() {
    return InputDecoration(
      hintText: '06 12 34 56',
      hintStyle: Design.body1.copyWith(color: Design.texteSecondaire),
      filled: true,
      fillColor: Design.blanc,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.phone_outlined, color: Design.texteSecondaire),
            const SizedBox(width: 8),
            const Text('🇬🇦', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              '+241',
              style: Design.body1.copyWith(fontWeight: FontWeight.w600),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 1,
              height: 24,
              color: Design.bordure,
            ),
          ],
        ),
      ),
      border: _bordure(),
      enabledBorder: _bordure(),
      focusedBorder: _bordure(focus: true),
    );
  }

  OutlineInputBorder _bordure({bool focus = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Design.radiusMd),
      borderSide: BorderSide(
        color: focus ? Design.primaire : Design.bordure,
        width: focus ? 1.5 : 1,
      ),
    );
  }
}
