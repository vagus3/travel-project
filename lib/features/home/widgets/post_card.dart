// import 'dart:developer';
// import 'package:flutter/material.dart';

// /// 홈 화면의 세로 피드에 사용될 여행 포스트 카드
// class TravelPostCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String author;
//   final String timeAgo;
//   final String profileImageUrl;

//   /// 생성자: 각 포스트에 필요한 데이터를 받습니다.
//   const TravelPostCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.author,
//     required this.timeAgo,
//     required this.profileImageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       // 1. 카드 좌우, 하단에 여백을 줍니다.
//       padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
//       child: InkWell(
//         onTap: () {
//           // 2. (구현 필요) 포스트 카드 클릭 시 동작
//           log('$title 탭됨');
//         },
//         borderRadius: BorderRadius.circular(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 3. 상단 프로필 영역 (작성자)
//             ListTile(
//               contentPadding: EdgeInsets.zero, // ListTile의 기본 패딩 제거
//               leading: CircleAvatar(
//                 // 4. 프로필 이미지
//                 backgroundImage: NetworkImage(profileImageUrl),
//                 backgroundColor: Colors.grey[200],
//               ),
//               title: Text(
//                 author, // 5. 작성자 이름
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//               subtitle: Text(
//                 timeAgo, // 6. 작성 시간
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8), // 프로필과 이미지 사이 간격
//             // 7. 메인 이미지 (둥근 모서리)
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 imageUrl,
//                 height: 250, // 이미지 높이 고정
//                 width: double.infinity, // 너비 꽉 채우기
//                 fit: BoxFit.cover,
//                 // 8. 이미지 로딩 중/실패 시 처리
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) {
//                     return child;
//                   }
//                   return Container(
//                     height: 250,
//                     color: Colors.grey[200],
//                     child: const Center(child: CircularProgressIndicator()),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     height: 250,
//                     color: Colors.grey[200],
//                     child: const Icon(Icons.image_not_supported_outlined),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 12), // 이미지와 텍스트 사이 간격
//             // 9. 포스트 제목
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               maxLines: 2, // 10. 제목은 최대 2줄까지만 표시
//               overflow: TextOverflow.ellipsis, // 2줄이 넘으면 ... 처리
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
