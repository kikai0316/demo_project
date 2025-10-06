import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/loading_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/l10n/app_localizations.dart';

class CustomNetworkImageWidegt extends StatelessWidget {
  const CustomNetworkImageWidegt({
    super.key,
    required this.safeAreaWidth,
    required this.url,
    this.radius,
    this.width,
    this.aspectRatio,
    this.height,
    this.isUserImage,
    this.imageBuilder,
    this.placeholder,
    this.errorWidget,
    this.boxShadow,
    this.margin,
  });
  final double safeAreaWidth;
  final String url;
  final double? radius;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final bool? isUserImage;
  final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
  final Widget? placeholder;
  final Widget? errorWidget;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return nContainer(
      height: height,
      width: width,
      margin: margin,
      child: nContainer(
        aspectRatio: aspectRatio ?? mainAspectRatio,
        boxShadow: boxShadow,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 0),
          child: CachedNetworkImage(
            imageUrl: url,
            cacheKey: url,
            fit: BoxFit.cover,
            placeholder: (_, __) => placeholder ?? _loadingWidget(),
            errorWidget: (_, __, ___) => errorWidget ?? _errorWidget(context),
            imageBuilder: imageBuilder,
          ),
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return nSkeletonLoadingWidget(child: nContainer(color: Colors.grey));
  }

  Widget _errorWidget(BuildContext context) {
    final ln = AppLocalizations.of(context)!;
    final isUser = isUserImage != false;
    return nContainer(
        color: Colors.grey,
        image: isUser ? assetImg("image/notImage.png") : null,
        child: Opacity(
          opacity: 0.3,
          child: !isUser
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    nIcon(Icons.error, size: safeAreaWidth * 0.15),
                    SizedBox(height: safeAreaWidth * 0.03),
                    nText(ln.imageLoadError, fontSize: safeAreaWidth / 23),
                    SizedBox(height: safeAreaWidth * 0.3),
                  ],
                )
              : null,
        ));
  }
}

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// タップイベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// イベント
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
// その他
//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
