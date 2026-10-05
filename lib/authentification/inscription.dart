import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/input_component.dart';
import 'package:gabpharmamobile/composants/logo_gabpharma.dart';
import 'package:gabpharmamobile/controllers/controller_auth.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

class Inscription extends StatelessWidget {
  Inscription({super.key});

  final ControllerAuth controller = Get.find<ControllerAuth>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(title: const Text('Création de compte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: LogoGabPharma(size: 64, showSlogan: false)),
              const SizedBox(height: Design.s16),
              const Text(
                'Inscription patient',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Design.vertFonce,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Structure provisoire — champs prêts pour POST /api/v1/auth/register/.',
                style: TextStyle(color: Design.texteSecondaire, height: 1.5),
              ),
              const SizedBox(height: 20),
              InputComponent(
                title: 'Nom',
                label: 'Nom',
                controller: controller.nomController,
              ),
              const SizedBox(height: 10),
              InputComponent(
                title: 'Prénom',
                label: 'Prénom',
                controller: controller.prenomController,
              ),
              const SizedBox(height: 10),
              InputComponent(
                title: 'Identifiant',
                label: 'Nom d\'utilisateur',
                controller: controller.identifiantController,
              ),
              const SizedBox(height: 10),
              InputComponent(
                title: 'E-mail',
                label: 'email@exemple.com',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              InputComponent(
                title: 'Téléphone',
                label: '+241 …',
                controller: controller.telephoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              InputComponent(
                title: 'Mot de passe',
                label: '••••••••',
                controller: controller.motDePasseController,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Obx(
                () => BoutonPrincipal(
                  texte: 'Créer mon compte',
                  loading: controller.isLoading.value,
                  onTap: controller.inscription,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: 'Déjà un compte ? ',
                    children: [
                      TextSpan(
                        text: 'Se connecter',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Design.vert,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.offNamed(Routes.connexion),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
