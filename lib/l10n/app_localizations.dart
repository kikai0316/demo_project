import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @lang.
  ///
  /// In ja, this message translates to:
  /// **'jp'**
  String get lang;

  /// No description provided for @dateLocaleName.
  ///
  /// In ja, this message translates to:
  /// **'ja_JP'**
  String get dateLocaleName;

  /// No description provided for @notSpecified.
  ///
  /// In ja, this message translates to:
  /// **'設定しない'**
  String get notSpecified;

  /// No description provided for @enfjLabel.
  ///
  /// In ja, this message translates to:
  /// **'主人公'**
  String get enfjLabel;

  /// No description provided for @enfpLabel.
  ///
  /// In ja, this message translates to:
  /// **'広報運動家'**
  String get enfpLabel;

  /// No description provided for @entjLabel.
  ///
  /// In ja, this message translates to:
  /// **'指揮官'**
  String get entjLabel;

  /// No description provided for @entpLabel.
  ///
  /// In ja, this message translates to:
  /// **'討論者'**
  String get entpLabel;

  /// No description provided for @esfjLabel.
  ///
  /// In ja, this message translates to:
  /// **'領事官'**
  String get esfjLabel;

  /// No description provided for @esfpLabel.
  ///
  /// In ja, this message translates to:
  /// **'エンターテイナー'**
  String get esfpLabel;

  /// No description provided for @estjLabel.
  ///
  /// In ja, this message translates to:
  /// **'幹部'**
  String get estjLabel;

  /// No description provided for @estpLabel.
  ///
  /// In ja, this message translates to:
  /// **'起業家'**
  String get estpLabel;

  /// No description provided for @infjLabel.
  ///
  /// In ja, this message translates to:
  /// **'提唱者'**
  String get infjLabel;

  /// No description provided for @infpLabel.
  ///
  /// In ja, this message translates to:
  /// **'仲介者'**
  String get infpLabel;

  /// No description provided for @intjLabel.
  ///
  /// In ja, this message translates to:
  /// **'建築家'**
  String get intjLabel;

  /// No description provided for @intpLabel.
  ///
  /// In ja, this message translates to:
  /// **'論理学者'**
  String get intpLabel;

  /// No description provided for @isfjLabel.
  ///
  /// In ja, this message translates to:
  /// **'擁護者'**
  String get isfjLabel;

  /// No description provided for @isfpLabel.
  ///
  /// In ja, this message translates to:
  /// **'冒険家'**
  String get isfpLabel;

  /// No description provided for @istjLabel.
  ///
  /// In ja, this message translates to:
  /// **'管理者'**
  String get istjLabel;

  /// No description provided for @istpLabel.
  ///
  /// In ja, this message translates to:
  /// **'巨匠'**
  String get istpLabel;

  /// No description provided for @holidayOptionWeekend.
  ///
  /// In ja, this message translates to:
  /// **'土日'**
  String get holidayOptionWeekend;

  /// No description provided for @holidayOptionWeekdays.
  ///
  /// In ja, this message translates to:
  /// **'平日'**
  String get holidayOptionWeekdays;

  /// No description provided for @holidayOptionFlexible.
  ///
  /// In ja, this message translates to:
  /// **'不定期'**
  String get holidayOptionFlexible;

  /// No description provided for @holidayOptionOther.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get holidayOptionOther;

  /// No description provided for @exerciseOptionOften.
  ///
  /// In ja, this message translates to:
  /// **'よくする'**
  String get exerciseOptionOften;

  /// No description provided for @exerciseOptionSometimes.
  ///
  /// In ja, this message translates to:
  /// **'ときどきする'**
  String get exerciseOptionSometimes;

  /// No description provided for @exerciseOptionRarely.
  ///
  /// In ja, this message translates to:
  /// **'あまりしない'**
  String get exerciseOptionRarely;

  /// No description provided for @exerciseOptionNever.
  ///
  /// In ja, this message translates to:
  /// **'全くしない'**
  String get exerciseOptionNever;

  /// No description provided for @alcoholOptionOften.
  ///
  /// In ja, this message translates to:
  /// **'よく飲む'**
  String get alcoholOptionOften;

  /// No description provided for @alcoholOptionSometimes.
  ///
  /// In ja, this message translates to:
  /// **'時々飲む'**
  String get alcoholOptionSometimes;

  /// No description provided for @alcoholOptionRarely.
  ///
  /// In ja, this message translates to:
  /// **'あまり飲まない'**
  String get alcoholOptionRarely;

  /// No description provided for @alcoholOptionNever.
  ///
  /// In ja, this message translates to:
  /// **'全く飲まない'**
  String get alcoholOptionNever;

  /// No description provided for @smokingOptionOften.
  ///
  /// In ja, this message translates to:
  /// **'吸う'**
  String get smokingOptionOften;

  /// No description provided for @smokingOptionHeatedTobacco.
  ///
  /// In ja, this message translates to:
  /// **'吸う（電子タバコ）'**
  String get smokingOptionHeatedTobacco;

  /// No description provided for @smokingOptionSometimes.
  ///
  /// In ja, this message translates to:
  /// **'ときどき吸う'**
  String get smokingOptionSometimes;

  /// No description provided for @smokingOptionIfDislikedStop.
  ///
  /// In ja, this message translates to:
  /// **'相手が嫌なら吸わない'**
  String get smokingOptionIfDislikedStop;

  /// No description provided for @smokingOptionNever.
  ///
  /// In ja, this message translates to:
  /// **'吸わない'**
  String get smokingOptionNever;

  /// No description provided for @heightUnit.
  ///
  /// In ja, this message translates to:
  /// **'cm'**
  String get heightUnit;

  /// No description provided for @settings.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settings;

  /// No description provided for @information.
  ///
  /// In ja, this message translates to:
  /// **'情報'**
  String get information;

  /// No description provided for @privacy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシー'**
  String get privacy;

  /// No description provided for @language.
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get language;

  /// No description provided for @otherSettings.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get otherSettings;

  /// No description provided for @rateSUP.
  ///
  /// In ja, this message translates to:
  /// **'OOOを評価'**
  String get rateSUP;

  /// No description provided for @help.
  ///
  /// In ja, this message translates to:
  /// **'ヘルプ'**
  String get help;

  /// No description provided for @basicInformation.
  ///
  /// In ja, this message translates to:
  /// **'基本情報'**
  String get basicInformation;

  /// No description provided for @logout.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール編集'**
  String get editProfile;

  /// No description provided for @preview.
  ///
  /// In ja, this message translates to:
  /// **'プレビュー'**
  String get preview;

  /// No description provided for @facePhoto.
  ///
  /// In ja, this message translates to:
  /// **'顔写真'**
  String get facePhoto;

  /// No description provided for @other.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get other;

  /// No description provided for @name.
  ///
  /// In ja, this message translates to:
  /// **'名前'**
  String get name;

  /// No description provided for @aboutMe.
  ///
  /// In ja, this message translates to:
  /// **'自己紹介'**
  String get aboutMe;

  /// No description provided for @height.
  ///
  /// In ja, this message translates to:
  /// **'身長'**
  String get height;

  /// No description provided for @mbti.
  ///
  /// In ja, this message translates to:
  /// **'MBTI'**
  String get mbti;

  /// No description provided for @holiday.
  ///
  /// In ja, this message translates to:
  /// **'休日'**
  String get holiday;

  /// No description provided for @exercise.
  ///
  /// In ja, this message translates to:
  /// **'運動'**
  String get exercise;

  /// No description provided for @alcohol.
  ///
  /// In ja, this message translates to:
  /// **'お酒'**
  String get alcohol;

  /// No description provided for @smoking.
  ///
  /// In ja, this message translates to:
  /// **'タバコ'**
  String get smoking;

  /// No description provided for @notSet.
  ///
  /// In ja, this message translates to:
  /// **'未設定'**
  String get notSet;

  /// No description provided for @updateFailed.
  ///
  /// In ja, this message translates to:
  /// **'更新に失敗しました。\n再試行してください。'**
  String get updateFailed;

  /// No description provided for @noPermission.
  ///
  /// In ja, this message translates to:
  /// **'アクセス権限がありません。'**
  String get noPermission;

  /// No description provided for @someErrorOccurred.
  ///
  /// In ja, this message translates to:
  /// **'何らかのエラーが発生しました。'**
  String get someErrorOccurred;

  /// No description provided for @openSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定を開く'**
  String get openSettings;

  /// No description provided for @save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In ja, this message translates to:
  /// **'編集'**
  String get edit;

  /// No description provided for @editReorder.
  ///
  /// In ja, this message translates to:
  /// **'編集・並び替え'**
  String get editReorder;

  /// No description provided for @done.
  ///
  /// In ja, this message translates to:
  /// **'完了'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @pleaseName.
  ///
  /// In ja, this message translates to:
  /// **'名前を入力...'**
  String get pleaseName;

  /// No description provided for @blockedUsers.
  ///
  /// In ja, this message translates to:
  /// **'ブロックしたユーザー'**
  String get blockedUsers;

  /// No description provided for @closeFriends.
  ///
  /// In ja, this message translates to:
  /// **'近しい人の表示制限'**
  String get closeFriends;

  /// No description provided for @blockedUserDescription.
  ///
  /// In ja, this message translates to:
  /// **'ブロックしたユーザーから、あなたへのメッセージは届かなくなります。この設定について相手に通知されることはありません。'**
  String get blockedUserDescription;

  /// No description provided for @closeFriendsDescription.
  ///
  /// In ja, this message translates to:
  /// **'近しい人に設定した相手には、あなたのプロフィールは表示されません。この設定が相手に知られることはありません。'**
  String get closeFriendsDescription;

  /// No description provided for @deleteAccount.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを削除する'**
  String get deleteAccount;

  /// No description provided for @bugs.
  ///
  /// In ja, this message translates to:
  /// **'バグが多い'**
  String get bugs;

  /// No description provided for @fewFriends.
  ///
  /// In ja, this message translates to:
  /// **'ユーザーが少ない'**
  String get fewFriends;

  /// No description provided for @rarelyUsed.
  ///
  /// In ja, this message translates to:
  /// **'OOOをあまり使わない'**
  String get rarelyUsed;

  /// No description provided for @unclearUsage.
  ///
  /// In ja, this message translates to:
  /// **'OOOの使い方がよくわからない'**
  String get unclearUsage;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In ja, this message translates to:
  /// **'本当にアカウントを削除しますか？'**
  String get deleteAccountConfirmation;

  /// No description provided for @deletionNotice.
  ///
  /// In ja, this message translates to:
  /// **'アカウントと全データは直ちに削除され、\n後から復元することはできません。'**
  String get deletionNotice;

  /// No description provided for @unsubscribeReasonPrompt.
  ///
  /// In ja, this message translates to:
  /// **'アプリの解約理由を教えてください。'**
  String get unsubscribeReasonPrompt;

  /// No description provided for @reconsider.
  ///
  /// In ja, this message translates to:
  /// **'考え直します'**
  String get reconsider;

  /// No description provided for @confirmDeletion.
  ///
  /// In ja, this message translates to:
  /// **'はい、削除します'**
  String get confirmDeletion;

  /// No description provided for @faq.
  ///
  /// In ja, this message translates to:
  /// **'よくある質問'**
  String get faq;

  /// No description provided for @contactUs.
  ///
  /// In ja, this message translates to:
  /// **'お問い合わせ'**
  String get contactUs;

  /// No description provided for @reportProblem.
  ///
  /// In ja, this message translates to:
  /// **'問題を報告'**
  String get reportProblem;

  /// No description provided for @contactUrl.
  ///
  /// In ja, this message translates to:
  /// **'https://docs.google.com/forms/d/e/1FAIpQLScoBWWLp6HAjB8R4lSuhvbHQinmODuAXFIhgvNeoxG_oNO5Zg/viewform?usp=header'**
  String get contactUrl;

  /// No description provided for @problemUrl.
  ///
  /// In ja, this message translates to:
  /// **'https://docs.google.com/forms/d/e/1FAIpQLSd7Yuq5w5pxyZu8LOhmRlHCbQkeqcXhcmHfxwUuFQ_a3WulHA/viewform?usp=header'**
  String get problemUrl;

  /// No description provided for @privacyUrl.
  ///
  /// In ja, this message translates to:
  /// **'https://political-meadow-0b2.notion.site/252d4001d7568184a2bdcc8748a92180'**
  String get privacyUrl;

  /// No description provided for @termsUrl.
  ///
  /// In ja, this message translates to:
  /// **'https://political-meadow-0b2.notion.site/252d4001d75681599b1be36868085a5f?pvs=73'**
  String get termsUrl;

  /// No description provided for @termsOfService.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacyPolicy;

  /// No description provided for @confirmLogout.
  ///
  /// In ja, this message translates to:
  /// **'本当にログアウトしますか？'**
  String get confirmLogout;

  /// No description provided for @errorDatabaseConnection.
  ///
  /// In ja, this message translates to:
  /// **'データベースに接続できませんでした。\nしばらくしてから再度お試しください。'**
  String get errorDatabaseConnection;

  /// No description provided for @errorUnexpected.
  ///
  /// In ja, this message translates to:
  /// **'何かしらの問題が発生しました\nしばらくしてから再度お試しください。'**
  String get errorUnexpected;

  /// No description provided for @callingUser.
  ///
  /// In ja, this message translates to:
  /// **'@さんを呼び出しています...'**
  String get callingUser;

  /// No description provided for @typing.
  ///
  /// In ja, this message translates to:
  /// **'入力中...'**
  String get typing;

  /// No description provided for @error.
  ///
  /// In ja, this message translates to:
  /// **'エラー'**
  String get error;

  /// No description provided for @messageSendFailed.
  ///
  /// In ja, this message translates to:
  /// **'メッセージの送信に失敗しました。'**
  String get messageSendFailed;

  /// No description provided for @noMoreUsers.
  ///
  /// In ja, this message translates to:
  /// **'これ以上のユーザーはいないようです。\nまた後ほどお試しください。'**
  String get noMoreUsers;

  /// No description provided for @retry.
  ///
  /// In ja, this message translates to:
  /// **'再取得'**
  String get retry;

  /// No description provided for @chatInvitation.
  ///
  /// In ja, this message translates to:
  /// **'初回呼び出しの有効期限は残り24時間です。\n今すぐ相手を呼び出して、会話を始めてみよう！'**
  String get chatInvitation;

  /// No description provided for @premium.
  ///
  /// In ja, this message translates to:
  /// **'プレミアム'**
  String get premium;

  /// No description provided for @notTalkTitl.
  ///
  /// In ja, this message translates to:
  /// **'まだ話したことがない相手'**
  String get notTalkTitl;

  /// No description provided for @yesterday.
  ///
  /// In ja, this message translates to:
  /// **'昨日'**
  String get yesterday;

  /// No description provided for @noResponse.
  ///
  /// In ja, this message translates to:
  /// **'応答しませんでした'**
  String get noResponse;

  /// No description provided for @missedInvitation.
  ///
  /// In ja, this message translates to:
  /// **'不在着信'**
  String get missedInvitation;

  /// No description provided for @invitationCanceled.
  ///
  /// In ja, this message translates to:
  /// **'キャンセルしました'**
  String get invitationCanceled;

  /// No description provided for @bioHintText.
  ///
  /// In ja, this message translates to:
  /// **'はじめまして！ちょっとしたきっかけで始めてみました！\n映画を観たりカフェでまったりするのが好きです。\n話しやすい人と出会えたら嬉しいです！よろしくお願いします！'**
  String get bioHintText;

  /// No description provided for @blockedAt.
  ///
  /// In ja, this message translates to:
  /// **'@にブロックしました。'**
  String get blockedAt;

  /// No description provided for @noBlockedUsers.
  ///
  /// In ja, this message translates to:
  /// **'ブロックしているユーザーはいません。'**
  String get noBlockedUsers;

  /// No description provided for @confirmUnblock.
  ///
  /// In ja, this message translates to:
  /// **'本当にブロックを解除しますか？'**
  String get confirmUnblock;

  /// No description provided for @unblockAction.
  ///
  /// In ja, this message translates to:
  /// **'ブロックを解除'**
  String get unblockAction;

  /// No description provided for @block.
  ///
  /// In ja, this message translates to:
  /// **'ブロック'**
  String get block;

  /// No description provided for @errorLoadData.
  ///
  /// In ja, this message translates to:
  /// **'データの読み込みに失敗しました。'**
  String get errorLoadData;

  /// No description provided for @whoLikesYou.
  ///
  /// In ja, this message translates to:
  /// **'あなたをLikeした人'**
  String get whoLikesYou;

  /// No description provided for @recentChats.
  ///
  /// In ja, this message translates to:
  /// **'最近のチャット'**
  String get recentChats;

  /// No description provided for @pleaseTellMeYourPhoneNumber.
  ///
  /// In ja, this message translates to:
  /// **'電話番号を教えてください。'**
  String get pleaseTellMeYourPhoneNumber;

  /// No description provided for @done2.
  ///
  /// In ja, this message translates to:
  /// **'決定'**
  String get done2;

  /// No description provided for @selectCountryCode.
  ///
  /// In ja, this message translates to:
  /// **'国コードを選択'**
  String get selectCountryCode;

  /// No description provided for @sendVerificationCode.
  ///
  /// In ja, this message translates to:
  /// **'認証コードを送信'**
  String get sendVerificationCode;

  /// No description provided for @phoneNumberInvalid.
  ///
  /// In ja, this message translates to:
  /// **'電話番号が正しくありません。'**
  String get phoneNumberInvalid;

  /// No description provided for @tooManyRequests.
  ///
  /// In ja, this message translates to:
  /// **'リクエストが多すぎます。\nしばらくしてから再試行してください。'**
  String get tooManyRequests;

  /// No description provided for @networkRequestFailed.
  ///
  /// In ja, this message translates to:
  /// **'ネットワークエラーが発生しました。\n接続を確認してください。'**
  String get networkRequestFailed;

  /// No description provided for @sessionExpired.
  ///
  /// In ja, this message translates to:
  /// **'セッションの有効期限が切れました。\nもう一度認証を行ってください。'**
  String get sessionExpired;

  /// No description provided for @invalidVerificationCode.
  ///
  /// In ja, this message translates to:
  /// **'確認コードが間違っています。\nもう一度確認して入力してください。'**
  String get invalidVerificationCode;

  /// No description provided for @invalidVerificationId.
  ///
  /// In ja, this message translates to:
  /// **'無効な認証IDです。\n最初から認証をやり直してください。'**
  String get invalidVerificationId;

  /// No description provided for @enterVerificationCode.
  ///
  /// In ja, this message translates to:
  /// **'認証コードを入力してください。'**
  String get enterVerificationCode;

  /// No description provided for @codeSentTo.
  ///
  /// In ja, this message translates to:
  /// **'@ に送信されました'**
  String get codeSentTo;

  /// No description provided for @resendCode.
  ///
  /// In ja, this message translates to:
  /// **'新しい認証コードを送信'**
  String get resendCode;

  /// No description provided for @incorrectCode.
  ///
  /// In ja, this message translates to:
  /// **'コードが正しくありません。もう一度お試しください。'**
  String get incorrectCode;

  /// No description provided for @verificationCodeResent.
  ///
  /// In ja, this message translates to:
  /// **'認証コードが送信されました'**
  String get verificationCodeResent;

  /// No description provided for @pleaseUserName.
  ///
  /// In ja, this message translates to:
  /// **'あなたの名前は何ですか？'**
  String get pleaseUserName;

  /// No description provided for @userNameExplanation.
  ///
  /// In ja, this message translates to:
  /// **'これは、友達に表示されます。'**
  String get userNameExplanation;

  /// No description provided for @pleaseProfilePic.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール写真を追加しよう！'**
  String get pleaseProfilePic;

  /// No description provided for @profilePicGuidelines.
  ///
  /// In ja, this message translates to:
  /// **'適当な写真は避けてください。\n最大5枚までアップロードできます。'**
  String get profilePicGuidelines;

  /// No description provided for @pleaseBirth.
  ///
  /// In ja, this message translates to:
  /// **'何歳ですか？'**
  String get pleaseBirth;

  /// No description provided for @createProfile.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール作成'**
  String get createProfile;

  /// No description provided for @ageRestriction.
  ///
  /// In ja, this message translates to:
  /// **'利用規約により13歳以上でなければ利用できません。'**
  String get ageRestriction;

  /// No description provided for @emptyUserName.
  ///
  /// In ja, this message translates to:
  /// **'名前を入力してください'**
  String get emptyUserName;

  /// No description provided for @setProfilePicture.
  ///
  /// In ja, this message translates to:
  /// **'設定完了'**
  String get setProfilePicture;

  /// No description provided for @choosePicture.
  ///
  /// In ja, this message translates to:
  /// **'写真を選択'**
  String get choosePicture;

  /// No description provided for @reselectPicture.
  ///
  /// In ja, this message translates to:
  /// **'別の写真を選ぶ'**
  String get reselectPicture;

  /// No description provided for @permissionNotificationsTitle.
  ///
  /// In ja, this message translates to:
  /// **'通知を許可する'**
  String get permissionNotificationsTitle;

  /// No description provided for @permissionNotificationsExplanation.
  ///
  /// In ja, this message translates to:
  /// **'いいねやチャットの招待を見逃さないように、通知をオンにしましょう！'**
  String get permissionNotificationsExplanation;

  /// No description provided for @permissionLocationTitle.
  ///
  /// In ja, this message translates to:
  /// **'位置情報を許可する'**
  String get permissionLocationTitle;

  /// No description provided for @permissionLocationExplanation.
  ///
  /// In ja, this message translates to:
  /// **'新しい友達と出会うためには、位置情報の許可が必要です。'**
  String get permissionLocationExplanation;

  /// No description provided for @permissionLocationDeniedTitle.
  ///
  /// In ja, this message translates to:
  /// **'位置情報が許可されていません'**
  String get permissionLocationDeniedTitle;

  /// No description provided for @permissionLocationDeniedMessage.
  ///
  /// In ja, this message translates to:
  /// **'設定を開いて、位置情報を許可してください'**
  String get permissionLocationDeniedMessage;

  /// No description provided for @noMessages.
  ///
  /// In ja, this message translates to:
  /// **'まだメッセージはありません'**
  String get noMessages;

  /// No description provided for @proUnlockLimits.
  ///
  /// In ja, this message translates to:
  /// **'PROで制限解除'**
  String get proUnlockLimits;

  /// No description provided for @upgradeUnlockAllLimits.
  ///
  /// In ja, this message translates to:
  /// **'アップグレードして、すべての制限を解放！'**
  String get upgradeUnlockAllLimits;

  /// No description provided for @unlimitedChatTime.
  ///
  /// In ja, this message translates to:
  /// **'時間無制限チャット'**
  String get unlimitedChatTime;

  /// No description provided for @unlimitedChatTimeText.
  ///
  /// In ja, this message translates to:
  /// **'時間を気にせず、好きなだけチャット'**
  String get unlimitedChatTimeText;

  /// No description provided for @unlimitedSwipes.
  ///
  /// In ja, this message translates to:
  /// **'スワイプし放題'**
  String get unlimitedSwipes;

  /// No description provided for @unlimitedSwipesText.
  ///
  /// In ja, this message translates to:
  /// **'1日に何回でもスワイプ可能!'**
  String get unlimitedSwipesText;

  /// No description provided for @seeWhoLikedYou.
  ///
  /// In ja, this message translates to:
  /// **'LIKEした人を確認'**
  String get seeWhoLikedYou;

  /// No description provided for @seeWhoLikedYouText.
  ///
  /// In ja, this message translates to:
  /// **'あなたにLikeした全員をチェック可能!'**
  String get seeWhoLikedYouText;

  /// No description provided for @months.
  ///
  /// In ja, this message translates to:
  /// **'ヶ月'**
  String get months;

  /// No description provided for @week.
  ///
  /// In ja, this message translates to:
  /// **'週'**
  String get week;

  /// No description provided for @month.
  ///
  /// In ja, this message translates to:
  /// **'月'**
  String get month;

  /// No description provided for @saveAbout.
  ///
  /// In ja, this message translates to:
  /// **'約@%お得'**
  String get saveAbout;

  /// No description provided for @aboutPaidServiceTitle.
  ///
  /// In ja, this message translates to:
  /// **'有料サービスについて'**
  String get aboutPaidServiceTitle;

  /// No description provided for @aboutPaidServiceDesc1.
  ///
  /// In ja, this message translates to:
  /// **'申し込み日を起点として、12ヶ月後（12ヶ月プラン）、3ヶ月後（3ヶ月プラン）、および1ヶ月後（1ヶ月プラン）に自動更新されます。'**
  String get aboutPaidServiceDesc1;

  /// No description provided for @aboutPaidServiceDesc2.
  ///
  /// In ja, this message translates to:
  /// **'次回の更新日は会員ステータスページで確認できます。'**
  String get aboutPaidServiceDesc2;

  /// No description provided for @aboutPaidServiceDesc3.
  ///
  /// In ja, this message translates to:
  /// **'自動継続課金は、現在のサブスクリプション期間終了から24時間以内に自動で行われます。'**
  String get aboutPaidServiceDesc3;

  /// No description provided for @aboutPaidServiceDesc4.
  ///
  /// In ja, this message translates to:
  /// **'自動更新の停止（定期購入の解約、サブスクリプションの解約）は、利用期間終了の24時間前までに手続きを行ってください。行わない場合、自動的に更新されます。'**
  String get aboutPaidServiceDesc4;

  /// No description provided for @aboutPaidServiceDesc5.
  ///
  /// In ja, this message translates to:
  /// **'Apple IDによる定期購入は、当アプリの会員状態と連動していません。そのため、当アプリからの退会やアプリのアンインストールだけでは購読は自動でキャンセルされません。'**
  String get aboutPaidServiceDesc5;

  /// No description provided for @aboutPaidServiceDesc6.
  ///
  /// In ja, this message translates to:
  /// **'自動継続課金の解約手続き後、次回更新日を過ぎると無料会員へ移行します（更新日までは有料会員特典を継続利用可能）。'**
  String get aboutPaidServiceDesc6;

  /// No description provided for @importantNotesTitle.
  ///
  /// In ja, this message translates to:
  /// **'注意事項（必ずお読みください）'**
  String get importantNotesTitle;

  /// No description provided for @importantNotesDesc1.
  ///
  /// In ja, this message translates to:
  /// **'購入手続き完了後のお客様都合によるキャンセル（中途退会を含む）はできません。'**
  String get importantNotesDesc1;

  /// No description provided for @importantNotesDesc2.
  ///
  /// In ja, this message translates to:
  /// **'お客様が解約手続きを行わない限り、購入したサブスクリプションサービスは各期間の終了時に自動更新され、その都度料金が請求されます。'**
  String get importantNotesDesc2;

  /// No description provided for @importantNotesDesc3.
  ///
  /// In ja, this message translates to:
  /// **'解約手続きをしない限り、購読サービスは各期間終了時に自動更新され、その都度料金が発生します。'**
  String get importantNotesDesc3;

  /// No description provided for @importantNotesDesc4.
  ///
  /// In ja, this message translates to:
  /// **'Apple IDによる定期購入はAppleが管理しているため、当アプリ上でキャンセルはできません。キャンセル方法は以下のAppleのサポートページをご確認ください。'**
  String get importantNotesDesc4;

  /// No description provided for @restorePurchaseTitle.
  ///
  /// In ja, this message translates to:
  /// **'購入を復元する'**
  String get restorePurchaseTitle;

  /// No description provided for @restorePurchaseDesc.
  ///
  /// In ja, this message translates to:
  /// **'※決済内容がアプリに反映されない場合、リストアをお試しください。'**
  String get restorePurchaseDesc;

  /// No description provided for @noPurchaseHistory.
  ///
  /// In ja, this message translates to:
  /// **'購入履歴が見つかりませんでした。'**
  String get noPurchaseHistory;

  /// No description provided for @subscription.
  ///
  /// In ja, this message translates to:
  /// **'会員ステータス'**
  String get subscription;

  /// No description provided for @plan.
  ///
  /// In ja, this message translates to:
  /// **'プラン'**
  String get plan;

  /// No description provided for @startDate.
  ///
  /// In ja, this message translates to:
  /// **'開始日'**
  String get startDate;

  /// No description provided for @nextRenewalDate.
  ///
  /// In ja, this message translates to:
  /// **'次回更新日'**
  String get nextRenewalDate;

  /// No description provided for @cancelSubscription.
  ///
  /// In ja, this message translates to:
  /// **'サブスクリプション解約'**
  String get cancelSubscription;

  /// No description provided for @free.
  ///
  /// In ja, this message translates to:
  /// **'無料'**
  String get free;

  /// No description provided for @freeTrial.
  ///
  /// In ja, this message translates to:
  /// **'無料トライアル'**
  String get freeTrial;

  /// No description provided for @monthlyPlan.
  ///
  /// In ja, this message translates to:
  /// **'1ヶ月'**
  String get monthlyPlan;

  /// No description provided for @quarterlyPlan.
  ///
  /// In ja, this message translates to:
  /// **'3ヶ月'**
  String get quarterlyPlan;

  /// No description provided for @annualPlan.
  ///
  /// In ja, this message translates to:
  /// **'12ヶ月'**
  String get annualPlan;

  /// No description provided for @tryFreeFor1Week.
  ///
  /// In ja, this message translates to:
  /// **'まずは1週間無料トライアル'**
  String get tryFreeFor1Week;

  /// No description provided for @noResponseTitle.
  ///
  /// In ja, this message translates to:
  /// **'応答がありませんでした'**
  String get noResponseTitle;

  /// No description provided for @noResponseMessage.
  ///
  /// In ja, this message translates to:
  /// **'時間をおいて、もう一度かけてみてください。'**
  String get noResponseMessage;

  /// No description provided for @cancelledTitle.
  ///
  /// In ja, this message translates to:
  /// **'相手がキャンセルしました'**
  String get cancelledTitle;

  /// No description provided for @cancelledMessage.
  ///
  /// In ja, this message translates to:
  /// **'通話は相手の都合により終了しました。'**
  String get cancelledMessage;

  /// No description provided for @end.
  ///
  /// In ja, this message translates to:
  /// **'終了'**
  String get end;

  /// No description provided for @remainingMessage.
  ///
  /// In ja, this message translates to:
  /// **'終了まであと@分です。'**
  String get remainingMessage;

  /// No description provided for @timeoutTitle.
  ///
  /// In ja, this message translates to:
  /// **'通話が終了しました'**
  String get timeoutTitle;

  /// No description provided for @timeoutMessage.
  ///
  /// In ja, this message translates to:
  /// **'通話時間の上限に達したため、自動的に終了しました。'**
  String get timeoutMessage;

  /// No description provided for @callEndedMessage.
  ///
  /// In ja, this message translates to:
  /// **'相手が通話を終了しました。'**
  String get callEndedMessage;

  /// No description provided for @unlimited.
  ///
  /// In ja, this message translates to:
  /// **'制限なし'**
  String get unlimited;

  /// No description provided for @reportButtonLabel.
  ///
  /// In ja, this message translates to:
  /// **'報告する'**
  String get reportButtonLabel;

  /// No description provided for @reportHeaderTitle.
  ///
  /// In ja, this message translates to:
  /// **'報告'**
  String get reportHeaderTitle;

  /// No description provided for @reasonMessageHeader.
  ///
  /// In ja, this message translates to:
  /// **'このトークルームを報告する理由'**
  String get reasonMessageHeader;

  /// No description provided for @reasonUserHeader.
  ///
  /// In ja, this message translates to:
  /// **'このユーザーを報告する理由'**
  String get reasonUserHeader;

  /// No description provided for @disclaimerText.
  ///
  /// In ja, this message translates to:
  /// **'報告は匿名で行われます。差し迫った危険に直面する人がいる場合は、今すぐ地域の普察または消防機関に緊急通報してください。'**
  String get disclaimerText;

  /// No description provided for @bullying.
  ///
  /// In ja, this message translates to:
  /// **'いじめ、または望まない接触'**
  String get bullying;

  /// No description provided for @selfHarm.
  ///
  /// In ja, this message translates to:
  /// **'自殺・自傷行為・摂食障害'**
  String get selfHarm;

  /// No description provided for @violence.
  ///
  /// In ja, this message translates to:
  /// **'暴力、ヘイト、または搾取'**
  String get violence;

  /// No description provided for @restrictedGoods.
  ///
  /// In ja, this message translates to:
  /// **'制限された商品を販売または宣伝している'**
  String get restrictedGoods;

  /// No description provided for @nudity.
  ///
  /// In ja, this message translates to:
  /// **'ヌードまたは性的行為'**
  String get nudity;

  /// No description provided for @fraud.
  ///
  /// In ja, this message translates to:
  /// **'詐欺またはスパム'**
  String get fraud;

  /// No description provided for @misinformation.
  ///
  /// In ja, this message translates to:
  /// **'虚偽の情報'**
  String get misinformation;

  /// No description provided for @intellectualProperty.
  ///
  /// In ja, this message translates to:
  /// **'知的財産権'**
  String get intellectualProperty;

  /// No description provided for @reportSubmitted.
  ///
  /// In ja, this message translates to:
  /// **'報告しました'**
  String get reportSubmitted;

  /// No description provided for @reallyBlockThisUser.
  ///
  /// In ja, this message translates to:
  /// **'本当にブロックしますか？'**
  String get reallyBlockThisUser;

  /// No description provided for @youHaveBlocked.
  ///
  /// In ja, this message translates to:
  /// **'@さんをブロックしました'**
  String get youHaveBlocked;

  /// No description provided for @youHaveUnblocked.
  ///
  /// In ja, this message translates to:
  /// **'@さんをブロックを解除しました'**
  String get youHaveUnblocked;

  /// No description provided for @genderTitle.
  ///
  /// In ja, this message translates to:
  /// **'性別を教えてください'**
  String get genderTitle;

  /// No description provided for @genderNote.
  ///
  /// In ja, this message translates to:
  /// **'この設定は後から変更できません。'**
  String get genderNote;

  /// No description provided for @genderOptionMale.
  ///
  /// In ja, this message translates to:
  /// **'男性'**
  String get genderOptionMale;

  /// No description provided for @genderOptionFemale.
  ///
  /// In ja, this message translates to:
  /// **'女性'**
  String get genderOptionFemale;

  /// No description provided for @freeFor1Week.
  ///
  /// In ja, this message translates to:
  /// **'今なら1週間無料！'**
  String get freeFor1Week;

  /// No description provided for @subscriptionNotice.
  ///
  /// In ja, this message translates to:
  /// **'※トライアル終了後は自動課金されます'**
  String get subscriptionNotice;

  /// No description provided for @chatDuration.
  ///
  /// In ja, this message translates to:
  /// **'チャット時間'**
  String get chatDuration;

  /// No description provided for @noSnsRegistered.
  ///
  /// In ja, this message translates to:
  /// **'SNSをまだ登録していません。'**
  String get noSnsRegistered;

  /// No description provided for @noProfileSet.
  ///
  /// In ja, this message translates to:
  /// **'プロフィールをまだ設定していません。'**
  String get noProfileSet;

  /// No description provided for @callBusyTitle.
  ///
  /// In ja, this message translates to:
  /// **'通話中のため応答することができません。'**
  String get callBusyTitle;

  /// No description provided for @callBusyMessage.
  ///
  /// In ja, this message translates to:
  /// **'しばらくしてからもう一度かけ直してください。'**
  String get callBusyMessage;

  /// No description provided for @noNearbyUsersTitle.
  ///
  /// In ja, this message translates to:
  /// **'周辺にまだ\nユーザーはいないようです。'**
  String get noNearbyUsersTitle;

  /// No description provided for @noNearbyUsersMessage.
  ///
  /// In ja, this message translates to:
  /// **'OOO はまだ発展途上のアプリなので、\n今はユーザーが少ない状態です。\nぜひ TikTok でシェアして、一緒に盛り上げてください！'**
  String get noNearbyUsersMessage;

  /// No description provided for @details.
  ///
  /// In ja, this message translates to:
  /// **'詳細'**
  String get details;

  /// No description provided for @sns.
  ///
  /// In ja, this message translates to:
  /// **'SNS'**
  String get sns;

  /// No description provided for @accountId.
  ///
  /// In ja, this message translates to:
  /// **'アカウントID'**
  String get accountId;

  /// No description provided for @verify.
  ///
  /// In ja, this message translates to:
  /// **'確認する'**
  String get verify;

  /// No description provided for @accountIdRequired.
  ///
  /// In ja, this message translates to:
  /// **'アカウントIDを入力してください'**
  String get accountIdRequired;

  /// No description provided for @getStarted.
  ///
  /// In ja, this message translates to:
  /// **'はじめる'**
  String get getStarted;

  /// No description provided for @invitedToChat.
  ///
  /// In ja, this message translates to:
  /// **'チャットに呼び出されています'**
  String get invitedToChat;

  /// No description provided for @viewProfile.
  ///
  /// In ja, this message translates to:
  /// **'プロフィールを見る'**
  String get viewProfile;

  /// No description provided for @noNearbyUsers.
  ///
  /// In ja, this message translates to:
  /// **'周辺にまだユーザーはいません'**
  String get noNearbyUsers;

  /// No description provided for @smallCommunityPitch.
  ///
  /// In ja, this message translates to:
  /// **'ボットやサクラはいない、安心できるアプリだからこそ、今はまだ少人数です\nぜひ TikTok でシェアして、一緒に盛り上げてください！'**
  String get smallCommunityPitch;

  /// No description provided for @moderationNotice.
  ///
  /// In ja, this message translates to:
  /// **'健全な運営のため、運営側がメッセージを確認する場合があります。違反が確認された場合はアカウントを停止することがあります。'**
  String get moderationNotice;

  /// No description provided for @locationOff.
  ///
  /// In ja, this message translates to:
  /// **'位置情報がオフです'**
  String get locationOff;

  /// No description provided for @locationPermissionWithRestart.
  ///
  /// In ja, this message translates to:
  /// **'周辺ユーザーを表示するには位置情報を許可してください。許可後はアプリを再起動してください。'**
  String get locationPermissionWithRestart;

  /// No description provided for @startChatTitle.
  ///
  /// In ja, this message translates to:
  /// **'チャットを始めますか？'**
  String get startChatTitle;

  /// No description provided for @startChatDescription.
  ///
  /// In ja, this message translates to:
  /// **'呼び出しを開始して、\nこのユーザーとチャットを始めます'**
  String get startChatDescription;

  /// No description provided for @endChatTitle.
  ///
  /// In ja, this message translates to:
  /// **'チャットを終了しますか？'**
  String get endChatTitle;

  /// No description provided for @endChatDescription.
  ///
  /// In ja, this message translates to:
  /// **'進行中の通話が終了されます。\nこの操作は取り消せません。'**
  String get endChatDescription;

  /// No description provided for @actionButtonStartChat.
  ///
  /// In ja, this message translates to:
  /// **'開始'**
  String get actionButtonStartChat;

  /// No description provided for @actionButtonEndChat.
  ///
  /// In ja, this message translates to:
  /// **'終了'**
  String get actionButtonEndChat;

  /// No description provided for @imageLoadError.
  ///
  /// In ja, this message translates to:
  /// **'画像を読み込めませんでした'**
  String get imageLoadError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
