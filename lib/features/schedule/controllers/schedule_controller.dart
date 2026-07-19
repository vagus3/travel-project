import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template/features/schedule/models/schedule_model.dart';

/// Schedule 컨트롤러 (최신 Riverpod 방식)
class ScheduleController extends Notifier<List<ScheduleSummary>> {
  @override
  List<ScheduleSummary> build() {
    // build 메서드에서 초기 상태(데이터)를 반환합니다.
    return [
      ScheduleSummary(
        id: '1',
        title: '도쿄 3박 4일 자유여행',
        dateRange: '2024.08.15 ~ 2024.08.18',
        imageUrl:
            'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?q=80&w=294&auto=format&fit=crop',
      ),
      ScheduleSummary(
        id: '2',
        title: '주말 부산 식도락 여행',
        dateRange: '2024.09.20 ~ 2024.09.21',
        imageUrl:
            'https://images.unsplash.com/photo-1634547481228-466d338bbd6d?q=80&w=294&auto=format&fit=crop',
      ),
      ScheduleSummary(
        id: '3',
        title: '가을 교토, 나 홀로 여행',
        dateRange: '2024.11.01 ~ 2024.11.04',
        imageUrl:
            'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=294&auto=format&fit=crop',
      ),
    ];
  }

  /// AI가 생성한 일정을 목록에 추가
  void addSchedule(ScheduleSummary schedule) {
    state = [schedule, ...state];
  }

  /// 오사카 샘플 상세 일정 반환
  List<ScheduleDetail> getOsakaDetails() {
    return const [
      ScheduleDetail(
        day: 1,
        time: '오전 10시',
        placeName: '도톤보리',
        description: '오사카의 대표적인 먹거리 골목',
        imageUrl:
            'https://images.unsplash.com/photo-1590559899731-a3828395a229?q=80&w=294',
        lat: 34.6687,
        lng: 135.5013,
      ),
      ScheduleDetail(
        day: 1,
        time: '오후 1시',
        placeName: '신사이바시',
        description: '쇼핑과 패션의 중심지',
        imageUrl:
            'https://images.unsplash.com/photo-1595503023223-999330669b36?q=80&w=294',
        lat: 34.6726,
        lng: 135.5016,
      ),
    ];
  }
}

/// (Provider) 최신 Riverpod 방식의 프로바이더
final scheduleControllerProvider =
    NotifierProvider<ScheduleController, List<ScheduleSummary>>(
  ScheduleController.new,
);
