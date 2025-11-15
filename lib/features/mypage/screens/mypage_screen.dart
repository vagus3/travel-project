import 'package:flutter/material.dart';

/// '마이페이지' 탭에 해당하는 메인 화면
// 1. '나의 활동' 탭(작성한 리뷰/저장한 장소)의 상태를 관리해야 하므로
//    StatefulWidget으로 생성합니다.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// 2. TickerProviderStateMixin을 추가하여 TabController의 애니메이션을 처리합니다.
class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController; // '나의 활동' 탭을 제어할 컨트롤러

  @override
  void initState() {
    super.initState();
    // 3. 컨트롤러 초기화 (탭 2개)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // 4. 위젯 종료 시 컨트롤러 리소스 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 5. 디자인 시안에 맞게 배경색을 연한 회색으로 설정
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // 6. main.dart의 탭 화면이므로 뒤로가기 버튼(leading)은 제거
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // 7. 화면이 길어질 경우 스크롤 가능하도록 설정
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. 프로필 섹션 ---
            _buildProfileSection(context),

            // --- 2. 나의 활동 (탭) 섹션 ---
            _buildMyActivitiesSection(context),

            // --- 3. 설정 섹션 ---
            _buildSectionHeader('설정'), // 섹션 제목
            Container(
              color: Colors.white, // 설정 항목들은 흰색 배경
              child: Column(
                children: [
                  _buildSettingItem(Icons.notifications_none_outlined, '알림 설정'),
                  _buildSettingItem(Icons.language_outlined, '언어 설정'),
                ],
              ),
            ),

            // --- 4. 고객지원 섹션 ---
            _buildSectionHeader('고객지원'), // 섹션 제목
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(Icons.campaign_outlined, '공지사항'),
                  _buildSettingItem(Icons.headset_mic_outlined, '문의하기'),
                  _buildSettingItem(Icons.description_outlined, '이용약관'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. 프로필 섹션 (프로필 사진, 이름, 이메일, 버튼)
  Widget _buildProfileSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      // 8. 프로필 섹션은 AppBar와 동일한 배경색
      color: Colors.grey[50],
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(
              'https://placehold.co/180x180/E0E0E0/BDBDBD?text=P',
            ), // 임시 프로필 이미지
          ),
          const SizedBox(height: 12),
          const Text(
            '김여행', // 임시 이름
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            'traveler_kim@email.com', // 임시 이메일
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // (구현 필요) 프로필 수정
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48), // 버튼 높이 및 너비
              backgroundColor: Colors.grey[200], // 디자인 시안의 버튼 색
              foregroundColor: Colors.black87, // 버튼 글자색
              elevation: 0, // 그림자 제거
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text('프로필 수정'),
          ),
        ],
      ),
    );
  }

  /// 2. 나의 활동 섹션 (TabBar + TabBarView)
  Widget _buildMyActivitiesSection(BuildContext context) {
    return Container(
      color: Colors.white, // 탭 영역은 흰색 배경
      child: Column(
        children: [
          // 9. 탭 바 (작성한 리뷰 / 저장한 장소)
          TabBar(
            controller: _tabController, // initState에서 생성한 컨트롤러 연결
            tabs: const [
              Tab(text: '작성한 리뷰'),
              Tab(text: '저장한 장소'),
            ],
            labelColor: Colors.black, // 선택된 탭 글자색
            unselectedLabelColor: Colors.grey[600], // 선택 안된 탭 글자색
            indicatorColor: Colors.black, // 하단 밑줄 색상
          ),
          // 10. 탭 뷰 (실제 탭 내용)
          // (주의) SingleChildScrollView 안의 TabBarView는 명시적인 높이가 필요합니다.
          SizedBox(
            height: 300, // 11. 탭 내용 영역의 높이를 300으로 고정
            child: TabBarView(
              controller: _tabController,
              children: [
                // --- 탭 1: 작성한 리뷰 ---
                // (리뷰가 300px보다 많아지면 이 안에서 스크롤됨)
                ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // (임시 데이터)
                    _buildReviewCard(
                      'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHx0b2t5byUyMHNreSUyMG5pZ2h0fGVufDB8fHx8MTczMTY5MjUzOHww&ixlib=rb-4.0.3&q=80&w=1080',
                      '도쿄 시부야 스카이 전망대',
                      '최고의 야경이었습니다! 정말 추천...',
                      '2일 전',
                    ),
                    _buildReviewCard(
                      'https://images.unsplash.com/photo-1545892224-c1c5c00b21e8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wzNzk5ODV8MHwxfHNlYXJjaHwxfHxreW90byUyMHN0cmVldHxlbnwwfHx8fDE3MzE2OTI1NjF8MA&ixlib=rb-4.0.3&q=80&w=1080',
                      '교토 기온 거리 맛집',
                      '분위기도 좋고 음식도 맛있었어요.',
                      '5일 전',
                    ),
                  ],
                ),
                // --- 탭 2: 저장한 장소 ---
                const Center(
                  child: Text(
                    '저장한 장소가 없습니다.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 3. "나의 활동" 탭 안의 리뷰 카드 헬퍼
  Widget _buildReviewCard(
    String imageUrl,
    String title,
    String subtitle,
    String date,
  ) {
    return Card(
      elevation: 0, // 그림자 없음
      color: Colors.grey[50], // 카드 배경색
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              date,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// 4. "설정", "고객지원" 섹션의 제목 헬퍼
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  /// 5. "설정", "고객지원" 섹션의 각 항목 헬퍼
  Widget _buildSettingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: () {
        // (구현 필요) 각 설정 항목 클릭 시 동작
      },
    );
  }
}
