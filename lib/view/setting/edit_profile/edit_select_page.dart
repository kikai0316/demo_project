import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/sliver_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/constant/profile_const.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/view_model/user_data.dart';

class EditSelectPage extends HookConsumerWidget {
  const EditSelectPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final isLoading = useState<bool>(false);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;

        return Stack(
          children: [
            Scaffold(
              appBar: nAppBar(context, safeAreaWidth, title: title),
              backgroundColor: mainBackgroundColor,
              body: nCustomScrollView(
                slivers: [
                  for (int i = 1; i < getItems(context).length; i++)
                    _item(
                      safeAreaWidth,
                      getItems(context)[i],
                      onSave(context, ref, isLoading, i),
                    ),
                  _item(
                    safeAreaWidth,
                    ln.notSpecified,
                    onSave(context, ref, isLoading, 0),
                  ),
                  nSliverSpacer(safeAreaWidth * 0.3),
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
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  VoidCallback onSave(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
    int itemIndex,
  ) {
    final user = ref.watch(userDataNotifierProvider).value;
    if (user == null) return () => Navigator.pop(context);
    return () async {
      final ln = AppLocalizations.of(context)!;
      final notifier = ref.read(userDataNotifierProvider.notifier);
      final body = ApiUserUpdateBodyType(
        id: user.id,
        mbti: title == ln.mbti ? itemIndex : null,
        dayOff: title == ln.holiday ? itemIndex : null,
        exercise: title == ln.exercise ? itemIndex : null,
        alcohol: title == ln.alcohol ? itemIndex : null,
        smoking: title == ln.smoking ? itemIndex : null,
      );
      isLoading.value = true;
      FocusScope.of(context).unfocus();
      final isUpDate = await notifier.upDateUserProfile(context, body);
      if (!context.mounted) return;
      isLoading.value = false;
      if (!isUpDate) nErrorDialog(context);
      Navigator.pop(context);
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  List<String> getItems(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    final mbtis =
        mbtiDatas(context).map((e) => "${e["name"]}(${e["label"]})").toList();
    List<String> items = [];
    if (title == ln.mbti) items = mbtis;
    if (title == ln.holiday) items = dayOffDatas(context);
    if (title == ln.exercise) items = exerciseDatas(context);
    if (title == ln.alcohol) items = alcoholDatas(context);
    if (title == ln.smoking) items = smokingDatas(context);
    return [...items];
  }
}

Widget _item(double safeAreaWidth, String item, void Function()? onTap) {
  return SliverToBoxAdapter(
    child: nButton(
      safeAreaWidth,
      margin: nSpacing(
        top: safeAreaWidth * 0.04,
        xSize: safeAreaWidth * 0.05,
      ),
      backGroundColor: Colors.white,
      boxShadow: nBoxShadow(shadow: 0.05),
      border: nBorder(
        color: Colors.black.withCustomOpacity(),
        width: 1.5,
      ),
      radius: 15,
      text: item,
      onTap: onTap,
    ),
  );
}
