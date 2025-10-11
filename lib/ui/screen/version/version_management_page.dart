import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/ui/layout/common_style.dart';
import 'package:xrp_monitor_flutter_admin/widgets/base/widget_controller.dart';

part 'version_management_page.controller.dart';

class VersionManagementPage extends HookConsumerWidget {
  const VersionManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState<int>(0);
    final isLoading = useState<bool>(false);

    // 더미 데이터 - 실제로는 API에서 가져올 데이터
    final versions = [
      {
        'version': '2.1.0',
        'platform': 'Android',
        'status': '출시됨',
        'releaseDate': '2024-03-15',
        'downloadCount': 12485,
        'description': '새로운 XRP 분석 기능 추가',
        'isForced': false,
      },
      {
        'version': '2.0.5',
        'platform': 'iOS',
        'status': '검토중',
        'releaseDate': '2024-03-10',
        'downloadCount': 8932,
        'description': '버그 수정 및 성능 개선',
        'isForced': true,
      },
      {
        'version': '2.0.4',
        'platform': 'Android',
        'status': '출시됨',
        'releaseDate': '2024-03-05',
        'downloadCount': 15673,
        'description': '보안 패치 업데이트',
        'isForced': false,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 페이지 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '버전 관리',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '앱 버전을 관리하고 배포합니다',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: 새 버전 추가 기능
                },
                icon: Icon(Icons.add, size: 18),
                label: Text(
                  '새 버전 추가',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: CommonColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),


          SizedBox(height: 24),

          // 탭 메뉴
          Container(
            decoration: BoxDecoration(
              color: CommonColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: CommonColors.mainBlack.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // 탭 헤더
                Container(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      _buildTabButton(
                        title: '전체 버전',
                        isSelected: selectedTab.value == 0,
                        onTap: () => selectedTab.value = 0,
                      ),
                      _buildTabButton(
                        title: 'Android',
                        isSelected: selectedTab.value == 1,
                        onTap: () => selectedTab.value = 1,
                      ),
                      _buildTabButton(
                        title: 'iOS',
                        isSelected: selectedTab.value == 2,
                        onTap: () => selectedTab.value = 2,
                      ),
                    ],
                  ),
                ),

                // 버전 목록
                Container(
                  height: 400,
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                    itemCount: versions.length,
                    itemBuilder: (context, index) {
                      final version = versions[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 버전 정보
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: version['platform'] == 'Android'
                                              ? const Color(0xFFDCFCE7)
                                              : const Color(0xFFDBEAFE),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          version['platform'].toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: version['platform'] == 'Android'
                                                ? const Color(0xFF166534)
                                                : const Color(0xFF1E40AF),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'v${version['version']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF111827),
                                        ),
                                      ),
                                      if (version['isForced'] == true) ...[
                                        SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEE2E2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '강제업데이트',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: const Color(0xFF991B1B),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    version['description'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        version['releaseDate'].toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: const Color(0xFF6B7280),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Icon(
                                        Icons.download,
                                        size: 16,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${version['downloadCount']} 다운로드',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: const Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // 상태 및 액션
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: version['status'] == '출시됨'
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    version['status'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: version['status'] == '출시됨'
                                          ? const Color(0xFF065F46)
                                          : const Color(0xFF92400E),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // TODO: 버전 수정
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // TODO: 버전 삭제
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: const Color(0xFFDC2626),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CommonColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: CommonColors.mainBlack..withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CommonColors.mainBlack.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                color: isSelected ? CommonColors.white : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }
}