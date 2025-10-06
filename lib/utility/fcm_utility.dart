import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/utility/notistack/custom_dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/talk/incoming_dialog.dart';
import 'package:demo_project/view_model/matching_users.dart';
import 'package:demo_project/view_model/user_data.dart';

bool _dialogShowing = false;

StreamSubscription<RemoteMessage> fcmMessageStreamListener(WidgetRef ref) {
  final myId = ref.watch(userDataNotifierProvider).value?.id;
  final notifier = ref.read(matchingUsersNotifierProvider.notifier);

  return FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    try {
      final messageId = message.data['messageId'] as String;
      final parts = messageId.split('@');
      if (parts.length != 4 || myId == null) return;
      if ("like" == parts[0]) notifier.refetchOnNotification(myId);
      if ("call" == parts[0]) {
        if (_dialogShowing) return;
        _dialogShowing = true;
        final context = navigatorKey.currentContext;
        if (context == null || !context.mounted) return;
        final widget = IncomingDialog(messageId: messageId);
        nCustomDialog(context, widget, false, onValue());
      }
    } catch (_) {}
  });
}

void Function(Widget)? onValue() {
  return (page) async {
    final context = navigatorKey.currentContext;
    if (context == null || !context.mounted) return;
    ScreenTransition(context, page).normal();
    await Future<void>.delayed(const Duration(seconds: 3));
    _dialogShowing = false;
  };
}
