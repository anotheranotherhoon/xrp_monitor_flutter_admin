import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword_create_request.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword_type.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword_update_request.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/keyword/models/keyword_state.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/keyword/view_models/keyword_view_model.dart';
import 'package:xrp_monitor_flutter_admin/widgets/base/widget_controller.dart';

part 'keyword_management_page.controller.dart';

class KeywordManagementPage extends HookConsumerWidget {
  const KeywordManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final KeywordManagementPageController controller = useWidgetController(() => KeywordManagementPageController(ref: ref), context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('키워드 관리',
          style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111827),
        ),),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          TextButton.icon(
            onPressed: () => _showCreateDialog(context, ref, controller.refresh),
            icon: const Icon(Icons.add, color: Colors.blue),
            label: const Text('키워드 추가', style: TextStyle(color: Colors.blue)),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: ref.watch(keywordViewModelProvider).when(
          data: (KeywordState keywordState) {
            return _buildContent(keywordState, ref, controller.refresh
            );
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

  Widget _buildContent(
      KeywordState data,
      WidgetRef ref,
      VoidCallback refresh
      ) {


    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildKeywordSection(
                    '긍정 키워드',
                    data.positiveKeywords,
                    Colors.green,
                    ref,
                    refresh
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _buildKeywordSection(
                    '부정 키워드',
                    data.negativeKeywords,
                    Colors.red,
                    ref,
                      refresh
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: _buildKeywordSection(
                    '중요 키워드',
                    data.importantKeywords,
                    Colors.orange,
                    ref,
                      refresh
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordSection(
    String title,
    List<Keyword> keywords,
    Color color,
    WidgetRef ref,
      VoidCallback refresh
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.label, color: color, size: 20),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${keywords.length}개',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: keywords.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                        SizedBox(height: 8),
                        Text(
                          '키워드가 없습니다',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: keywords.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final keyword = keywords[index];
                      return _buildKeywordCard(context, keyword, color, ref, refresh);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordCard(
    BuildContext context,
    Keyword keyword,
    Color color,
    WidgetRef ref,
      VoidCallback refresh
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  keyword.keyword,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: keyword.isActive ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  keyword.isActive ? '활성' : '비활성',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up, size: 14, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                '가중치: ${keyword.weight}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showEditDialog(context, ref, keyword, refresh),
                child: Icon(Icons.edit, size: 16, color: Colors.blue),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () => _showDeleteDialog(context, ref, keyword, refresh),
                child: Icon(Icons.delete, size: 16, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref, VoidCallback refresh) {
    showDialog(
      context: context,
      builder: (context) => _CreateKeywordDialog(
        onCreated: refresh,
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Keyword keyword,
    VoidCallback refresh,
  ) {
    showDialog(
      context: context,
      builder: (context) => _EditKeywordDialog(
        keyword: keyword,
        onUpdated: refresh,
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Keyword keyword,
    VoidCallback refresh,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('키워드 삭제'),
        content: Text('\'${keyword.keyword}\' 키워드를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final controller = ref.read(keywordManagementPageControllerProvider(ref));
              await controller.handleDeleteKeyword(context, keyword.id, keyword.keyword);
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _CreateKeywordDialog extends ConsumerStatefulWidget {
  final VoidCallback onCreated;

  const _CreateKeywordDialog({required this.onCreated});

  @override
  ConsumerState<_CreateKeywordDialog> createState() => _CreateKeywordDialogState();
}

class _CreateKeywordDialogState extends ConsumerState<_CreateKeywordDialog> {
  final keywordController = TextEditingController();
  final weightController = TextEditingController();
  KeywordType selectedType = KeywordType.POSITIVE;

  @override
  void dispose() {
    keywordController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text('키워드 추가'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keywordController,
              decoration: const InputDecoration(
                labelText: '키워드',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '가중치',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<KeywordType>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: '타입',
                border: OutlineInputBorder(),
              ),
              items: KeywordType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            final controller = ref.read(keywordManagementPageControllerProvider(ref));
            await controller.handleCreateKeyword(
              context,
              keywordController.text,
              weightController.text,
              selectedType,
              widget.onCreated,
            );
          },
          child: const Text('생성'),
        ),
      ],
    );
  }
}

class _EditKeywordDialog extends ConsumerStatefulWidget {
  final Keyword keyword;
  final VoidCallback onUpdated;

  const _EditKeywordDialog({
    required this.keyword,
    required this.onUpdated,
  });

  @override
  ConsumerState<_EditKeywordDialog> createState() => _EditKeywordDialogState();
}

class _EditKeywordDialogState extends ConsumerState<_EditKeywordDialog> {
  late final TextEditingController keywordController;
  late final TextEditingController weightController;
  late KeywordType selectedType;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    keywordController = TextEditingController(text: widget.keyword.keyword);
    weightController = TextEditingController(text: widget.keyword.weight);
    selectedType = widget.keyword.type;
    isActive = widget.keyword.isActive;
  }

  @override
  void dispose() {
    keywordController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text('키워드 수정'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keywordController,
              decoration: const InputDecoration(
                labelText: '키워드',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '가중치',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<KeywordType>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: '타입',
                border: OutlineInputBorder(),
              ),
              items: KeywordType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedType = value;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isActive,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        isActive = value;
                      });
                    }
                  },
                ),
                const Text('활성화'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () async {
            final controller = ref.read(keywordManagementPageControllerProvider(ref));
            await controller.handleUpdateKeyword(
              context,
              widget.keyword.id,
              keywordController.text,
              weightController.text,
              selectedType,
              isActive,
              widget.onUpdated,
            );
          },
          child: const Text('수정'),
        ),
      ],
    );
  }
}