import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:template/features/schedule/models/schedule_model.dart';

/// 일정 상세 화면 — Google Maps Static API로 동선 표시
class ScheduleDetailScreen extends StatefulWidget {
  /// [ScheduleDetailScreen] 생성자
  const ScheduleDetailScreen({super.key, required this.schedule});

  /// 표시할 일정 요약 데이터
  final ScheduleSummary schedule;

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  var _selectedDay = 1;

  List<int> get _days {
    return widget.schedule.details
        .map((d) => d.day)
        .toSet()
        .toList()
      ..sort();
  }

  List<ScheduleDetail> get _currentDayDetails {
    return widget.schedule.details
        .where((d) => d.day == _selectedDay)
        .toList();
  }

  /// Google Maps Static API URL 생성
  String _buildMapUrl(List<ScheduleDetail> places) {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    if (apiKey.isEmpty || places.isEmpty) {
      return '';
    }

    final validPlaces = places.where((p) => p.lat != 0 || p.lng != 0).toList();
    if (validPlaces.isEmpty) {
      return '';
    }

    final buffer = StringBuffer(
      'https://maps.googleapis.com/maps/api/staticmap?size=800x400&maptype=roadmap',
    );

    for (var i = 0; i < validPlaces.length; i++) {
      final p = validPlaces[i];
      buffer.write(
        '&markers=color:0xEE2B5B|label:${i + 1}|${p.lat},${p.lng}',
      );
    }

    if (validPlaces.length > 1) {
      final coords = validPlaces.map((p) => '${p.lat},${p.lng}').join('|');
      buffer.write('&path=color:0xEE2B5BCC|weight:3|$coords');
    }

    buffer.write('&key=$apiKey');
    return buffer.toString();
  }

  @override
  void initState() {
    super.initState();
    if (_days.isNotEmpty) {
      _selectedDay = _days.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = _currentDayDetails;
    final mapUrl = _buildMapUrl(details);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.schedule.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 지도 영역
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: mapUrl.isNotEmpty
                ? Image.network(
                    mapUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) => _buildMapPlaceholder(),
                  )
                : _buildMapPlaceholder(),
          ),

          // 하단 시트
          DraggableScrollableSheet(
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return DecoratedBox(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F6F6),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(blurRadius: 20, color: Colors.black26),
                  ],
                ),
                child: Column(
                  children: [
                    // 핸들
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // Day 탭
                    if (_days.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: _days.map((day) {
                            final isSelected = day == _selectedDay;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedDay = day),
                                child: Chip(
                                  label: Text(
                                    'Day $day',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: isSelected
                                      ? const Color(0xFFEE2B5B)
                                      : Colors.grey[200],
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // 일정 목록
                    Expanded(
                      child: details.isEmpty
                          ? const Center(child: Text('일정이 없습니다.'))
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              itemCount: details.length,
                              itemBuilder: (context, index) =>
                                  _buildPlaceCard(details[index], index),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(ScheduleDetail item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFFEE2B5B),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF89616B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.placeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF181113),
                  ),
                ),
                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return ColoredBox(
      color: const Color(0xFFE8E8E8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 48, color: Colors.grey[500]),
            const SizedBox(height: 8),
            Text(
              '.env에 GOOGLE_MAPS_API_KEY를 추가하면\n지도가 표시됩니다.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
