import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/keyword/keyword_management_page.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/user/user_management_page.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/version/version_management_page.dart';

@RoutePage()
class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<int> selectedIndex = useState<int>(0);
    
    return Scaffold(
      body: Row(
        children: [
          // 사이드바
          Container(
            width: 240,
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                // 로고/헤더 영역
                Container(
                  height: 64,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'XRP Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 메뉴 영역
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuItem(
                        context,
                        index: 0,
                        selectedIndex: selectedIndex.value,
                        onTap: () => selectedIndex.value = 0,
                        icon: Icons.people,
                        title: '회원 관리',
                      ),
                      _buildMenuItem(
                        context,
                        index: 1,
                        selectedIndex: selectedIndex.value,
                        onTap: () => selectedIndex.value = 1,
                        icon: Icons.system_update,
                        title: '버전 관리',
                      ),
                      _buildMenuItem(
                        context,
                        index: 2,
                        selectedIndex: selectedIndex.value,
                        onTap: () => selectedIndex.value = 2,
                        icon: Icons.analytics,
                        title: '키워드 관리',
                      ),
                    ],
                  ),
                ),
                
                // 로그아웃 버튼
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: 로그아웃 구현
                      },
                      icon: const Icon(
                        Icons.logout,
                        size: 16,
                      ),
                      label: const Text(
                        '로그아웃',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF374151),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // 메인 콘텐츠 영역
          Expanded(
            child: Column(
              children: [
                // 상단 헤더
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getPageTitle(selectedIndex.value),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const Spacer(),
                      // 사용자 정보나 알림 등을 추가할 수 있는 영역
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF6B7280),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 페이지 콘텐츠
                Expanded(
                  child: Container(
                    color: const Color(0xFFF9FAFB),
                    child: _buildPageContent(selectedIndex.value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required int index,
    required int selectedIndex,
    required VoidCallback onTap,
    required IconData icon,
    required String title,
  }) {
    final isSelected = index == selectedIndex;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return '회원 관리';
      case 1:
        return '버전 관리';
      case 2:
        return '키워드 관리';
      default:
        return '';
    }
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return const UserManagementPage();
      case 1:
        return const VersionManagementPage();
      case 2:
        return const KeywordManagementPage();
      default:
        return const SizedBox.shrink();
    }
  }
}