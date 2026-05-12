import 'package:flutter/material.dart';

import '../../infrastructure/navigation/navigation.dart';

class CustomLayout extends StatelessWidget {
  const CustomLayout({
    super.key,
    this.appBar,
    this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonAnimator,
    this.drawer,
    this.endDrawer,
    this.bottomSheet,
    this.extendBody,
    this.extendBodyBehindAppBar,
    this.withBg,
    this.resizeToAvoidBottomInset,
    this.backgroundColor,
    this.keyLayout,
  });

  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomSheet;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;
  final bool? withBg;
  final bool? resizeToAvoidBottomInset;
  final Color? backgroundColor;
  final Key? keyLayout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return EnvironmentsBadge(
      child: Scaffold(
        key: keyLayout,
        backgroundColor: backgroundColor ?? theme.colorScheme.surface,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
        appBar: appBar,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        drawer: drawer,
        endDrawer: endDrawer,
        bottomSheet: bottomSheet,
        extendBody: extendBody ?? false,
        extendBodyBehindAppBar: extendBodyBehindAppBar ?? true,
        floatingActionButtonAnimator: floatingActionButtonAnimator,
      ),
    );
  }
}
