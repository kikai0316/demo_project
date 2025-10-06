import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/image_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/user_profile_page.dart';
import 'package:demo_project/view/setting/edit_profile/edit_height_page.dart';
import 'package:demo_project/view/setting/edit_profile/edit_images_page.dart';
import 'package:demo_project/view/setting/edit_profile/edit_select_page.dart';
import 'package:demo_project/view/setting/edit_profile/edit_sns_page.dart';
import 'package:demo_project/view/setting/edit_profile/edit_textfield_page.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/home/page/account_page_widget.dart';
import 'package:demo_project/widget/setting/edti_setting_page_widget.dart';

class EdtitProfilePage extends HookConsumerWidget {
  const EdtitProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final isLoading = useState<bool>(false);
    final user = ref.watch(userDataNotifierProvider).value;
    final tags = user?.toTags(context) ?? [];
    final sns = user?.toSNS(context) ?? [];

    VoidCallback screenTransition(Widget page) {
      return () => ScreenTransition(context, page).normal();
    }

    // useEffect(handleEffect(context), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        // final safeAreaHeight = constraints.maxHeight;
        return Stack(
          children: [
            Scaffold(
              backgroundColor: mainBackgroundColor,
              appBar: editProfileAppBar(
                context,
                safeAreaWidth,
                isLoading: false,
                onPreview: onPreview(context, user),
              ),
              body: nCustomScrollView(
                slivers: [
                  editImagesItem(
                    context,
                    safeAreaWidth,
                    user,
                    onTap: onEditImage(context, user),
                    onAdd: onImgAdd(context, safeAreaWidth, user, isLoading),
                    onEdit: onEditImage(context, user),
                  ),
                  userProfileWidget(
                    context,
                    safeAreaWidth,
                    top: safeAreaWidth * 0.05,
                    label: ln.name,
                    value: user?.userName ?? "",
                    onTap: screenTransition(
                      EditTextFieldPage(title: ln.name),
                    ),
                  ),
                  userProfileWidget(
                    context,
                    safeAreaWidth,
                    top: safeAreaWidth * 0.03,
                    label: ln.aboutMe,
                    value: user?.bio ?? "",
                    onTap: screenTransition(
                      EditTextFieldPage(title: ln.aboutMe),
                    ),
                  ),
                  titleWidget(safeAreaWidth, text: ln.sns),
                  ...settingItemList(
                    safeAreaWidth,
                    itemList: [
                      for (int i = 0; i < sns.length; i++)
                        SettingItemType(
                          itemName: ["Instagram", "TikTok", "BeReal"][i],
                          customImage: "icon/${[
                            "instagram.png",
                            "tiktok.png",
                            "bereal.png",
                          ][i]}",
                          value: sns[i],
                          valueColor:
                              sns[i] == ln.notSet ? redColor : blackColor,
                          onTap: screenTransition(
                            EditSnsPage(
                              title: ["Instagram", "TikTok", "BeReal"][i],
                            ),
                          ),
                        ),
                    ],
                  ),
                  titleWidget(safeAreaWidth, text: ln.details),
                  ...settingItemList(
                    safeAreaWidth,
                    itemList: [
                      for (int i = 0; i < tags.length; i++)
                        SettingItemType(
                          itemName: tags[i].title,
                          icon: tags[i].icon,
                          value: tags[i].value ?? ln.notSet,
                          valueColor: tags[i].value == ln.notSet
                              ? redColor
                              : blackColor,
                          onTap: screenTransition(
                            i == 0
                                ? const EditHeighatPage()
                                : EditSelectPage(title: tags[i].title),
                          ),
                        ),
                    ],
                  ),
                  nSliverSpacer(safeAreaWidth * 0.2),
                ],
              ),
            ),
            loadinPage(safeAreaWidth, isLoading: isLoading.value),
          ],
        );
      },
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
  VoidCallback? onPreview(BuildContext context, UserType? user) {
    if (user == null) return null;
    return () {
      final page =
          UserProfilePage(user: user, initImageIndex: 0, isPreview: true);
      ScreenTransition(context, page).top();
    };
  }

  void Function(int) onEditImage(BuildContext context, UserType? user) {
    return (index) {
      if (user == null) return;
      final page = EditImagesPage(
        urls: user.profileImages,
        initIndex: index,
        myId: user.id,
      );
      ScreenTransition(context, page).hero();
    };
  }

  void Function(int) onImgAdd(
    BuildContext context,
    double safeAreaWidth,
    UserType? user,
    ValueNotifier<bool> isLoading,
  ) {
    return (itemIndex) async {
      if (user == null) return;
      final newImgs = await getMobileImages(
        context,
        safeAreaWidth,
        isLoading,
        5 - user.profileImages.length,
      );
      if (!context.mounted || newImgs.isEmpty) return;
      final page = EditImagesPage(
        urls: user.profileImages,
        files: newImgs,
        myId: user.id,
      );
      ScreenTransition(context, page).top();
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
}
