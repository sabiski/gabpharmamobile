import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_panier.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Icône panier avec badge — accès rapide hors bottom nav.
class BoutonPanier extends StatelessWidget {
  const BoutonPanier({super.key});

  @override
  Widget build(BuildContext context) {
    final panier = Get.find<ControllerPanier>();
    return Obx(() {
      final n = panier.items.fold<int>(0, (s, e) => s + e.quantite);
      return Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.panier),
            icon: const Icon(Icons.shopping_cart_outlined),
            color: Design.texte,
            tooltip: 'Mon panier',
          ),
          if (n > 0)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Design.primaire,
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
            ),
        ],
      );
    });
  }
}
