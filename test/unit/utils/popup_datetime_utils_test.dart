import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_monitor_flutter_admin/core/utils/popup_datetime_utils.dart';

void main() {
  test('로컬 시간을 yyyy-MM-dd HH:mm:ss 형식으로 표시한다', () {
    final DateTime value = DateTime(2026, 6, 9, 10, 30);

    expect(PopupDateTimeUtils.format(value), '2026-06-09 10:30:00');
  });

  test('관리자에서 선택한 로컬 시간을 UTC ISO 형식으로 전송한다', () {
    final DateTime localValue = DateTime(2026, 6, 9, 10, 30);

    expect(
      PopupDateTimeUtils.toApiValue(localValue),
      localValue.toUtc().toIso8601String(),
    );
  });
}
