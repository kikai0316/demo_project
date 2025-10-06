import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/gradient_loop_button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/firebase/storage_utility.dart';
import 'package:demo_project/utility/image_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/data_initialize_page.dart';
import 'package:demo_project/view/setting/edit_profile/edit_images_page.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/login/init_setting_widget.dart';

final userIdFocusNode = FocusNode();

class UserImagePage extends HookConsumerWidget {
  const UserImagePage({
    super.key,
    required this.birthday,
    required this.userName,
    required this.gender,
  });

  final String birthday;
  final String userName;
  final int gender;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final ln = AppLocalizations.of(context)!;
    final isLoading = useState<bool>(false);
    final selectImages = useState<List<EditImageItemType>>([]);

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: mainBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  nText(
                    ln.pleaseProfilePic,
                    fontSize: safeAreaWidth / 15,
                    isFit: true,
                    padding: nSpacing(
                      top: safeAreaHeight * 0.1,
                      xSize: safeAreaWidth * 0.05,
                    ),
                    color: blackColor,
                  ),
                  nText(
                    ln.profilePicGuidelines,
                    fontSize: safeAreaWidth / 25,
                    height: 1.3,
                    color: blackColor.withCustomOpacity(0.6),
                    isFit: true,
                    padding: nSpacing(
                      top: safeAreaWidth * 0.05,
                      xSize: safeAreaWidth * 0.05,
                    ),
                  ),
                  inputProfileImagesItem(
                    context,
                    safeAreaWidth,
                    selectImages.value,
                    onTap: onTap(context, safeAreaWidth, selectImages),
                    onAdd: onSelect(
                      context,
                      safeAreaWidth,
                      isLoading,
                      selectImages,
                    ),
                  ),
                  Visibility(
                    visible: selectImages.value.isNotEmpty,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: GradientLoopButton(
                      text: ln.setProfilePicture,
                      safeAreaWidth: safeAreaWidth,
                      margin: nSpacing(top: safeAreaWidth * 0.2),
                      width: safeAreaWidth * 0.8,
                      height: safeAreaWidth * 0.15,
                      fontSize: safeAreaWidth / 22,
                      onTap: onComplete(context, ref, isLoading, selectImages),
                    ),
                  ),
                ],
              ),
            ),
            loadinPage(safeAreaWidth, isLoading: isLoading.value),
          ],
        ),
      ),
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onSelect(
    BuildContext context,
    double safeAreaWidth,
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<EditImageItemType>> selectImages,
  ) {
    return () async {
      final limit = 5 - selectImages.value.length;
      final images =
          await getMobileImages(context, safeAreaWidth, isLoading, limit);
      if (!context.mounted || images.isEmpty) return;
      final page = createEditPage(selectImages, images);
      ScreenTransition(context, page).top(onPop: onPop(context, selectImages));
    };
  }

  void Function(int) onTap(
    BuildContext context,
    double safeAreaWidth,
    ValueNotifier<List<EditImageItemType>> selectImages,
  ) {
    return (value) {
      final page = createEditPage(selectImages, [], value);
      ScreenTransition(context, page).top(onPop: onPop(context, selectImages));
    };
  }

  void Function()? onComplete(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<EditImageItemType>> selectImages,
  ) {
    return () async {
      try {
        final id = ref.watch(userDataNotifierProvider).value?.id ?? "";
        isLoading.value = true;
        final urls = await dbStorageProfileImageUploads(id, selectImages.value);
        if (!context.mounted) return;
        if (urls.isEmpty) nErrorDialog(context);
        if (urls.isEmpty) return;
        final body = createBody(id, urls);
        final notifier = ref.read(userDataNotifierProvider.notifier);
        final isUpDate = await notifier.upDateUserProfile(context, body);
        const page = DataInitializePage();
        final nextPage = await getPermissionRoute() ?? page;
        if (!context.mounted) return;
        isLoading.value = false;
        if (!isUpDate) nErrorDialog(context);
        if (!isUpDate) return;
        ScreenTransition(context, nextPage).normal();
      } catch (_) {
        if (context.mounted) if (!context.mounted) nErrorDialog(context);
      }
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  dynamic Function(List<EditImageItemType>?)? onPop(
    BuildContext context,
    ValueNotifier<List<EditImageItemType>> selectImages,
  ) {
    return (value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (value != null && context.mounted) selectImages.value = value;
      });
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  Widget createEditPage(
    ValueNotifier<List<EditImageItemType>> selectImages,
    List<File> images, [
    int? initIndex,
  ]) {
    final editImages =
        images.map((e) => EditImageItemType(file: e, originalFile: e)).toList();
    return EditImagesPage(
      myId: "",
      urls: const [],
      editFiles: [...selectImages.value, ...editImages],
      initIndex: initIndex ?? selectImages.value.length,
    );
  }

  ApiUserUpdateBodyType createBody(String id, List<String> urls) {
    return ApiUserUpdateBodyType(
      id: id,
      userName: userName,
      birthday: birthday,
      profileImages: urls,
    );
  }
}
