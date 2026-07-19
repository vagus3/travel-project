import 'package:template/features/home/models/post_model.dart';

/// 여행 포스트 데이터 소스 추상화.
///
/// 추후 REST/GraphQL/Firestore 등 실제 백엔드를 붙일 때
/// 이 인터페이스만 구현하면 컨트롤러 변경 없이 교체 가능합니다.
abstract class TravelPostRepository {
  /// 홈 피드용 여행 포스트 목록을 가져옵니다.
  Future<List<PostData>> fetchPosts();

  /// 단일 포스트 상세를 가져옵니다.
  /// (현재는 mock에서 메모리 조회, 추후 서버 호출로 대체)
  Future<PostData?> fetchPostById(String id);
}

/// 로컬 더미 데이터 구현.
///
/// 서버 연동 전까지 사용. 동일한 [TravelPostRepository] 시그니처를 유지하므로
/// 컨트롤러/위젯 코드는 그대로 재사용됩니다.
class MockTravelPostRepository implements TravelPostRepository {
  static const _posts = <PostData>[
    PostData(
      id: 'tp_001',
      title: '교토 단풍 명소 BEST 5 — 가을이 가장 잘 어울리는 도시',
      author: '여행작가 민수',
      timeAgo: '2시간 전',
      initialLikeCount: 128,
      imageUrl:
          'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?w=1200',
      profileImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBC73IAzvSE_yn1i152QgW76wQxFgozFcdanX3fAtqS1bl0-qn0f7-TTR5mj7TQUiPEMKEFdTCP6D8sjMAjTVTVvh6nOG8KEiAs-3eS1cconjPKLanBcTvNcQzsT0kF2jL5LQ4reuUg0tNQPSBYwTddpAsPQkLX_ghdx9E9PpCHZshFVyHYEVJaIDaH0tuiK-ySdG3Gt0kd6d6tDOabzAzWWlpaIiGQdoc-dr6i2gWywOSRf8DqBSr0fbI2lSBdf2i35Dyh1QomR10g',
      content: '교토에서 단풍을 가장 아름답게 즐길 수 있는 다섯 곳을 소개합니다.\n\n'
          '1. 도후쿠지 — 통천교에서 내려다보는 단풍 절경\n'
          '2. 에이칸도 — 야간 라이트업이 환상적\n'
          '3. 기요미즈데라 — 무대에서 보는 시내 전경과 단풍\n'
          '4. 아라시야마 — 강가 단풍과 도게츠교\n'
          '5. 난젠지 — 사찰과 어우러진 차분한 단풍\n\n'
          '11월 중순부터 12월 초가 절정이며, 평일 오전 방문을 추천합니다.',
    ),
    PostData(
      id: 'tp_002',
      title: '오사카 3박 4일 먹부림 코스 — 도톤보리부터 쿠로몬 시장까지',
      author: 'foodie_jin',
      timeAgo: '5시간 전',
      initialLikeCount: 87,
      imageUrl:
          'https://images.unsplash.com/photo-1590559899731-a382839e5549?w=1200',
      profileImageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
      content: '오사카는 "천하의 부엌"이라 불릴 만큼 먹거리가 풍부한 도시입니다.\n\n'
          'Day 1 — 도톤보리에서 다코야키, 오코노미야키\n'
          'Day 2 — 쿠로몬 시장 아침 식사, 우메다 푸드코트\n'
          'Day 3 — 신세카이 쿠시카츠 골목\n'
          'Day 4 — 공항 가기 전 한큐 백화점 디저트\n\n'
          '예산은 1일 8만원 정도면 충분히 즐길 수 있어요.',
    ),
    PostData(
      id: 'tp_003',
      title: '후쿠오카 당일치기 — 하카타 라멘 투어와 캐널시티',
      author: 'travel_eunji',
      timeAgo: '1일 전',
      initialLikeCount: 53,
      imageUrl:
          'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=1200',
      profileImageUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      content: '후쿠오카는 한국에서 비행시간 1시간이라 당일치기로도 충분히 다녀올 수 있습니다.\n\n'
          '오전 — 캐널시티에서 쇼핑\n'
          '점심 — 하카타 잇푸도 본점 라멘\n'
          '오후 — 다자이후 텐만구 사찰 투어\n'
          '저녁 — 야타이(포장마차) 거리\n\n'
          '항공권은 보통 왕복 25만원 안팎이면 구할 수 있어요.',
    ),
    PostData(
      id: 'tp_004',
      title: '나가사키 야경 명소와 글로버 가든의 노을',
      author: 'photo_wanderer',
      timeAgo: '2일 전',
      initialLikeCount: 41,
      imageUrl:
          'https://images.unsplash.com/photo-1542640244-7e672d6cef4e?w=1200',
      profileImageUrl:
          'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=400',
      content: '세계 3대 야경으로 꼽히는 나가사키.\n\n'
          '이나사야마 전망대에서 보는 항구 야경은 잊을 수 없는 풍경입니다. '
          '글로버 가든에서는 일몰 직후 분위기가 가장 좋고, '
          '데지마 거리는 야간 조명 산책 코스로 추천합니다.',
    ),
  ];

  @override
  Future<List<PostData>> fetchPosts() async {
    // 서버 호출 흉내 (UX 일관성을 위해 약간의 지연)
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _posts;
  }

  @override
  Future<PostData?> fetchPostById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    for (final p in _posts) {
      if (p.id == id) {
        return p;
      }
    }
    return null;
  }
}
