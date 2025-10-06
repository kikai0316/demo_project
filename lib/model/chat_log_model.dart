import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';

class ChatLogType {
  String id;
  UserPreviewType user;
  RoleType role;
  int status;
  String? cancelledUserId;
  double? chatDuration;
  DateTime createdAt;

  ChatLogType({
    required this.id,
    required this.user,
    required this.role,
    required this.status,
    this.cancelledUserId,
    this.chatDuration,
    required this.createdAt,
  });

  factory ChatLogType.fromJson(Map<String, dynamic> json) {
    final createdStr = json["created_at"] as String;
    final role = json["role"] as String;
    return ChatLogType(
      id: json["id"] as String,
      user: UserPreviewType.fromJson(json["user"] as Map<String, dynamic>),
      role: role == "initiator" ? RoleType.initiator : RoleType.target,
      status: json["status"] as int,
      cancelledUserId: json["cancelled_user"] as String?,
      chatDuration: json["chat_duration"] as double?,
      createdAt: DateTime.parse(createdStr).toLocal(),
    );
  }

  static List<ChatLogType> fromList(List json) {
    return json.map((e) {
      return ChatLogType.fromJson(e as Map<String, dynamic>);
    }).toList();
  }

  String toDateTimeForChat(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    final locale = ln.dateLocaleName;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final difference = today.difference(target).inDays;
    // 今日
    if (difference == 0) return DateFormat.jm(locale).format(createdAt);
    // 昨日
    if (difference == 1) return ln.yesterday;
    // 1週間以内
    if (difference <= 6) {
      final date = DateFormat.E(locale).format(createdAt);
      return locale == "ja_JP" ? "$date曜日" : date;
    }
    // 1年以内 例: 7/14
    if (now.year == createdAt.year) {
      return DateFormat.Md(locale).format(createdAt);
    }
    // それより前// 例: 2023/7/14
    return DateFormat.yMd(locale).format(createdAt);
  }

  Color? toColor() {
    if (status == 1 && role.isTarget()) return redColor;
    if (status == 2 && role.isTarget()) return redColor;
    return blackColor;
  }

  String? toMessage(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    if (status == 4) return null;
    return [
      formatDurationAsTime(context, chatDuration),
      if (role.isInitiator()) ln.noResponse else ln.missedInvitation,
      if (role.isInitiator()) ln.invitationCanceled else ln.missedInvitation,
      if (role.isInitiator()) ln.noResponse else ln.invitationCanceled,
    ][status];
  }

  String formatDurationAsTime(BuildContext context, double? chatDuration) {
    final ln = AppLocalizations.of(context)!;
    if (chatDuration == null) return "※※:※※:※※";
    final totalSeconds = (chatDuration * 60).round();
    final duration = Duration(seconds: totalSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return hours == "00"
        ? "${ln.chatDuration} $minutes:$seconds"
        : '${ln.chatDuration} $hours:$minutes:$seconds';
  }
}

class ApiChatLogBodyType {
  String initiatorId;
  String targetId;
  int status;
  String? cancelledUserId;
  double? chatDuration;

  ApiChatLogBodyType({
    required this.initiatorId,
    required this.targetId,
    required this.status,
    this.cancelledUserId,
    this.chatDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      "initiator_user": initiatorId,
      "target_user": targetId,
      "status": status,
      "cancelled_user": cancelledUserId,
      "chat_duration": chatDuration,
    }..removeWhere((key, value) => value == null);
  }
}
