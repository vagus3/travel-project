import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/features/home/models/post_model.dart';
import 'package:template/features/home/repositories/travel_post_repository.dart';

/// 여행 포스트 레포지토리 Provider.
///
/// 추후 서버 연동 시 [MockTravelPostRepository]를 실제 구현체로 교체하거나,
/// 테스트에서 `overrideWith`로 갈아끼우면 됩니다.
final travelPostRepositoryProvider = Provider<TravelPostRepository>(
  (ref) => MockTravelPostRepository(),
);

/// 홈 피드의 여행 포스트 목록 컨트롤러.
class TravelPostController extends AsyncNotifier<List<PostData>> {
  TravelPostRepository get _repository =>
      ref.read(travelPostRepositoryProvider);

  @override
  Future<List<PostData>> build() {
    return _repository.fetchPosts();
  }

  /// 새로고침 (Pull-to-refresh 등에서 사용)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.fetchPosts);
  }
}

/// 여행 포스트 목록 Provider
final travelPostsProvider =
    AsyncNotifierProvider<TravelPostController, List<PostData>>(
  TravelPostController.new,
);
