import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/version/models/version_model.dart';

part 'version_state.freezed.dart';

@freezed
abstract class VersionState with _$VersionState {
  const factory VersionState({
    @Default([]) List<Version> version,
    @Default(false) bool isLoading,
    String? error,
  }) = _VersionState;
}