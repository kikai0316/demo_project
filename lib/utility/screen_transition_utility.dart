import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:demo_project/model/user_model.dart';
import 'package:demo_project/utility/path_provider_utility.dart';
import 'package:demo_project/view/login/init_setting/birthday_setting_page.dart';
import 'package:demo_project/view/login/permission/location_permission_page.dart';
import 'package:demo_project/view/login/permission/notifications_permission_page.dart';
import 'package:demo_project/view/login/phone_login/phone_login_page.dart';
import 'package:demo_project/view/page/data_initialize_page.dart';

class ScreenTransition {
  final Widget page;
  final BuildContext context;

  ScreenTransition(
    this.context,
    this.page,
  );

  void normal([bool isReset = false]) {
    final route = CupertinoPageRoute(builder: (_) => page);
    if (!isReset) Navigator.of(context).push(route);
    if (isReset) Navigator.of(context).pushReplacement(route);
  }

  void reset() => Navigator.of(context)
      .pushReplacement(NoAnimationCupertinoPageRoute(builder: (_) => page));

  /// 上方向へのスライド遷移
  Future<T?> top<T>({
    Function(T?)? onPop,
  }) async {
    final result = await Navigator.of(context).push<T>(
      CupertinoPageRoute(fullscreenDialog: true, builder: (_) => page),
    );
    onPop?.call(result);
    return result;
  }

  //スケールイン
  void scale() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const beginScale = 1.5;
          const endScale = 1.0;
          const curve = Curves.easeOutBack;

          final scaleTween = Tween(begin: beginScale, end: endScale)
              .chain(CurveTween(curve: curve));

          final opacityTween = Tween(begin: 0.8, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn));

          return FadeTransition(
            opacity: animation.drive(opacityTween),
            child: ScaleTransition(
              scale: animation.drive(scaleTween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  /// Heroアニメーションを利用した遷移
  Future<T?> hero<T>({Function(T?)? onPop, int milliseconds = 250}) async {
    final result = await Navigator.push<T>(
      context,
      createRoute<T>(
        useTransition: false,
        onPop: () {},
        milliseconds: milliseconds,
      ),
    );
    onPop?.call(result);
    return result;
  }

  Widget _buildSlideTransition({
    required Offset beginOffset,
    required Animation<double> animation,
    required Widget child,
  }) {
    final tween = Tween(begin: beginOffset, end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeInOut));
    final offsetAnimation = animation.drive(tween);
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  PageRouteBuilder<T> createRoute<T>({
    VoidCallback? onThen,
    VoidCallback? onPop,
    bool useTransition = true,
    int milliseconds = 250,
  }) {
    final animationDuration = Duration(milliseconds: milliseconds);
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        animation.addStatusListener((status) {
          if (status == AnimationStatus.dismissed) onPop?.call();
        });
        return page;
      },
      transitionsBuilder: useTransition
          ? _buildDefaultTransition
          : (_, __, ___, child) => child,
      transitionDuration: animationDuration,
      reverseTransitionDuration: animationDuration,
    );
  }

  Widget _buildDefaultTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _buildSlideTransition(
      beginOffset: const Offset(0, 1.0),
      animation: animation,
      child: child,
    );
  }
}

//ユーザーデータのデータ足りないものがあるならページに飛ばすのかを判断する
Widget? getUserDataRoute(UserType? userData) {
  if (userData == null) return const PhoneLoginPage();
  final isBirthday = userData.birthday.isEmpty;
  final isUserName = userData.userName.isEmpty;
  final isImages = userData.profileImages.isEmpty;
  if (isBirthday || isUserName || isImages) return const BirthdayPage();
  return null;
}

Future<Widget?> getPermissionRoute() async {
  final fastAction = await localGetFirstActions();
  final isNotiNotRequest = fastAction.notificationRequestPermission;
  final isLocNotRequest = fastAction.locationRequestPermission;
  if (isNotiNotRequest) return const NotificationsPermissionPage();
  if (isLocNotRequest) return const LocationPermissionPage();
  return null;
}

Future<Widget> initializeRoute(UserType? userData) async {
  Widget? page = getUserDataRoute(userData);
  page ??= await getPermissionRoute();
  return page ?? const DataInitializePage();
}

class NoAnimationCupertinoPageRoute<T> extends CupertinoPageRoute<T> {
  NoAnimationCupertinoPageRoute({required super.builder});
  @override
  Duration get transitionDuration => Duration.zero;
  @override
  Duration get reverseTransitionDuration => Duration.zero;
}
