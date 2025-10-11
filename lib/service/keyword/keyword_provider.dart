// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import '../../core/models/api/api_response.dart';
// import 'keyword_service.dart';
//
// part 'keyword_provider.g.dart';
//
// @riverpod
// class KeywordList extends _$KeywordList {
//   @override
//   Future<ApiResponse> build() async {
//     final service = ref.watch(keywordServiceProvider);
//     return service.getAllKeywords();
//   }
//
//   Future<void> refresh() async {
//     ref.invalidateSelf();
//     await future;
//   }
// }