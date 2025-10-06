import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/talk/connecting_page.dart';
import 'package:demo_project/view_model/matching_users.dart';
import 'package:demo_project/widget/page/match_success_page_widget.dart';

class MatchSuccessPage extends HookConsumerWidget {
  const MatchSuccessPage({
    super.key,
    required this.myData,
    required this.partner,
  });
  final UserPreviewType myData;
  final UserPreviewType partner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationState = useState<int>(0);
    final ln = AppLocalizations.of(context)!;
    useEffect(handleEffect(ref, animationState), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final safeAreaHeight = constraints.maxHeight;
        return nContainer(
          squareSize: double.infinity,
          gradient: mainGradation(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              alignment: Alignment.center,
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      cancelIconWidget(constraints, onTap: onCancel(context)),
                      nContainer(
                        margin: nSpacing(top: safeAreaHeight * 0.03),
                        height: safeAreaHeight * 0.4,
                        width: safeAreaWidth * 0.85,
                        // color: Colors.red,
                        child: Stack(
                          children: [
                            for (int i = 0; i < 2; i++)
                              matchCardWidget(
                                constraints,
                                i,
                                [myData, partner],
                                animationState,
                              ),
                            favoriteIcon(constraints, animationState),
                          ],
                        ),
                      ),
                      // nText(
                      //   "You matched!",
                      //   padding: nSpacing(top: safeAreaHeight * 0.05),
                      //   fontSize: safeAreaWidth / 9,
                      //   color: Colors.blueAccent,
                      //   boderColor: Colors.white,
                      //   boderWidth: 7,
                      //   bold: 900,
                      // ),
                      Transform.scale(
                        scale: 4,
                        child: nContainer(
                          squareSize: safeAreaWidth * 0.2,
                          margin: nSpacing(top: safeAreaWidth * 0.03),
                          image: assetImg("image/match.png"),
                        ),
                      ),

                      nText(
                        ln.chatInvitation,
                        padding: nSpacing(
                          top: safeAreaHeight * 0.04,
                          xSize: safeAreaHeight * 0.02,
                        ),
                        fontSize: safeAreaWidth / 25,
                        color: blackColor.withCustomOpacity(0.5),
                        isOverflow: false,
                        isFit: true,
                        height: 1.5,
                      ),
                      const Spacer(),
                      talkIconWidget(constraints, onTap: onChat(context)),
                    ],
                  ),
                ),
                IgnorePointer(
                  child: Lottie.asset(
                    "assets/animations/success.json",
                    repeat: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(
    WidgetRef ref,
    ValueNotifier<int> animationState,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(matchingUsersNotifierProvider.notifier).newMatching(partner);
        animation(animationState);
      });
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback onCancel(BuildContext context) {
    return () => Navigator.pop(context);
  }

  VoidCallback onChat(BuildContext context) {
    return () {
      final page = ConnectingPage(targetUser: partner);
      ScreenTransition(context, page).normal(true);
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  Future<void> animation(ValueNotifier<int> animationState) async {
    HapticFeedback.vibrate();
    animationState.value++;
    animationState.value++;
  }
}
