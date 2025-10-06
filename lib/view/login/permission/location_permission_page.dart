import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/button/gradient_loop_button_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';
import 'package:demo_project/utility/path_provider_utility.dart';
import 'package:demo_project/utility/screen_transition_utility.dart';
import 'package:demo_project/view/page/data_initialize_page.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionPage extends HookConsumerWidget {
  const LocationPermissionPage({
    super.key,
    this.isUnPermission,
  });

  final bool? isUnPermission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FlutterNativeSplash.remove();
    final ln = AppLocalizations.of(context)!;
    final isLoading = useState<bool>(false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final safeAreaWidth = constraints.maxWidth;
        final safeAreaheight = constraints.maxHeight;
        return PopScope(
          canPop: false,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.blueAccent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      nContainer(
                        squareSize: safeAreaWidth * 0.3,
                        image: assetImg("image/location.png"),
                        radius: 25,
                        border: nBorder(
                          color: Colors.white.withCustomOpacity(0.2),
                        ),
                        boxShadow: nBoxShadow(shadow: 0.3),
                      ),
                      nText(
                        ln.permissionLocationTitle,
                        fontSize: safeAreaWidth / 15,
                        padding: nSpacing(
                          top: safeAreaheight * 0.05,
                          xSize: safeAreaWidth * 0.05,
                        ),
                        isFit: true,
                      ),
                      nText(
                        ln.permissionLocationExplanation,
                        fontSize: safeAreaWidth / 23,
                        padding: nSpacing(
                          top: safeAreaheight * 0.02,
                          xSize: safeAreaWidth * 0.05,
                        ),
                        color: Colors.white.withCustomOpacity(0.8),
                        height: 1.3,
                        isOverflow: false,
                      ),
                      GradientLoopButton(
                        text: "continue",
                        safeAreaWidth: safeAreaWidth,
                        margin: nSpacing(top: safeAreaheight * 0.07),
                        width: safeAreaWidth * 0.7,
                        height: safeAreaWidth * 0.18,
                        fontSize: safeAreaWidth / 16,
                        radius: 20,
                        onTap: () async {
                          localWriteFirstActions(location: false);
                          await Permission.location.request();
                          if (!context.mounted) return;
                          const page = DataInitializePage();
                          ScreenTransition(context, page).normal(true);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              loadinPage(safeAreaWidth, isLoading: isLoading.value),
            ],
          ),
        );
      },
    );
  }
}
