import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/bottom_menu/bottom_menu_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/view_model/block_users.dart';
import 'package:demo_project/widget/home/page/account_page_widget.dart';
import 'package:demo_project/widget/setting/block_users_page_widget.dart';

class BlockUsersPage extends HookConsumerWidget {
  const BlockUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final blockUsersState = ref.watch(blockUsersNotifierProvider);
    final loadingData = useState<String?>(null); //idが入り、idがあるデータはローディング中になる。

    useEffect(handleEffect(context, ref), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        // final safeAreaHeight = constraints.maxHeight;
        return Scaffold(
          backgroundColor: mainBackgroundColor,
          appBar: nAppBar(context, safeAreaWidth, title: ln.blockedUsers),
          body: nCustomScrollView(
            onRefresh: () => fetch(context, ref),
            slivers: blockUsersState.when(
              loading: () => loadingWidget(context),
              error: (_, __) =>
                  notDataItem(safeAreaWidth, ln.someErrorOccurred),
              data: (data) {
                final emptyMesse = ln.noBlockedUsers;
                if (data == null) return loadingWidget(context);
                if (data.isEmpty) return notDataItem(safeAreaWidth, emptyMesse);

                return [
                  titleWidget(
                    safeAreaWidth,
                    text: "${ln.blockedUsers}（${data.length}）",
                    fontSize: safeAreaWidth / 25,
                  ),
                  for (final user in data)
                    blockUserItem(
                      context,
                      data: user,
                      onTap: onDelete(context, ref, user, loadingData),
                      isLoading: loadingData.value == user.id,
                    ),
                ];
              },
            ),
          ),
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(BuildContext context, WidgetRef ref) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final user = ref.read(blockUsersNotifierProvider).value;
        if (user != null) return;
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (context.mounted) await fetch(context, ref);
      });
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback? onDelete(
    BuildContext context,
    WidgetRef ref,
    BlockUserType user,
    ValueNotifier<String?> loadingData,
  ) {
    if (loadingData.value != null) return null;
    final ln = AppLocalizations.of(context)!;
    return () => nShowBottomMenu(
          context,
          title: ln.confirmUnblock,
          itemList: [
            MenuItemType(
              itemName: ln.unblockAction,
              onTap: executeUnblockAction(context, ref, user, loadingData),
            ),
          ],
          onShow: () => SchedulerBinding.instance
              .addPostFrameCallback((_) => loadingData.value = user.id),
          onDismiss: (_) => SchedulerBinding.instance
              .addPostFrameCallback((_) => loadingData.value = null),
        );
  }

  VoidCallback executeUnblockAction(
    BuildContext context,
    WidgetRef ref,
    BlockUserType user,
    ValueNotifier<String?> loadingData,
  ) {
    return () async {
      loadingData.value = user.id;
      final notifier = ref.read(blockUsersNotifierProvider.notifier);
      final isSuccess = await notifier.upDate(user.user.id, ToggleType.delete);
      if (context.mounted && !isSuccess) nErrorDialog(context);
      loadingData.value = null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Future<void> fetch(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final notifier = ref.read(blockUsersNotifierProvider.notifier);
    await notifier.fetch();
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
}
