import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemberManagementPage extends HookConsumerWidget {
  const MemberManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final selectedFilter = useState<String>('전체');
    final isLoading = useState<bool>(false);

    // 더미 데이터 - 실제로는 API에서 가져올 데이터
    final members = [
      {
        'id': 1,
        'name': '김철수',
        'email': 'kimcs@email.com',
        'status': '활성',
        'joinDate': '2024-01-15',
        'lastLogin': '2024-03-10',
      },
      {
        'id': 2,
        'name': '이영희',
        'email': 'leeyh@email.com',
        'status': '활성',
        'joinDate': '2024-02-20',
        'lastLogin': '2024-03-09',
      },
      {
        'id': 3,
        'name': '박민수',
        'email': 'parkms@email.com',
        'status': '비활성',
        'joinDate': '2024-01-05',
        'lastLogin': '2024-02-28',
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
                  const Text(
                    '회원관리',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '전체 ${members.length}명의 회원을 관리합니다',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: 회원 추가 기능
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text(
                  '회원 추가',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 검색 및 필터 영역
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // 검색 필드
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: '이름, 이메일로 검색',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 상태 필터
                DropdownButton<String>(
                  value: selectedFilter.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedFilter.value = newValue;
                    }
                  },
                  items: ['전체', '활성', '비활성']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),

                const SizedBox(width: 12),

                // 새로고침 버튼
                IconButton(
                  onPressed: () {
                    isLoading.value = true;
                    // TODO: 데이터 새로고침
                    Future.delayed(const Duration(seconds: 1), () {
                      isLoading.value = false;
                    });
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Color(0xFF6B7280),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 회원 목록 테이블
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 테이블 헤더
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '이름',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            '이메일',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '상태',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '가입일',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '최근 로그인',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '관리',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 테이블 바디
                  Expanded(
                    child: ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  member['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  member['email'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: member['status'] == '활성'
                                        ? const Color(0xFFD1FAE5)
                                        : const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    member['status'].toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: member['status'] == '활성'
                                          ? const Color(0xFF065F46)
                                          : const Color(0xFF991B1B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  member['joinDate'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  member['lastLogin'].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: PopupMenuButton<String>(
                                  onSelected: (String result) {
                                    switch (result) {
                                      case 'edit':
                                        // TODO: 회원 정보 수정
                                        break;
                                      case 'delete':
                                        // TODO: 회원 삭제
                                        break;
                                      case 'activate':
                                        // TODO: 회원 활성화
                                        break;
                                      case 'deactivate':
                                        // TODO: 회원 비활성화
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('수정', style: TextStyle(fontSize: 12)),
                                    ),
                                    PopupMenuItem<String>(
                                      value: member['status'] == '활성' ? 'deactivate' : 'activate',
                                      child: Text(
                                        member['status'] == '활성' ? '비활성화' : '활성화',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('삭제', style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                  child: const Icon(
                                    Icons.more_vert,
                                    size: 16,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }
}