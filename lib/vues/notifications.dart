import 'package:flutter/material.dart';
import 'package:gabpharmamobile/controllers/controller_metier.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/models/prescription_model.dart';
import 'package:get/get.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ControllerNotifications>();

    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        backgroundColor: Design.blanc,
        surfaceTintColor: Design.blanc,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: Text(
          'Notifications',
          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: c.toutMarquerLu,
            child: Text(
              'Tout marquer lu',
              style: Design.body2.copyWith(
                color: Design.primaire,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Obx(() {
              final f = c.filtre.value;
              final n = c.nonLuesCount;
              return Row(
                children: [
                  Expanded(
                    child: _FiltreChip(
                      label: 'Toutes ($n)',
                      selected: f == FiltreNotifications.toutes,
                      onTap: () =>
                          c.changerFiltre(FiltreNotifications.toutes),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FiltreChip(
                      label: 'Non lues ($n)',
                      selected: f == FiltreNotifications.nonLues,
                      onTap: () =>
                          c.changerFiltre(FiltreNotifications.nonLues),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FiltreChip(
                      label: 'Lues',
                      selected: f == FiltreNotifications.lues,
                      onTap: () => c.changerFiltre(FiltreNotifications.lues),
                    ),
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value && c.notifications.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Design.primaire),
                );
              }
              final list = c.filtrees;
              if (list.isEmpty) {
                return Center(
                  child: Text('Aucune notification', style: Design.body1),
                );
              }

              final groupes = _grouperParJour(list);
              return RefreshIndicator(
                color: Design.primaire,
                onRefresh: c.charger,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    for (final entry in groupes.entries) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 8),
                        child: Text(
                          entry.key,
                          style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      ...entry.value.map(
                        (n) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _CarteNotification(
                            notif: n,
                            onTap: () => c.ouvrir(n),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _BandeauParametres(),
                    const SizedBox(height: 8),
                    _BandeauSecuriteNotif(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Map<String, List<NotificationModel>> _grouperParJour(
    List<NotificationModel> list,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final map = <String, List<NotificationModel>>{
      "Aujourd'hui": [],
      'Hier': [],
      'Plus tôt': [],
    };
    for (final n in list) {
      final d = n.createdAt;
      if (d == null) {
        map['Plus tôt']!.add(n);
        continue;
      }
      final day = DateTime(d.year, d.month, d.day);
      if (day == today) {
        map["Aujourd'hui"]!.add(n);
      } else if (day == yesterday) {
        map['Hier']!.add(n);
      } else {
        map['Plus tôt']!.add(n);
      }
    }
    map.removeWhere((_, v) => v.isEmpty);
    return map;
  }
}

class _FiltreChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FiltreChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Design.primaire : Design.blanc,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(
              color: selected ? Design.primaire : Design.bordure,
            ),
          ),
          child: Text(
            label,
            style: Design.body2.copyWith(
              fontWeight: FontWeight.w700,
              color: selected ? Design.blanc : Design.texte,
            ),
          ),
        ),
      ),
    );
  }
}

class _CarteNotification extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;

  const _CarteNotification({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final style = _stylePour(notif.type);
    final heure = _formatHeure(notif.createdAt);

    return Material(
      color: Design.blanc,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Design.radiusMd),
            border: Border.all(color: Design.bordure),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: style.$1.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(style.$2, color: style.$1, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif.titre ?? 'Notification',
                      style: Design.body1.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (notif.sousTitre != null &&
                        notif.sousTitre!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(notif.sousTitre!, style: Design.caption),
                    ],
                    if (notif.message != null && notif.message!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        notif.message!,
                        style: Design.body2,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(heure, style: Design.caption),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: notif.lue
                              ? Design.bordure
                              : Design.alerte,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Design.texteSecondaire,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, IconData) _stylePour(String? type) {
    switch (type) {
      case 'livraison':
        return (Design.secondaire, Icons.local_shipping_outlined);
      case 'commande':
        return (Design.primaire, Icons.shopping_bag_outlined);
      case 'promo':
        return (Design.attention, Icons.local_offer_outlined);
      case 'paiement':
        return (Design.information, Icons.payments_outlined);
      case 'securite':
        return (Design.primaire, Icons.shield_outlined);
      default:
        return (Design.texteSecondaire, Icons.notifications_outlined);
    }
  }

  String _formatHeure(DateTime? d) {
    if (d == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    if (day == today) {
      return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    }
    if (day == today.subtract(const Duration(days: 1))) return 'Hier';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }
}

class _BandeauParametres extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Design.primaire.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Design.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Ne manquez rien d\'important ! Activez les notifications push.',
              style: Design.body2.copyWith(color: Design.texte, height: 1.35),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () {
              Get.snackbar(
                'Paramètres',
                'Préférences notifications à brancher (FCM).',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Design.primaire,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Paramètres',
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

class _BandeauSecuriteNotif extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Design.surface,
        borderRadius: BorderRadius.circular(Design.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user_outlined, color: Design.secondaire),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Vos données sont sécurisées.',
              style: Design.body2.copyWith(
                color: Design.texte,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
