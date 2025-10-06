//
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Timer? _timer;

Widget nCustomScrollView({
  Future<void> Function()? onRefresh,
  List<Widget>? topSlivers,
  required List<Widget> slivers,
  ScrollPhysics? physics,
  Brightness brightness = Brightness.light,
  VoidCallback? onScrollStart,
  ScrollController? controller,
  void Function(ScrollNotification)? onScrollEnd,
  void Function(ScrollUpdateNotification)? onScrollUpdate,
  bool isScrollBar = false,
  double? cacheExtent,
}) {
  final isListener = (onScrollStart ?? onScrollUpdate ?? onScrollEnd) != null;
  final customScrollView = CupertinoTheme(
    data: CupertinoThemeData(brightness: brightness),
    child: CustomScrollView(
      cacheExtent: cacheExtent,
      controller: controller,
      physics: physics,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        if (topSlivers != null) ...topSlivers,
        if (onRefresh != null)
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await Future<void>.delayed(const Duration(seconds: 1));
              await onRefresh();
            },
          ),
        ...slivers,
      ],
    ),
  );
  final customScrollViewWithScrollBar =
      isScrollBar ? Scrollbar(child: customScrollView) : customScrollView;
  if (!isListener) return customScrollViewWithScrollBar;
  return NotificationListener(
    onNotification: (notification) {
      final isStart = notification is ScrollStartNotification;
      final isUpdate = notification is ScrollUpdateNotification;
      final isScrollEnd = notification is ScrollEndNotification;
      final isDragDetails = isScrollEnd && notification.dragDetails != null;
      final isEnd = isScrollEnd || isDragDetails;
      if (isStart) _timer?.cancel();
      if (isStart) onScrollStart?.call();
      if (isUpdate) onScrollUpdate?.call(notification);
      if (isEnd) onScrollEnd?.call(notification);
      return false;
    },
    child: customScrollViewWithScrollBar,
  );
}
