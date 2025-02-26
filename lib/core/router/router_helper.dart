import 'package:go_router/go_router.dart';

import 'app_router.dart';

void navigateTo(context, String pageRoute, {Map<String, dynamic>? extra}) =>
    AppRouter.globalContext.push(pageRoute, extra: extra);

void navigateAndReplacement(context, String pageRoute,
        {Map<String, dynamic>? extra}) =>
    AppRouter.globalContext.pushReplacement(pageRoute, extra: extra);

void navigateAndFinish(context, String pageRoute,
        {Map<String, dynamic>? extra}) =>
    AppRouter.globalContext.go(pageRoute, extra: extra);

void navigatePop(context) {
  if (AppRouter.globalContext.canPop()) {
    AppRouter.globalContext.pop();
  }
}

bool canPop() {
  return AppRouter.globalContext.canPop();
}
