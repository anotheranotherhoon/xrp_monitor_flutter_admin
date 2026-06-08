import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/core/services/popup/models/popup_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/popup/popup_service.dart';
import 'package:xrp_monitor_flutter_admin/core/utils/popup_datetime_utils.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/popup/view_models/popup_view_model.dart';

class PopupManagementPage extends ConsumerWidget {
  const PopupManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popups = ref.watch(popupViewModelProvider);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '활성 팝업은 최대 10개이며 노출 순서대로 스와이프됩니다.',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showPopupDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('팝업 등록'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: popups.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('$error')),
              data:
                  (items) =>
                      items.isEmpty
                          ? const Center(child: Text('등록된 팝업이 없습니다.'))
                          : ListView.separated(
                            itemCount: items.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final popup = items[index];
                              return _PopupListItem(
                                popup: popup,
                                onEdit:
                                    () => _showPopupDialog(
                                      context,
                                      ref,
                                      popup: popup,
                                    ),
                                onDelete:
                                    () => _confirmDelete(context, ref, popup),
                                onToggle:
                                    () => ref
                                        .read(popupViewModelProvider.notifier)
                                        .togglePopup(popup.key),
                              );
                            },
                          ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPopupDialog(
    BuildContext context,
    WidgetRef ref, {
    PopupModel? popup,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PopupFormDialog(popup: popup),
    );
    await ref.read(popupViewModelProvider.notifier).refresh();
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PopupModel popup,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('팝업 삭제'),
            content: Text('${popup.title} 팝업을 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('취소'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('삭제'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await ref.read(popupViewModelProvider.notifier).deletePopup(popup.key);
    }
  }
}

class _PopupListItem extends StatelessWidget {
  const _PopupListItem({
    required this.popup,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  final PopupModel popup;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                popup.resolvedImageUrl,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const SizedBox(
                      width: 120,
                      height: 90,
                      child: Icon(Icons.broken_image),
                    ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${popup.displayOrder}. ${popup.title}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('시작: ${_formatPopupDateTime(popup.startAt)}'),
                  Text('종료: ${_formatPopupDateTime(popup.endAt)}'),
                  Text(
                    popup.actionType == PopupActionType.externalLink
                        ? '이동: 외부 링크 (${popup.linkUrl ?? '-'})'
                        : '이동: 없음',
                  ),
                  const SizedBox(height: 8),
                  _PopupExposureStatus(popup: popup),
                ],
              ),
            ),
            Switch(value: popup.isActive, onChanged: (_) => onToggle()),
            IconButton(onPressed: onEdit, icon: const Icon(Icons.edit)),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPopupDateTime(String? value) {
    final DateTime? dateTime = PopupDateTimeUtils.parseApiValue(value);
    return dateTime == null ? '제한 없음' : PopupDateTimeUtils.format(dateTime);
  }
}

class _PopupExposureStatus extends StatelessWidget {
  const _PopupExposureStatus({required this.popup});

  final PopupModel popup;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime? startAt = PopupDateTimeUtils.parseApiValue(popup.startAt);
    final DateTime? endAt = PopupDateTimeUtils.parseApiValue(popup.endAt);
    final String label;
    final Color color;

    if (!popup.isActive) {
      label = '비활성';
      color = Colors.grey;
    } else if (startAt != null && now.isBefore(startAt)) {
      label = '노출 예정';
      color = Colors.orange;
    } else if (endAt != null && now.isAfter(endAt)) {
      label = '노출 종료';
      color = Colors.red;
    } else {
      label = '노출 중';
      color = Colors.green;
    }

    return Chip(
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color),
      label: Text(label, style: TextStyle(color: color)),
    );
  }
}

class _PopupFormDialog extends ConsumerStatefulWidget {
  const _PopupFormDialog({this.popup});

  final PopupModel? popup;

  @override
  ConsumerState<_PopupFormDialog> createState() => _PopupFormDialogState();
}

