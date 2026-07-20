import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:core/features/schedule/models/schedule_model.dart';

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
    final colors = context.colors;
    final details = _currentDayDetails;
    final mapUrl = _buildMapUrl(details);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.schedule.title,
          style: AppTypography.bodyBold.copyWith(color: colors.textPrimary),
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
                    errorBuilder: (_, e, s) => _buildMapPlaceholder(colors),
                  )
                : _buildMapPlaceholder(colors),
          ),

          // 하단 시트
          DraggableScrollableSheet(
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: const [
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
                          color: colors.border,
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
                                          : colors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor: isSelected
                                      ? colors.highlight
                                      : colors.background,
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
                                  _buildPlaceCard(colors, details[index], index),
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

  Widget _buildPlaceCard(AppColors colors, ScheduleDetail item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.highlight.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: colors.highlight,
            child: Text(
              '${index + 1}',
              style: AppTypography.small.copyWith(
                color: Colors.white,
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
                  style: AppTypography.small.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.placeName,
                  style: AppTypography.bodyBold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (item.description.isNotEmpty)
                  Text(
                    item.description,
                    style: AppTypography.small.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(AppColors colors) {
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 48, color: colors.textMuted),
            const SizedBox(height: 8),
            Text(
              '.env에 GOOGLE_MAPS_API_KEY를 추가하면\n지도가 표시됩니다.',
              textAlign: TextAlign.center,
              style: AppTypography.label.copyWith(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
