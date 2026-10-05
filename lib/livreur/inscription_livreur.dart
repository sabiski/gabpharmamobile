import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gabpharmamobile/design/design.dart';
import 'package:gabpharmamobile/livreur/controller_auth_livreur.dart';
import 'package:gabpharmamobile/livreur/widgets_livreur.dart';
import 'package:gabpharmamobile/routes/routes.dart';
import 'package:get/get.dart';

/// Inscription livreur — wizard 4 étapes (Société → Livreur → Documents → Confirmation).
class InscriptionLivreur extends StatelessWidget {
  InscriptionLivreur({super.key});

  final ControllerAuthLivreur c = Get.find<ControllerAuthLivreur>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: c.precedent,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/logo_gabpharma.png',
              height: 28,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Obx(
                () => Text(
                  c.etape.value == 1
                      ? 'Créer un compte livreur'
                      : 'Créer un compte',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Get.snackbar(
                'Aide',
                'Support inscription livreur : +241 11 73 45 67',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Design.s16,
              Design.s8,
              Design.s16,
              Design.s16,
            ),
            child: Obx(() => StepperLivreur(etapeActive: c.etape.value)),
          ),
          Expanded(
            child: Obx(() {
              switch (c.etape.value) {
                case 0:
                  return _EtapeSociete(c: c);
                case 1:
                  return _EtapeLivreur(c: c);
                case 2:
                  return _EtapeDocuments(c: c);
                default:
                  return _EtapeConfirmation(c: c);
              }
            }),
          ),
        ],
      ),
    );
  }
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

InputDecoration _deco({
  String? hint,
  Widget? prefix,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: Design.body1.copyWith(color: Design.texteSecondaire),
    filled: true,
    fillColor: Design.blanc,
    prefixIcon: prefix,
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: _bordure(),
    enabledBorder: _bordure(),
    focusedBorder: _bordure(focus: true),
  );
}

