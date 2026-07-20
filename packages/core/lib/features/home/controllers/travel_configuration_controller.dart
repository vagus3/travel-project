import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 여행 설정 데이터 모델
class TravelConfiguration {
  final DateTimeRange? dateRange;
  final String location;

  const TravelConfiguration({
    this.dateRange,
    this.location = '도쿄', // 기본값
  });

  TravelConfiguration copyWith({
    DateTimeRange? dateRange,
    String? location,
  }) {
    return TravelConfiguration(
      dateRange: dateRange ?? this.dateRange,
      location: location ?? this.location,
    );
  }
}

/// 여행 설정을 관리하는 Notifier
class TravelConfigurationController extends Notifier<TravelConfiguration> {
  @override
  TravelConfiguration build() {
    return const TravelConfiguration();
  }

  void setConfiguration(DateTimeRange? dateRange, String location) {
    state = state.copyWith(dateRange: dateRange, location: location);
  }
}

/// 여행 설정 Provider
final travelConfigurationProvider =
    NotifierProvider<TravelConfigurationController, TravelConfiguration>(
      TravelConfigurationController.new,
    );
