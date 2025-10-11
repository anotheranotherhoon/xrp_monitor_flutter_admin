import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword.dart';


part 'keyword_state.freezed.dart';

@freezed
abstract class KeywordState with _$KeywordState {
  const factory KeywordState({
    @Default([]) List<Keyword> positiveKeywords,
    @Default([]) List<Keyword> negativeKeywords,
    @Default([]) List<Keyword> importantKeywords,
    @Default(false) bool isFetching,
  }) = _KeywordState;
}