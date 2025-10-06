//メニューのタップイベント

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/message_model.dart';
import 'package:demo_project/utility/api_functions/api_report_utility.dart';
import 'package:demo_project/utility/app_utlity.dart';
import 'package:demo_project/utility/bottom_menu/bottom_menu_utility.dart';
import 'package:demo_project/utility/notistack/center_snackbar_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/notistack/top_snackbar_utility.dart';
import 'package:demo_project/view_model/block_users.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/widget/report_reason_sheet.dart';

VoidCallback onMenu(BuildContext context, WidgetRef ref, UserPreviewType tUser,
    [List<MessageType>? messageData, FocusNode? focusNode,]) {
  final ln = AppLocalizations.of(context)!;
  return () {
    final myId = ref.watch(userDataNotifierProvider).value?.id;
    final isBlock = _getIsContains(ref, tUser.id);
    final page = ReportReasonSelectionSheet(
      isUserReport: messageData == null,
      onTap: _submitReport(
        context,
        myId,
        tUser.id,
        messageData,
      ),
    );
    focusNode?.unfocus();
    nShowBottomMenu(
      context,
      cancelColor: Colors.blueAccent,
      onDismiss: (isNotSelect) =>
          isNotSelect ? focusNode?.requestFocus() : null,
      itemList: [
        for (int i = 0; i < 2; i++)
          MenuItemType(
            itemName: [
              if (isBlock) ln.unblockAction else ln.block,
              ln.reportButtonLabel,
            ][i],
            color: redColor,
            onTap: [
              _onBlock(context, ref, tUser),
              () => nShowbottomSheet(
                    context,
                    page: page,
                    onThen: _focus(focusNode),
                  ),
            ][i],
          ),
      ],
    );
  };
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他上記に付随する関数
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
Function(int, String) _submitReport(
  BuildContext context,
  String? myId,
  String targetUserId, [
  List<MessageType>? messageData,
]) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final ln = AppLocalizations.of(context)!;
  final error = ln.someErrorOccurred;
  return (code, reason) async {
    if (myId == null) nErrorDialog(context);
    if (myId == null) return;
    final body = {
      "initiator_user": myId,
      "target_user": targetUserId,
      "message": messagetoJsons(messageData),
      "reason_code": code.toString(),
      "reason": reason,
    }..removeWhere((key, value) => value == null);
    final isSuccess = await apiCreateReport(myId, body);
    if (!context.mounted) return;
    final messe = isSuccess ? ln.reportSubmitted : error;
    if (messageData == null) nShowCenterSnackBar(context, message: messe);
    if (messageData != null) {
      nTopSnackBar(context, safeAreaWidth, message: messe);
    }
  };
}

bool _getIsContains(WidgetRef ref, String id) {
  final blockUsers = ref.watch(blockUsersNotifierProvider).value ?? [];
  return blockUsers.map((v) => v.user.id).toList().contains(id);
}

Future<void> _executeBlock(
  BuildContext context,
  WidgetRef ref,
  UserPreviewType tUser,
) async {
  final notifier = ref.read(blockUsersNotifierProvider.notifier);
  final ln = AppLocalizations.of(context)!;
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final isContains = _getIsContains(ref, tUser.id);
  final toggle = isContains ? ToggleType.delete : ToggleType.add;
  final isUpDate = await notifier.upDate(tUser.id, toggle);
  final successState = isContains ? ln.youHaveUnblocked : ln.youHaveBlocked;
  final success = successState.replaceAll('@', tUser.userName);

  if (!context.mounted) return;
  nTopSnackBar(
    context,
    safeAreaWidth,
    message: isUpDate ? success : ln.someErrorOccurred,
    addLeftWidget: isUpDate ? _checkIcon(safeAreaWidth) : null,
    textAlign: isUpDate ? TextAlign.start : TextAlign.center,
  );
}

VoidCallback _onBlock(
  BuildContext context,
  WidgetRef ref,
  UserPreviewType tUser,
) {
  return () {
    final ln = AppLocalizations.of(context)!;
    final isContains = _getIsContains(ref, tUser.id);
    if (isContains) _executeBlock(context, ref, tUser);
    if (isContains) return;
    nDialog(
      context,
      title: ln.reallyBlockThisUser,
      content: ln.blockedUserDescription,
      mainItem: MenuItemType(
        itemName: ln.block,
        color: redColor,
        onTap: () => _executeBlock(context, ref, tUser),
      ),
    );
  };
}

Widget _checkIcon(double safeAreaWidth) {
  const color = Colors.green;
  return nContainerWithCircle(
    alignment: Alignment.center,
    squareSize: safeAreaWidth * 0.05,
    margin: nSpacing(right: safeAreaWidth * 0.02),
    border: nBorder(color: color),
    child: nIcon(Icons.check, size: safeAreaWidth / 23, color: color),
  );
}

List<Map<String, dynamic>>? messagetoJsons(List<MessageType>? datas) {
  if (datas == null) return null;
  return datas.map((e) {
    return {
      "id": e.id,
      "user_id": e.userId,
      "text": e.text,
      "at": e.timestamp.toString(),
    };
  }).toList();
}

void Function()? _focus(FocusNode? focusNode) {
  return () => focusNode?.requestFocus();
}
