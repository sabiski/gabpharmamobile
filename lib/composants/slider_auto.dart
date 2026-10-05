import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_navigation.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

class SlideGabPharma {
  final String image;
  final String titre;
  final String sousTitre;
  final String cta;
  final Alignment alignement;
  final VoidCallback? onCta;

  const SlideGabPharma({
    required this.image,
    required this.titre,
    required this.sousTitre,
    required this.cta,
    this.alignement = Alignment.center,
    this.onCta,
  });
}

/// Slider auto-défilant avec images recadrées + textes lisibles.
class SliderAutoGabPharma extends StatefulWidget {
  final double height;
  final BorderRadius? borderRadius;
  final Duration intervalle;
  final bool afficherIndicateurs;
  final List<SlideGabPharma>? slides;

  static List<SlideGabPharma> get slidesDefaut => [
        SlideGabPharma(
          image: 'images/slide_1.jpg',
          titre: 'Prenez soin de vous et de vos proches',
          sousTitre:
              'Trouvez vos médicaments rapidement et en toute sécurité.',
          cta: 'Rechercher un médicament',
          alignement: const Alignment(0, -0.25),
          onCta: () {
            if (Get.isRegistered<ControllerNavigation>()) {
              Get.find<ControllerNavigation>().recherche();
            }
          },
        ),
        SlideGabPharma(
          image: 'images/slide_2.jpg',
          titre: 'Pharmacies de garde près de vous',
          sousTitre:
              'Localisez une officine ouverte 24h/24 en un clin d’œil.',
          cta: 'Voir les pharmacies',
          alignement: Alignment.center,
          onCta: () => Get.toNamed(Routes.pharmacies),
        ),
        SlideGabPharma(
          image: 'images/slide_3_livreur.jpg',
          titre: 'Livraison à domicile',
          sousTitre:
              'Commandez en ligne et recevez vos médicaments rapidement.',
          cta: 'Découvrir',
          alignement: const Alignment(0, -0.2),
          onCta: () {
            if (Get.isRegistered<ControllerNavigation>()) {
              Get.find<ControllerNavigation>().recherche();
            }
          },
        ),
      ];

  const SliderAutoGabPharma({
    super.key,
    this.height = 180,
    this.borderRadius,
    this.intervalle = const Duration(seconds: 4),
    this.afficherIndicateurs = true,
    this.slides,
  });

  @override
  State<SliderAutoGabPharma> createState() => _SliderAutoGabPharmaState();
}

class _SliderAutoGabPharmaState extends State<SliderAutoGabPharma> {
  late final PageController _controller;
  late final List<SlideGabPharma> _slides;
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _slides = widget.slides ?? SliderAutoGabPharma.slidesDefaut;
    _controller = PageController(viewportFraction: 0.94);
    _demarrerAuto();
  }

  void _demarrerAuto() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.intervalle, (_) {
      if (!mounted || !_controller.hasClients || _slides.isEmpty) return;
      final suivant = (_index + 1) % _slides.length;
      _controller.animateToPage(
        suivant,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius =
        widget.borderRadius ?? BorderRadius.circular(Design.radiusLg);

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) {
              final slide = _slides[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        slide.image,
                        fit: BoxFit.cover,
                        alignment: slide.alignement,
                        errorBuilder: (_, error, stack) => Container(
                          color: Design.primaire,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Design.blanc,
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.black.withValues(alpha: 0.15),
                              Colors.black.withValues(alpha: 0.55),
                              Colors.black.withValues(alpha: 0.72),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Design.s16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slide.titre,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Design.h3.copyWith(
                                color: Design.blanc,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              slide.sousTitre,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Design.body2.copyWith(
                                color: Colors.white.withValues(alpha: 0.92),
                                height: 1.35,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 36,
                              child: FilledButton(
                                onPressed: slide.onCta,
                                style: FilledButton.styleFrom(
                                  backgroundColor: Design.blanc,
                                  foregroundColor: Design.primaire,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      Design.radiusSm,
                                    ),
                                  ),
                                  textStyle: Design.body2.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Design.primaire,
                                  ),
                                ),
                                child: Text(slide.cta),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.afficherIndicateurs) ...[
          const SizedBox(height: Design.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (i) {
              final actif = i == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: actif ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: actif ? Design.primaire : Design.bordure,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
