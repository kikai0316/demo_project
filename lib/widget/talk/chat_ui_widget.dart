import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/message_model.dart';
import 'package:demo_project/widget/talk/page/connecting_page_widget.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

// チャット表示ウィジェット
class ChatUiWidget extends StatelessWidget {
  const ChatUiWidget({
    super.key,
    required this.messages,
    required this.partner,
    required this.myData,
    required this.constraints,
  });

  final List<MessageType> messages;
  final UserPreviewType partner;
  final UserPreviewType myData;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final safeAreaWidth = constraints.maxWidth;
    final safeAreaHeight = constraints.maxHeight;

    return Expanded(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: nContainer(
          gradient: nGradation(
            begin: Alignment.center,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF94D9FE), const Color(0xFFDFFAF7)],
          ),
          width: safeAreaWidth,
          customBorderRadius: nBorderRadius(radius: 30, isOnlyBottom: true),
          boxShadow: nBoxShadow(shadow: 0.05),
          border: nBorder(color: Colors.white.withCustomOpacity(0.3)),
          child: ListView.builder(
            reverse: true,
            addAutomaticKeepAlives: false,
            cacheExtent: 1000,
            padding: nSpacing(
              xSize: 10,
              top: safeAreaHeight * 0.15,
              bottom: safeAreaHeight * 0.02,
            ),
            itemCount: messages.length + 1,
            itemBuilder: (context, index) {
              if (index == messages.length) {
                return TopContents(
                  myData: myData,
                  partner: partner,
                  constraints: constraints,
                );
              }
              final itemIndex = messages.length - 1 - index;
              final message = messages[itemIndex];

              return MessageBubble(
                key: ValueKey(message.id ?? itemIndex), // 安定したキー
                message: message,
                partner: partner,
                constraints: constraints,
              );
            },
          ),
        ),
      ),
    );
  }
}

// メッセージバブルを別ウィジェットに分離してconst化
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.partner,
    required this.constraints,
  });

  final MessageType message;
  final UserPreviewType partner;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final isPartner = message.isPartner(partner);
    final safeAreaWidth = constraints.maxWidth;
    final safeAreaHeight = constraints.maxHeight;

    return Padding(
      padding: nSpacing(
        top: !message.isTyping ? 0 : safeAreaHeight * 0.02,
        bottom: safeAreaWidth * 0.04,
      ),
      child: Row(
        mainAxisAlignment: _axisAlignment(isPartner),
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isPartner)
            CustomNetworkImageWidegt(
              safeAreaWidth: safeAreaWidth,
              height: safeAreaWidth * 0.1,
              width: safeAreaWidth * 0.1,
              url: partner.profileImages.first,
              margin: nSpacing(right: safeAreaWidth * 0.02),
              radius: 100,
            ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isPartner)
                  DateItem(
                    message: message,
                    constraints: constraints,
                  ),
                Flexible(
                  child: MessageContent(
                    message: message,
                    isPartner: isPartner,
                    constraints: constraints,
                  ),
                ),
                if (isPartner)
                  DateItem(
                    message: message,
                    constraints: constraints,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MainAxisAlignment _axisAlignment(bool isPartner) {
    return isPartner ? MainAxisAlignment.start : MainAxisAlignment.end;
  }
}

// メッセージコンテンツをconst化
class MessageContent extends StatelessWidget {
  const MessageContent({
    super.key,
    required this.message,
    required this.isPartner,
    required this.constraints,
  });

  final MessageType message;
  final bool isPartner;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    final safeAreaWidth = constraints.maxWidth;
    final isTypingText = message.isTyping && message.text.isEmpty;
    final borderRadius = nBorderRadius(
      radius: 15,
      zeroRadius: 5,
      isNotOnlyBottomRight: !isPartner,
      isNotOnlyBottomLeft: isPartner,
    );
    return nSkeletonLoadingWidget(
      isLoading: message.isTyping,
      borderRadius: borderRadius,
      child: nContainer(
        padding: nSpacing(
          xSize: safeAreaWidth * 0.04,
          ySize: safeAreaWidth * 0.035,
        ),
        // color: _formatBGColor(isPartner),
        gradient: nGradation(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: _formatBGColors(isPartner),
        ),
        customBorderRadius: borderRadius,
        child: nText(
          !isTypingText ? message.text : ln.typing,
          fontSize: safeAreaWidth / 25,
          isOverflow: false,
          height: 1.3,
          textAlign: TextAlign.start,
          color: _formatTextColor(isPartner),
        ),
      ),
    );
  }

  List<Color> _formatBGColors(bool isPartner) {
    const green1 = Color(0xFF28C38E);
    const green2 = Color(0xFF5EDFAE);
    const blue1 = Color(0xFF7FD0FD);
    const blue2 = Color(0xFF14A7EA);
    if (message.isTyping) return [green1, green2];
    if (!isPartner) return [blue1, blue2];
    return [Colors.white, Colors.white];
  }

  Color _formatTextColor(bool isPartner) {
    final isOpacity = message.isTyping && message.text.isEmpty;
    if (isOpacity) return Colors.white.withCustomOpacity(0.3);
    return !isPartner ? Colors.white : blackColor;
  }
}

// 日時表示をconst化
class DateItem extends StatelessWidget {
  const DateItem({
    super.key,
    required this.message,
    required this.constraints,
  });

  final MessageType message;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final safeAreaWidth = constraints.maxWidth;

    return Padding(
      padding: nSpacing(xSize: safeAreaWidth * 0.01),
      child: nText(
        _formatTime(message.timestamp),
        fontSize: safeAreaWidth / 35,
        color: blackColor.withCustomOpacity(0.5),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

// トップコンテンツをconst化
class TopContents extends StatelessWidget {
  const TopContents({
    super.key,
    required this.myData,
    required this.partner,
    required this.constraints,
  });

  final UserPreviewType myData;
  final UserPreviewType partner;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    final safeAreaWidth = constraints.maxWidth;
    final safeAreaHeight = constraints.maxHeight;
    final users = [myData, partner];

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < users.length; i++)
              connectImagesItems(safeAreaWidth, users[i], i),
          ],
        ),
        nText(
          "${myData.userName}&${partner.userName}",
          fontSize: safeAreaWidth / 20,
          padding: nSpacing(top: safeAreaWidth * 0.02),
          color: blackColor,
          isFit: true,
        ),
        nContainer(
          width: safeAreaWidth * 0.8,
          padding: nSpacing(
            top: safeAreaHeight * 0.02,
            bottom: safeAreaHeight * 0.04,
          ),
          child: nText(
            ln.moderationNotice,
            fontSize: 12, // 固定値に変更してconst化
            isOverflow: false,
            height: 1.3,
            color: const Color(0x80000000),
          ),
        ),
      ],
    );
  }
}
