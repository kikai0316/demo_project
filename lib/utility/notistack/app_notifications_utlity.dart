// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// Future<void> showAppNotifications({
//   required String message,
//   String title = 'Sup.',
// }) async {
//   try {
//     await flutterLocalNotificationsPlugin.show(
//       0, // 通知ID
//       title,
//       message,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'default_channel',
//           'Default',
//           channelDescription: 'Default channel for notifications',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//     );
//   } catch (_) {
//     return;
//   }
// }
