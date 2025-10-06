import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/widget/setting/block_users_page_widget.dart';

class AccessCtrlPage extends HookConsumerWidget {
  const AccessCtrlPage({
    super.key,
    required this.user,
    required this.accessControl,
  });
  final UserType user;
  final AccessCtrlType accessControl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final ln = AppLocalizations.of(context)!;
    // final usersData = ref.watch(accessCtrlDataNotifierProvider);
    final isBlock = accessControl.isBlock();
    final title = isBlock ? ln.blockedUsers : ln.closeFriends;

    // final loadingData = useState<String?>(null);
    final isError = useState<bool>(false);

    // useEffect(handleEffect(context, ref, isError), []);

    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: nAppBar(context, safeAreaWidth, title: title),
      body: nCustomScrollView(
        onRefresh: () => fetch(context, ref, isError),
        slivers: notDataItem(safeAreaWidth, ln.someErrorOccurred),
        // slivers: usersData.when(
        //   loading: () => loadingWidget(context),
        //   error: (_, __) => notDataItem(safeAreaWidth, ln.someErrorOccurred),
        //   data: (data) {
        //     final notUser = isBlock ? ln.noBlockedUsers : ln.noMutedUsers;
        //     final error = ln.someErrorOccurred;
        //     final users = isBlock ? data?.blockUsers : data?.muteUsers;

        //     if (isError.value) return notDataItem(safeAreaWidth, error);
        //     if (users == null) return loadingWidget(context);
        //     if (users.isEmpty) return notDataItem(safeAreaWidth, notUser);

        //     return [
        //       titleWidget(
        //         safeAreaWidth,
        //         text: "$title（${users.length}）",
        //       ),
        //       for (int i = 0; i < users.length; i++)
        //         accessCtrlUserItem(
        //           context,
        //           blockUserData: users[i],
        //           isBlock: isBlock,
        //           onTap: onDelete(context, ref, users[i], loadingData, isBlock),
        //           isLoading: loadingData.value == users[i].id,
        //         ),
        //     ];
        //   },
        // ),
      ),
    );
  }

//   // useEffect
//   Dispose? Function() handleEffect(
//     BuildContext context,
//     WidgetRef ref,
//     ValueNotifier<bool> isError,
//   ) {
//     return () {
//       WidgetsBinding.instance
//           .addPostFrameCallback((_) async => fetch(context, ref, isError));
//       return null;
//     };
//   }

// //ユーザーリストの取得
  Future<void> fetch(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isError,
  ) async {
    // isError.value = false;
    // final notifier = ref.read(accessCtrlDataNotifierProvider.notifier);
    // final isSuccess = await notifier.fetch(userData.id, accessControl);
    // if (context.mounted && !isSuccess) isError.value = true;
  }

// //削除処理
//   VoidCallback onDelete(
//     BuildContext context,
//     WidgetRef ref,
//     AccessCtrlUserType user,
//     ValueNotifier<String?> loadingData,
//     bool isBlock,
//   ) {
//     if (loadingData.value != null) return () {};
//     final ln = AppLocalizations.of(context)!;
//     final titleText = isBlock ? ln.confirmUnblock : ln.confirmUnmute;
//     final itemText = isBlock ? ln.unblockAction : ln.unmuteAction;
//     return () async => nShowBottomMenu(
//           context,
//           title: titleText,
//           itemList: [
//             MenuItemType(
//               itemName: itemText,
//               onTap: () async {
//                 loadingData.value = user.id;
//                 final notifier =
//                     ref.read(accessCtrlDataNotifierProvider.notifier);
//                 final isSuccess = await notifier.accessCtrlUpdate(
//                   user.userData.id,
//                   accessControl,
//                   ToggleType.delete,
//                 );
//                 if (!context.mounted) return;
//                 if (!isSuccess) {
//                   showTopSnackBar(context, message: ln.someErrorOccurred);
//                 }

//                 loadingData.value = null;
//               },
//             ),
//           ],
//           onShow: () => SchedulerBinding.instance
//               .addPostFrameCallback((_) => loadingData.value = user.id),
//           onDismiss: (_) => SchedulerBinding.instance
//               .addPostFrameCallback((_) => loadingData.value = null),
//         );
//   }
}
