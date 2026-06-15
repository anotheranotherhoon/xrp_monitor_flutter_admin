import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/pagination.dart';
import 'package:xrp_monitor_flutter_admin/core/services/notification/models/notification_history.dart';
import 'package:xrp_monitor_flutter_admin/core/services/notification/notification_service.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/user_service.dart';

class NotificationManagementPage extends ConsumerStatefulWidget {
  const NotificationManagementPage({super.key});

  @override
  ConsumerState<NotificationManagementPage> createState() =>
      _NotificationManagementPageState();
}

class _NotificationManagementPageState
    extends ConsumerState<NotificationManagementPage> {
  NotificationHistoryPage? _historyPage;
  bool _isLoading = true;
  String? _error;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(notificationAdminServiceProvider)
          .getHistories(page: _page);
      if (!mounted) return;
      setState(() => _historyPage = result);
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showSendDialog() async {
    final sent = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _NotificationComposeDialog(),
    );
    if (sent == true) {
      _page = 1;
      await _load();
    }
  }

  void _showRecipients(NotificationHistory history) {
    showDialog<void>(
      context: context,
      builder: (_) => _NotificationRecipientsDialog(history: history),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '발송한 푸시 메시지와 처리 결과를 확인합니다.',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('새로고침'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _showSendDialog,
                icon: const Icon(Icons.send),
                label: const Text('알림 발송'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildBody()),
          if (_historyPage != null) _buildPagination(_historyPage!.pagination),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }
    final histories = _historyPage?.histories ?? const <NotificationHistory>[];
    if (histories.isEmpty) {
      return const Center(child: Text('발송 내역이 없습니다.'));
    }
    return ListView.separated(
      itemCount: histories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder:
          (_, index) => _NotificationHistoryCard(
            history: histories[index],
            onTap: () => _showRecipients(histories[index]),
          ),
    );
  }

  Widget _buildPagination(Pagination pagination) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed:
                pagination.currentPage > 1
                    ? () {
                      _page--;
                      _load();
                    }
                    : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            '${pagination.currentPage} / ${pagination.lastPage == 0 ? 1 : pagination.lastPage}',
          ),
          IconButton(
            onPressed:
                pagination.currentPage < pagination.lastPage
                    ? () {
                      _page++;
                      _load();
                    }
                    : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _NotificationHistoryCard extends StatelessWidget {
  const _NotificationHistoryCard({required this.history, required this.onTap});

  final NotificationHistory history;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = history.isFailed ? Colors.red : Colors.green;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      history.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      history.isFailed ? '발송 오류' : '처리 완료',
                      style: TextStyle(color: statusColor, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
                ],
              ),
              const SizedBox(height: 8),
              Text(history.body),
              const SizedBox(height: 14),
              Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  Text('선택 회원 ${history.requestedUsers}명'),
                  Text('대상 기기 ${history.targetDevices}대'),
                  Text('성공 ${history.sent}건'),
                  Text('실패 ${history.failed}건'),
                  Text(
                    DateFormat(
                      'yyyy-MM-dd HH:mm:ss',
                    ).format(history.createdAt.toLocal()),
                  ),
                ],
              ),
              if (history.errorMessage?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  history.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationRecipientsDialog extends ConsumerStatefulWidget {
  const _NotificationRecipientsDialog({required this.history});

  final NotificationHistory history;

  @override
  ConsumerState<_NotificationRecipientsDialog> createState() =>
      _NotificationRecipientsDialogState();
}

class _NotificationRecipientsDialogState
    extends ConsumerState<_NotificationRecipientsDialog> {
  late final Future<NotificationRecipients> _recipients;

  @override
  void initState() {
    super.initState();
    _recipients = ref
        .read(notificationAdminServiceProvider)
        .getRecipients(widget.history.id);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.history.title} 수신 회원'),
      content: SizedBox(
        width: 620,
        height: 500,
        child: FutureBuilder<NotificationRecipients>(
          future: _recipients,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '수신 회원을 불러오지 못했습니다.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final result = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '선택 회원 ${widget.history.requestedUsers}명',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      for (final recipient in result.recipients)
                        ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              recipient.nickname.isEmpty
                                  ? recipient.email.isEmpty
                                      ? '?'
                                      : recipient.email.characters.first
                                          .toUpperCase()
                                  : recipient.nickname.characters.first
                                      .toUpperCase(),
                            ),
                          ),
                          title: Text(
                            recipient.nickname.isEmpty
                                ? '닉네임 없음'
                                : recipient.nickname,
                          ),
                          subtitle: Text(
                            '${recipient.email} · 회원 ID ${recipient.id}',
                          ),
                          trailing: Text(
                            recipient.isActive ? '활성' : '비활성',
                            style: TextStyle(
                              color:
                                  recipient.isActive
                                      ? Colors.green
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      for (final userId in result.missingUserIds)
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person_off),
                          ),
                          title: const Text('삭제된 회원'),
                          subtitle: Text('회원 ID $userId'),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}

class _NotificationComposeDialog extends ConsumerStatefulWidget {
  const _NotificationComposeDialog();

  @override
  ConsumerState<_NotificationComposeDialog> createState() =>
      _NotificationComposeDialogState();
}

class _NotificationComposeDialogState
    extends ConsumerState<_NotificationComposeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  Set<User> _selectedUsers = {};
  bool _isSending = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _selectUsers() async {
    final users = await showDialog<Set<User>>(
      context: context,
      builder: (_) => _UserSelectionDialog(initialUsers: _selectedUsers),
    );
    if (users != null) setState(() => _selectedUsers = users);
  }

  Future<void> _send() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedUsers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('알림을 받을 회원을 선택하세요.')));
      return;
    }
    setState(() => _isSending = true);
    try {
      await ref
          .read(notificationAdminServiceProvider)
          .send(
            userIds: _selectedUsers.map((user) => user.key).toList(),
            title: _titleController.text.trim(),
            body: _bodyController.text.trim(),
          );
      if (!mounted) return;
      Navigator.pop(context, true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('FCM 알림을 발송했습니다.')));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('알림 발송 실패: $error')));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('알림 발송'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedUsers.isEmpty
                          ? '선택된 회원이 없습니다.'
                          : '${_selectedUsers.length}명 선택됨',
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _selectUsers,
                    icon: const Icon(Icons.people),
                    label: const Text('회원 선택'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                maxLength: 100,
                decoration: const InputDecoration(labelText: '제목'),
                validator:
                    (value) =>
                        value?.trim().isEmpty != false ? '제목을 입력하세요.' : null,
              ),
              TextFormField(
                controller: _bodyController,
                maxLength: 1000,
                minLines: 4,
                maxLines: 8,
                decoration: const InputDecoration(labelText: '내용'),
                validator:
                    (value) =>
                        value?.trim().isEmpty != false ? '내용을 입력하세요.' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSending ? null : () => Navigator.pop(context, false),
          child: const Text('취소'),
        ),
        FilledButton.icon(
          onPressed: _isSending ? null : _send,
          icon:
              _isSending
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.send),
          label: const Text('발송'),
        ),
      ],
    );
  }
}

