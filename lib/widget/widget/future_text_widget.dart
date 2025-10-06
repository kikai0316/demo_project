import 'package:flutter/material.dart';
import 'package:demo_project/component/widget_component.dart';
import 'package:demo_project/utility/location_utility.dart';

class FutureTextWidget extends StatefulWidget {
  final List<double> location;
  final double fontSize;
  final EdgeInsetsGeometry margin;
  final double maxWidth;
  final bool isFit;
  final Color? color;

  const FutureTextWidget({
    super.key,
    required this.location,
    required this.fontSize,
    this.margin = EdgeInsets.zero,
    this.maxWidth = double.infinity,
    this.isFit = false,
    this.color = Colors.white,
  });

  @override
  State<FutureTextWidget> createState() => _FutureTextWidgetState();
}

class _FutureTextWidgetState extends State<FutureTextWidget> {
  String? _text;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadText());
  }

  Future<void> _loadText() async {
    final locationStr = await getLocationString(context, widget.location);
    if (mounted) setState(() => _text = locationStr);
  }

  @override
  Widget build(BuildContext context) {
    return nContainer(
      margin: widget.margin,
      maxWidth: widget.maxWidth,
      child: nText(
        _text ?? "error",
        fontSize: widget.fontSize,
        isFit: widget.isFit,
        color: widget.color,
      ),
    );
  }
}
