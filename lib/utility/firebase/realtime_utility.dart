import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/message_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/api_functions/api_user_utility.dart';
import 'package:demo_project/utility/app_utlity.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/talk/chat_page.dart';
import 'package:demo_project/view_model/subscription.dart';

const _url = String.fromEnvironment("firebaseRealTimeURL");
const _room = "room";
const _userState = "user_state";

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// ルーム関連（追加、アップデート系）
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
Future<RoomCreateState> dbRTCreateRoom(
  UserPreviewType initiatorUser,
  String targetUserId,
  bool isSubscription,
) async {
  try {
    final app = Firebase.app();
    final roomId = initiatorUser.id;
    final myProfileImage = initiatorUser.profileImages.first;
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final targetUserRoomId = await dbRTGetRoomId(targetUserId);
    final messageId = "call@$roomId@${initiatorUser.userName}@$myProfileImage";
    final tUserSet = {"room_id": roomId, "message_id": messageId};

    if (targetUserRoomId != null) return RoomCreateState.alreadyJoined;
    await rtdb.ref("$_userState/$targetUserId").update(tUserSet);
    await rtdb.ref("$_userState/$roomId").update({"room_id": roomId});
    await rtdb.ref("$_room/$roomId").set({
      "state": 0, //0が待ち、1が入室
      "initiator_id": initiatorUser.id,
      "target_id": targetUserId,
      initiatorUser.id: "",
      targetUserId: "",
      "createdAt": ServerValue.timestamp,
      "isEndless": isSubscription,
    });

    return RoomCreateState.success;
  } catch (_) {
    return RoomCreateState.error;
  }
}

Future<bool> dbRTTypingUpDate(
  String roomId,
  String userId,
  String newValue,
) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    await rtdb.ref("$_room/$roomId").update({userId: newValue});
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> dbRTAddMessage(
  String roomId,
  String userId,
  String text,
) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final json = {
      "id": generateUniqueId(),
      "user_id": userId,
      "text": text,
      "created_at": DateTime.now().toUtc().toString(),
    };
    await rtdb.ref("$_room/$roomId/messages").push().set(json);
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> dbRTJoinRoom(String roomId, WidgetRef ref) async {
  try {
    final subsc = ref.watch(subscriptionNotifierProvider).value?.activeSub;
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final body = {"state": 1, "isEndless": subsc != null};
    await rtdb.ref("$_room/$roomId").update(body);
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> dbRTCheckRoom(BuildContext context, UserType myData) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final myId = myData.id;
    final getRoomId = await dbRTGetRoomId(myId);
    //MessageIDが存在するか、getRoomId がない場合は何もしない
    if (getRoomId == null) return;
    final userType = getRoomId == myId ? "initiator_id" : "target_id";
    final roomState = await rtdb.ref("$_room/$getRoomId/state").once();
    if ((roomState.snapshot.value as int? ?? 0) == 0) {
      await dbRTDeleteRoom(getRoomId);
      return;
    }

    final partnerState = await rtdb.ref("$_room/$getRoomId/$userType").once();
    final partnerId = partnerState.snapshot.value as String?;
    if (partnerId == null) return;
    final partnerData = await apiFetchUser(partnerId);
    final pMyData = myData.toUserPreviewType();
    final pPartnerData = partnerData?.toUserPreviewType();
    if (pPartnerData == null || !context.mounted) return;
    final page =
        ChatPage(roomId: getRoomId, partner: pPartnerData, myData: pMyData);
    ScreenTransition(context, page).top();
  } catch (_) {
    return;
  }
}
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// ルーム関連（削除系）
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

Future<bool> dbRTDeleteRoom(String roomId) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    rtdb.ref("$_room/$roomId").remove();
    return true;
  } catch (_) {
    return false;
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// ルーム関連（リスナー系）
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
StreamSubscription<DatabaseEvent>? dbRTRoomStateListen(
  String roomId,
  VoidCallback? onSuccess,
  VoidCallback? onBlake,
) {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final ref = rtdb.ref("$_room/$roomId/state");
    return ref.onValue.listen((DatabaseEvent event) async {
      final state = event.snapshot.value as int?;
      if (state == null) onBlake?.call();
      if (state != 1) return;
      final snapshot = await ref.get();
      final recheckedState = snapshot.value as int?;
      if (recheckedState == 1) onSuccess?.call();
    });
  } catch (_) {
    return null;
  }
}

StreamSubscription<DatabaseEvent>? dbRTTypingStateListen(
  String roomId,
  String partnerId,
  void Function(String?)? onChange,
) {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final ref = rtdb.ref("$_room/$roomId/$partnerId");
    return ref.onValue.listen(
      (DatabaseEvent event) => onChange?.call(event.snapshot.value as String?),
    );
  } catch (e) {
    return null;
  }
}

StreamSubscription<DatabaseEvent>? dbRTMessageStateListen(
  String roomId,
  String partnerId,
  void Function(List<MessageType>)? onChange,
) {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final ref = rtdb.ref("$_room/$roomId/messages");
    return ref.onValue.listen((DatabaseEvent event) {
      final raw = event.snapshot.value as Map<Object?, Object?>?;
      if (raw == null) return;
      onChange?.call(MessageType.fromResponse(raw));
    });
  } catch (e) {
    return null;
  }
}

StreamSubscription<DatabaseEvent>? dbRTIsEndlesstateListen(
  String roomId,
  String partnerId,
  void Function(bool)? onChange,
) {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final ref = rtdb.ref("$_room/$roomId/isEndless");
    return ref.onValue.listen(
      (DatabaseEvent event) =>
          onChange?.call(event.snapshot.value as bool? ?? false),
    );
  } catch (e) {
    return null;
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// user/ の階層関連
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

// roomIdの追加削除
Future<bool> dbRTUserStateSetRoomId(String userid, {String? roomId}) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    if (roomId == null) {
      await rtdb.ref("$_userState/$userid/room_id").remove();
    } else {
      await rtdb.ref("$_userState/$userid").update({"room_id": roomId});
    }
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> dbRTUserStateActiveOn(String userid) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final ref = rtdb.ref("$_userState/$userid");
    await ref.update({"isActive": 1});
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> dbRTUserStateActiveOFF(String userid) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final ref = rtdb.ref("$_userState/$userid");
    await ref.update({
      "isActive": 0,
      "lastOpenedDate": DateTime.now().toUtc().toString(),
    });
    return true;
  } catch (e) {
    return false;
  }
}

Future<String?> dbRTGetRoomId(String userid) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final tUserRef = rtdb.ref("$_userState/$userid/room_id");
    final tUserSnapshot = await tUserRef.once();
    return tUserSnapshot.snapshot.value as String?;
  } catch (e) {
    return null;
  }
}

Future<String?> dbRTGetMessageId(String userid) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    final tUserRef = rtdb.ref("$_userState/$userid/message_id");
    final tUserSnapshot = await tUserRef.once();
    return tUserSnapshot.snapshot.value as String?;
  } catch (_) {
    return null;
  }
}

Future<void> dbRTDeleteMessageId(String userid) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    await rtdb.ref("$_userState/$userid/message_id").remove();
  } catch (_) {}
}

Future<void> dbRTDeleteRoomId(String userid) async {
  try {
    final app = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(app: app, databaseURL: _url);
    await rtdb.ref("$_userState/$userid/room_id").remove();
  } catch (_) {}
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他関数
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
