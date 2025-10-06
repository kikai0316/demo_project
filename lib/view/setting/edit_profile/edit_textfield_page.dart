import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/view_model/user_data.dart';

TextEditingController? textController;

class EditTextFieldPage extends HookConsumerWidget {
  const EditTextFieldPage({
    super.key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final user = ref.watch(userDataNotifierProvider).value;
    final isBio = title == ln.aboutMe;
    final isLoading = useState<bool>(false);

    useEffect(handleEffect(isBio ? user?.bio : user?.userName), []);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return Stack(
          children: [
            Scaffold(
              appBar: nAppBar(context, safeAreaWidth, title: title),
              backgroundColor: mainBackgroundColor,
              body: SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: nContainer(
                        margin: nSpacing(top: safeAreaWidth * 0.05),
                        color: Colors.white,
                        radius: 15,
                        width: safeAreaWidth * 0.9,
                        padding: nSpacing(
                          ySize: safeAreaWidth * 0.01,
                          xSize: safeAreaWidth * 0.03,
                        ),
                        boxShadow: nBoxShadow(shadow: 0.05),
                        child: Row(
                          children: [
                            nTextFormField(
                              textController: textController,
                              fontSize: safeAreaWidth / (isBio ? 23 : 18),
                              textColor: blackColor,
                              maxLength: 50,
                              maxLines: isBio ? 7 : 1,
                              textAlign:
                                  isBio ? TextAlign.start : TextAlign.center,
                              height: isBio ? 1.5 : 1,
                              hintText: isBio ? ln.bioHintText : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    nButton(
                      safeAreaWidth,
                      margin: nSpacing(bottom: safeAreaWidth * 0.03),
                      backGroundColor: Colors.blueAccent,
                      width: safeAreaWidth * 0.9,
                      radius: 15,
                      text: ln.save,
                      textColor: Colors.white,
                      onTap: onSave(context, ref, isLoading),
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
  Dispose? Function() handleEffect(String? initValue) {
    return () {
      textController = TextEditingController(text: initValue);
      return null;
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

  VoidCallback onSave(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) {
    final user = ref.watch(userDataNotifierProvider).value;
    if (user == null) return () => Navigator.pop(context);
    return () async {
      final ln = AppLocalizations.of(context)!;
      final isBio = title == ln.aboutMe;
      final initValue = isBio ? user.bio : user.userName;
      final value = textController?.text;
      final notifier = ref.read(userDataNotifierProvider.notifier);
      final body = ApiUserUpdateBodyType(
        id: user.id,
        userName: !isBio ? value : null,
        bio: isBio ? value : null,
      );
      if (initValue == value || (value ?? "").isEmpty) return;
      isLoading.value = true;
      FocusScope.of(context).unfocus();
      final isUpDate = await notifier.upDateUserProfile(context, body);
      if (!context.mounted) return;
      isLoading.value = false;
      if (!isUpDate) nErrorDialog(context);
      Navigator.pop(context);
    };
  }
}
