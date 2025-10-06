import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/subscription_model.dart';
import 'package:demo_project/utility/notistack/center_snackbar_utility.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/widget/page/payment_page_widget.dart';

class PaymentPage extends HookConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(subscriptionNotifierProvider);
    final ln = AppLocalizations.of(context)!;
    final dataIndex = useState<int>(0); //0デフォルト,1ローディング,2購入完了
    final monthPlan = SubscriptionItemType.toMonthPlan(data.value);
    final titles = [ln.aboutPaidServiceTitle, ln.importantNotesTitle];

    // useEffect(handleEffect(context), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final safeAreaHeight = constraints.maxHeight;
        return Scaffold(
          backgroundColor: mainBackgroundColor,
          body: Stack(
            children: [
              nCustomScrollView(
                slivers: [
                  //タイトル
                  paymentTitleTextWidget(context, constraints),
                  // paymentTitleTextWidget(context, constraints, false),
                  //内容
                  planContentsWidget(context, constraints),
                  SliverToBoxAdapter(
                    child: nDiver(
                      safeAreaWidth,
                      margin: nSpacing(
                        ySize: safeAreaHeight * 0.005,
                        xSize: safeAreaWidth * 0.4,
                      ),
                    ),
                  ),
                  // plan
                  if (data.value != null)
                    for (final plan in data.value!.plans)
                      planWidget(
                        context,
                        constraints,
                        plan,
                        monthPlan,
                        onBuy(context, ref, dataIndex),
                      ),

                  //nullの場合スペースを開ける
                  if (data.value == null)
                    sliverSpacer((safeAreaHeight * 0.123) * 3),

                  SliverToBoxAdapter(
                    child: nDiver(
                      safeAreaWidth,
                      margin: nSpacing(
                        top: safeAreaHeight * 0.02,
                        xSize: safeAreaWidth * 0.06,
                      ),
                    ),
                  ),

                  for (final text in sections(context))
                    detailsTextWidget(constraints, text, titles.contains(text)),

                  restorePurchaseWidget(
                    context,
                    safeAreaWidth,
                    onTap: onRestorePurchase(context, ref, dataIndex),
                  ),
                  detailsTextWidget(constraints, ln.restorePurchaseDesc, true),
                  sliverSpacer(safeAreaHeight * 0.1),
                ],
              ),
              paymentLoadingWidget(context, safeAreaWidth, data),
              paymentAppBar(context, constraints),
              loadinPage(safeAreaWidth, isLoading: dataIndex.value == 1),
              if (dataIndex.value == 2)
                SuccessScreen(safeAreaWidth: safeAreaWidth),
            ],
          ),
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback? onRestorePurchase(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<int> dataIndex,
  ) {
    return () async {
      final ln = AppLocalizations.of(context)!;
      final notifier = ref.read(subscriptionNotifierProvider.notifier);

      dataIndex.value = 1;
      final isSubsc = await notifier.restorePurchase();
      if (!context.mounted) return;
      dataIndex.value = 0;
      if (isSubsc) Navigator.pop(context);
      if (!isSubsc) nShowCenterSnackBar(context, message: ln.noPurchaseHistory);
    };
  }

  void Function(SubscriptionItemType)? onBuy(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<int> dataIndex,
  ) {
    if (dataIndex.value != 0) return null;
    return (value) async {
      final notifier = ref.read(subscriptionNotifierProvider.notifier);
      dataIndex.value = 1;
      final isSuccess = await notifier.makePurchase(value);
      if (context.mounted) dataIndex.value = !isSuccess ? 0 : 2;
    };
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  List<String> sections(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    return [
      //タイトル
      ln.aboutPaidServiceTitle,
      //タイトルの内容
      ln.aboutPaidServiceDesc1,
      ln.aboutPaidServiceDesc2,
      ln.aboutPaidServiceDesc3,
      ln.aboutPaidServiceDesc4,
      ln.aboutPaidServiceDesc5,
      ln.aboutPaidServiceDesc6,

      //タイトル２
      ln.importantNotesTitle,
      //タイトル2の内容
      ln.importantNotesDesc1,
      ln.importantNotesDesc2,
      ln.importantNotesDesc3,
      ln.importantNotesDesc4,
    ];
  }
}
