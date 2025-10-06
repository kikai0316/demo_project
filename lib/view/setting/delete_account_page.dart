import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/login/phone_login/phone_login_page.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/setting/delete_account_page_widget.dart';

class DeleteAccountPage extends HookConsumerWidget {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final selectIndex = useState<int?>(null);
    final otherReason = useState<String?>(null);
    final isLoading = useState<bool>(false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: mainBackgroundColor,
              body: SafeArea(
                top: false,
                child: Padding(
                  padding: nSpacing(top: safeAreaWidth * 0.1),
                  child: nCustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      delAccTextItem(
                        safeAreaWidth,
                        ln.deleteAccountConfirmation,
                      ),
                      delAccTextItem(
                        safeAreaWidth,
                        ln.deletionNotice,
                        color: redColor,
                        fontSize: safeAreaWidth / 27,
                        top: safeAreaWidth * 0.05,
                      ),
                      delAccTextItem(
                        safeAreaWidth,
                        ln.unsubscribeReasonPrompt,
                        top: safeAreaWidth * 0.1,
                      ),
                      delAccReasonItem(
                        context,
                        safeAreaWidth,
                        selectIndex,
                        otherReason,
                        reasonList: reasonList(context),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false, // スクロール可能エリアを無効化
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            delAccButtonItem(
                              safeAreaWidth,
                              ln.reconsider,
                              isDelete: false,
                              onTap: () => Navigator.pop(context),
                            ),
                            delAccButtonItem(
                              safeAreaWidth,
                              ln.confirmDeletion,
                              isDelete: true,
                              onTap: deleteUserAccount(
                                context,
                                ref,
                                isLoading,
                                selectIndex,
                                otherReason,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            loadinPage(safeAreaWidth, isLoading: isLoading.value),
          ],
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  //アカウント削除の実行
  VoidCallback deleteUserAccount(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
    ValueNotifier<int?> selectIndex,
    ValueNotifier<String?> otherReason,
  ) {
    return () async {
      try {
        final user = ref.watch(userDataNotifierProvider).value;
        final notifier = ref.read(userDataNotifierProvider.notifier);
        const initialPage = PhoneLoginPage();
        final index = selectIndex.value;
        final nReason = index != null ? reasonList(context)[index] : null;
        final reason = index == 4 ? otherReason.value : nReason;

        if (user == null) nErrorDialog(context);
        if (user == null) return;

        isLoading.value = true;
        final isDelete = await notifier.deleteAccount(user, reason, index);
        if (!context.mounted) return;
        if (!isDelete) nErrorDialog(context);
        if (!isDelete) isLoading.value = false;
        if (isDelete) ScreenTransition(context, initialPage).top();
      } catch (_) {
        nErrorDialog(context);
      }
    };
  }

  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  // その他
  //＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  List<String> reasonList(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    return [ln.bugs, ln.fewFriends, ln.rarelyUsed, ln.unclearUsage, ln.other];
  }
}
