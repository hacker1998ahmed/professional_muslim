import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prayer_times_provider.dart';


class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مواقيت الصلاة'),
        centerTitle: true,
      ),
      body: Consumer<PrayerTimesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  if (!provider.isLocationEnabled)
                    ElevatedButton(
                      onPressed: () {
                        provider.updatePrayerTimes();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                ],
              ),
            );
          }

          if (provider.dailyPrayers.isEmpty) {
            return const Center(
              child: Text('لا توجد معلومات متاحة عن مواقيت الصلاة'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.updatePrayerTimes(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildPrayerTimeCard(context, 'الفجر', provider.dailyPrayers['fajr']!),
                _buildPrayerTimeCard(context, 'الظهر', provider.dailyPrayers['dhuhr']!),
                _buildPrayerTimeCard(context, 'العصر', provider.dailyPrayers['asr']!),
                _buildPrayerTimeCard(context, 'المغرب', provider.dailyPrayers['maghrib']!),
                _buildPrayerTimeCard(context, 'العشاء', provider.dailyPrayers['isha']!),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime12Hour(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildPrayerTimeCard(BuildContext context, String name, DateTime time) {
    final now = DateTime.now();
    final isNextPrayer = now.isBefore(time) &&
        (now.difference(time).inHours).abs() < 24;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          _formatTime12Hour(time),
          style: const TextStyle(fontSize: 18),
        ),
        trailing: isNextPrayer
            ? const Icon(
                Icons.notifications_active,
                color: Colors.green,
                size: 28,
              )
            : null,
        tileColor: isNextPrayer ? Colors.green.withValues(alpha: 0.1) : null,
      ),
    );
  }
}