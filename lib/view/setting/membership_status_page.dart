import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/button/gradient_loop_button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/payment_page.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/widget/page/payment_page_widget.dart';
import 'package:demo_project/widget/setting/membership_status_page_widget.dart';
import 'package:demo_project/widget/widget/surveillance_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MembershipStatusPage extends HookConsumerWidget {
  const MembershipStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsc = ref.watch(subscriptionNotifierProvider).value;
    final ln = AppLocalizations.of(context)!;
    final isLoading = useState<bool>(false);
    const paymentPage = PaymentPage();
    final titles = [ln.plan, ln.startDate, ln.nextRenewalDate];
    final values = subsc?.toValues(context) ?? [null, null, null];

    // useEffect(handleEffect(context), []);
    return PopScope(
      canPop: !isLoading.value,
      child: Surveillance(
        onForeground: onForeground(ref),
        child: LayoutBuilder(
          builder: (_, constraints) {
            final safeAreaWidth = constraints.maxWidth;
            return Stack(
              children: [
                Scaffold(
                  appBar:
                      nAppBar(context, safeAreaWidth, title: ln.subscription),
                  backgroundColor: mainBackgroundColor,
                  body: nCustomScrollView(
                    slivers: [
                      sliverSpacer(safeAreaWidth * 0.05),
                      ...membershipItemList(
                        safeAreaWidth,
                        itemList: [
                          for (int i = 0; i < 3; i++)
                            SettingItemType(
                              itemName: titles[i],
                              value: values[i],
                            ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: nIconButton(
                          onTap: onRestore(context, ref, isLoading),
                          margin: nSpacing(top: safeAreaWidth * 0.05),
                          iconData: Icons.refresh_rounded,
                          iconColor: Colors.blueAccent,
                          iconSize: safeAreaWidth / 20,
                          withTextWidget: nText(
                            ln.restorePurchaseTitle,
                            fontSize: safeAreaWidth / 25,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      sliverSpacer(safeAreaWidth * 0.05),
                      if (values.firstOrNull == ln.free)
                        SliverToBoxAdapter(
                          child: GradientLoopButton(
                            onTap: () =>
                                ScreenTransition(context, paymentPage).top(),
                            text: ln.tryFreeFor1Week,
                            fontSize: safeAreaWidth / 25,
                            margin: nSpacing(
                              top: safeAreaWidth * 0.05,
                              xSize: safeAreaWidth * 0.03,
                            ),
                            safeAreaWidth: safeAreaWidth,
                            width: safeAreaWidth * 0.94,
                            height: safeAreaWidth * 0.16,
                            radius: 15,
                            beginColor: const Color.fromARGB(255, 0, 217, 255),
                            endColor: const Color.fromARGB(255, 75, 147, 255),
                            bold: 900,
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: nButton(
                          safeAreaWidth,
                          margin: nSpacing(
                            top: safeAreaWidth * 0.05,
                            xSize: safeAreaWidth * 0.03,
                          ),
                          backGroundColor: Colors.white,
                          text: ln.cancelSubscription,
                          boxShadow: nBoxShadow(shadow: 0.05),
                          textColor: Colors.red,
                          width: safeAreaWidth * 0.94,
                          radius: 15,
                          onTap: onUnsubscribeButton(context, ref, isLoading),
                        ),
                      ),
                    ],
                  ),
                ),
                loadinPage(safeAreaWidth, isLoading: isLoading.value),
              ],
            );
          },
        ),
      ),
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// Dispose? Function() handleEffect(BuildContext context) {
//   return () {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {});
//     return null;
//   };
// }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onUnsubscribeButton(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) {
    return () async {
      isLoading.value = true;
      if (Platform.isIOS) {
        return await _openIOSSubscriptionSettings();
      } else if (Platform.isAndroid) {
        return await _openAndroidSubscriptionSettings();
      }
      if (context.mounted) isLoading.value = false;
    };
  }
}

VoidCallback onRestore(
  BuildContext context,
  WidgetRef ref,
  ValueNotifier<bool> isLoading,
) {
  return () async {
    final notifier = ref.read(subscriptionNotifierProvider.notifier);

    isLoading.value = true;
    await notifier.restorePurchase();
    if (context.mounted) isLoading.value = false;
  };
}

VoidCallback onUnsubscribeButton(
  BuildContext context,
  WidgetRef ref,
  ValueNotifier<bool> isLoading,
) {
  return () async {
    isLoading.value = true;
    if (Platform.isIOS) {
      return await _openIOSSubscriptionSettings();
    } else if (Platform.isAndroid) {
      return await _openAndroidSubscriptionSettings();
    }
    if (context.mounted) isLoading.value = false;
  };
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

void Function()? onForeground(WidgetRef ref) {
  return () {
    final notifier = ref.read(subscriptionNotifierProvider.notifier);
    notifier.restorePurchase();
  };
}

Future<void> _openIOSSubscriptionSettings() async {
  try {
    const url = 'https://apps.apple.com/account/subscriptions';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    return;
  }
}

Future<void> _openAndroidSubscriptionSettings() async {
  try {
    const packageName = 'com.islez.vava_game_app';
    const url =
        'https://play.google.com/store/account/subscriptions?package=$packageName';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    return;
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