class _PopupFormDialogState extends ConsumerState<_PopupFormDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _orderController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final TextEditingController _linkController;
  DateTime? _startAt;
  DateTime? _endAt;
  PopupActionType _actionType = PopupActionType.none;
  bool _isActive = true;
  bool _isSaving = false;
  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void initState() {
    super.initState();
    final popup = widget.popup;
    _titleController = TextEditingController(text: popup?.title ?? '');
    _orderController = TextEditingController(
      text: '${popup?.displayOrder ?? 1}',
    );
    _startAt = PopupDateTimeUtils.parseApiValue(popup?.startAt);
    _endAt = PopupDateTimeUtils.parseApiValue(popup?.endAt);
    _startController = TextEditingController(
      text: PopupDateTimeUtils.format(_startAt),
    );
    _endController = TextEditingController(
      text: PopupDateTimeUtils.format(_endAt),
    );
    _actionType = popup?.actionType ?? PopupActionType.none;
    _linkController = TextEditingController(text: popup?.linkUrl ?? '');
    _isActive = popup?.isActive ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _orderController.dispose();
    _startController.dispose();
    _endController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.popup == null ? '팝업 등록' : '팝업 수정'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _imagePreview(),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: Text(_imageName ?? '이미지 선택 (JPG, PNG, WebP / 5MB 이하)'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '관리용 제목'),
              ),
              TextField(
                controller: _orderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: '노출 순서 (1~10)'),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '이미지 클릭 동작',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Row(
                children:
                    PopupActionType.values
                        .map(
                          (PopupActionType type) => Expanded(
                            child: RadioListTile<PopupActionType>(
                              contentPadding: EdgeInsets.zero,
                              title: Text(type.label),
                              value: type,
                              groupValue: _actionType,
                              onChanged: (PopupActionType? value) {
                                if (value == null) return;
                                setState(() {
                                  _actionType = value;
                                  if (value == PopupActionType.none) {
                                    _linkController.clear();
                                  }
                                });
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
              if (_actionType == PopupActionType.externalLink) ...<Widget>[
                const SizedBox(height: 12),
                TextField(
                  controller: _linkController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: '외부 링크 주소',
                    hintText: 'https://example.com',
                  ),
                ),
              ],
              const SizedBox(height: 12),
              _dateTimeField(
                controller: _startController,
                label: '노출 시작일',
                value: _startAt,
                onChanged: (DateTime? value) => _setStartAt(value),
              ),
              const SizedBox(height: 12),
              _dateTimeField(
                controller: _endController,
                label: '노출 종료일',
                value: _endAt,
                onChanged: (DateTime? value) => _setEndAt(value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('활성화'),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: Text(_isSaving ? '저장 중...' : '저장'),
        ),
      ],
    );
  }

  Widget _imagePreview() {
    if (_imageBytes != null) {
      return Image.memory(_imageBytes!, height: 220, fit: BoxFit.contain);
    }
    final popup = widget.popup;
    if (popup != null) {
      return Image.network(
        popup.resolvedImageUrl,
        height: 220,
        fit: BoxFit.contain,
      );
    }
    return const SizedBox(
      height: 160,
      child: Center(child: Icon(Icons.image_outlined, size: 64)),
    );
  }

  Widget _dateTimeField({
    required TextEditingController controller,
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickDateTime(value, onChanged),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'yyyy-MM-dd HH:mm:ss',
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (value != null)
              IconButton(
                tooltip: '설정 해제',
                onPressed: () => onChanged(null),
                icon: const Icon(Icons.clear),
              ),
            IconButton(
              tooltip: '날짜 및 시간 선택',
              onPressed: () => _pickDateTime(value, onChanged),
              icon: const Icon(Icons.calendar_month),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime(
    DateTime? currentValue,
    ValueChanged<DateTime?> onChanged,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime initialValue = currentValue ?? now;
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialValue,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10, 12, 31),
    );
    if (selectedDate == null || !mounted) return;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialValue),
    );
    if (selectedTime == null) return;

    onChanged(
      DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );
  }

  void _setStartAt(DateTime? value) {
    setState(() {
      _startAt = value;
      _startController.text = PopupDateTimeUtils.format(value);
    });
  }

  void _setEndAt(DateTime? value) {
    setState(() {
      _endAt = value;
      _endController.text = PopupDateTimeUtils.format(value);
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      withData: true,
    );
    final file = result?.files.single;
    if (file == null || file.bytes == null) return;
    if (file.size > 5 * 1024 * 1024) {
      _showError('이미지는 5MB 이하만 업로드할 수 있습니다.');
      return;
    }
    setState(() {
      _imageBytes = file.bytes;
      _imageName = file.name;
    });
  }

  Future<void> _save() async {
    final String title = _titleController.text.trim();
    final int? order = int.tryParse(_orderController.text);
    final String linkUrl = _linkController.text.trim();
    if (title.isEmpty || order == null || order < 1 || order > 10) {
      _showError('제목과 1~10 사이의 노출 순서를 입력해주세요.');
      return;
    }
    if (widget.popup == null && _imageBytes == null) {
      _showError('팝업 이미지를 선택해주세요.');
      return;
    }
    if (_startAt != null && _endAt != null && _endAt!.isBefore(_startAt!)) {
      _showError('노출 종료일은 시작일보다 이후여야 합니다.');
      return;
    }
    if (_actionType == PopupActionType.externalLink &&
        !_isValidExternalUrl(linkUrl)) {
      _showError('http:// 또는 https://로 시작하는 링크 주소를 입력해주세요.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final PopupService service = ref.read(popupServiceProvider.notifier);
      final String? savedLinkUrl =
          _actionType == PopupActionType.externalLink ? linkUrl : null;
      if (widget.popup == null) {
        await service.createPopup(
          title: title,
          displayOrder: order,
          startAt: PopupDateTimeUtils.toApiValue(_startAt),
          endAt: PopupDateTimeUtils.toApiValue(_endAt),
          isActive: _isActive,
          actionType: _actionType,
          linkUrl: savedLinkUrl,
          imageBytes: _imageBytes!,
          imageName: _imageName!,
        );
      } else {
        await service.updatePopup(
          id: widget.popup!.key,
          title: title,
          displayOrder: order,
          startAt: PopupDateTimeUtils.toApiValue(_startAt),
          endAt: PopupDateTimeUtils.toApiValue(_endAt),
          isActive: _isActive,
          actionType: _actionType,
          linkUrl: savedLinkUrl,
          imageBytes: _imageBytes,
          imageName: _imageName,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (error) {
      _showError('$error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  bool _isValidExternalUrl(String value) {
    final Uri? uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}
