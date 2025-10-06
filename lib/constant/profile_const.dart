import 'package:flutter/material.dart';
import 'package:demo_project/l10n/app_localizations.dart';

List<Map<String, String>> mbtiDatas(BuildContext context) {
  final ln = AppLocalizations.of(context)!;
  return [
    {"name": "ENFJ", "label": ln.enfjLabel},
    {"name": "ENFP", "label": ln.enfpLabel},
    {"name": "ENTJ", "label": ln.entjLabel},
    {"name": "ENTP", "label": ln.entpLabel},
    {"name": "ESFJ", "label": ln.esfjLabel},
    {"name": "ESFP", "label": ln.esfpLabel},
    {"name": "ESTJ", "label": ln.estjLabel},
    {"name": "ESTP", "label": ln.estpLabel},
    {"name": "INFJ", "label": ln.infjLabel},
    {"name": "INFP", "label": ln.infpLabel},
    {"name": "INTJ", "label": ln.intjLabel},
    {"name": "INTP", "label": ln.intpLabel},
    {"name": "ISFJ", "label": ln.isfjLabel},
    {"name": "ISFP", "label": ln.isfpLabel},
    {"name": "ISTJ", "label": ln.istjLabel},
    {"name": "ISTP", "label": ln.istpLabel},
  ];
}

List<String> dayOffDatas(BuildContext context) {
  final ln = AppLocalizations.of(context)!;
  return [
    ln.holidayOptionWeekend,
    ln.holidayOptionWeekdays,
    ln.holidayOptionFlexible,
    ln.holidayOptionOther,
  ];
}

List<String> exerciseDatas(BuildContext context) {
  final ln = AppLocalizations.of(context)!;
  return [
    ln.exerciseOptionOften,
    ln.exerciseOptionSometimes,
    ln.exerciseOptionRarely,
    ln.exerciseOptionNever,
  ];
}

List<String> alcoholDatas(BuildContext context) {
  final ln = AppLocalizations.of(context)!;
  return [
    ln.alcoholOptionOften,
    ln.alcoholOptionSometimes,
    ln.alcoholOptionRarely,
    ln.alcoholOptionNever,
  ];
}

List<String> smokingDatas(BuildContext context) {
  final ln = AppLocalizations.of(context)!;
  return [
    ln.smokingOptionOften,
    ln.smokingOptionHeatedTobacco,
    ln.smokingOptionSometimes,
    ln.smokingOptionIfDislikedStop,
    ln.smokingOptionNever,
  ];
}
