//AppBarで使用中。　左側のアイコンの形を決める。

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/formatter_utility.dart';
import 'package:demo_project/utility/location_utility.dart';

enum AppBarLeftIconType { down, left, cancel, none }

enum DataState { idle, success, error }

enum RoomCreateState { alreadyJoined, success, error }

enum ToggleType { add, delete }

enum FlowDirectionType { back, forward }

enum SwipeActionType { idle, like, nope }

enum ScreenState { idle, active, end }

enum AccessCtrlType { block, visibility }

enum RoleType { initiator, target }

extension RoleTypeX on RoleType {
  bool isInitiator() => this == RoleType.initiator;
  bool isTarget() => this == RoleType.target;
}

extension RoomCreateStateX on RoomCreateState {
  bool isAlreadyJoined() => this == RoomCreateState.alreadyJoined;
  bool isSuccess() => this == RoomCreateState.success;
  bool isError() => this == RoomCreateState.error;
}

extension FlowDirectionTypeX on FlowDirectionType {
  bool isBack() => this == FlowDirectionType.back;
  bool isForward() => this == FlowDirectionType.forward;
}

extension SwipeActionTypeX on SwipeActionType {
  bool isIdle() => this == SwipeActionType.idle;
  bool isLike() => this == SwipeActionType.like;
  bool isNope() => this == SwipeActionType.nope;
  int toInt() => this == SwipeActionType.like ? 2 : 0;
  Color toColor() {
    if (isLike()) return Colors.blueAccent;
    if (isNope()) return Colors.deepPurpleAccent;
    return Colors.black;
  }

  CardSwiperDirection toDirection() {
    if (this == SwipeActionType.like) return CardSwiperDirection.right;
    if (this == SwipeActionType.nope) return CardSwiperDirection.left;
    return CardSwiperDirection.none;
  }
}

extension ScreenStateX on ScreenState {
  bool isIdle() => this == ScreenState.idle;
  bool isActive() => this == ScreenState.active;
  bool isEnd() => this == ScreenState.end;
}

extension CardSwiperDirectionX on CardSwiperDirection {
  SwipeActionType toSwipeActionType() {
    switch (this) {
      case CardSwiperDirection.right:
        return SwipeActionType.like;
      case CardSwiperDirection.left:
        return SwipeActionType.nope;
      default:
        return SwipeActionType.idle;
    }
  }
}

extension AccessControlX on AccessCtrlType {
  bool isBlock() => this == AccessCtrlType.block;
  bool isVisibility() => this == AccessCtrlType.visibility;
}

class TagType {
  String title;
  String? value;
  IconData icon;
  TagType({
    required this.title,
    required this.value,
    required this.icon,
  });
}

class SettingItemType {
  String itemName;
  String? customImage;
  String? itemImage;
  IconData? icon;
  String? value;
  Color? valueColor;
  VoidCallback? onTap;
  SettingItemType({
    required this.itemName,
    this.itemImage,
    this.icon,
    this.value,
    this.valueColor,
    this.onTap,
    this.customImage,
  });
}

class MenuItemType {
  String? itemId;
  String itemName;
  IconData? itemIcon;
  Color? color = Colors.blue;
  bool? isSelect;
  Widget? addWidget;
  VoidCallback? onTap;
  MenuItemType({
    this.itemId,
    required this.itemName,
    this.itemIcon,
    this.color,
    this.onTap,
    this.isSelect,
    this.addWidget,
  });
}

class EditImageItemType {
  String? url;
  File? file;
  File? originalFile;
  EditImageItemType({this.url, this.file, this.originalFile});

  static List<EditImageItemType> toList({
    List<String>? urls,
    List<File>? files,
  }) {
    return [
      for (final url in urls ?? <String>[]) EditImageItemType(url: url),
      for (final file in files ?? <File>[])
        EditImageItemType(file: file, originalFile: file),
    ];
  }

  DecorationImage? toDecoration() {
    if (url != null) return networkImg(url);
    if (file != null) return fileImg(file);
    return null;
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// ユーザー関連の型
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

class LikedMeUsersType {
  bool isFetch;
  int count;
  List<UserPreviewType> users;
  LikedMeUsersType({
    required this.count,
    required this.users,
    required this.isFetch,
  });

  factory LikedMeUsersType.fromJson(Map<String, dynamic> data) {
    final json = data["liked_me_user"] as Map<String, dynamic>;
    return LikedMeUsersType(
      isFetch: false,
      count: json["count"] as int? ?? 0,
      users: UserPreviewType.fromList(json["users"] as List),
    );
  }
  LikedMeUsersType upDate(List<UserPreviewType> newUsers) {
    return LikedMeUsersType(isFetch: isFetch, count: count, users: newUsers);
  }
}

class BlockUserType {
  String id;
  UserPreviewType user;
  DateTime createAt;
  BlockUserType({
    required this.id,
    required this.user,
    required this.createAt,
  });

  static List<BlockUserType> fromList(List<dynamic> dataList) {
    return dataList.map((item) {
      final json = item as Map<String, dynamic>;
      final createAt = DateTime.parse(json["createdAt"] as String? ?? "");
      final user = json["target"] as Map<String, dynamic>;
      return BlockUserType(
        id: json["_id"] as String? ?? "",
        createAt: createAt.toLocal(),
        user: UserPreviewType.fromJson(user),
      );
    }).toList();
  }

  static List<BlockUserType> fromResponse(Response response) {
    final data = json.decode(response.body);
    return BlockUserType.fromList(data as List);
  }
}

class UserPreviewType {
  String id;
  String userName;
  List<String> profileImages;
  String birthday;
  List<double> location; //位置情報
  UserPreviewType({
    required this.id,
    required this.userName,
    required this.profileImages,
    required this.location,
    required this.birthday,
  });

  factory UserPreviewType.fromJson(Map<String, dynamic> json) {
    final profileImages = json["profile_images"] as List? ?? [];
    final locationData = json["location"] as Map<String, dynamic>?;
    final locations = locationData?["coordinates"] as List? ?? [];
    return UserPreviewType(
      id: json["_id"] as String? ?? "",
      userName: json["user_name"] as String? ?? "",
      birthday: json["birthday"] as String? ?? "",
      location: locations.map((e) => e as double).toList(),
      profileImages: profileImages.whereType<String>().toList(),
    );
  }

  static List<UserPreviewType> fromList(List json) {
    return json
        .map((e) => UserPreviewType.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String toAge() => formatAge(birthday);

  Future<String> toLocationStr(BuildContext context) async =>
      await getLocationString(context, location);

  UserType toUserType() {
    return UserType(
      id: id,
      uid: "",
      userName: userName,
      birthday: birthday,
      language: "",
      location: location,
      profileImages: profileImages,
    );
  }
}

class SwipeUserType {
  UserType user;
  bool isSwipe;
  SwipeUserType({
    required this.user,
    this.isSwipe = false,
  });
  static List<SwipeUserType> fromList(List json) {
    return json.map((e) {
      return SwipeUserType(user: UserType.fromJson(e as Map<String, dynamic>));
    }).toList();
  }

  SwipeUserType swipe() => SwipeUserType(user: user, isSwipe: true);
}
