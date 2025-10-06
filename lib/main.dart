import 'dart:async';

import 'package:demo_project/view/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/firebase_options.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/path_provider_utility.dart';
import 'package:demo_project/view/initial_page.dart';
import 'package:demo_project/view_model/block_users.dart';
import 'package:demo_project/view_model/chat_logs.dart';
import 'package:demo_project/view_model/liked_me_users.dart';
import 'package:demo_project/view_model/matching_users.dart';
import 'package:demo_project/view_model/subscription.dart';
import 'package:demo_project/view_model/swipe_users.dart';
import 'package:demo_project/view_model/user_data.dart';

// Stopwatch? appStartStopwatch;
bool isFirstLaunch = false;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ignore: unreachable_from_main
AppLocalizations? appLocalizations;
StreamSubscription<RemoteMessage>? fcmMessageListener;

void main() async {
  // appStartStopwatch = Stopwatch()..start();
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    init(),
    getIsFirstLaunch(),
  ]);
  fcmMessageListener = null;
  SystemChrome.setSystemUIOverlayStyle(systemStyle());
  runApp(ProviderScope(child: MyApp(locale: locale)));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key, required this.locale});
  final Locale? locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(swipeUsersDataNotifierProvider);
    ref.watch(matchingUsersNotifierProvider);
    ref.watch(likedMeUsersNotifierProvider);
    ref.watch(chatLogsNotifierProvider);
    ref.watch(blockUsersNotifierProvider);
    ref.watch(subscriptionNotifierProvider);
    ref.watch(userDataNotifierProvider);

    return CupertinoApp(
        navigatorKey: navigatorKey,
        theme: const CupertinoThemeData(brightness: Brightness.light),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        home: const HomePage());
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他上記に付随する関数
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
SystemUiOverlayStyle systemStyle() {
  return const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  );
}

Future<void> getIsFirstLaunch() async {
  final fastAction = await localGetFirstActions();
  isFirstLaunch = fastAction.startup;
}
