import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/popup/models/popup_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/popup/popup_service.dart';

part 'popup_view_model.g.dart';

@riverpod
class PopupViewModel extends _$PopupViewModel {
  PopupService get _service => ref.read(popupServiceProvider.notifier);

  @override
  Future<List<PopupModel>> build() async {
    return _fetch();
  }

  Future<List<PopupModel>> _fetch() async {
    final response = await _service.getPopups();
    return response.result ?? const [];
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetch);
  }

  Future<void> deletePopup(int id) async {
    await _service.deletePopup(id);
    await refresh();
  }

  Future<void> togglePopup(int id) async {
    await _service.togglePopup(id);
    await refresh();
  }
}
