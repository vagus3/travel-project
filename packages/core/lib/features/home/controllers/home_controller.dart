// lib/features/home/controllers/home_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/features/home/controllers/travel_configuration_controller.dart';
import 'package:core/features/home/models/post_model.dart';

/// 홈 화면의 포스트 목록을 관리하는 Notifier
class HomeController extends Notifier<List<PostData>> {
  @override
  List<PostData> build() {
    // 여행 설정 상태 구독 (지역 변경 감지)
    final config = ref.watch(travelConfigurationProvider);
    final location = config.location;

    // 지역에 따라 다른 데이터 반환
    if (location.contains('오사카')) {
      return [
        const PostData(
          imageUrl:
              'https://images.unsplash.com/photo-1590559899731-a3828395a229?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxvcyVFQSVCQSVCN2ElMjBkb3RvbmJvcml8ZW58MHx8fHwxNzMxNjc5Nzc2fDA&ixlib=rb-4.0.3&q=80&w=1080',
          title: '오사카 도톤보리 먹방 투어, 이건 꼭 먹어야 해!',
          author: '먹방요정',
          timeAgo: '1시간 전',
          profileImageUrl: 'https://placehold.co/100x100/FFCC80/E65100?text=M',
        ),
        const PostData(
          imageUrl:
              'https://images.unsplash.com/photo-1595503023223-999330669b36?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHx1bml2ZXJzYWwlMjBzdHVkaW9zJTIwamFwYW58ZW58MHx8fHwxNzMxNjc5Nzc2fDA&ixlib=rb-4.0.3&q=80&w=1080',
          title: '유니버설 스튜디오 재팬(USJ) 오픈런 후기',
          author: '테마파크덕후',
          timeAgo: '3시간 전',
          profileImageUrl: 'https://placehold.co/100x100/FFF59D/FBC02D?text=T',
        ),
        const PostData(
          imageUrl:
              'https://images.unsplash.com/photo-1549468057-5b7fa1a41d7c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxvcyVFQSVCQSVCN2ElMjBjYXN0bGUlMjBuaWdodHxlbnwwfHx8fDE3MzE2Nzk3NzZ8MA&ixlib=rb-4.0.3&q=80&w=1080',
          title: '오사카성 야경, 인생샷 명소 추천',
          author: '오사카보이',
          timeAgo: '5시간 전',
          profileImageUrl: 'https://placehold.co/100x100/C5CAE9/9FA8DA?text=O',
        ),
      ];
    } else if (location.contains('도쿄')) {
      return [
        const PostData(
          imageUrl:
              'https://images.unsplash.com/photo-1548625149-fc4a874b73e5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxyZWQlMjBqYXBhbmVzZSUyMHNocmluZXxlbnwwfHx8fDE3MzE2Nzk3NDZ8MA&ixlib=rb-4.0.3&q=80&w=1080',
          title: '도쿄 현지인만 아는 맛집 리스트 공유합니다.',
          author: '여행매니아',
          timeAgo: '2시간 전',
          profileImageUrl: 'https://placehold.co/100x100/E0E0E0/BDBDBD?text=P',
        ),
        const PostData(
          imageUrl:
              'https://images.unsplash.com/photo-1547738021-87c2b54c8b67?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHx0b2t5byUyMGRpc25leSUyMGZpcmV3b3Jrc3xlbnwwfHx8fDE3MzE2Nzk3OTh8MA&ixlib=rb-4.0.3&q=80&w=1080',
          title: '도쿄 디즈니랜드 꿀팁 대방출! (스포주의)',
          author: '디즈니덕후',
          timeAgo: '1일 전',
          profileImageUrl: 'https://placehold.co/100x100/F8BBD0/F48FB1?text=D',
        ),
      ];
    }

    // 기본값 (그 외 지역) - 지역명을 제목에 반영
    return [
      PostData(
        imageUrl:
            'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHx0cmF2ZWx8ZW58MHx8fHwxNzMxNjc5Nzc2fDA&ixlib=rb-4.0.3&q=80&w=1080',
        title: '$location 현지인만 아는 숨은 명소 Best 5',
        author: '여행작가K',
        timeAgo: '2시간 전',
        profileImageUrl: 'https://placehold.co/100x100/E0E0E0/BDBDBD?text=K',
      ),
      PostData(
        imageUrl:
            'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHx0cmF2ZWwlMjBhZHZlbnR1cmV8ZW58MHx8fHwxNzMxNjc5Nzc2fDA&ixlib=rb-4.0.3&q=80&w=1080',
        title: '$location 3박 4일 알짜배기 코스 공유',
        author: '배낭러',
        timeAgo: '5시간 전',
        profileImageUrl: 'https://placehold.co/100x100/C5CAE9/9FA8DA?text=B',
      ),
      PostData(
        imageUrl:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxiZWFjaCUyMHN1bnNldHxlbnwwfHx8fDE3MzE2Nzk3NzZ8MA&ixlib=rb-4.0.3&q=80&w=1080',
        title: '$location 여행 중 만난 최고의 순간들',
        author: '포토그래퍼Lee',
        timeAgo: '1일 전',
        profileImageUrl: 'https://placehold.co/100x100/F8BBD0/F48FB1?text=P',
      ),
    ];
  }

  // C-R-U-D 메서드를 여기에 추가할 수 있습니다.
  // 예: void addPost(PostData post) { state = [...state, post]; }
}

/// 홈 화면 포스트 목록 Provider
final homeControllerProvider = NotifierProvider<HomeController, List<PostData>>(
  HomeController.new,
);
