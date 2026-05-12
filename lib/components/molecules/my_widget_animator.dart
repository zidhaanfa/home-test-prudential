import 'package:flutter/material.dart';

import '../../utils/config.dart';

// switch between different widgets with animation
// depending on api call status
class MyWidgetsAnimator extends StatelessWidget {
  final ApiCallStatus status;
  final Widget Function()? loadingWidget;
  final Widget Function() successWidget;
  final Widget Function()? errorWidget;
  final Widget Function()? emptyWidget;
  final Widget Function()? holdingWidget;
  final Widget Function()? refreshWidget;
  // final Duration? animationDuration;
  // final Widget Function(Widget, Animation<double>)? transitionBuilder;
  // this will be used to not hide the success widget when refresh
  // if its true success widget will still be shown
  // if false refresh widget will be shown or empty box if passed (refreshWidget) is null
  final bool hideSuccessWidgetWhileRefreshing;

  const MyWidgetsAnimator({
    super.key,
    required this.status,
    this.loadingWidget,
    this.errorWidget,
    required this.successWidget,
    this.holdingWidget,
    this.emptyWidget,
    this.refreshWidget,
    // this.animationDuration,
    // this.transitionBuilder,
    this.hideSuccessWidgetWhileRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: switch (status) {
        (ApiCallStatus.success) => successWidget,
        (ApiCallStatus.error) =>
          errorWidget ??
              () {
                return const SizedBox();
              },
        (ApiCallStatus.holding) =>
          holdingWidget ??
              () {
                return const SizedBox();
              },
        (ApiCallStatus.loading) =>
          loadingWidget ??
              () {
                return Center(child: CircularProgressIndicator());
              },
        (ApiCallStatus.empty) =>
          emptyWidget ??
              () {
                return const SizedBox();
              },
      }(),
    );
  }
}
