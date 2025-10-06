import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/firebase/storage_utility.dart';
import 'package:demo_project/utility/image_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/setting/edti_image_page_widget.dart';

PageController? editImagesPageController;
Timer? pageIndexTimer;

class EditImagesPage extends HookConsumerWidget {
  const EditImagesPage({
    super.key,
    required this.myId,
    required this.urls,
    this.files,
    this.initIndex,
    this.editFiles,
  });
  final String myId;
  final List<String> urls; //プロフィールに設定済みの画像
  final List<File>? files; //カメラロールからの画像
  final List<EditImageItemType>? editFiles;
  final int? initIndex;

  //initIndexがnullの場合：
  //  newImagesがない場合：defaultImagesの最初の画像
  //  newImagesがある場合：の最初の画像を選択する

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenState = useState<ScreenState>(ScreenState.idle);
    final selectIndex = useState<int>(initSelectIndex());
    final moveItemIndex = useState<int?>(null);
    final isLoading = useState<bool>(false);
    final images = useState(editFiles ?? initEditImageItems());
    final isPageIndex = useState<bool>(false);

    useEffect(handleEffect(context, screenState), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final remainingHeight = getRemainingHeight(context, constraints);
        return Stack(
          children: [
            Scaffold(
              backgroundColor: mainBackgroundColor,
              appBar: editImagePageAppBar(
                context,
                safeAreaWidth,
                onSave: editFiles != null
                    ? () => Navigator.pop(context, images.value)
                    : onSave(context, ref, images, isLoading),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    nContainer(
                      aspectRatio: mainAspectRatio,
                      child: PageView(
                        controller: editImagesPageController,
                        onPageChanged: (value) => selectIndex.value = value,
                        children: [
                          for (int i = 0; i < images.value.length; i++)
                            mainImageItemWidget(
                              context,
                              safeAreaWidth,
                              itemIndex: i,
                              screenState: screenState,
                              isPageIndex: isPageIndex,
                              images: images,
                              onMove: onMove(i, selectIndex, images),
                              onTrimming: onTrimming(context, i, images),
                              onDelete: onDelete(i, images),
                            ),
                        ],
                      ),
                    ),
                    nContainer(
                      padding: nSpacing(xSize: safeAreaWidth * 0.01),
                      height: remainingHeight,
                      child: ReorderableListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.value.length,
                        onReorderStart: onReorderStart(moveItemIndex),
                        onReorderEnd: onReorderEnd(moveItemIndex),
                        onReorder: onReorder(selectIndex, images),
                        footer: footerWidget(
                          safeAreaWidth,
                          images,
                          onAddImage(
                            context,
                            safeAreaWidth,
                            isLoading,
                            images,
                            selectIndex,
                          ),
                        ),
                        itemBuilder: (context, index) {
                          return bottomImageItemWidget(
                            safeAreaWidth,
                            onTap: onBottomImage(selectIndex, index),
                            itemIndex: index,
                            selectIndex: selectIndex,
                            moveItemIndex: moveItemIndex,
                            image: images.value[index],
                            isNewText: editFiles == null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
  Dispose? Function() handleEffect(
    BuildContext context,
    ValueNotifier<ScreenState> screenState,
  ) {
    return () {
      editImagesPageController = PageController(initialPage: initSelectIndex());
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (context.mounted) screenState.value = ScreenState.active;
      });
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onBottomImage(ValueNotifier<int> selectIndex, int index) {
    return () {
      selectIndex.value = index;
      editImagesPageController?.jumpToPage(index);
    };
  }

  VoidCallback onTrimming(
    BuildContext context,
    int index,
    ValueNotifier<List<EditImageItemType>> images,
  ) {
    return () async {
      final file = images.value[index].originalFile;
      final newImage = await cropProfileImg(context, file);
      if (newImage == null || !context.mounted) return;
      final newImages = [...images.value];
      newImages[index] = EditImageItemType(file: newImage, originalFile: file);
      images.value = [...newImages];
    };
  }

  VoidCallback? onDelete(
    int index,
    ValueNotifier<List<EditImageItemType>> images,
  ) {
    if (images.value.length == 1) return null;
    return () {
      final newImages = [...images.value];
      newImages.removeAt(index);
      images.value = [...newImages];
    };
  }

  void Function(FlowDirectionType)? onMove(
    int index,
    ValueNotifier<int> selectIndex,
    ValueNotifier<List<EditImageItemType>> images,
  ) {
    return (type) {
      final newIndex = type.isBack() ? index - 1 : index + 1;
      final newImages = [...images.value];
      newImages.removeAt(index);
      newImages.insert(newIndex, images.value[index]);
      images.value = newImages;
      final newSelect = getNewSelectedIndex(selectIndex, index, newIndex);
      selectIndex.value = newSelect;
      editImagesPageController?.jumpToPage(newSelect);
    };
  }

  VoidCallback? onSave(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<List<EditImageItemType>> images,
    ValueNotifier<bool> isLoading,
  ) {
    final editUrls = images.value.map((e) => e.url).toList();
    if (files == null && listEquals(editUrls, urls)) return null;
    return () async {
      try {
        isLoading.value = true;
        final urls = await dbStorageProfileImageUploads(myId, images.value);
        if (!context.mounted) return;
        final notifier = ref.read(userDataNotifierProvider.notifier);
        final body = ApiUserUpdateBodyType(id: myId, profileImages: urls);
        final isUpDate = await notifier.upDateUserProfile(context, body);
        if (!context.mounted) return;
        isLoading.value = false;
        if (isUpDate) Navigator.pop(context);
        if (!isUpDate) nErrorDialog(context);
      } catch (_) {
        if (!context.mounted) return;
        isLoading.value = false;
        nErrorDialog(context);
        return;
      }
    };
  }

  VoidCallback onAddImage(
    BuildContext context,
    double safeAreaWidth,
    ValueNotifier<bool> isLoading,
    ValueNotifier<List<EditImageItemType>> images,
    ValueNotifier<int> selectIndex,
  ) {
    return () async {
      final length = images.value.length;
      final newImgs =
          await getMobileImages(context, safeAreaWidth, isLoading, 1);
      if (!context.mounted || newImgs.isEmpty) return;
      final editImages = newImgs
          .map((e) => EditImageItemType(file: e, originalFile: e))
          .toList();
      images.value = [...images.value, ...editImages];
      selectIndex.value = length;
      editImagesPageController?.jumpToPage(length);
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  void Function(int, int) onReorder(
    ValueNotifier<int> selectIndex,
    ValueNotifier<List<EditImageItemType>> images,
  ) {
    return (oldIndex, newIndex) {
      final newImages = [...images.value];
      newImages.removeAt(oldIndex);
      if (oldIndex < newIndex) newIndex -= 1;
      newImages.insert(newIndex, images.value[oldIndex]);
      images.value = newImages;
      final newSelect = getNewSelectedIndex(selectIndex, oldIndex, newIndex);
      selectIndex.value = newSelect;
      editImagesPageController?.jumpToPage(newSelect);
    };
  }

  void Function(int)? onReorderStart(ValueNotifier<int?> moveItemIndex) {
    return (index) {
      moveItemIndex.value = index;
      HapticFeedback.mediumImpact();
    };
  }

  void Function(int)? onReorderEnd(ValueNotifier<int?> moveItemIndex) {
    return (_) => moveItemIndex.value = null;
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  List<EditImageItemType> initEditImageItems() {
    return [...EditImageItemType.toList(urls: urls, files: files)];
  }

  int initSelectIndex() {
    if (initIndex != null) return initIndex!;
    if ((files ?? []).isNotEmpty) return urls.length;
    return 0;
  }

  double getRemainingHeight(BuildContext context, BoxConstraints constraints) {
    final safeAreaWidth = constraints.maxWidth;
    final safeAreaHeight = constraints.maxHeight;
    final aspectHeight = safeAreaWidth * mainAspectRatioInverse;
    final appBarHeight = AppBar().preferredSize.height;
    final pTop = MediaQuery.of(context).padding.top;
    final pBottom = MediaQuery.of(context).padding.bottom;
    return safeAreaHeight - aspectHeight - appBarHeight - pTop - pBottom;
  }

  int getNewSelectedIndex(
    ValueNotifier<int> selectIndex,
    int oldIndex,
    int newIndex,
  ) {
    final currentIndex = selectIndex.value;
    if (currentIndex == oldIndex) {
      return newIndex;
    } else if (currentIndex > oldIndex && currentIndex <= newIndex) {
      return currentIndex - 1;
    } else if (currentIndex < oldIndex && currentIndex >= newIndex) {
      return currentIndex + 1;
    } else {
      return currentIndex;
    }
  }
}
