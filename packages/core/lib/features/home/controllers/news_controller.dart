import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/features/home/controllers/travel_configuration_controller.dart';
import 'package:core/features/home/models/news_model.dart';
import 'package:core/features/home/repositories/news_repository.dart';

part 'news_controller.g.dart';

/// 뉴스 컨트롤러 — travelConfigurationProvider의 지역 변경 시 자동 갱신
@riverpod
class NewsController extends _$NewsController {
  final _repository = NewsRepository();

  /// travelConfigurationProvider의 지역을 기준으로 뉴스 목록 반환
  @override
  Future<List<NewsArticle>> build() {
    final location = ref.watch(travelConfigurationProvider).location;
    return _repository.fetchNews(location);
  }
}
