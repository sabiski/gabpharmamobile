import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_navigation.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/vues/accueil.dart';
import 'package:gabpharmamobile/vues/ecrans.dart';
import 'package:get/get.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  static const _pages = [
    Accueil(),
    Recherche(),
    Commandes(),
    Favoris(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<ControllerNavigation>();

    return Obx(() {
      final index = nav.index.value;
      return Scaffold(
        body: IndexedStack(
          index: index,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Design.blanc,
            border: Border(top: BorderSide(color: Design.bordure)),
          ),
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: nav.allerA,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Design.blanc,
            selectedItemColor: Design.secondaire,
            unselectedItemColor: Design.texteSecondaire,
            selectedLabelStyle: Design.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: Design.secondaire,
            ),
            unselectedLabelStyle: Design.caption,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Recherche',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Commandes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Favoris',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      );
    });
  }
}
