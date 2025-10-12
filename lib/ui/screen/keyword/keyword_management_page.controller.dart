part of 'keyword_management_page.dart';


class KeywordManagementPageController extends ConsumerWidgetController<KeywordManagementPage> {
  KeywordManagementPageController ({
    required super.ref
  });

  @override
  void build(BuildContext context) {

  }

  void refresh(){
    ref.read(keywordViewModelProvider.notifier).reset();
  }

  // 키워드 생성
  Future<bool> createKeyword(KeywordCreateRequest request) async {
    try {
      final ResponseModel<bool> result = await ref.read(keywordViewModelProvider.notifier).createKeyword(request);
      if (result.success) {
        refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 키워드 수정
  Future<bool> updateKeyword(int id, KeywordUpdateRequest request) async {
    try {
      final ResponseModel<bool> result = await ref.read(keywordViewModelProvider.notifier).updateKeyword(id, request);
      if (result.success) {
        refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 키워드 삭제
  Future<bool> deleteKeyword(int id) async {
    try {
      final ResponseModel<bool> result = await ref.read(keywordViewModelProvider.notifier).deleteKeyword(id);
      if (result.success) {
        refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 성공 메시지 표시
  void showSuccessMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // 실패 메시지 표시
  void showErrorMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 생성 다이얼로그 처리
  Future<void> handleCreateKeyword(
    BuildContext context,
    String keyword,
    String weight,
    KeywordType type,
    VoidCallback onSuccess,
  ) async {
    if (keyword.isEmpty || weight.isEmpty) {
      showErrorMessage(context, '모든 필드를 입력해주세요.');
      return;
    }

    try {
      final request = KeywordCreateRequest(
        keKeyword: keyword,
        keWeight: double.parse(weight),
        keType: type,
      );

      final success = await createKeyword(request);
      if (success) {
        Navigator.of(context).pop();
        onSuccess();
        showSuccessMessage(context, '키워드가 생성되었습니다.');
      } else {
        showErrorMessage(context, '키워드 생성에 실패했습니다.');
      }
    } catch (e) {
      showErrorMessage(context, '생성 실패: $e');
    }
  }

  // 수정 다이얼로그 처리
  Future<void> handleUpdateKeyword(
    BuildContext context,
    int id,
    String keyword,
    String weight,
    KeywordType type,
    bool isActive,
    VoidCallback onSuccess,
  ) async {
    if (keyword.isEmpty || weight.isEmpty) {
      showErrorMessage(context, '모든 필드를 입력해주세요.');
      return;
    }

    try {
      final request = KeywordUpdateRequest(
        keKeyword: keyword,
        keWeight: double.parse(weight),
        keType: type,
        keIsActive: isActive,
      );

      final success = await updateKeyword(id, request);
      if (success) {
        Navigator.of(context).pop();
        onSuccess();
        showSuccessMessage(context, '키워드가 수정되었습니다.');
      } else {
        showErrorMessage(context, '키워드 수정에 실패했습니다.');
      }
    } catch (e) {
      showErrorMessage(context, '수정 실패: $e');
    }
  }

  // 삭제 다이얼로그 처리
  Future<void> handleDeleteKeyword(
    BuildContext context,
    int id,
    String keywordName,
  ) async {
    final success = await deleteKeyword(id);
    if (success) {
      showSuccessMessage(context, '키워드가 삭제되었습니다.');
    } else {
      showErrorMessage(context, '삭제 실패');
    }
  }
}
