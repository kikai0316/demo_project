// 自作メッセージの型
import 'package:demo_project/model/app_model.dart';

class MessageType {
  final String? id;
  final String userId;
  final String text;
  final DateTime timestamp;
  final bool isTyping;

  MessageType({
    this.id,
    required this.userId,
    required this.text,
    required this.timestamp,
    this.isTyping = false,
  });

  bool isPartner(UserPreviewType partner) => userId == partner.id;

  static List<MessageType> fromResponse(Map<Object?, Object?> raw) {
    final list = raw.values
        .map((item) {
          final data = Map<String, dynamic>.from(item! as Map);
          return MessageType(
            id: (data["id"] as String?) ?? "",
            userId: (data["user_id"] as String?) ?? "",
            text: (data["text"] as String?) ?? "",
            timestamp: DateTime.parse(
              (data["created_at"] as String?) ?? "",
            ).toLocal(),
          );
        })
        .whereType<MessageType>()
        .toList();
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }
}
