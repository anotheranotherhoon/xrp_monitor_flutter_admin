part of 'widget_controller.dart';

typedef Constructor<T> = T Function();

T useWidgetController<T extends WidgetController>(Constructor<T> constructor, BuildContext context) {
  final controller = use(
    _WidgetControllerHook(
      constructor: () {
        final controller = constructor();
        WidgetsBinding.instance.addPostFrameCallback((_) => controller.postInitState());
        return controller;
      },
    ),
  );
  useListenable(controller);
  controller._context = context;
  controller._widget = context.widget;
  controller.build(context);
  return controller;
}

class _WidgetControllerHook<T extends WidgetController> extends Hook<T> {
  const _WidgetControllerHook({required this.constructor});

  final Constructor<T> constructor;

  @override
  _WidgetControllerHookState<T> createState() => _WidgetControllerHookState<T>(constructor);
}

class _WidgetControllerHookState<T extends WidgetController> extends HookState<T, _WidgetControllerHook<T>> {
  _WidgetControllerHookState(Constructor<T> constructor) : controller = constructor();

  final T controller;

  @override
  T build(BuildContext context) {
    return controller;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool get debugHasShortDescription => false;

  @override
  String get debugLabel => 'useWidgetController<${T.runtimeType.toString()}>';
}
