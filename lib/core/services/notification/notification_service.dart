import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/api_service.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/api_response.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/pagination.dart';
import 'package:xrp_monitor_flutter_admin/core/services/notification/models/notification_history.dart';

final notificationAdminServiceProvider = Provider<NotificationAdminService>((
  ref,
) {
  return NotificationAdminService(ref.read(apiServiceProvider.notifier));
});

class NotificationHistoryPage {
  const NotificationHistoryPage({
    required this.histories,
    required this.pagination,
  });

  final List<NotificationHistory> histories;
  final Pagination pagination;
}

class NotificationAdminService {
  NotificationAdminService(this._apiService);

  final ApiService _apiService;

  Future<NotificationHistoryPage> getHistories({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _apiService.get(
      url: '${ApiPath.apiUrl}admin/notifications',
      params: {'page': page, 'perPage': perPage},
    );
    final apiResponse = ApiResponse.fromJson(response.data!);
    final result = apiResponse.result;
    if (!apiResponse.success || result?.page == null || result?.list == null) {
      throw Exception(apiResponse.message);
    }

    return NotificationHistoryPage(
      histories:
          (result!.list as List<dynamic>)
              .map(
                (item) =>
                    NotificationHistory.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      pagination: result.page!,
    );
  }

  Future<void> send({
    required List<int> userIds,
    required String title,
    required String body,
  }) async {
    final response = await _apiService.post(
      url: '${ApiPath.apiUrl}admin/notifications/send',
      params: {'userIds': userIds, 'title': title, 'body': body},
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('알림 발송에 실패했습니다.');
    }
  }

  Future<NotificationRecipients> getRecipients(int historyId) async {
    final response = await _apiService.get(
      url: '${ApiPath.apiUrl}admin/notifications/$historyId/recipients',
    );
    final payload = response.data;
    final result = payload?['result'];
    if (response.statusCode != 200 || result is! Map<String, dynamic>) {
      throw Exception(payload?['message'] ?? '수신 회원 조회에 실패했습니다.');
    }
    return NotificationRecipients.fromJson(result);
  }
}
