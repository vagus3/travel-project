// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 날씨 컨트롤러 — date/location 기준으로 OpenWeatherMap API 호출

@ProviderFor(WeatherController)
const weatherControllerProvider = WeatherControllerFamily._();

/// 날씨 컨트롤러 — date/location 기준으로 OpenWeatherMap API 호출
final class WeatherControllerProvider
    extends $AsyncNotifierProvider<WeatherController, WeatherState> {
  /// 날씨 컨트롤러 — date/location 기준으로 OpenWeatherMap API 호출
  const WeatherControllerProvider._({
    required WeatherControllerFamily super.from,
    required (DateTime, String) super.argument,
  }) : super(
         retry: null,
         name: r'weatherControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weatherControllerHash();

  @override
  String toString() {
    return r'weatherControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  WeatherController create() => WeatherController();

  @override
  bool operator ==(Object other) {
    return other is WeatherControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weatherControllerHash() => r'85cfdd0192f710403b8777141251ce951ce90391';

/// 날씨 컨트롤러 — date/location 기준으로 OpenWeatherMap API 호출

final class WeatherControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          WeatherController,
          AsyncValue<WeatherState>,
          WeatherState,
          FutureOr<WeatherState>,
          (DateTime, String)
        > {
  const WeatherControllerFamily._()
    : super(
        retry: null,
        name: r'weatherControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 날씨 컨트롤러 — date/location 기준으로 OpenWeatherMap API 호출

  WeatherControllerProvider call(DateTime date, String location) =>
      WeatherControllerProvider._(argument: (date, location), from: this);

  @override
  String toString() => r'weatherControllerProvider';
}

/// 날씨 컨트롤러 — date/location 기준으로 OpenWeatherMap API 호출

abstract class _$WeatherController extends $AsyncNotifier<WeatherState> {
  late final _$args = ref.$arg as (DateTime, String);
  DateTime get date => _$args.$1;
  String get location => _$args.$2;

  FutureOr<WeatherState> build(DateTime date, String location);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, _$args.$2);
    final ref = this.ref as $Ref<AsyncValue<WeatherState>, WeatherState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WeatherState>, WeatherState>,
              AsyncValue<WeatherState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
