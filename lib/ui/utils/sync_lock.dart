/*
 * Simple lock
 * 락 걸린 상태에서는 모든 시도 무시
 * 대기후 실행이 필요한 경우 mutex 사용
 */
import 'package:flutter/cupertino.dart';

/// Simple try lock and return success or not
class SyncLock {
  bool _locked = false;
  bool get locked => _locked;

  /// Try get lock and return result
  /// [release] must be called after acquired
  bool tryAcquire() {
    if (_locked) {
      return false;
    }
    _locked = true;
    return true;
  }

  /// Release state
  void release() {
    _locked = false;
  }

  /// Acquire and release automatically
  /// [callback] will be executed only if acquired
  Future<bool> protect(Future<void> Function() callback) async {
    if (!tryAcquire()) {
      return false;
    }
    try {
      await callback();
      return true;
    } finally {
      release();
    }
  }
}

class SyncLockNotifier extends ChangeNotifier implements SyncLock {
  @override
  bool _locked = false;
  @override
  bool get locked => _locked;

  @override
  Future<bool> protect(Future<void> Function() callback) async {
    if (!tryAcquire()) {
      return false;
    }
    try {
      await callback();
      return true;
    } finally {
      release();
    }
  }

  @override
  void release() {
    _locked = false;
    notifyListeners();
  }

  @override
  bool tryAcquire() {
    if (_locked) {
      return false;
    }
    _locked = true;
    notifyListeners();
    return true;
  }
}