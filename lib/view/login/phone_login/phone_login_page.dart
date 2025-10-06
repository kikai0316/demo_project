import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart' as lib;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/constant/country_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/app_utlity.dart';
import 'package:demo_project/utility/bottom_menu/bottom_select_text_utlity.dart';
import 'package:demo_project/utility/formatter_utility.dart';
import 'package:demo_project/utility/notistack/dialog_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/login/phone_login/phone_verification_page.dart';
import 'package:demo_project/widget/login/phone_login/phone_login_page_widget.dart';

const adminPhoneNumber = "10293847560";
const adminCode = "827549";
const adminUid = "u9876543210fedcba";
final _textController = TextEditingController();

class PhoneLoginPage extends HookConsumerWidget {
  const PhoneLoginPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ln = AppLocalizations.of(context)!;
    final country = useState<Map<String, String>>(getInitCountry(context));
    final isLoading = useState<bool>(false);

    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: mainBackgroundColor,
            body: SafeArea(
              child: Padding(
                padding: nSpacing(xSize: safeAreaWidth * 0.05),
                child: Column(
                  children: [
                    nText(
                      ln.pleaseTellMeYourPhoneNumber,
                      padding: nSpacing(top: constraints.maxHeight * 0.1),
                      fontSize: safeAreaWidth / 18,
                      color: blackColor,
                    ),
                    phoneNumberInputItem(
                      safeAreaWidth,
                      country: toCodeText(country.value),
                      textController: _textController,
                      onCountry: onCountry(context, constraints, country),
                      // onChanged: onChanged(
                      //   context,
                      //   country.value,
                      //   selectPhoneData,
                      //   isAdmin,
                      // ),
                    ),
                    privacyTextItem(
                      safeAreaWidth,
                      lang: ln.lang,
                      onTerms: onTerms(context),
                      onPrivacy: onPrivacyPolicy(context),
                    ),
                    const Spacer(),
                    indicatorButton(
                      safeAreaWidth,
                      isLoading: isLoading.value,
                      isValidData: true,
                      text: ln.sendVerificationCode,
                      onTap: onVerifyPhone(context, country.value, isLoading),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

//国変更のタップインベント
  VoidCallback? onCountry(
    BuildContext context,
    BoxConstraints constraints,
    ValueNotifier<Map<String, String>> country,
  ) {
    final countrys = sortedCountryDataList();
    final ln = AppLocalizations.of(context)!;
    final items = countrys.map((country) => toCodeText(country)).toList();
    return () async {
      final selectItem = await nShowbottomSelectTextSheet(
        context,
        constraints: constraints,
        items: items,
        title: ln.selectCountryCode,
        initValue: toCodeText(country.value),
      );
      final selectIndex = items.indexOf(selectItem ?? "");
      if (selectIndex == -1 || !context.mounted) return;
      country.value = countrys[selectIndex];
      _textController.clear();
    };
  }

  //認証コードの送信処理
  VoidCallback? onVerifyPhone(
    BuildContext context,
    Map<String, String> country,
    ValueNotifier<bool> isLoading,
  ) {
    final ln = AppLocalizations.of(context)!;
    return () async {
      try {
        if (_textController.text == adminPhoneNumber) {
          onAdminLogIn(context)?.call();
          return;
        }
        if (_textController.text.isEmpty) {
          _error(context, isLoading, ln.phoneNumberInvalid);
          return;
        }
        isLoading.value = true;
        final phoneData =
            await getPhoneData(context, _textController.text, country);
        await FirebaseAuth.instance.verifyPhoneNumber(
          timeout: const Duration(seconds: 90),
          phoneNumber: phoneData["e164"] as String?,
          verificationCompleted: (_) {},
          verificationFailed: (e) =>
              _error(context, isLoading, toPhoneErrorMessage(context, e)),
          codeSent: (String verificationId, int? resendToken) {
            isLoading.value = false;
            ScreenTransition(
              context,
              PhoneVerificationPage(
                selectPhoneData: phoneData,
                verificationId: verificationId,
                resendToken: resendToken,
                isAdminLogin: false,
              ),
            ).normal();
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (_) {
        if (context.mounted) _error(context, isLoading, ln.someErrorOccurred);
      }
    };
  }

  VoidCallback? onAdminLogIn(BuildContext context) {
    return () => ScreenTransition(
          context,
          const PhoneVerificationPage(
            selectPhoneData: {
              "country_code": "81",
              "national_number": adminPhoneNumber,
            },
            verificationId: "",
            resendToken: 0,
            isAdminLogin: true,
          ),
        ).normal();
  }

  Future<Map<String, dynamic>> getPhoneData(
    BuildContext context,
    String phoneNumber,
    Map<String, String> country,
  ) async {
    final dialCode = country["dial_code"];
    Map<String, dynamic> initData = {
      "international": "$dialCode $phoneNumber",
      "e164": "$dialCode$phoneNumber",
      "national_number": phoneNumber,
      "country_code": dialCode?.replaceAll('+', ''),
      "type": "mobile",
      "region_code": country["code"],
      "national": phoneNumber,
    };
    try {
      initData = await lib.parse(phoneNumber, region: country["code"]);
      if (!context.mounted) return initData;
      return initData;
    } catch (e) {
      return initData;
    }
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//Map<String, String>から国旗＋国際コードを組み合わせた文字列に変える
  String toCodeText(Map<String, String> country) =>
      "${country["emoji"]} ${country["dial_code"]}";

  //使用しているデバイスをもとに最初に取得した国を決定する
  Map<String, String> getInitCountry(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    final items = countryDataList;
    final countryCode = ln.dateLocaleName.split('_').last.toUpperCase();
    final index = items.indexWhere((item) => item["code"] == countryCode);
    return index != -1 ? items[index] : items.first;
  }

  //countryDataListのdial_codeの数字が小さい順に並び替え
  List<Map<String, String>> sortedCountryDataList() =>
      [...countryDataList]..sort((a, b) {
          final aDialCode = int.parse(a['dial_code']!.substring(1));
          final bDialCode = int.parse(b['dial_code']!.substring(1));
          return aDialCode.compareTo(bDialCode);
        });
}

// //処理終了のあとの処理
void _error(
  BuildContext context,
  ValueNotifier<bool> isLoading,
  String message,
) {
  isLoading.value = false;
  nErrorDialog(context, message);
}
