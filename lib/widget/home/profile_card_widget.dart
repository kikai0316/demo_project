import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/user_profile_page.dart';
import 'package:demo_project/widget/widget/future_text_widget.dart';
import 'package:demo_project/widget/widget/network_image_widget.dart';

class ProfileCardWidget extends HookConsumerWidget {
  const ProfileCardWidget({
    super.key,
    required this.constraints,
    required this.currentIndex,
    required this.itemIndex,
    required this.swipeAction,
    required this.user,
    required this.onAction,
    required this.onMenu,
  });
  final int currentIndex;
  final int itemIndex;
  final ValueNotifier<SwipeActionType> swipeAction;
  final UserType user;
  final BoxConstraints constraints;
  final void Function(SwipeActionType) onAction;
  final void Function() onMenu;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = constraints.maxWidth;
    final imageIndex = useState<int>(0);
    final isSelect = currentIndex == itemIndex;
    // useEffect(handleEffect(context), []);
    return nContainer(
      radius: 35,
      color: blueColor,
      border: nBorder(color: Colors.black.withCustomOpacity(0.05)),
      child: Opacity(
        opacity: calcValue(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _imagesWidget(imageIndex),
            ..._fadeGradationWidget(),
            tapEventWidget(imageIndex, user),
            _profileContainer(
              onProfile: onProfile(context, imageIndex),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _locationItem(),
                    _openProfileButton(
                      onTap: onProfile(context, imageIndex),
                    ),
                  ],
                ),
                if (imageIndex.value != 0) tagWidgetItems(context),
                if (imageIndex.value == 0) ...[
                  _nameAgeItem(),
                  _commentItem(),
                ],
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: nSpacing(
                  top: safeAreaWidth * 0.07,
                  left: safeAreaWidth * 0.03,
                ),
                child: indicatorWidget(constraints, imageIndex, user),
              ),
            ),
            menuIconWidget(onMenu),
            if (isSelect && swipeAction.value.isLike())
              _likeWidget(safeAreaWidth),
            if (isSelect && swipeAction.value.isNope())
              _nopeWidget(safeAreaWidth),
          ],
        ),
      ),
    );
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// Dispose? Function() handleEffect(BuildContext context) {
//   return () {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {});
//     return null;
//   };
// }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onProfile(
    BuildContext context,
    ValueNotifier<int> imageIndex,
  ) {
    return () {
      final initIndex = imageIndex.value;
      final page = UserProfilePage(user: user, initImageIndex: initIndex);
      swipeAction.value = SwipeActionType.idle;
      ScreenTransition(context, page).top<Map<String, dynamic>>(
        onPop: (value) async {
          final index = value?["index"] as int? ?? imageIndex.value;
          final action = value?["action"] as SwipeActionType?;
          if (!context.mounted) return;
          if (action != null) onAction.call(action);
          imageIndex.value = index;
          await Future<void>.delayed(const Duration(milliseconds: 500));
          if (context.mounted) swipeAction.value = SwipeActionType.idle;
        },
      );
      HapticFeedback.mediumImpact();
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//カードの薄さを取得
  double calcValue() {
    final diff = itemIndex - currentIndex;
    if (diff <= 0) return 1.0;
    if (diff == 1) return 0.6;
    if (diff == 2) return 0.2;
    return 0.0;
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// Widgets
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  Widget _imagesWidget(ValueNotifier<int> imageIndex) {
    return IndexedStack(index: imageIndex.value, children: [
      for (final url in user.profileImages)
        Hero(
          tag: "${user.id}_$url",
          child: CustomNetworkImageWidegt(
            safeAreaWidth: constraints.maxWidth,
            url: url,
            radius: 35,
            height: double.infinity,
            isUserImage: false,
          ),
        ),
    ]);
  }

  List<Widget> _fadeGradationWidget() {
    final safeAreaWidth = constraints.maxWidth;
    final color = swipeAction.value.toColor();
    final opacity = !swipeAction.value.isIdle() ? 0.5 : 0.3;
    const aligns = [
      Alignment.topCenter,
      Alignment.bottomCenter,
    ];
    return [
      for (int i = 0; i < 2; i++)
        Align(
          alignment: aligns[i],
          child: nContainer(
            customBorderRadius: nBorderRadius(
              radius: 35,
              isOnlyBottom: i == 1,
              isOnlyTop: i == 0,
            ),
            height: [
              safeAreaWidth * 0.18,
              safeAreaWidth * 0.5,
            ][i],
            width: safeAreaWidth,
            gradient:
                nGradation(colors: fadeGradation(aligns[i], opacity, color)),
          ),
        ),
    ];
  }

  Widget _profileContainer({
    VoidCallback? onProfile,
    required List<Widget> children,
  }) {
    final safeAreaWidth = constraints.maxWidth;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: nSpacing(bottom: safeAreaWidth * 0.15),
        child: GestureDetector(
          onTap: onProfile,
          child: AnimatedSize(
            clipBehavior: Clip.none,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget _likeWidget(double safeAreaWidth) {
    return Align(
      alignment: const Alignment(-1, -1.1),
      child: Transform.rotate(
        angle: -0.3,
        child: nContainer(
          margin: nSpacing(left: safeAreaWidth * 0.03),
          squareSize: safeAreaWidth * 0.6,
          image: assetImg("image/like.png"),
        ),
      ),
    );
  }

  Widget _nopeWidget(double safeAreaWidth) {
    return Align(
      alignment: const Alignment(1, -1.1),
      child: Transform.rotate(
        angle: 0.3,
        child: nContainer(
          margin: nSpacing(right: safeAreaWidth * 0.03),
          squareSize: safeAreaWidth * 0.6,
          image: assetImg("image/nope.png"),
        ),
      ),
    );
  }

  Widget _locationItem() {
    final safeAreaWidth = constraints.maxWidth;
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: nSpacing(left: safeAreaWidth * 0.03),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: nIconButton(
              backGroundColor: Colors.white.withCustomOpacity(0.3),
              iconData: Icons.location_on_rounded,
              padding: nSpacing(allSize: safeAreaWidth * 0.03),
              iconSize: safeAreaWidth / 30,
              withTextWidget: FutureTextWidget(
                location: user.location,
                fontSize: safeAreaWidth / 25,
                maxWidth: safeAreaWidth * 0.55,
                margin: nSpacing(left: safeAreaWidth * 0.01),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameAgeItem() {
    final safeAreaWidth = constraints.maxWidth;
    return Padding(
      padding: nSpacing(top: safeAreaWidth * 0.01),
      child: CustomFadeIn(
        key: const ValueKey("nameAge"),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            nContainer(
              margin: nSpacing(left: safeAreaWidth * 0.03),
              maxWidth: safeAreaWidth * 0.8,
              child: nText(
                user.userName,
                fontSize: safeAreaWidth / 10,
                isFit: true,
                isOverflow: false,
              ),
            ),
            nText(
              user.toAge(),
              padding: nSpacing(left: safeAreaWidth * 0.02),
              fontSize: safeAreaWidth / 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentItem() {
    final safeAreaWidth = constraints.maxWidth;
    return CustomFadeIn(
      key: const ValueKey("nameAge"),
      child: nText(
        user.bio,
        padding: nSpacing(
          top: safeAreaWidth * 0.01,
          xSize: safeAreaWidth * 0.04,
        ),
        fontSize: safeAreaWidth / 23,
        maxLiune: 2,
        textAlign: TextAlign.start,
        height: 1.2,
        color: Colors.white.withCustomOpacity(1),
        bold: 400,
      ),
    );
  }

  Widget _openProfileButton({VoidCallback? onTap}) {
    final safeAreaWidth = constraints.maxWidth;
    return Padding(
      padding: nSpacing(right: safeAreaWidth * 0.03),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: nIconButton(
            squareSize: safeAreaWidth * 0.13,
            onTap: onTap,
            iconImage: "black/arror_top.png",
            iconSize: safeAreaWidth / 15,
            imageCustomColor: Colors.white,
            backGroundColor: Colors.white.withCustomOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget menuIconWidget(VoidCallback onTap) {
    final safeAreaWidth = constraints.maxWidth;
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: nSpacing(allSize: safeAreaWidth * 0.05),
        child: CustomAnimatedButton(
          onTap: onTap,
          vibration: () => HapticFeedback.mediumImpact(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: nIconButton(
                backGroundColor: Colors.black.withCustomOpacity(0.2),
                iconData: Icons.more_horiz,
                padding: nSpacing(allSize: safeAreaWidth * 0.02),
                iconSize: safeAreaWidth / 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tagWidgetItems(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    final safeAreaWidth = constraints.maxWidth;
    final tags = user.toTags(context);

    return Padding(
      padding: nSpacing(xSize: safeAreaWidth * 0.03, top: safeAreaWidth * 0.03),
      child: CustomFadeIn(
        child: Wrap(
          runSpacing: safeAreaWidth * 0.02,
          children: [
            for (final tag in tags)
              if (tag.value == ln.notSet)
                const SizedBox.shrink()
              else
                nIconButton(
                  iconData: tag.icon,
                  iconSize: safeAreaWidth * 0.05,
                  margin: nSpacing(right: safeAreaWidth * 0.02),
                  backGroundColor: Colors.black.withCustomOpacity(0.1),
                  padding: nSpacing(
                    ySize: safeAreaWidth * 0.02,
                    xSize: safeAreaWidth * 0.025,
                  ),
                  border: nBorder(color: Colors.white),
                  withTextWidget: nText(
                    tag.value ?? "",
                    fontSize: safeAreaWidth / 30,
                    padding: nSpacing(left: safeAreaWidth * 0.01),
                    bold: 900,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

Widget tapEventWidget(ValueNotifier<int> imageIndex, UserType user) {
  final isAdd = imageIndex.value != user.profileImages.length - 1;
  final isMinus = imageIndex.value != 0;
  return Row(
    children: [
      for (int i = 0; i < 2; i++)
        Expanded(
          child: CustomAnimatedButton(
            vibration: () => HapticFeedback.mediumImpact(),
            onTap: () {
              if (i == 0 && isMinus) imageIndex.value--;
              if (i == 1 && isAdd) imageIndex.value++;
            },
            child: nContainer(color: Colors.transparent),
          ),
        ),
    ],
  );
}

Widget indicatorWidget(
  BoxConstraints constraints,
  ValueNotifier<int> imageIndex,
  UserType user,
) {
  final safeAreaWidth = constraints.maxWidth;
  final size = safeAreaWidth * 0.02;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (int i = 0; i < user.profileImages.length; i++)
        nContainer(
          duration: const Duration(milliseconds: 100),
          radius: 100,
          margin: nSpacing(xSize: safeAreaWidth * 0.01),
          width: i == imageIndex.value ? safeAreaWidth * 0.1 : size,
          height: size,
          color: i == imageIndex.value ? Colors.white : null,
          border: i != imageIndex.value
              ? nBorder(color: Colors.white, width: 1.5)
              : null,
        ),
    ],
  );
}
