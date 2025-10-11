import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/ui/layout/common_style.dart';
import 'package:xrp_monitor_flutter_admin/widgets/base/widget_controller.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/version/view_models/version_view_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/version/models/version_model.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/version/models/version_state.dart';

part 'version_management_page.controller.dart';

class VersionManagementPage extends HookConsumerWidget {
  const VersionManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = useState<int>(0);
    
    // 탭 변경 시 API 요청
    useEffect(() {
      final platform = selectedTab.value == 0 ? null : 
                      selectedTab.value == 1 ? 'android' : 'ios';
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(versionViewModelProvider.notifier).fetchVersionsByPlatform(platform);
      });
      
      return null;
    }, [selectedTab.value]);
    
    return ref.watch(versionViewModelProvider).when(
      data: (VersionState state) {
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
                    onPressed: () async {
                      await _showCreateVersionDialog(context, ref, selectedTab);
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
                            onTap: () {
                              selectedTab.value = 0;
                            },
                          ),
                          _buildTabButton(
                            title: 'Android',
                            isSelected: selectedTab.value == 1,
                            onTap: () {
                              selectedTab.value = 1;
                            },
                          ),
                          _buildTabButton(
                            title: 'iOS',
                            isSelected: selectedTab.value == 2,
                            onTap: () {
                              selectedTab.value = 2;
                            },
                          ),
                        ],
                      ),
                    ),

                    // 버전 목록
                    Container(
                      height: 400,
                      padding: const EdgeInsets.all(20),
                      child: state.isLoading
                          ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF3B82F6)),
                        ),
                      )
                          : state.version.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              '버전이 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        itemCount: state.version.length,
                        itemBuilder: (context, index) {
                          final Version version = state.version[index];
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
                                              color: version.platform.toLowerCase() == 'android'
                                                  ? const Color(0xFFDCFCE7)
                                                  : const Color(0xFFDBEAFE),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              version.platform,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: version.platform.toLowerCase() == 'android'
                                                    ? const Color(0xFF166534)
                                                    : const Color(0xFF1E40AF),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'v${version.version}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF111827),
                                            ),
                                          ),
                                          if (version.appStatus == 2) ...[
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
                                        version.releaseNotes.isNotEmpty ? version.releaseNotes : '릴리즈 노트 없음',
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
                                            version.createdAt.isNotEmpty ? version.createdAt.split('T')[0] : '날짜 없음',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: const Color(0xFF6B7280),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: version.isActive 
                                                  ? const Color(0xFFD1FAE5)
                                                  : const Color(0xFFF3F4F6),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  version.isActive ? Icons.check_circle : Icons.cancel,
                                                  size: 12,
                                                  color: version.isActive 
                                                      ? const Color(0xFF065F46)
                                                      : const Color(0xFF6B7280),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  version.isActive ? '활성' : '비활성',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: version.isActive 
                                                        ? const Color(0xFF065F46)
                                                        : const Color(0xFF6B7280),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
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
                                        color: _getStatusColor(version.appStatus),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        _getStatusText(version.appStatus),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _getStatusTextColor(version.appStatus),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await _showEditVersionDialog(context, ref, version, selectedTab);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: const Color(0xFF6B7280),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            await _showDeleteConfirmDialog(context, ref, version, selectedTab);
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
      },
        loading: () => _buildLoading(),
      error: (error, stackTrace) => _buildError(error.toString()),
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
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ],
      ),
    );
  }
  
  // Widget _buildContent(
  //   BuildContext context,
  //   WidgetRef ref,
  //   ValueNotifier<int> selectedTab,
  //   List<Version> versions,
  //   bool isLoading,
  //   String? error,
  // ) {
  //
  //   if (error != null) {
  //     return Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(Icons.error_outline, size: 64, color: Colors.red),
  //           SizedBox(height: 16),
  //           Text(
  //             '오류가 발생했습니다',
  //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 8),
  //           Text(
  //             error,
  //             style: TextStyle(color: Colors.red),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //
  // }

  // 상태별 색상 및 텍스트 함수들
  Color _getStatusColor(int appStatus) {
    switch (appStatus) {
      case 1: return const Color(0xFFD1FAE5); // 정상 - 초록
      case 2: return const Color(0xFFFEE2E2); // 강제업데이트 - 빨강
      case 3: return const Color(0xFFFEF3C7); // 점검중 - 노랑
      default: return const Color(0xFFF3F4F6); // 기타 - 회색
    }
  }
  
  Color _getStatusTextColor(int appStatus) {
    switch (appStatus) {
      case 1: return const Color(0xFF065F46); // 정상
      case 2: return const Color(0xFF991B1B); // 강제업데이트  
      case 3: return const Color(0xFF92400E); // 점검중
      default: return const Color(0xFF374151); // 기타
    }
  }
  
  String _getStatusText(int appStatus) {
    switch (appStatus) {
      case 1: return '정상';
      case 2: return '강제업데이트';
      case 3: return '점검중';
      default: return '알 수 없음';
    }
  }

  // 버전 생성 다이얼로그
  Future<void> _showCreateVersionDialog(BuildContext context, WidgetRef ref, ValueNotifier<int> selectedTab) async {
    final formKey = GlobalKey<FormState>();
    final versionController = TextEditingController();
    final platformController = TextEditingController(text: 'android');
    final minimumVersionController = TextEditingController();
    final releaseNotesController = TextEditingController();
    final downloadUrlController = TextEditingController();
    final apiDomainController = TextEditingController();
    final reviewVersionController = TextEditingController();
    final shorebirdVersionController = TextEditingController();
    
    int appStatus = 1;
    bool isActive = true;
    String deploymentStatus = 'DEVELOPMENT';
    
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('새 버전 추가'),
          content: Container(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: versionController,
                      decoration: InputDecoration(labelText: '버전'),
                      validator: (value) => value?.isEmpty == true ? '버전을 입력하세요' : null,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: platformController.text,
                      decoration: InputDecoration(labelText: '플랫폼'),
                      items: ['android', 'ios'].map((platform) => 
                        DropdownMenuItem(value: platform, child: Text(platform))).toList(),
                      onChanged: (value) => platformController.text = value ?? 'android',
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: minimumVersionController,
                      decoration: InputDecoration(labelText: '최소 버전'),
                      validator: (value) => value?.isEmpty == true ? '최소 버전을 입력하세요' : null,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: appStatus,
                      decoration: InputDecoration(labelText: '앱 상태'),
                      items: [
                        DropdownMenuItem(value: 1, child: Text('정상')),
                        DropdownMenuItem(value: 2, child: Text('강제업데이트')),
                        DropdownMenuItem(value: 3, child: Text('점검중')),
                      ],
                      onChanged: (value) => setState(() => appStatus = value ?? 1),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: releaseNotesController,
                      decoration: InputDecoration(labelText: '릴리즈 노트'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: downloadUrlController,
                      decoration: InputDecoration(labelText: '다운로드 URL'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: apiDomainController,
                      decoration: InputDecoration(labelText: 'API 도메인'),
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('활성화'),
                      value: isActive,
                      onChanged: (value) => setState(() => isActive = value),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: reviewVersionController,
                      decoration: InputDecoration(labelText: '리뷰 버전'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: shorebirdVersionController,
                      decoration: InputDecoration(labelText: 'Shorebird 버전'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: deploymentStatus,
                      decoration: InputDecoration(labelText: '배포 상태'),
                      items: [
                        DropdownMenuItem(value: 'DEPLOYING', child: Text('배포중')),
                        DropdownMenuItem(value: 'IN_REVIEW', child: Text('심사중')),
                        DropdownMenuItem(value: 'REVIEW_COMPLETE', child: Text('심사완료')),
                        DropdownMenuItem(value: 'DEVELOPMENT', child: Text('개발중')),
                      ],
                      onChanged: (value) => setState(() => deploymentStatus = value ?? 'DEVELOPMENT'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  final params = CreateVersionParams(
                    veVersion: versionController.text,
                    vePlatform: platformController.text,
                    veMinimumVersion: minimumVersionController.text,
                    veAppStatus: appStatus,
                    veReleaseNotes: releaseNotesController.text,
                    veDownloadUrl: downloadUrlController.text,
                    veApiDomain: apiDomainController.text,
                    veIsActive: isActive,
                    veReviewVersion: reviewVersionController.text,
                    veShorebirdVersion: shorebirdVersionController.text,
                    veDeploymentStatus: deploymentStatus,
                  );
                  
                  final viewModel = ref.read(versionViewModelProvider.notifier);
                  final result = await viewModel.createVersion(params);
                  
                  if (result.success) {
                    Navigator.pop(context);
                    // 현재 선택된 탭에 맞는 데이터 다시 로드
                    final platform = selectedTab.value == 0 ? null : 
                                    selectedTab.value == 1 ? 'android' : 'ios';
                    ref.read(versionViewModelProvider.notifier).fetchVersionsByPlatform(platform);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('버전이 생성되었습니다')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('버전 생성에 실패했습니다')),
                    );
                  }
                }
              },
              child: Text('생성'),
            ),
          ],
        ),
      ),
    );
  }

  // 버전 수정 다이얼로그
  Future<void> _showEditVersionDialog(BuildContext context, WidgetRef ref, Version version, ValueNotifier<int> selectedTab) async {
    final formKey = GlobalKey<FormState>();
    final versionController = TextEditingController(text: version.version);
    final platformController = TextEditingController(text: version.platform);
    final minimumVersionController = TextEditingController(text: version.minimumVersion);
    final releaseNotesController = TextEditingController(text: version.releaseNotes);
    final downloadUrlController = TextEditingController(text: version.downloadUrl);
    final apiDomainController = TextEditingController(text: version.apiDomain);
    final reviewVersionController = TextEditingController(text: version.reviewVersion);
    final shorebirdVersionController = TextEditingController(text: version.shorebirdVersion);
    
    int appStatus = version.appStatus;
    bool isActive = version.isActive;
    String deploymentStatus = version.deploymentStatus.isNotEmpty ? version.deploymentStatus : 'DEVELOPMENT';
    
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('버전 수정'),
          content: Container(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: versionController,
                      decoration: InputDecoration(labelText: '버전'),
                      validator: (value) => value?.isEmpty == true ? '버전을 입력하세요' : null,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: platformController.text,
                      decoration: InputDecoration(labelText: '플랫폼'),
                      items: ['android', 'ios'].map((platform) => 
                        DropdownMenuItem(value: platform, child: Text(platform))).toList(),
                      onChanged: (value) => platformController.text = value ?? 'android',
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: minimumVersionController,
                      decoration: InputDecoration(labelText: '최소 버전'),
                      validator: (value) => value?.isEmpty == true ? '최소 버전을 입력하세요' : null,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: appStatus,
                      decoration: InputDecoration(labelText: '앱 상태'),
                      items: [
                        DropdownMenuItem(value: 1, child: Text('정상')),
                        DropdownMenuItem(value: 2, child: Text('강제업데이트')),
                        DropdownMenuItem(value: 3, child: Text('점검중')),
                      ],
                      onChanged: (value) => setState(() => appStatus = value ?? 1),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: releaseNotesController,
                      decoration: InputDecoration(labelText: '릴리즈 노트'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: downloadUrlController,
                      decoration: InputDecoration(labelText: '다운로드 URL'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: apiDomainController,
                      decoration: InputDecoration(labelText: 'API 도메인'),
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('활성화'),
                      value: isActive,
                      onChanged: (value) => setState(() => isActive = value),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: reviewVersionController,
                      decoration: InputDecoration(labelText: '리뷰 버전'),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: shorebirdVersionController,
                      decoration: InputDecoration(labelText: 'Shorebird 버전'),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: deploymentStatus,
                      decoration: InputDecoration(labelText: '배포 상태'),
                      items: [
                        DropdownMenuItem(value: 'DEPLOYING', child: Text('배포중')),
                        DropdownMenuItem(value: 'IN_REVIEW', child: Text('심사중')),
                        DropdownMenuItem(value: 'REVIEW_COMPLETE', child: Text('심사완료')),
                        DropdownMenuItem(value: 'DEVELOPMENT', child: Text('개발중')),
                      ],
                      onChanged: (value) => setState(() => deploymentStatus = value ?? 'DEVELOPMENT'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() == true) {
                  final params = CreateVersionParams(
                    veVersion: versionController.text,
                    vePlatform: platformController.text,
                    veMinimumVersion: minimumVersionController.text,
                    veAppStatus: appStatus,
                    veReleaseNotes: releaseNotesController.text,
                    veDownloadUrl: downloadUrlController.text,
                    veApiDomain: apiDomainController.text,
                    veIsActive: isActive,
                    veReviewVersion: reviewVersionController.text,
                    veShorebirdVersion: shorebirdVersionController.text,
                    veDeploymentStatus: deploymentStatus,
                  );
                  
                  final viewModel = ref.read(versionViewModelProvider.notifier);
                  final result = await viewModel.updateVersion(version.key, params);
                  
                  if (result.success) {
                    Navigator.pop(context);
                    // 현재 선택된 탭에 맞는 데이터 다시 로드
                    final platform = selectedTab.value == 0 ? null : 
                                    selectedTab.value == 1 ? 'android' : 'ios';
                    ref.read(versionViewModelProvider.notifier).fetchVersionsByPlatform(platform);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('버전이 수정되었습니다')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('버전 수정에 실패했습니다')),
                    );
                  }
                }
              },
              child: Text('수정'),
            ),
          ],
        ),
      ),
    );
  }

  // 버전 삭제 확인 다이얼로그
  Future<void> _showDeleteConfirmDialog(BuildContext context, WidgetRef ref, Version version, ValueNotifier<int> selectedTab) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('버전 삭제'),
        content: Text('버전 v${version.version}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final viewModel = ref.read(versionViewModelProvider.notifier);
              final result = await viewModel.deleteVersion(version.key);
              
              if (result.success) {
                Navigator.pop(context);
                // 현재 선택된 탭에 맞는 데이터 다시 로드
                final platform = selectedTab.value == 0 ? null : 
                                selectedTab.value == 1 ? 'android' : 'ios';
                ref.read(versionViewModelProvider.notifier).fetchVersionsByPlatform(platform);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('버전이 삭제되었습니다')),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('버전 삭제에 실패했습니다')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('삭제', style: TextStyle(color: Colors.white)),
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