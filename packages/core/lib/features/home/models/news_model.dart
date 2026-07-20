/// 뉴스 기사 데이터 모델
class NewsArticle {
  /// [NewsArticle] 생성자
  const NewsArticle({
    required this.title,
    required this.timeAgo,
    required this.source,
    required this.url,
  });

  /// Naver 뉴스 검색 API 응답으로부터 파싱
  factory NewsArticle.fromNaverJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: _stripHtml(json['title'] as String? ?? ''),
      timeAgo: _timeAgo(json['pubDate'] as String? ?? ''),
      source: _extractDomain(json['originallink'] as String? ?? ''),
      url: json['originallink'] as String? ?? json['link'] as String? ?? '',
    );
  }

  /// 기사 제목
  final String title;

  /// 게시 경과 시간 (예: 2시간 전)
  final String timeAgo;

  /// 출처 도메인
  final String source;

  /// 원본 URL
  final String url;

  /// HTML 태그 및 엔티티 제거
  static String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }

  /// RFC 822 날짜 → 경과 시간 문자열
  static String _timeAgo(String pubDate) {
    if (pubDate.isEmpty) {
      return '';
    }
    try {
      final parts = pubDate.split(' ');
      final normalized = '${parts[1]} ${parts[2]} ${parts[3]} ${parts[4]}';
      const months = {
        'Jan': '01',
        'Feb': '02',
        'Mar': '03',
        'Apr': '04',
        'May': '05',
        'Jun': '06',
        'Jul': '07',
        'Aug': '08',
        'Sep': '09',
        'Oct': '10',
        'Nov': '11',
        'Dec': '12',
      };
      final m = RegExp(
        r'(\d+) (\w+) (\d{4}) (\d+):(\d+):(\d+)',
      ).firstMatch(normalized);
      if (m == null) {
        return '';
      }
      final dt = DateTime(
        int.parse(m.group(3)!),
        int.parse(months[m.group(2)] ?? '1'),
        int.parse(m.group(1)!),
        int.parse(m.group(4)!),
        int.parse(m.group(5)!),
        int.parse(m.group(6)!),
      );
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) {
        return '${diff.inMinutes}분 전';
      }
      if (diff.inHours < 24) {
        return '${diff.inHours}시간 전';
      }
      return '${diff.inDays}일 전';
    } on Exception {
      return '';
    }
  }

  /// URL에서 도메인 추출
  static String _extractDomain(String url) {
    try {
      return Uri.parse(url).host.replaceFirst('www.', '');
    } on FormatException {
      return '';
    }
  }
}
