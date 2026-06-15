part of 'user_management_page.dart';

class UserManagementPageController
    extends ConsumerWidgetController<UserManagementPage> {
  UserManagementPageController({required super.ref});

  @override
  void build(BuildContext context) {
    // 필요시 초기화 로직 추가
  }

  void refresh() {
    ref.read(userViewModelProvider.notifier).fetchUsersByRole();
  }

  // 사용자 생성
  Future<bool> createUser(CreateUserRequest request) async {
    try {
      final ResponseModel<bool> result = await ref
          .read(userViewModelProvider.notifier)
          .createUser(request);
      if (result.success) {
        refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 사용자 수정
  Future<bool> updateUser(int id, UpdateUserRequest request) async {
    try {
      final ResponseModel<bool> result = await ref
          .read(userViewModelProvider.notifier)
          .updateUser(id, request);
      if (result.success) {
        refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 사용자 삭제
  Future<bool> deleteUser(int id) async {
    try {
      final ResponseModel<bool> result = await ref
          .read(userViewModelProvider.notifier)
          .deleteUser(id);
      if (result.success) {
        refresh();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 폼 유효성 검사
  String? validateEmail(String? value) {
    if (value?.isEmpty == true) return '이메일을 입력하세요';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return '올바른 이메일 형식을 입력하세요';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value?.isEmpty == true) return '비밀번호를 입력하세요';
    if (value!.length < 6) return '비밀번호는 6자 이상이어야 합니다';
    return null;
  }

  String? validateNickname(String? value) {
    return value?.isEmpty == true ? '닉네임을 입력하세요' : null;
  }
}
