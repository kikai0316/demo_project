//cmをフィートインチに変換
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo_project/l10n/app_localizations.dart';

String cmToFeetInches(int cm) {
  try {
    if (cm <= 130.0) return "";
    final int totalInches = (cm / 2.54).round();
    final int feet = totalInches ~/ 12;
    final int inches = totalInches % 12;
    return "$feet'$inches\"";
  } catch (_) {
    return "";
  }
}

//ブロック・非表示ユーザーページで使用。例）2024年3月16日にブロックしました。
String formatDaysSinceforBlock(BuildContext context, DateTime date) {
  final ln = AppLocalizations.of(context)!;
  final formattedDate = DateFormat.yMMMMd(ln.localeName).format(date);
  return ln.blockedAt.replaceAll('@', formattedDate);
}

//誕生日から年齢で
String formatAge(String birthday) {
  try {
    final birthDate = DateTime.parse(birthday);
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    // まだ誕生日が来ていない場合は1歳引く
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  } catch (_) {
    return "";
  }
}

//電話番号認証でのエラーメッセージ
String toPhoneErrorMessage(BuildContext context, FirebaseAuthException e) {
  final ln = AppLocalizations.of(context)!;
  if (e.code == 'invalid-phone-number') return ln.phoneNumberInvalid;
  if (e.code == 'too-many-requests') return ln.tooManyRequests;
  if (e.code == 'network-request-failed') return ln.networkRequestFailed;
  if (e.code == 'session-expired') return ln.sessionExpired;
  if (e.code == 'invalid-verification-code') return ln.invalidVerificationCode;
  if (e.code == 'invalid-verification-id') return ln.invalidVerificationId;
  return ln.someErrorOccurred;
}
