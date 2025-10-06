import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionType {
  ActiveSubType? activeSub;
  List<SubscriptionItemType> plans;
  Offerings offerings;

  SubscriptionType({
    required this.activeSub,
    required this.plans,
    required this.offerings,
  });

  static SubscriptionType? fromOfferings(Offerings offerings) {
    final data = offerings.all.entries.firstOrNull?.value.availablePackages;
    if (data == null) return null;

    return SubscriptionType(
      activeSub: null,
      plans: SubscriptionItemType.fromPackages(data),
      offerings: offerings,
    );
  }

  SubscriptionType upDate(ActiveSubType? activeSub) {
    return SubscriptionType(
      activeSub: activeSub,
      plans: plans,
      offerings: offerings,
    );
  }

  List<String?> toValues(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    if (activeSub == null) return [ln.free, "　ー　", "　ー　"];
    return [
      activeSub?.planStr(context),
      activeSub?.createAtStr(context),
      activeSub?.nextBillingAtStr(context),
    ];
  }
}

class SubscriptionItemType {
  int months;
  String priceStr;
  double price;
  String currencyCode;
  SubscriptionItemType({
    required this.months,
    required this.priceStr,
    required this.price,
    required this.currencyCode,
  });

  static List<SubscriptionItemType> fromPackages(List<Package> packages) {
    final plans = packages
        .map((e) {
          final p = e.storeProduct;
          final month = getIdToMonth(e.storeProduct.identifier);
          if (month == null) return null;
          return SubscriptionItemType(
            months: month,
            price: p.price,
            priceStr: p.priceString,
            currencyCode: p.currencyCode,
          );
        })
        .whereType<SubscriptionItemType>()
        .toList();
    plans.sort((a, b) => b.months.compareTo(a.months));
    return plans;
  }

  static SubscriptionItemType? toMonthPlan(SubscriptionType? data) {
    if (data == null) return null;
    for (final plan in data.plans) {
      if (plan.months == 1) return plan;
    }
    return null;
  }

  String toPricePerWeek(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    final weekPrice = price / months / 4;
    final formattedPrice = NumberFormat.currency(
      locale: currencyCode == "JPY" ? "ja_JP" : "en_US",
      symbol: currencyCode == "JPY" ? "¥" : "\$",
      decimalDigits: currencyCode == 'JPY' ? 0 : 2,
    ).format(weekPrice);
    return "$formattedPrice/${ln.week}";
  }

  String? toSalePrice(BuildContext context, SubscriptionItemType? monthPlan) {
    if (monthPlan == null || months == 1) return null;
    final ln = AppLocalizations.of(context)!;
    final savings = monthPlan.price - (price / months);
    final discountRate = savings / monthPlan.price * 100;
    return ln.saveAbout.replaceAll('@', discountRate.round().toString());
  }

  Package? toPackage(SubscriptionType? data) {
    final offering = data?.offerings.all["default"];
    if (months == 1) return offering?.monthly;
    if (months == 3) return offering?.threeMonth;
    if (months == 12) return offering?.annual;
    return null;
  }
}

int? getIdToMonth(String id) {
  if ("islez.ooo.ios.1month" == id) return 1;
  if ("islez.ooo.ios.3month" == id) return 3;
  if ("islez.ooo.ios.year" == id) return 12;
  return null;
}

class ActiveSubType {
  int months;
  DateTime updatedAt;
  DateTime createAt;
  DateTime? nextBillingAt;
  OwnershipType purchased;
  ActiveSubType({
    required this.months,
    required this.updatedAt,
    required this.createAt,
    required this.nextBillingAt,
    required this.purchased,
  });

  static ActiveSubType? fromCustomerInfo(CustomerInfo info) {
    const entitlement = "pro";
    final entitlements = info.entitlements.all;
    if (entitlements.isEmpty) return null;
    if (!entitlements.containsKey(entitlement)) return null;
    if (entitlements[entitlement]!.isActive) {
      final data = entitlements[entitlement]!;
      final month = getIdToMonth(data.productIdentifier);
      if (month == null) return null;
      final updatedAtStr = data.latestPurchaseDate;
      final createAtStr = data.originalPurchaseDate;
      final nextBillingAt = data.expirationDate;
      return ActiveSubType(
        months: month,
        purchased: data.ownershipType,
        updatedAt: DateTime.parse(updatedAtStr).toLocal(),
        createAt: DateTime.parse(createAtStr).toLocal(),
        nextBillingAt: nextBillingAt != null
            ? DateTime.parse(nextBillingAt).toLocal()
            : null,
      );
    }
    return null;
  }

  String planStr(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    if (months == 1) return ln.monthlyPlan;
    if (months == 3) return ln.quarterlyPlan;
    if (months == 12) return ln.annualPlan;
    return ln.free;
  }

  String createAtStr(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    return DateFormat.yMMMMd(ln.localeName).format(createAt);
  }

  String? nextBillingAtStr(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    if (nextBillingAt == null) return null;
    return DateFormat.yMMMMd(ln.localeName).format(nextBillingAt!);
  }
}
