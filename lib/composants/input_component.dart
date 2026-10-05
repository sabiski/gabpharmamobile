import 'package:flutter/material.dart';
import 'package:gabpharmamobile/design/design.dart';

class InputComponent extends StatelessWidget {
  final String? title;
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Color? backgroundColor;
  final Widget? leading;
  final Widget? trailing;
  final String? Function(String?)? validator;
  final VoidCallback? onTrailingTap;

  const InputComponent({
    super.key,
    this.title,
    required this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.backgroundColor,
    this.leading,
    this.trailing,
    this.validator,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: Design.h4.copyWith(fontSize: 14)),
          const SizedBox(height: Design.s8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: Design.body1,
          decoration: InputDecoration(
            hintText: label,
            hintStyle: Design.body1.copyWith(color: Design.texteSecondaire),
            filled: true,
            fillColor: backgroundColor ?? Design.blanc,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Design.s16,
              vertical: 14,
            ),
            prefixIcon: leading == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: IconTheme(
                      data: const IconThemeData(
                        color: Design.texteSecondaire,
                        size: 22,
                      ),
                      child: leading!,
                    ),
                  ),
            suffixIcon: trailing == null
                ? null
                : IconButton(
                    onPressed: onTrailingTap,
                    icon: IconTheme(
                      data: const IconThemeData(
                        color: Design.texteSecondaire,
                        size: 22,
                      ),
                      child: trailing!,
                    ),
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Design.radiusMd),
              borderSide: const BorderSide(color: Design.bordure),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Design.radiusMd),
              borderSide: const BorderSide(color: Design.bordure),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Design.radiusMd),
              borderSide: const BorderSide(color: Design.primaire, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class BoutonPrincipal extends StatelessWidget {
  final String texte;
  final VoidCallback? onTap;
  final bool loading;
  final Color? couleur;

  const BoutonPrincipal({
    super.key,
    required this.texte,
    this.onTap,
    this.loading = false,
    this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: loading ? null : onTap,
        style: FilledButton.styleFrom(
          backgroundColor: couleur ?? Design.primaire,
          foregroundColor: Design.blanc,
          disabledBackgroundColor: (couleur ?? Design.primaire).withValues(
            alpha: 0.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Design.radiusMd),
          ),
          textStyle: Design.h4.copyWith(
            fontWeight: FontWeight.w600,
            color: Design.blanc,
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(texte),
      ),
    );
  }
}

class BoutonOutlineSocial extends StatelessWidget {
  final String texte;
  final Widget icone;
  final VoidCallback? onTap;

  const BoutonOutlineSocial({
    super.key,
    required this.texte,
    required this.icone,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: Design.texte,
          side: const BorderSide(color: Design.bordure),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Design.radiusMd),
          ),
          textStyle: Design.body1.copyWith(fontWeight: FontWeight.w500),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 22, height: 22, child: icone),
            const SizedBox(width: Design.s8),
            Text(texte),
          ],
        ),
      ),
    );
  }
}

class PagePlaceholder extends StatelessWidget {
  final String titre;
  final String description;
  final IconData icone;

  const PagePlaceholder({
    super.key,
    required this.titre,
    required this.description,
    this.icone = Icons.medical_services_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.fond,
      appBar: AppBar(title: Text(titre)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Design.s24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 56, color: Design.primaire),
              const SizedBox(height: Design.s16),
              Text(
                titre,
                textAlign: TextAlign.center,
                style: Design.h3,
              ),
              const SizedBox(height: Design.s8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Design.body1.copyWith(
                  color: Design.texteSecondaire,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
