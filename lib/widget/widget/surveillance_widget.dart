import 'package:flutter/material.dart';

class Surveillance extends StatefulWidget {
  final VoidCallback? onForeground;
  final VoidCallback? onBackground;
  final Widget child;
  const Surveillance({
    super.key,
    this.onForeground,
    this.onBackground,
    required this.child,
  });
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Surveillance> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      widget.onForeground?.call();
    } else if (state == AppLifecycleState.paused) {
      widget.onBackground?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
