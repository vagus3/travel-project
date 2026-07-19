// lib/features/home/models/post_model.dart

/// 홈 화면에 표시될 포스트 데이터 모델
class PostData {
  /// [PostData] 생성자
  const PostData({
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.timeAgo,
    required this.profileImageUrl,
    this.id,
    this.content,
    this.initialLikeCount = 0,
  });

  /// 포스트 고유 식별자 (DB 연동 시 사용)
  final String? id;

  /// 포스트 이미지 URL
  final String imageUrl;

  /// 포스트 제목
  final String title;

  /// 작성자 이름
  final String author;

  /// 작성 시간
  final String timeAgo;

  /// 작성자 프로필 이미지 URL
  final String profileImageUrl;

  /// 포스트 본문 (상세 페이지에서 사용)
  final String? content;

  /// 좋아요 초기 개수 (목록 진입 시 표시될 시작값)
  final int initialLikeCount;
}
