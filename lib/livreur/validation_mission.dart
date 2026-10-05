import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_livraison_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_mission.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Validation récupération en pharmacie.
class ValidationRecuperation extends StatefulWidget {
  const ValidationRecuperation({super.key});

  @override
  State<ValidationRecuperation> createState() => _ValidationRecuperationState();
}

class _ValidationRecuperationState extends State<ValidationRecuperation> {
  final _codeCtrl = TextEditingController();
  final _c = Get.find<ControllerLivraisonLivreur>();
  bool _signatureOk = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: Obx(() {
          final l = _c.livraison.value;
          if (l == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              EnteteLivreur(onUrgence: _c.urgence),
              const SizedBox(height: Design.s8),
              const StepperMission(etape: 0),
              const SizedBox(height: Design.s16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: Design.s16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Validation de récupération de la commande',
                        style: Design.h3.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: Design.s12),
                      _CarteCommande(l: l),
                      const SizedBox(height: Design.s16),
                      Text(
                        '1. Scanner le code de la commande',
                        style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Scannez le QR code ou le code-barres sur le colis.',
                        style: Design.caption,
                      ),
                      const SizedBox(height: Design.s8),
                      OutlinedButton.icon(
                        onPressed: () {
                          _c.codeCommandeScanne.value = true;
                          _codeCtrl.text = l.reference;
                          Get.snackbar(
                            'Scan',
                            'Code ${l.reference} reconnu (démo).',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Scanner le QR code'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Design.primaire,
                          side: const BorderSide(
                            color: Design.primaire,
                            style: BorderStyle.solid,
                          ),
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Design.radiusMd),
                          ),
                        ),
                      ),
                      const SizedBox(height: Design.s8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _codeCtrl,
                              style: Design.body1,
                              decoration: InputDecoration(
                                hintText: 'Saisir le code',
                                filled: true,
                                fillColor: Design.blanc,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    Design.radiusMd,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: Design.s8),
                          FilledButton(
                            onPressed: () {
                              if (_codeCtrl.text.trim().isEmpty) return;
                              _c.codeCommandeScanne.value = true;
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Design.primaire,
                              minimumSize: const Size(88, 48),
                            ),
                            child: const Text('Valider'),
                          ),
                        ],
                      ),
                      Obx(
                        () => _c.codeCommandeScanne.value
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '✓ Code validé',
                                  style: Design.caption.copyWith(
                                    color: Design.secondaire,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: Design.s24),
                      Text(
                        '2. Signature / cachet de la pharmacie',
                        style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Faites signer ou tamponner le pharmacien.',
                        style: Design.caption,
                      ),
                      const SizedBox(height: Design.s8),
                      PadSignature(
                        nomSignataire: 'Pharmacien',
                        onChange: (ok) {
                          setState(() => _signatureOk = ok);
                          _c.signaturePharmacie.value = ok;
                        },
                      ),
                      const SizedBox(height: Design.s24),
                      Text(
                        '3. Preuve de récupération (optionnel)',
                        style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prenez une photo du colis comme preuve.',
                        style: Design.caption,
                      ),
                      const SizedBox(height: Design.s8),
                      Obx(
                        () => _c.photoRecuperation.value
                            ? Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F3FF),
                                      borderRadius: BorderRadius.circular(
                                        Design.radiusMd,
                                      ),
                                      border: Border.all(color: Design.bordure),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.inventory_2_outlined,
                                        size: 40,
                                        color: Design.primaire,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _c.photoRecuperation.value = false,
                                    icon: const Icon(Icons.close, size: 18),
                                  ),
                                ],
                              )
                            : OutlinedButton.icon(
                                onPressed: () =>
                                    _c.photoRecuperation.value = true,
                                icon: const Icon(Icons.camera_alt_outlined),
                                label: const Text('Prendre une photo'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Design.texteSecondaire,
                                  side: BorderSide(
                                    color: Design.bordure,
                                  ),
                                  minimumSize: const Size.fromHeight(52),
                                ),
                              ),
                      ),
                      const SizedBox(height: Design.s16),
                      Container(
                        padding: const EdgeInsets.all(Design.s12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              color: Design.primaire,
                            ),
                            const SizedBox(width: Design.s8),
                            Expanded(
                              child: Text(
                                'Assurez-vous que la commande correspond avant de valider la récupération.',
                                style: Design.caption.copyWith(
                                  color: Design.texte,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Design.s24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Design.s16,
                  0,
                  Design.s16,
                  Design.s12,
                ),
                child: Column(
                  children: [
                    BoutonSuivantLivreur(
                      texte: "J'ai récupéré la commande",
                      onTap: () {
                        if (!_c.codeCommandeScanne.value &&
                            _codeCtrl.text.trim().isEmpty) {
                          Get.snackbar(
                            'Code requis',
                            'Scannez ou saisissez le code commande.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }
                        if (!_signatureOk && !_c.signaturePharmacie.value) {
                          Get.snackbar(
                            'Signature',
                            'La signature pharmacie est requise.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }
                        _c.confirmerRecuperation();
                        Get.offNamed(Routes.carteSuiviLivreur);
                      },
                    ),
                    const SizedBox(height: Design.s8),
                    OutlinedButton(
                      onPressed: () {
                        Get.snackbar(
                          'Mission annulée',
                          'Annulation à brancher (API).',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Design.erreur,
                        side: const BorderSide(color: Design.erreur),
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text('Annuler la mission'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _CarteCommande extends StatelessWidget {
  final LivraisonLivreur l;
  const _CarteCommande({required this.l});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Design.s16),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Commande #${l.reference}',
                  style: Design.body1.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(Design.radiusPill),
                ),
                child: Text(
                  'En attente',
                  style: Design.caption.copyWith(
                    color: Design.secondaire,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Design.s12),
          Row(
            children: [
              const Icon(Icons.storefront, color: Design.secondaire, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.pharmacie.nom,
                  style: Design.body1.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Text(l.pharmacie.adresse, style: Design.caption),
          Text(l.pharmacie.telephone, style: Design.caption),
          const SizedBox(height: Design.s8),
          Text(
            'Retrait ${l.recupererAvant} · ${l.distanceKm.toStringAsFixed(1)} km',
            style: Design.body2.copyWith(color: Design.texte),
          ),
          Text(
            'Client : ${l.client.nom}',
            style: Design.body2.copyWith(color: Design.texte),
          ),
          Text(
            'Montant : ${l.montantPercevoir} FCFA',
            style: Design.body1.copyWith(
              color: Design.secondaire,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Validation remise au client (OTP + signature).
class ValidationLivraison extends StatefulWidget {
  const ValidationLivraison({super.key});

  @override
  State<ValidationLivraison> createState() => _ValidationLivraisonState();
}

class _ValidationLivraisonState extends State<ValidationLivraison> {
  final _c = Get.find<ControllerLivraisonLivreur>();
  final _otp = List.generate(4, (_) => TextEditingController());
  final _focus = List.generate(4, (_) => FocusNode());
  bool _modeSignature = true;
  bool _signatureOk = false;
  String _messageOtp = 'Code démo : 1957';
  Color _couleurOtp = Design.texteSecondaire;

  static const _codeAttendu = '1957';

  @override
  void dispose() {
    for (final c in _otp) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  String get _codeSaisi => _otp.map((c) => c.text).join();

  void _verifierOtp() {
    final code = _codeSaisi;
    if (code.length < 4) {
      _c.otpValide.value = false;
      setState(() {
        _messageOtp = 'Code démo : $_codeAttendu';
        _couleurOtp = Design.texteSecondaire;
      });
      return;
    }
    final ok = code == _codeAttendu;
    _c.otpValide.value = ok;
    setState(() {
      _messageOtp = ok ? '✓ Code valide' : '✗ Code incorrect';
      _couleurOtp = ok ? Design.secondaire : Design.erreur;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = _c.livraison.value;
    if (l == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Design.fond,
      body: SafeArea(
        child: Column(
          children: [
            EnteteLivreur(onUrgence: _c.urgence),
            const SizedBox(height: Design.s8),
            const StepperMission(etape: 2),
            const SizedBox(height: Design.s16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Design.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Design.secondaire,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Validation de remise au client',
                            style: Design.h3.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vous êtes arrivé chez le client. Faites valider la livraison pour terminer la mission.',
                      style: Design.caption,
                    ),
                    const SizedBox(height: Design.s12),
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
                          Row(
                            children: [
                              Text(
                                'Commande #${l.reference}',
                                style: Design.body1.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(
                                    Design.radiusPill,
                                  ),
                                ),
                                child: Text(
                                  'En livraison',
                                  style: Design.caption.copyWith(
                                    color: Design.secondaire,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Design.s12),
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFF5F3FF),
                                child: Icon(
                                  Icons.person,
                                  color: Design.primaire,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l.client.nom,
                                      style: Design.body1.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      l.client.adresse,
                                      style: Design.caption,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    _c.appeler(l.client.telephone),
                                icon: const Icon(
                                  Icons.phone_outlined,
                                  color: Design.primaire,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l.payeEnLigne
                                ? 'Payé en ligne · ${l.montantPercevoir} FCFA'
                                : 'À encaisser · ${l.montantPercevoir} FCFA',
                            style: Design.body2.copyWith(
                              color: Design.secondaire,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Design.s24),
                    Text(
                      '1. Code de validation (OTP)',
                      style: Design.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Demandez au client le code à 4 chiffres envoyé sur son téléphone.',
                      style: Design.caption,
                    ),
                    const SizedBox(height: Design.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (i) {
                        return Container(
                          width: 52,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextFormField(
                            controller: _otp[i],
                            focusNode: _focus[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: Design.h2,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: Design.blanc,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Design.bordure,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Design.primaire,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            onChanged: (v) {
                              if (v.isNotEmpty && i < 3) {
                                _focus[i + 1].requestFocus();
                              }
                              if (v.isEmpty && i > 0) {
                                _focus[i - 1].requestFocus();
                              }
                              _verifierOtp();
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: Design.s8),
                    Text(
                      _messageOtp,
                      style: Design.body2.copyWith(
                        color: _couleurOtp,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Design.s24),
                    Text(
                      '2. Signature du client (ou preuve)',
                      style: Design.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Faites signer le client ou prenez une photo comme preuve.',
                      style: Design.caption,
                    ),
                    const SizedBox(height: Design.s8),
                    Row(
                      children: [
                        Expanded(
                          child: _TogglePreuve(
                            label: 'Signature',
                            actif: _modeSignature,
                            onTap: () =>
                                setState(() => _modeSignature = true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _TogglePreuve(
                            label: 'Photo',
                            actif: !_modeSignature,
                            onTap: () =>
                                setState(() => _modeSignature = false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Design.s12),
                    if (_modeSignature)
                      PadSignature(
                        nomSignataire: '${l.client.nom} (Client)',
                        onChange: (ok) {
                          setState(() => _signatureOk = ok);
                          _c.signatureClient.value = ok;
                        },
                      )
                    else
                      Obx(
                        () => OutlinedButton.icon(
                          onPressed: () => _c.photoLivraison.value = true,
                          icon: Icon(
                            _c.photoLivraison.value
                                ? Icons.check_circle
                                : Icons.camera_alt_outlined,
                            color: _c.photoLivraison.value
                                ? Design.secondaire
                                : Design.primaire,
                          ),
                          label: Text(
                            _c.photoLivraison.value
                                ? 'Photo ajoutée'
                                : 'Prendre une photo',
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                        ),
                      ),
                    const SizedBox(height: Design.s16),
                    Container(
                      padding: const EdgeInsets.all(Design.s12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(Design.radiusMd),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: Design.secondaire,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Vérifiez l\'identité du destinataire. Ne partagez jamais le code de livraison.',
                              style: Design.caption.copyWith(
                                color: Design.texte,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Design.s24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Design.s16,
                0,
                Design.s16,
                Design.s12,
              ),
              child: Column(
                children: [
                  BoutonSuivantLivreur(
                    texte: 'Livraison terminée',
                    onTap: () {
                      if (!_c.otpValide.value) {
                        Get.snackbar(
                          'OTP',
                          'Saisissez le code client valide.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      final preuveOk = _modeSignature
                          ? (_signatureOk || _c.signatureClient.value)
                          : _c.photoLivraison.value;
                      if (!preuveOk) {
                        Get.snackbar(
                          'Preuve',
                          'Signature ou photo requise.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                      _c.confirmerLivraison();
                      Get.offAllNamed(Routes.navigationLivreur);
                      _c.onglet.value = 1;
                    },
                  ),
                  const SizedBox(height: Design.s8),
                  OutlinedButton.icon(
                    onPressed: _c.signalerProbleme,
                    icon: const Icon(
                      Icons.flag_outlined,
                      color: Design.erreur,
                    ),
                    label: Text(
                      'Signaler un problème',
                      style: Design.body1.copyWith(color: Design.erreur),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Design.erreur),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TogglePreuve extends StatelessWidget {
  final String label;
  final bool actif;
  final VoidCallback onTap;

  const _TogglePreuve({
    required this.label,
    required this.actif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Design.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: actif ? Design.primaire : Design.blanc,
          borderRadius: BorderRadius.circular(Design.radiusMd),
          border: Border.all(
            color: actif ? Design.primaire : Design.bordure,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Design.body2.copyWith(
            color: actif ? Design.blanc : Design.texte,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
