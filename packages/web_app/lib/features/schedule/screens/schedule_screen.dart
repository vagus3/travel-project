import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core/themes/app_colors.dart';
import 'package:core/core/themes/app_typography.dart';
import 'package:core/features/schedule/controllers/schedule_controller.dart';
import 'package:web_app/features/schedule/screens/schedule_detail_screen.dart';
import 'package:web_app/features/schedule/widgets/schedule_card.dart';

///
class ScheduleScreen extends ConsumerWidget {
  ///
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final schedules = ref.watch(scheduleControllerProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '일정',
          style: AppTypography.subtitle.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return ScheduleCard(
            schedule: schedules[index],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ScheduleDetailScreen(
                    schedule: schedules[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
