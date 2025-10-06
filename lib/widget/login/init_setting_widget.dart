import 'package:flutter/material.dart';
import 'package:demo_project/component/app_component.dart';
import 'package:demo_project/component/image_component.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/constant/app_constant.dart';
import 'package:demo_project/constant/color_constant.dart';
import 'package:demo_project/model/app_model.dart';
import 'package:demo_project/widget/setting/edti_setting_page_widget.dart';

Widget initSetteingTitle(BoxConstraints constraints, String title) {
  final safeAreaWidth = constraints.maxWidth;
  final safeAreaHeight = constraints.maxHeight;
  return nText(
    title,
    padding: nSpacing(top: safeAreaHeight * 0.1),
    fontSize: safeAreaWidth / 15,
    isFit: true,
    color: blackColor,
  );
}

Widget userNameInput(
  double safeAreaWidth, {
  TextEditingController? textController,
  void Function(String)? onFieldSubmitted,
}) {
  return Row(
    children: [
      nTextFormField(
        padding: nSpacing(
          xSize: safeAreaWidth * 0.1,
          top: safeAreaWidth * 0.1,
          bottom: safeAreaWidth * 0.05,
        ),
        textController: textController,
        textAlign: TextAlign.center,
        maxLines: 1,
        maxLength: 50,
        keyboardType: TextInputType.text,
        fontSize: safeAreaWidth / 10,
        onFieldSubmitted: onFieldSubmitted,
        textColor: Colors.black,
        hintText: "・・・",
      ),
    ],
  );
}

Widget birthdayInput(
  BuildContext context,
  double safeAreaWidth,
  FocusNode? focusNode,
  TextEditingController? textController,
) {
  return nTextFormField(
    textController: textController,
    padding: nSpacing(top: safeAreaWidth * 0.1, xSize: safeAreaWidth * 0.2),
    textAlign: TextAlign.center,
    focusNode: focusNode,
    autofocus: false,
    maxLines: 1,
    maxLength: 2,
    keyboardType: TextInputType.number,
    fontSize: safeAreaWidth / 10,
    textColor: blackColor,
    hintText: "・・",
  );
}

Widget inputProfileImagesItem(
  BuildContext context,
  double safeAreaWidth,
  List<EditImageItemType> data, {
  required VoidCallback onAdd,
  required void Function(int) onTap,
}) {
  Widget imageWidget(int index) {
    final radius = index == 0 ? 20.0 : 10.0;
    final size = safeAreaWidth * (index == 0 ? 0.46 : 0.22);
    final image = "image/upload_${index + 1}.png";
    return SizedBox(
      width: size,
      child: GestureDetector(
        onTap: data.length > index ? () => onTap.call(index) : onAdd,
        child: nContainer(
          aspectRatio: mainAspectRatio,
          radius: radius,
          color: Colors.grey.withCustomOpacity(0.3),
          image: data.length > index ? fileImg(data[index].file) : null,
          child: Stack(
            children: [
              Opacity(
                opacity: data.length > index ? 0 : 0.1,
                child: nContainer(image: assetImg(image), radius: radius),
              ),
              if (!(data.length > index))
                uploadBoderWidget(context, safeAreaWidth, index),
              if (data.length > index)
                editIconButton(safeAreaWidth, onTap: () => onTap.call(index)),
            ],
          ),
        ),
      ),
    );
  }

  return nContainer(
    margin: nSpacing(top: safeAreaWidth * 0.1),
    padding: nSpacing(allSize: safeAreaWidth * 0.03),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        imageWidget(0),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            imageWidget(1),
            SizedBox(height: safeAreaWidth * 0.02),
            imageWidget(3),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            imageWidget(2),
            SizedBox(height: safeAreaWidth * 0.02),
            imageWidget(4),
          ],
        ),
      ],
    ),
  );
}