class _EtapeSociete extends StatelessWidget {
  final ControllerAuthLivreur c;
  const _EtapeSociete({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(Design.s24, 0, Design.s24, Design.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: IllustrationScooter(height: 64)),
          const SizedBox(height: Design.s12),
          Text(
            'Informations sur la société de livraison',
            style: Design.h3.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Design.s8),
          Text(
            'Créez le compte de votre société pour gérer vos livreurs et vos livraisons sur Gab\'Pharma.',
            style: Design.body1.copyWith(
              color: Design.texteSecondaire,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Design.s24),
          ChampLabel(
            label: 'Nom de la société',
            child: TextFormField(
              controller: c.nomSociete,
              style: Design.body1,
              decoration: _deco(hint: 'Ex : Gozem Delivery Gabon'),
            ),
          ),
          const SizedBox(height: Design.s16),
          Row(
            children: [
              Expanded(
                child: ChampLabel(
                  label: 'Nom commercial',
                  child: TextFormField(
                    controller: c.nomCommercial,
                    style: Design.body1,
                    decoration: _deco(hint: 'Nom commercial'),
                  ),
                ),
              ),
              const SizedBox(width: Design.s12),
              Expanded(
                child: ChampLabel(
                  label: 'Pays',
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Design.blanc,
                      borderRadius: BorderRadius.circular(Design.radiusMd),
                      border: Border.all(color: Design.bordure),
                    ),
                    child: Row(
                      children: [
                        const Text('🇬🇦', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text('Gabon', style: Design.body1),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Design.texteSecondaire,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Design.s16),
          Row(
            children: [
              Expanded(
                child: ChampLabel(
                  label: 'Numéro RCCM',
                  child: TextFormField(
                    controller: c.numeroRccm,
                    style: Design.body1,
                    decoration: _deco(hint: 'RCCM'),
                  ),
                ),
              ),
              const SizedBox(width: Design.s12),
              Expanded(
                child: ChampLabel(
                  label: 'Numéro fiscal (NIF)',
                  child: TextFormField(
                    controller: c.numeroFiscal,
                    style: Design.body1,
                    decoration: _deco(hint: 'NIF'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Adresse du siège',
            child: TextFormField(
              controller: c.adresseSiege,
              style: Design.body1,
              decoration: _deco(
                hint: 'Adresse complète',
                prefix: const Icon(
                  Icons.location_on_outlined,
                  color: Design.texteSecondaire,
                ),
              ),
            ),
          ),
          const SizedBox(height: Design.s16),
          Row(
            children: [
              Expanded(
                child: ChampLabel(
                  label: 'Téléphone',
                  child: TextFormField(
                    controller: c.telephoneSociete,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: Design.body1,
                    decoration: _deco(
                      hint: '+241 …',
                      prefix: const Icon(
                        Icons.phone_outlined,
                        color: Design.texteSecondaire,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Design.s12),
              Expanded(
                child: ChampLabel(
                  label: 'Email professionnel',
                  child: TextFormField(
                    controller: c.emailSociete,
                    keyboardType: TextInputType.emailAddress,
                    style: Design.body1,
                    decoration: _deco(
                      hint: 'email@…',
                      prefix: const Icon(
                        Icons.mail_outline,
                        color: Design.texteSecondaire,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Design.s16),
          Row(
            children: [
              Expanded(
                child: ChampLabel(
                  label: 'Mot de passe',
                  child: Obx(
                    () => TextFormField(
                      controller: c.mdpSociete,
                      obscureText: !c.mdpSocieteVisible.value,
                      style: Design.body1,
                      decoration: _deco(
                        hint: '••••••••',
                        prefix: const Icon(
                          Icons.lock_outline,
                          color: Design.texteSecondaire,
                        ),
                        suffix: IconButton(
                          onPressed: c.basculerMdpSociete,
                          icon: Icon(
                            c.mdpSocieteVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Design.texteSecondaire,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Design.s12),
              Expanded(
                child: ChampLabel(
                  label: 'Confirmer',
                  child: Obx(
                    () => TextFormField(
                      controller: c.mdpSocieteConfirm,
                      obscureText: !c.mdpSocieteConfirmVisible.value,
                      style: Design.body1,
                      decoration: _deco(
                        hint: '••••••••',
                        prefix: const Icon(
                          Icons.lock_outline,
                          color: Design.texteSecondaire,
                        ),
                        suffix: IconButton(
                          onPressed: c.basculerMdpSocieteConfirm,
                          icon: Icon(
                            c.mdpSocieteConfirmVisible.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Design.texteSecondaire,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Zone(s) de couverture',
            child: Obx(
              () => ChipsZones(
                selection: c.zonesCouverture.toList(),
                disponibles: ControllerAuthLivreur.zonesDisponibles,
                onAjouter: c.ajouterZoneCouverture,
                onRetirer: c.retirerZoneCouverture,
              ),
            ),
          ),
          const SizedBox(height: Design.s16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ChampLabel(
                  label: 'Logo de la société',
                  child: InkWell(
                    onTap: () => c.logoChoisi.value = true,
                    borderRadius: BorderRadius.circular(Design.radiusMd),
                    child: Obx(
                      () => Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Design.blanc,
                          borderRadius: BorderRadius.circular(Design.radiusMd),
                          border: Border.all(
                            color: c.logoChoisi.value
                                ? Design.secondaire
                                : Design.bordure,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              c.logoChoisi.value
                                  ? Icons.check_circle
                                  : Icons.cloud_upload_outlined,
                              color: c.logoChoisi.value
                                  ? Design.secondaire
                                  : Design.primaire,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.logoChoisi.value
                                  ? 'Logo ajouté'
                                  : 'Cliquez pour téléverser',
                              style: Design.caption,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Design.s12),
              Expanded(
                child: ChampLabel(
                  label: 'Couleur principale',
                  requis: false,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Design.blanc,
                      borderRadius: BorderRadius.circular(Design.radiusMd),
                      border: Border.all(color: Design.bordure),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Design.primaire,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(
                          () => Text(
                            c.couleurPrincipale.value,
                            style: Design.body1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Design.s24),
          Obx(
            () => CaseConditions(
              value: c.accepteConditions.value,
              onChanged: (v) => c.accepteConditions.value = v ?? false,
            ),
          ),
          const SizedBox(height: Design.s24),
          BoutonSuivantLivreur(texte: 'Suivant', onTap: c.suivant),
          const SizedBox(height: Design.s16),
          Center(
            child: Text.rich(
              TextSpan(
                text: 'Vous avez déjà un compte ? ',
                style: Design.body1,
                children: [
                  TextSpan(
                    text: 'Connectez-vous',
                    style: Design.body1.copyWith(
                      color: Design.information,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () =>
                          Get.offNamed(Routes.connexionLivreur),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EtapeLivreur extends StatelessWidget {
  final ControllerAuthLivreur c;
  const _EtapeLivreur({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(Design.s24, 0, Design.s24, Design.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(Design.s16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(Design.radiusMd),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: IllustrationLivreur(height: 90),
                ),
                const SizedBox(width: Design.s8),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations du livreur',
                        style: Design.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ces informations permettront aux clients de savoir que c\'est un livreur de votre société qui livre le colis.',
                        style: Design.caption.copyWith(height: 1.35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Design.s24),
          Text(
            'Informations personnelles',
            style: Design.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Nom complet',
            child: TextFormField(
              controller: c.nomComplet,
              style: Design.body1,
              decoration: _deco(hint: 'Ex : Jean Claude Moussavou'),
            ),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Date de naissance',
            child: TextFormField(
              controller: c.dateNaissance,
              readOnly: true,
              onTap: () => c.choisirDateNaissance(context),
              style: Design.body1,
              decoration: _deco(
                hint: 'JJ/MM/AAAA',
                prefix: const Icon(
                  Icons.calendar_today_outlined,
                  color: Design.texteSecondaire,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Numéro de téléphone',
            child: TextFormField(
              controller: c.telephoneLivreur,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: Design.body1,
              decoration: InputDecoration(
                hintText: '06 12 34 56',
                hintStyle: Design.body1.copyWith(color: Design.texteSecondaire),
                filled: true,
                fillColor: Design.blanc,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.phone_outlined,
                        color: Design.texteSecondaire,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '+241',
                        style: Design.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 1,
                        height: 22,
                        color: Design.bordure,
                      ),
                    ],
                  ),
                ),
                border: _bordure(),
                enabledBorder: _bordure(),
                focusedBorder: _bordure(focus: true),
              ),
            ),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Email',
            child: TextFormField(
              controller: c.emailLivreur,
              keyboardType: TextInputType.emailAddress,
              style: Design.body1,
              decoration: _deco(
                hint: 'email@exemple.com',
                prefix: const Icon(
                  Icons.mail_outline,
                  color: Design.texteSecondaire,
                ),
              ),
            ),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Adresse de résidence',
            child: TextFormField(
              controller: c.adresseResidence,
              style: Design.body1,
              decoration: _deco(
                hint: 'Quartier, ville…',
                prefix: const Icon(
                  Icons.location_on_outlined,
                  color: Design.texteSecondaire,
                ),
              ),
            ),
          ),
          const SizedBox(height: Design.s24),
          Text(
            'Informations professionnelles',
            style: Design.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'ID livreur (matricule)',
            child: TextFormField(
              controller: c.idLivreur,
              style: Design.body1,
              decoration: _deco(hint: 'Ex : GOZ-2024-0156'),
            ),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Zone(s) de livraison',
            child: Obx(
              () => ChipsZones(
                selection: c.zonesLivraison.toList(),
                disponibles: ControllerAuthLivreur.zonesDisponibles,
                onAjouter: c.ajouterZoneLivraison,
                onRetirer: c.retirerZoneLivraison,
              ),
            ),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Mot de passe',
            child: Obx(
              () => TextFormField(
                controller: c.mdpLivreur,
                obscureText: !c.mdpLivreurVisible.value,
                style: Design.body1,
                decoration: _deco(
                  hint: '••••••••',
                  prefix: const Icon(
                    Icons.lock_outline,
                    color: Design.texteSecondaire,
                  ),
                  suffix: IconButton(
                    onPressed: c.basculerMdpLivreur,
                    icon: Icon(
                      c.mdpLivreurVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Design.texteSecondaire,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Design.s16),
          ChampLabel(
            label: 'Confirmer le mot de passe',
            child: Obx(
              () => TextFormField(
                controller: c.mdpLivreurConfirm,
                obscureText: !c.mdpLivreurConfirmVisible.value,
                style: Design.body1,
                decoration: _deco(
                  hint: '••••••••',
                  prefix: const Icon(
                    Icons.lock_outline,
                    color: Design.texteSecondaire,
                  ),
                  suffix: IconButton(
                    onPressed: c.basculerMdpLivreurConfirm,
                    icon: Icon(
                      c.mdpLivreurConfirmVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Design.texteSecondaire,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Design.s24),
          Obx(
            () => CaseConditions(
              value: c.accepteConditionsLivreur.value,
              onChanged: (v) =>
                  c.accepteConditionsLivreur.value = v ?? false,
            ),
          ),
          const SizedBox(height: Design.s24),
          BoutonSuivantLivreur(texte: 'Suivant', onTap: c.suivant),
        ],
      ),
    );
  }
}

class _EtapeDocuments extends StatelessWidget {
  final ControllerAuthLivreur c;
  const _EtapeDocuments({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(Design.s24, 0, Design.s24, Design.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Documents requis',
            style: Design.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: Design.s8),
          Text(
            'Téléversez les pièces pour valider le compte livreur. Formats acceptés : JPG, PNG, PDF.',
            style: Design.body1.copyWith(color: Design.texteSecondaire),
          ),
          const SizedBox(height: Design.s24),
          Obx(
            () => ZoneUploadDocument(
              titre: 'Pièce d\'identité *',
              sousTitre: 'CNI, passeport ou titre de séjour',
              televerse: c.pieceIdentite.value,
              onTap: () => c.pieceIdentite.value = true,
            ),
          ),
          const SizedBox(height: Design.s12),
          Obx(
            () => ZoneUploadDocument(
              titre: 'Permis de conduire *',
              sousTitre: 'Permis valide',
              televerse: c.permisConduire.value,
              onTap: () => c.permisConduire.value = true,
            ),
          ),
          const SizedBox(height: Design.s12),
          Obx(
            () => ZoneUploadDocument(
              titre: 'Assurance véhicule *',
              sousTitre: 'Attestation en cours de validité',
              televerse: c.assuranceVehicule.value,
              onTap: () => c.assuranceVehicule.value = true,
            ),
          ),
          const SizedBox(height: Design.s12),
          Obx(
            () => ZoneUploadDocument(
              titre: 'Photo du véhicule',
              sousTitre: 'Optionnel — moto ou scooter',
              televerse: c.photoVehicule.value,
              onTap: () => c.photoVehicule.value = true,
            ),
          ),
          const SizedBox(height: Design.s24),
          Container(
            padding: const EdgeInsets.all(Design.s12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(Design.radiusMd),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Design.attention, size: 20),
                const SizedBox(width: Design.s8),
                Expanded(
                  child: Text(
                    'Les documents seront vérifiés sous 24–48 h. Vous serez notifié dès validation.',
                    style: Design.caption.copyWith(color: Design.texte, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Design.s24),
          BoutonSuivantLivreur(texte: 'Suivant', onTap: c.suivant),
        ],
      ),
    );
  }
}

class _EtapeConfirmation extends StatelessWidget {
  final ControllerAuthLivreur c;
  const _EtapeConfirmation({required this.c});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(Design.s24, 0, Design.s24, Design.s32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Icon(
              Icons.verified_outlined,
              size: 64,
              color: Design.primaire,
            ),
          ),
          const SizedBox(height: Design.s16),
          Text(
            'Confirmez votre demande',
            style: Design.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Design.s8),
          Text(
            'Vérifiez le récapitulatif avant d\'envoyer votre dossier.',
            style: Design.body1.copyWith(color: Design.texteSecondaire),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Design.s24),
          _RecapCarte(
            titre: 'Société',
            lignes: [
              c.nomSociete.text.trim().isEmpty
                  ? '—'
                  : c.nomSociete.text.trim(),
              c.emailSociete.text.trim(),
              'Zones : ${c.zonesCouverture.join(', ')}',
            ],
          ),
          const SizedBox(height: Design.s12),
          _RecapCarte(
            titre: 'Livreur',
            lignes: [
              c.nomComplet.text.trim().isEmpty
                  ? '—'
                  : c.nomComplet.text.trim(),
              'ID : ${c.idLivreur.text.trim()}',
              '+241 ${c.telephoneLivreur.text.trim()}',
            ],
          ),
          const SizedBox(height: Design.s12),
          _RecapCarte(
            titre: 'Documents',
            lignes: [
              c.pieceIdentite.value ? '✓ Pièce d\'identité' : '✗ Pièce d\'identité',
              c.permisConduire.value ? '✓ Permis' : '✗ Permis',
              c.assuranceVehicule.value ? '✓ Assurance' : '✗ Assurance',
            ],
          ),
          const SizedBox(height: Design.s24),
          Obx(
            () => BoutonSuivantLivreur(
              texte: 'Envoyer la demande',
              loading: c.chargementInscription.value,
              onTap: c.suivant,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecapCarte extends StatelessWidget {
  final String titre;
  final List<String> lignes;

  const _RecapCarte({required this.titre, required this.lignes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Design.s16),
      decoration: BoxDecoration(
        color: Design.blanc,
        borderRadius: BorderRadius.circular(Design.radiusMd),
        border: Border.all(color: Design.bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: Design.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: Design.primaire,
            ),
          ),
          const SizedBox(height: Design.s8),
          ...lignes.where((l) => l.isNotEmpty).map(
                (l) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(l, style: Design.body1),
                ),
              ),
        ],
      ),
    );
  }
}
