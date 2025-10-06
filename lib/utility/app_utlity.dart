import 'dart:math';

import 'package:flutter/material.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> nOpneUrl(String urlString) async {
  try {
    await launchUrl(Uri.parse(urlString));
  } catch (_) {
    return;
  }
}

String generateUniqueId() {
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(20, (index) => chars[Random().nextInt(chars.length)])
      .join();
}

VoidCallback onTerms(BuildContext context) {
  final url = AppLocalizations.of(context)!.termsUrl;
  return () => nOpneUrl(url);
}

VoidCallback onPrivacyPolicy(BuildContext context) {
  final url = AppLocalizations.of(context)!.privacyUrl;
  return () => nOpneUrl(url);
}

void nShowbottomSheet(
  BuildContext context, {
  required Widget page,
  VoidCallback? onThen,
  VoidCallback? onError,
  Color? barrierColor,
}) =>
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      builder: (context) => page,
    )
        .then((value) => onThen?.call())
        .onError((error, stackTrace) => onError?.call());
