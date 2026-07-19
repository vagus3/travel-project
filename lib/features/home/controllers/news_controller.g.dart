// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 뉴스 컨트롤러 — travelConfigurationProvider의 지역 변경 시 자동 갱신

@ProviderFor(NewsController)
const newsControllerProvider = NewsControllerProvider._();

/// 뉴스 컨트롤러 — travelConfigurationProvider의 지역 변경 시 자동 갱신
final class NewsControllerProvider
    extends $AsyncNotifierProvider<NewsController, List<NewsArticle>> {
  /// 뉴스 컨트롤러 — travelConfigurationProvider의 지역 변경 시 자동 갱신
  const NewsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newsControllerHash();

  @$internal
  @override
  NewsController create() => NewsController();
}

String _$newsControllerHash() => r'8a61fc9d91993c596b6c4c10f6c28badeb387fa0';

/// 뉴스 컨트롤러 — travelConfigurationProvider의 지역 변경 시 자동 갱신

abstract class _$NewsController extends $AsyncNotifier<List<NewsArticle>> {
  FutureOr<List<NewsArticle>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<NewsArticle>>, List<NewsArticle>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<NewsArticle>>, List<NewsArticle>>,
              AsyncValue<List<NewsArticle>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
