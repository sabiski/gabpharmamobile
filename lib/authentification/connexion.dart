import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/input_component.dart';
import 'package:gabpharmamobile/composants/logo_gabpharma.dart';
import 'package:gabpharmamobile/controllers/controller_auth.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

class Connexion extends StatelessWidget {
  Connexion({super.key});

  final ControllerAuth controller = Get.find<ControllerAuth>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.blanc,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Design.s24,
            vertical: Design.s16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Design.s24),
              const LogoGabPharma(size: 96),
              const SizedBox(height: Design.s24),
              Text('Bienvenue !', style: Design.h2, textAlign: TextAlign.center),
              const SizedBox(height: Design.s8),
              Text(
                'Connectez-vous pour accéder à tous nos services.',
                textAlign: TextAlign.center,
                style: Design.body1.copyWith(color: Design.texteSecondaire),
              ),
              const SizedBox(height: Design.s24),
              InputComponent(
                label: 'Adresse e-mail ou téléphone',
                controller: controller.identifiantController,
                keyboardType: TextInputType.emailAddress,
                leading: const Icon(Icons.mail_outline),
              ),
              const SizedBox(height: Design.s16),
              Obx(
                () => InputComponent(
                  label: 'Mot de passe',
                  controller: controller.motDePasseController,
                  obscureText: !controller.motDePasseVisible.value,
                  leading: const Icon(Icons.lock_outline),
                  trailing: Icon(
                    controller.motDePasseVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onTrailingTap: controller.basculerVisibiliteMotDePasse,
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
                        value: controller.seSouvenirDeMoi.value,
                        onChanged: controller.basculerSeSouvenir,
                      ),
                    ),
                  ),
                  const SizedBox(width: Design.s8),
                  Expanded(
                    child: Text(
                      'Se souvenir de moi',
                      style: Design.body2.copyWith(color: Design.texte),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.motDePasseOublie,
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
                () => BoutonPrincipal(
                  texte: 'Se connecter',
                  loading: controller.isLoading.value,
                  onTap: controller.connexion,
                ),
              ),
              const SizedBox(height: Design.s24),
              Row(
                children: [
                  const Expanded(child: Divider(color: Design.bordure)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Design.s16),
                    child: Text(
                      'ou continuer avec',
                      style: Design.body2,
                    ),
                  ),
                  const Expanded(child: Divider(color: Design.bordure)),
                ],
              ),
              const SizedBox(height: Design.s16),
              BoutonOutlineSocial(
                texte: 'Continuer avec Google',
                icone: const _GoogleIcon(),
                onTap: controller.connexionGoogle,
              ),
              const SizedBox(height: Design.s8),
              BoutonOutlineSocial(
                texte: 'Continuer avec Apple',
                icone: const Icon(Icons.apple, size: 22, color: Design.texte),
                onTap: controller.connexionApple,
              ),
              const SizedBox(height: Design.s24),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Pas encore de compte ? ',
                    style: Design.body1.copyWith(color: Design.texte),
                    children: [
                      TextSpan(
                        text: "S'inscrire",
                        style: Design.body1.copyWith(
                          color: Design.primaire,
                          fontWeight: FontWeight.w700,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.toNamed(Routes.inscription),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Design.s12),
              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed(Routes.connexionLivreur),
                  child: Text(
                    'Vous êtes livreur ? Se connecter',
                    style: Design.body2.copyWith(
                      color: Design.primaire,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Design.s8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icône Google simplifiée (4 couleurs) — sans asset externe.
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _GoogleIconPainter(),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final colors = [
      const Color(0xFFEA4335),
      const Color(0xFFFBBC05),
      const Color(0xFF34A853),
      const Color(0xFF4285F4),
    ];
    final starts = [ -0.4, 0.9, 2.2, 3.6 ];
    final sweeps = [ 1.3, 1.3, 1.4, 1.5 ];

    for (var i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        starts[i],
        sweeps[i],
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.2
          ..strokeCap = StrokeCap.butt,
      );
    }

    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.35,
      Paint()..color = Design.blanc,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
