import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/button_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/constant/value_const.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/app_utlity.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/view_model/user_data.dart';

TextEditingController? textController;

class EditSnsPage extends HookConsumerWidget {
  const EditSnsPage({
    super.key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final user = ref.watch(userDataNotifierProvider).value;
    final isLoading = useState<bool>(false);

    useEffect(handleEffect(user), []);
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
                            nText(
                              _getDomain(),
                              padding: nSpacing(right: safeAreaWidth * 0.02),
                              fontSize: safeAreaWidth / 25,
                              color: Colors.black.withCustomOpacity(0.2),
                            ),
                            nTextFormField(
                              textController: textController,
                              fontSize: safeAreaWidth / 25,
                              textColor: blackColor,
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 100,
                              maxLines: 1,
                              hintText: ln.accountId,
                            ),
                          ],
                        ),
                      ),
                    ),
                    nIconButton(
                      onTap: onVerify(context),
                      margin: nSpacing(top: safeAreaWidth * 0.03),
                      iconImage: "black/share.png",
                      iconSize: safeAreaWidth / 13,
                      imageCustomColor: Colors.blueAccent,
                      withTextWidget: nText(
                        ln.verify,
                        fontSize: safeAreaWidth / 25,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const Spacer(),
                    nButton(
                      safeAreaWidth,
                      margin: nSpacing(bottom: safeAreaWidth * 0.01),
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
  Dispose? Function() handleEffect(UserType? user) {
    return () {
      textController = TextEditingController(text: _getInitValue(user));
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
      final value = textController?.text;
      final notifier = ref.read(userDataNotifierProvider.notifier);
      final body = ApiUserUpdateBodyType(
        id: user.id,
        instagramId: title == "Instagram" ? value : null,
        tiktokId: title == "TikTok" ? value : null,
        beRealId: title == "BeReal" ? value : null,
      );

      if (_getInitValue(user) == value || (value ?? "").isEmpty) return;
      isLoading.value = true;
      FocusScope.of(context).unfocus();
      final isUpDate = await notifier.upDateUserProfile(context, body);
      if (!context.mounted) return;
      isLoading.value = false;
      if (!isUpDate) nErrorDialog(context);
      Navigator.pop(context);
    };
  }

  VoidCallback onVerify(BuildContext context) {
    return () {
      final ln = AppLocalizations.of(context)!;
      final value = textController?.text;
      if ((value ?? "").isEmpty) {
        nErrorDialog(context, ln.accountIdRequired);
        return;
      }
      nOpneUrl("${_getUrl()}$value");
    };
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  String? _getInitValue(UserType? user) {
    final sns = ["Instagram", "TikTok", "BeReal"];
    final values = [user?.instagramId, user?.tiktokId, user?.beRealId];
    for (int i = 0; i < 3; i++) {
      if (sns[i] == title) return values[i];
    }
    return null;
  }

  String _getDomain() {
    final sns = ["Instagram", "TikTok", "BeReal"];
    final domains = ["instagram.com/", "tiktok.com/@", "bere.al/"];
    for (int i = 0; i < 3; i++) {
      if (sns[i] == title) return domains[i];
    }
    return "";
  }

  String _getUrl() {
    final sns = ["Instagram", "TikTok", "BeReal"];
    for (int i = 0; i < 3; i++) {
      if (sns[i] == title) return snsUrls[i];
    }
    return "";
  }
}
