import 'package:demo_project/component/widget_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/main.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/home/home_page.dart';
import 'package:demo_project/view/login/welcome_page/welcome_page.dart';
import 'package:demo_project/view_model/user_data.dart';

class InitialPage extends HookConsumerWidget {
  const InitialPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    appLocalizations = AppLocalizations.of(context);
    final permissionPage = useState<Widget?>(null);

    useEffect(handleEffect(context, ref, permissionPage), []);

    final userDataState = ref.watch(userDataNotifierProvider);
    return LayoutBuilder(
      builder: (_, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        return userDataState.when(
          error: (_, __) => const SizedBox(),
          loading: () => loadinPage(safeAreaWidth),
          data: (data) {
            FlutterNativeSplash.remove();
            //ユーザーデータをチェックする
            if (data == null && isFirstLaunch) return const WelcomePage();
            final nextPage = getUserDataRoute(data);
            if (nextPage != null) return nextPage;
            if (permissionPage.value != null) return permissionPage.value!;
            if (data == null) return loadinPage(safeAreaWidth);
            // return HomePage(userData: data);
            return nContainer();
          },
        );
      },
    );
  }

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// useEffect
////＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
  Dispose? Function() handleEffect(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<Widget?> permissionPage,
  ) {
    return () {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final page = await getPermissionRoute();
        if (context.mounted) permissionPage.value = page;
      });
      return null;
    };
  }
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
}
