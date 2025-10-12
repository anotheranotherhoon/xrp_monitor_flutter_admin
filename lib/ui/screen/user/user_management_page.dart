import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_role.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_create_request.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/user/models/user_state.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/user/view_models/user_view_model.dart';
import 'package:xrp_monitor_flutter_admin/widgets/base/widget_controller.dart';

part 'user_management_page.controller.dart';

class UserManagementPage extends HookConsumerWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserManagementPageController controller = useWidgetController(() => UserManagementPageController(ref: ref), context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '회원 관리',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              await _showCreateUserDialog(context, controller);
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('사용자 추가', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () {
              controller.refresh();
            },
            icon: const Icon(Icons.refresh, color: Colors.blue),
            label: const Text('새로고침', style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: ref.watch(userViewModelProvider).when(
          data: (UserState userState) {
            return _buildContent(userState, ref, controller);
          },
          loading: () => _buildLoading(),
          error: (error, stackTrace) => _buildError(error.toString()),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(UserState userState, WidgetRef ref, UserManagementPageController controller) {
    print('userState.users ${userState.users}');
    if (userState.users.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(userState),
          const SizedBox(height: 24),
          Expanded(
            child: _buildUserList(userState.users, ref, controller),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            '등록된 사용자가 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(UserState userState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.people, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Text(
            '전체 사용자',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${userState.pageInfo?.total}명',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<User> users, WidgetRef ref, UserManagementPageController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          return _buildUserCard(context, user, ref, controller);
        },
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, User user, WidgetRef ref, UserManagementPageController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // 사용자 아바타
          CircleAvatar(
            radius: 24,
            backgroundColor: user.isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
            child: Icon(
              Icons.person,
              color: user.isActive ? Colors.green : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          
          // 사용자 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.nickname ?? '닉네임 없음',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: user.role == UserRole.ADMIN ? Colors.purple : Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        user.role.displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '가입일: ${user.createdAt}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // 액션 버튼들
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await _showEditUserDialog(context, controller, user);
                },
                icon: Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ),
              IconButton(
                onPressed: () async {
                  await _showDeleteConfirmDialog(context, controller, user);
                },
                icon: const Icon(
                  Icons.delete,
                  size: 18,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  // 사용자 생성 다이얼로그
  Future<void> _showCreateUserDialog(BuildContext context, UserManagementPageController controller) async {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nicknameController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 사용자 추가'),
        content: Container(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: '이메일'),
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: '비밀번호'),
                  obscureText: true,
                  validator: controller.validatePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nicknameController,
                  decoration: const InputDecoration(labelText: '닉네임'),
                  validator: controller.validateNickname,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                final request = CreateUserRequest(
                  meEmail: emailController.text,
                  mePassword: passwordController.text,
                  meNickname: nicknameController.text,
                );
                
                final success = await controller.createUser(request);
                
                if (!context.mounted) return;
                
                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('사용자가 생성되었습니다')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('사용자 생성에 실패했습니다')),
                  );
                }
              }
            },
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }

  // 사용자 수정 다이얼로그
  Future<void> _showEditUserDialog(BuildContext context, UserManagementPageController controller, User user) async {
    final formKey = GlobalKey<FormState>();
    final nicknameController = TextEditingController(text: user.nickname ?? '');
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사용자 정보 수정'),
        content: Container(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: TextEditingController(text: user.email),
                  decoration: const InputDecoration(labelText: '이메일'),
                  enabled: false,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nicknameController,
                  decoration: const InputDecoration(labelText: '닉네임'),
                  validator: controller.validateNickname,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                final request = UpdateUserRequest(
                  meNickname: nicknameController.text,
                );
                
                final success = await controller.updateUser(user.key, request);
                
                if (!context.mounted) return;
                
                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('사용자 정보가 수정되었습니다')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('사용자 수정에 실패했습니다')),
                  );
                }
              }
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  // 사용자 삭제 확인 다이얼로그
  Future<void> _showDeleteConfirmDialog(BuildContext context, UserManagementPageController controller, User user) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('사용자 삭제'),
        content: Text('${user.nickname ?? user.email} 사용자를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.deleteUser(user.key);
              
              if (!context.mounted) return;
              
              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('사용자가 삭제되었습니다')),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('사용자 삭제에 실패했습니다')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}