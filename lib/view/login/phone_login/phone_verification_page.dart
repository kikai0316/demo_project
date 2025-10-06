import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/topbar_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/formatter_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/login/init_setting/birthday_setting_page.dart';
import 'package:demo_project/view/login/phone_login/phone_login_page.dart';
import 'package:demo_project/view_model/user_data.dart';
import 'package:demo_project/widget/login/phone_login/phone_verification_page_widget.dart';

late TextEditingController _textController;

class PhoneVerificationPage extends HookConsumerWidget {
  const PhoneVerificationPage({
    super.key,
    required this.verificationId,
    required this.resendToken,
    required this.selectPhoneData,
    required this.isAdminLogin,
  });
  final Map<String, dynamic> selectPhoneData;
  final String verificationId;
  final int? resendToken;
  final bool isAdminLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;

    final isError = useState<bool>(false);
    final isLoading = useState<bool>(false);
    final isResending = useState<bool>(false);
    final verId = useState<String>(verificationId);
    final reToken = useState<int?>(resendToken);

    useEffect(handleEffect(), []);

    return LayoutBuilder(
      builder: (context, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return Stack(
          children: [
            PopScope(
              canPop: false,
              child: Scaffold(
                backgroundColor: mainBackgroundColor,
                appBar: nAppBar(context, safeAreaWidth),
                body: SafeArea(
                  top: false,
                  child: Padding(
                    padding: nSpacing(xSize: safeAreaWidth * 0.05),
                    child: Column(
                      children: [
                        nText(
                          ln.enterVerificationCode,
                          padding: nSpacing(top: constraints.maxHeight * 0.03),
                          fontSize: safeAreaWidth / 18,
                          isFit: true,
                          color: blackColor,
                        ),
                        codeSentWidget(
                          context,
                          safeAreaWidth,
                          selectPhoneData,
                          isAdminLogin,
                        ),
                        verifyInputItem(
                          safeAreaWidth,
                          textColor: isError.value ? Colors.red : blackColor,
                          textController: _textController,
                          onChanged: onChanged(
                            context,
                            ref,
                            isAdminLogin,
                            isError,
                            verId,
                            isLoading,
                          ),
                        ),
                        if (!isAdminLogin)
                          resendCodeWidget(
                            context,
                            safeAreaWidth,
                            isLoading: isResending.value,
                            onTap: onVerifyPhone(
                              context,
                              verId,
                              reToken,
                              isResending,
                              isError,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            loadinPage(safeAreaWidth, isLoading: isLoading.value),
          ],
        );
      },
    );
  }

  //useEfect
  Dispose? Function() handleEffect() {
    return () {
      _textController = TextEditingController();
      return null;
    };
  }

  //認証コードの検証
  Future<void> certification(
    BuildContext context,
    WidgetRef ref,
    String smsCode,
    ValueNotifier<bool> isError,
    ValueNotifier<String> verId,
    ValueNotifier<bool> isLoading,
  ) async {
    final ln = AppLocalizations.of(context)!;
    try {
      final id = verId.value;
      final credential =
          PhoneAuthProvider.credential(verificationId: id, smsCode: smsCode);
      FocusScope.of(context).unfocus();
      isLoading.value = true;
      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      final uid = user.user!.uid;
      final notifier = ref.read(userDataNotifierProvider.notifier);
      final userData = await notifier.signAccount(uid, selectPhoneData);
      if (!context.mounted) return;
      if (userData != null) {
        final page = await initializeRoute(userData);
        if (context.mounted) ScreenTransition(context, page).normal();
        return;
      }
      isLoading.value = false;
      nErrorDialog(context, ln.someErrorOccurred);
      isError.value = true;
    } catch (_) {
      if (!context.mounted) return;
      HapticFeedback.vibrate();
      isError.value = true;
      _error(context, isLoading, ln.incorrectCode);
    }
  }

  //認証コードの再送信処理
  VoidCallback onVerifyPhone(
    BuildContext context,
    ValueNotifier<String> verId,
    ValueNotifier<int?> reToken,
    ValueNotifier<bool> isLoading,
    ValueNotifier<bool> isError,
  ) {
    final ln = AppLocalizations.of(context)!;
    return () async {
      try {
        isLoading.value = true;
        await FirebaseAuth.instance.verifyPhoneNumber(
          timeout: const Duration(seconds: 90),
          forceResendingToken: reToken.value,
          phoneNumber: selectPhoneData["e164"] as String?,
          verificationCompleted: (_) {},
          verificationFailed: (e) =>
              _error(context, isLoading, toPhoneErrorMessage(context, e)),
          codeSent: (String verificationId, int? resendToken) {
            if (!context.mounted) return;
            verId.value = verificationId;
            reToken.value = resendToken;
            _textController.clear();
            nDialog(
              context,
              title: ln.verificationCodeResent,
              cancelText: "OK",
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
        if (isError.value) isError.value = false;
      } catch (e) {
        if (context.mounted) _error(context, isLoading, ln.someErrorOccurred);
      }
    };
  }

  //アドミンのログイン処理
  Future<void> adminCertification(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) async {
    final ln = AppLocalizations.of(context)!;
    try {
      FocusScope.of(context).unfocus();
      isLoading.value = true;
      final notifier = ref.read(userDataNotifierProvider.notifier);
      final userData = await notifier.signAccount(adminUid, selectPhoneData);
      if (!context.mounted) return;
      if (userData != null) {
        ScreenTransition(context, const BirthdayPage()).normal();
        return;
      }
      isLoading.value = false;
      nErrorDialog(context, ln.someErrorOccurred);
    } catch (_) {
      if (!context.mounted) return;
      HapticFeedback.vibrate();
      _error(context, isLoading, ln.incorrectCode);
    }
  }

  void Function(String)? onChanged(
    BuildContext context,
    WidgetRef ref,
    bool isAdminLogin,
    ValueNotifier<bool> isError,
    ValueNotifier<String> verId,
    ValueNotifier<bool> isLoading,
  ) {
    return !isAdminLogin
        ? (value) {
            if (isError.value) isError.value = false;
            if (value.length != 6) return;
            certification(context, ref, value, isError, verId, isLoading);
          }
        : (value) {
            if (value == adminCode) adminCertification(context, ref, isError);
          };
  }
}

//処理終了のあとの処理
void _error(
  BuildContext context,
  ValueNotifier<bool> isLoading,
  String message,
) {
  isLoading.value = false;
  nErrorDialog(context, message);
}
