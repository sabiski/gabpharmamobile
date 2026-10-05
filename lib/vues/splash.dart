import 'package:flutter/material.dart';
import 'package:gabpharmamobile/composants/logo_gabpharma.dart';
import 'package:gabpharmamobile/controllers/controller_auth.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  Future<void> _boot() async {
    await Get.find<ControllerAuth>().verifierSession();
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final auth = Get.find<ControllerAuth>();
    Get.offAllNamed(
      auth.estConnecte.value ? Routes.navigation : Routes.connexion,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(_boot);
    return Scaffold(
      backgroundColor: Design.blanc,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoGabPharma(size: 96, showSlogan: false),
            const SizedBox(height: Design.s16),
            Text(
              "Gab'Pharma",
              style: Design.h2.copyWith(
                color: Design.texte,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'La plateforme nationale du médicament',
              style: Design.body2.copyWith(color: Design.texteSecondaire),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: Design.primaire),
          ],
        ),
      ),
    );
  }
}
