import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_responsive.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:core/features/home/controllers/travel_configuration_controller.dart';

/// 여행 지역 및 일정 선택 위젯
class RegionSelectionWidget extends ConsumerStatefulWidget {
  /// [RegionSelectionWidget] 생성자
  const RegionSelectionWidget({super.key});

  @override
  ConsumerState<RegionSelectionWidget> createState() => _RegionSelectionWidgetState();
}

class _RegionSelectionWidgetState extends ConsumerState<RegionSelectionWidget> {
  DateTimeRange? _selectedDateRange;
  var _isCalendarExpanded = false;
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  void _toggleCalendar() {
    setState(() {
      _isCalendarExpanded = !_isCalendarExpanded;
    });
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      if (_selectedDateRange == null) {
        _selectedDateRange = DateTimeRange(start: date, end: date);
      } else {
        final start = _selectedDateRange!.start;
        final end = _selectedDateRange!.end;
        if (start.isAtSameMomentAs(end)) {
          _selectedDateRange = date.isBefore(start)
              ? DateTimeRange(start: date, end: date)
              : DateTimeRange(start: start, end: date);
        } else {
          _selectedDateRange = DateTimeRange(start: date, end: date);
        }
      }
    });
  }

  void _onSearch() {
    final location = _locationController.text.trim();
    if (location.isNotEmpty) {
      ref.read(travelConfigurationProvider.notifier).setConfiguration(
            _selectedDateRange,
            location,
          );
      FocusScope.of(context).unfocus();
      if (_isCalendarExpanded) _toggleCalendar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: context.hPad),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // 여행 일정 입력
          GestureDetector(
            onTap: _toggleCalendar,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month, color: colors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '여행 일정',
                          style: AppTypography.micro.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _selectedDateRange == null
                              ? '날짜를 선택하세요'
                              : '${DateFormat('yyyy.MM.dd').format(_selectedDateRange!.start)} ~ '
                                  '${DateFormat('yyyy.MM.dd').format(_selectedDateRange!.end)}',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 캘린더 (블라인드 효과)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isCalendarExpanded
                ? Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.border),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: colors.primary,
                          onSurface: colors.textPrimary,
                        ),
                      ),
                      child: CalendarDatePicker(
                        initialDate: _selectedDateRange?.start ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        onDateChanged: _onDateChanged,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 12),

          // 여행지 입력
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: colors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '여행지',
                        style: AppTypography.micro.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          hintText: '도시명을 입력하세요 (예: 오사카)',
                          hintStyle: AppTypography.caption.copyWith(
                            color: colors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 검색 버튼
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _onSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: colors.primary.withValues(alpha: 0.4),
              ),
              child: Text(
                '검색하기',
                style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