class _UserSelectionDialog extends ConsumerStatefulWidget {
  const _UserSelectionDialog({required this.initialUsers});

  final Set<User> initialUsers;

  @override
  ConsumerState<_UserSelectionDialog> createState() =>
      _UserSelectionDialogState();
}

class _UserSelectionDialogState extends ConsumerState<_UserSelectionDialog> {
  late Set<User> _selectedUsers;
  List<User> _users = [];
  bool _isLoading = true;
  String _query = '';
  int _page = 1;
  int _lastPage = 1;
  bool _isSelectingAll = false;

  @override
  void initState() {
    super.initState();
    _selectedUsers = Set<User>.from(widget.initialUsers);
    Future.microtask(_loadUsers);
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final response = await ref
          .read(userServiceProvider.notifier)
          .getUsers(page: _page, perPage: 10);
      if (!mounted) return;
      setState(() {
        _users = response.result ?? [];
        _lastPage = response.page?.lastPage ?? 1;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectAllUsers() async {
    setState(() => _isSelectingAll = true);
    try {
      final users = await ref.read(userServiceProvider.notifier).getAllUsers();
      if (!mounted) return;
      setState(() => _selectedUsers = users.toSet());
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('전체 회원 조회 실패: $error')));
    } finally {
      if (mounted) setState(() => _isSelectingAll = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        _users.where((user) {
          final query = _query.toLowerCase();
          return user.email.toLowerCase().contains(query) ||
              user.nickname.toLowerCase().contains(query);
        }).toList();
    return AlertDialog(
      title: const Text('회원 선택'),
      content: SizedBox(
        width: 620,
        height: 520,
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '현재 페이지에서 이메일 또는 닉네임 검색',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('${_selectedUsers.length}명 선택됨'),
                const Spacer(),
                TextButton(
                  onPressed: _isSelectingAll ? null : _selectAllUsers,
                  child:
                      _isSelectingAll
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('전체 선택'),
                ),
                TextButton(
                  onPressed:
                      _selectedUsers.isEmpty
                          ? null
                          : () => setState(_selectedUsers.clear),
                  child: const Text('전체 선택 해제'),
                ),
              ],
            ),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, index) {
                          final user = filtered[index];
                          final selected = _selectedUsers.any(
                            (item) => item.key == user.key,
                          );
                          return CheckboxListTile(
                            value: selected,
                            title: Text(
                              user.nickname.isEmpty ? '닉네임 없음' : user.nickname,
                            ),
                            subtitle: Text(user.email),
                            onChanged: (checked) {
                              setState(() {
                                _selectedUsers.removeWhere(
                                  (item) => item.key == user.key,
                                );
                                if (checked == true) _selectedUsers.add(user);
                              });
                            },
                          );
                        },
                      ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:
                      _page > 1
                          ? () {
                            _page--;
                            _loadUsers();
                          }
                          : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text('$_page / $_lastPage'),
                IconButton(
                  onPressed:
                      _page < _lastPage
                          ? () {
                            _page++;
                            _loadUsers();
                          }
                          : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _selectedUsers),
          child: const Text('선택 완료'),
        ),
      ],
    );
  }
}
