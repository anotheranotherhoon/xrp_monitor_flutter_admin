part of 'widget_controller.dart';

T useWidgetControllerForChild<T extends WidgetController>(Constructor<T> constructor) {
  return use(_WidgetControllerHook(
    constructor: constructor,
  ));
}
/// 부모가 자식에게 컨트롤러를 만들어서 넘긴 경우 자식에서 해당 함수 사용
T useWidgetControllerInstance<T extends WidgetController>(T instance, BuildContext context) {
  final controller = use(_WidgetControllerChildHook(instance));
  useListenable(controller);
  controller._context = context;
  controller._widget = context.widget;
  controller.build(context);
  return controller;
}

class _WidgetControllerChildHook<T extends WidgetController> extends Hook<T> {
  const _WidgetControllerChildHook(this.instance);

  final T instance;

  @override
  _WidgetControllerChildHookState<T> createState() => _WidgetControllerChildHookState<T>(instance);
}

class _WidgetControllerChildHookState<T extends WidgetController> extends HookState<T, _WidgetControllerHook<T>> {
  _WidgetControllerChildHookState(this.controller);

  final T controller;

  @override
  void initHook() {
    super.initHook();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.postInitState);
  }

  @override
  T build(BuildContext context) {
    return controller;
  }

  @override
  bool get debugHasShortDescription => false;

  @override
  String get debugLabel => 'useWidgetControllerReference<${T.runtimeType.toString()}>';
}