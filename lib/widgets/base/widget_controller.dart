import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'widget_controller.child_hook.dart';
part 'widget_controller.hook.dart';

/// Base controller of widget states
class WidgetController<T extends Widget> extends ChangeNotifier {
  WidgetController();

  BuildContext? _context;
  T? _widget;

  /// {@macro flutter.widgets.BuildContext.asynchronous_gap}
  bool get mounted => _context?.mounted ?? false;

  BuildContext get context => _context!;
  T get widget => _widget!;

  /// build가 1회 실행된 뒤 한번만 실행
  /// [WidgetsBinding.instance.addPostFrameCallback] 참고
  @protected
  void postInitState() {}

  @protected
  void build(BuildContext context) {}

// 기본적으로 다음 구조를 복사해서 구현
// 다만 이는 권장 사항일 뿐이니 상황에 따라서 수정하여 사용
// ex) final literal 변수를 Fields에 선언후 해당 값을 직접 Data binding이나 Interface로 사용
//    또는 `/// type: Data binding` 처럼 주석으로 알리기
// Interface는 Public, 나머지는 Private으로 구현
// 1. Fields : 변수 선언
// 2. Interface : 외부에(e.g. 부모 Widget) 노출되는 API
// 3. Data bindings : View에서 표현되기 위해 변수로 노출하는 프로퍼티
// 4. Callbacks : View에서 호출하는 메소드

//#region Fields
//#endregion Fields

//#region Interfaces
//#endregion Interfaces

//#region Data bindings
//#endregion Data bindings

//#region Callbacks
//#endregion Callbacks
}

/// Using riverpod inside of controller
class ConsumerWidgetController<T extends Widget> extends WidgetController<T> {
  ConsumerWidgetController({required WidgetRef ref}) : _ref = ref;

  final WidgetRef _ref;
  WidgetRef get ref => _ref;
}
