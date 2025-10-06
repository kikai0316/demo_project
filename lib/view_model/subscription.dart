import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:demo_project/model/subscription_model.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'subscription.g.dart';

@Riverpod(keepAlive: true)
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  Future<SubscriptionType?> build() async => null;

  Future<void> init(String id) async {
    try {
      await Purchases.setLogLevel(LogLevel.debug);
      final configuration = getConfiguration();
      if (configuration == null) {
        state = AsyncValue.error("error", StackTrace.current);
        return;
      }
      await Purchases.configure(configuration);
      await Purchases.logIn(id);
      final offerings = await Purchases.getOfferings();
      final customerInfo = await Purchases.getCustomerInfo();
      final data = SubscriptionType.fromOfferings(offerings);
      final activeSub = ActiveSubType.fromCustomerInfo(customerInfo);
      state = AsyncValue.data(data?.upDate(activeSub));
    } catch (_, __) {
      state = AsyncValue.error("error", StackTrace.current);
    }
  }

  Future<bool> restorePurchase() async {
    try {
      final myId = ref.watch(userDataNotifierProvider).value?.id;
      if (myId == null) return false;
      await Purchases.logIn(myId);
      final customerInfo = await Purchases.restorePurchases();
      final activeSub = ActiveSubType.fromCustomerInfo(customerInfo);
      final newDat = state.value?.upDate(activeSub);
      if (activeSub != null) state = AsyncValue.data(newDat);
      return activeSub != null;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<bool> makePurchase(SubscriptionItemType plan) async {
    try {
      final myId = ref.watch(userDataNotifierProvider).value?.id;
      final pkg = plan.toPackage(state.value);
      if (myId == null || pkg == null) return false;
      await Purchases.logIn(myId);
      final result = await Purchases.purchasePackage(pkg);
      final activeSub = ActiveSubType.fromCustomerInfo(result.customerInfo);
      state = AsyncValue.data(state.value?.upDate(activeSub));
      return true;
    } on PlatformException catch (_) {
      return false;
    }
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  // その他
  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
}

PurchasesConfiguration? getConfiguration() {
  if (Platform.isAndroid) {
    const androidApiKey = "goog_XXXXXXXXXXXXXXXXXXXXXXXX"; // ←必ず入れる
    return PurchasesConfiguration(androidApiKey);
  } else if (Platform.isIOS) {
    const iosApiKey = "appl_fKfgaNgeBRSrQvxjwTBfzruQzln";
    return PurchasesConfiguration(iosApiKey);
  }
  return null;
}
