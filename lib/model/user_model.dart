import 'package:flutter/material.dart';
import 'package:demo_project/constant/profile_const.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/formatter_utility.dart';
import 'package:demo_project/utility/location_utility.dart';

class UserType {
  String id;
  String uid;
  String userName;
  String birthday;
  String language; //日本語かどうか
  List<double> location; //位置情報
  List<String> profileImages;
  String bio;
  String instagramId;
  String beRealId;
  String tiktokId;
  int height;
  int mbti;
  int dayOff;
  int exercise;
  int alcohol;
  int smoking;
  DateTime? accountCreatedAt;
  List<String>? closeFriends;
  UserType({
    required this.id,
    required this.uid,
    required this.userName,
    required this.birthday,
    required this.language,
    required this.location,
    required this.profileImages,
    this.bio = "",
    this.instagramId = "",
    this.beRealId = "",
    this.tiktokId = "",
    this.height = 0,
    this.mbti = 0,
    this.dayOff = 0,
    this.exercise = 0,
    this.alcohol = 0,
    this.smoking = 0,
    this.accountCreatedAt,
    this.closeFriends,
  });
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// 特定の型や返り値から整形する
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  factory UserType.fromJson(Map<String, dynamic> json) {
    final createdAtStr = json["createdAt"] as String?;
    final profileImages = json["profile_images"] as List? ?? [];
    final closeFriends = json["close_friends"] as List? ?? [];
    final locationData = json["location"] as Map<String, dynamic>?;
    final locations = locationData?["coordinates"] as List? ?? [];

    return UserType(
      id: json["_id"] as String? ?? "",
      uid: json["uid"] as String? ?? "",
      userName: json["user_name"] as String? ?? "",
      birthday: json["birthday"] as String? ?? "",
      language: json["language"] as String? ?? "en",
      location: locations.map((e) => e as double).toList(),
      profileImages: profileImages.whereType<String>().toList(),
      bio: json["bio"] as String? ?? "",
      instagramId: json["instagram_id"] as String? ?? "",
      beRealId: json["beReal_id"] as String? ?? "",
      tiktokId: json["tiktok_id"] as String? ?? "",
      height: json["height"] as int? ?? 0,
      mbti: json["mbti"] as int? ?? 0,
      dayOff: json["dayOff"] as int? ?? 0,
      exercise: json["exercise"] as int? ?? 0,
      alcohol: json["alcohol"] as int? ?? 0,
      smoking: json["smoking"] as int? ?? 0,
      accountCreatedAt:
          createdAtStr != null ? DateTime.parse(createdAtStr).toLocal() : null,
      closeFriends: closeFriends.whereType<String>().toList(),
    );
  }
  static List<UserType> fromList(List json) {
    return json
        .map((e) => UserType.fromJson(e as Map<String, dynamic>))
        .toList();
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//各データを文字列に変える
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//誕生日の生年月日2002-03-16→23
  String toAge() => formatAge(birthday);

  Future<String> toLocationStr(BuildContext context) async =>
      await getLocationString(context, location);

//身長を文字列か
  String? toHeightStr(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    if (height == 0) return ln.notSet;
    if (ln.heightUnit == "cm") return "${height}cm";
    return cmToFeetInches(height);
  }

  List<TagType> toTags(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    return [
      for (int i = 0; i < 6; i++)
        TagType(
          title: [
            ln.height,
            ln.mbti,
            ln.holiday,
            ln.exercise,
            ln.alcohol,
            ln.smoking,
          ][i],
          value: [
            toHeightStr(context),
            if (mbti != 0) mbtiDatas(context)[mbti]["name"] else ln.notSet,
            if (dayOff != 0) dayOffDatas(context)[dayOff] else ln.notSet,
            if (exercise != 0) exerciseDatas(context)[exercise] else ln.notSet,
            if (alcohol != 0) alcoholDatas(context)[alcohol] else ln.notSet,
            if (smoking != 0) smokingDatas(context)[smoking] else ln.notSet,
          ][i],
          icon: [
            Icons.height_rounded,
            Icons.bolt_rounded,
            Icons.calendar_month_rounded,
            Icons.directions_run_rounded,
            Icons.sports_bar_rounded,
            Icons.smoking_rooms_rounded,
          ][i],
        ),
    ];
  }

  List<String> toSNS(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    return [
      if (instagramId.isNotEmpty) instagramId else ln.notSet,
      if (tiktokId.isNotEmpty) tiktokId else ln.notSet,
      if (beRealId.isNotEmpty) beRealId else ln.notSet,
    ];
  }

  UserPreviewType toUserPreviewType() {
    return UserPreviewType(
      id: id,
      userName: userName,
      profileImages: profileImages,
      location: location,
      birthday: birthday,
    );
  }
}

class ApiUserUpdateBodyType {
  String id; //これは自分のID
  String? userName;
  String? birthday;
  String? language; //日本語かどうか
  String? country; //日本
  String? prefecture; //東京都
  List<String>? profileImages;
  String? bio;
  String? instagramId;
  String? beRealId;
  String? tiktokId;
  int? height;
  int? mbti;
  int? dayOff;
  int? exercise;
  int? alcohol;
  int? smoking;
  ApiUserUpdateBodyType({
    required this.id,
    this.userName,
    this.birthday,
    this.language,
    this.country,
    this.prefecture,
    this.profileImages,
    this.bio,
    this.instagramId,
    this.beRealId,
    this.tiktokId,
    this.height,
    this.mbti,
    this.dayOff,
    this.exercise,
    this.alcohol,
    this.smoking,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      "language": language,
      "birthday": birthday,
      "country": country,
      "prefecture": prefecture,
      'profile_images': profileImages,
      'bio': bio,
      "instagram_id": instagramId,
      "beReal_id": beRealId,
      "tiktok_id": tiktokId,
      "height": height,
      "mbti": mbti,
      "dayOff": dayOff,
      "exercise": exercise,
      "alcohol": alcohol,
      "smoking": smoking,
    }..removeWhere((key, value) => value == null);
  }
}
