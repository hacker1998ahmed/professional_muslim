import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quran_memorization.dart';
import '../providers/quran_memorization_provider.dart';

class QuranMemorizationScreen extends StatelessWidget {
  const QuranMemorizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حفظ القرآن'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'التقدم'),
              Tab(text: 'المراجعة'),
              Tab(text: 'الإحصائيات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ProgressTab(),
            _ReviewTab(),
            _StatisticsTab(),
          ],
        ),
      ),
    );
  }
}

class _ProgressTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuranMemorizationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error.isNotEmpty) {
          return Center(child: Text(provider.error));
        }

        return Column(
          children: [
            _buildOverallProgress(provider),
            const Divider(),
            Expanded(
              child: _buildSurahList(provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverallProgress(QuranMemorizationProvider provider) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'التقدم الكلي',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CircularProgressIndicator(
              value: provider.totalMemorizationProgress / 100,
              backgroundColor: Colors.grey[200],
              strokeWidth: 10,
            ),
            const SizedBox(height: 8),
            Text(
              '${provider.totalMemorizationProgress.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahList(QuranMemorizationProvider provider) {
    final recommendedSurahs = provider.getRecommendedForMemorization();

    return ListView.builder(
      itemCount: provider.surahs.length,
      itemBuilder: (context, index) {
        final surah = provider.surahs[index];
        final isRecommended = recommendedSurahs.contains(surah);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(surah.number.toString()),
            ),
            title: Text(surah.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: surah.memorizationProgress / 100,
                  backgroundColor: Colors.grey[200],
                ),
                Text(
                  '${surah.memorizationProgress.toStringAsFixed(1)}% محفوظ',
                ),
              ],
            ),
            trailing: isRecommended
                ? const Tooltip(
                    message: 'موصى به للحفظ',
                    child: Icon(Icons.star, color: Colors.amber),
                  )
                : null,
            onTap: () => _showSurahDetailsDialog(context, provider, surah),
          ),
        );
      },
    );
  }
}

class _ReviewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuranMemorizationProvider>(
      builder: (context, provider, child) {
        final dueAyahs = provider.getDueForReview();

        if (dueAyahs.isEmpty) {
          return const Center(
            child: Text('لا توجد آيات تحتاج إلى مراجعة حالياً'),
          );
        }

        return ListView.builder(
          itemCount: dueAyahs.length,
          itemBuilder: (context, index) {
            final ayah = dueAyahs[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(ayah.text),
                subtitle: Text(
                  'آخر مراجعة: ${_formatDate(ayah.lastReviewed!)}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.rate_review),
                  onPressed: () =>
                      _showReviewDialog(context, provider, ayah),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}

class _StatisticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuranMemorizationProvider>(
      builder: (context, provider, child) {
        final totalAyahs = provider.surahs.fold(
            0, (sum, surah) => sum + surah.totalAyahs);
        final memorizedAyahs = provider.surahs.fold(
            0,
            (sum, surah) =>
                sum +
                surah.ayahs
                    .where((ayah) =>
                        ayah.status == MemorizationStatus.memorized)
                    .length);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatCard(
                'إجمالي الآيات المحفوظة',
                '$memorizedAyahs من $totalAyahs',
                Icons.bookmark,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'متوسط التقييم',
                _calculateAverageRating(provider),
                Icons.star,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'أيام الحفظ المتتالية',
                _calculateStreakDays(provider),
                Icons.timeline,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAverageRating(QuranMemorizationProvider provider) {
    var totalRating = 0.0;
    var totalReviews = 0;

    for (final surah in provider.surahs) {
      for (final ayah in surah.ayahs) {
        for (final review in ayah.reviews) {
          totalRating += _getRatingValue(review.rating);
          totalReviews++;
        }
      }
    }

    if (totalReviews == 0) return 'لا يوجد تقييمات';
    return '${(totalRating / totalReviews).toStringAsFixed(1)} / 5.0';
  }

  double _getRatingValue(ReviewRating rating) {
    switch (rating) {
      case ReviewRating.excellent:
        return 5.0;
      case ReviewRating.good:
        return 4.0;
      case ReviewRating.fair:
        return 3.0;
      case ReviewRating.poor:
        return 2.0;
      case ReviewRating.needsPractice:
        return 1.0;
    }
  }

  String _calculateStreakDays(QuranMemorizationProvider provider) {
    // يمكن إضافة منطق حساب أيام الحفظ المتتالية هنا
    return '7 أيام'; // مثال
  }
}

void _showSurahDetailsDialog(
    BuildContext context, QuranMemorizationProvider provider, Surah surah) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(surah.name),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: surah.ayahs.length,
          itemBuilder: (context, index) {
            final ayah = surah.ayahs[index];
            return ListTile(
              title: Text(ayah.text),
              subtitle: Text(_getStatusText(ayah.status)),
              trailing: PopupMenuButton<MemorizationStatus>(
                onSelected: (status) {
                  provider.updateAyahStatus(
                      surah.number, ayah.number, status);
                  Navigator.pop(context);
                },
                itemBuilder: (context) => MemorizationStatus.values
                    .map(
                      (status) => PopupMenuItem(
                        value: status,
                        child: Text(_getStatusText(status)),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
      ],
    ),
  );
}

void _showReviewDialog(
    BuildContext context, QuranMemorizationProvider provider, Ayah ayah) {
  final notesController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تقييم المراجعة'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(ayah.text),
          const SizedBox(height: 16),
          ...ReviewRating.values.map(
            (rating) => RadioListTile<ReviewRating>(
              title: Text(_getRatingText(rating)),
              value: rating,
              groupValue: null,
              onChanged: (value) {
                if (value != null) {
                  provider.addReview(
                    1, // يجب تحديد رقم السورة
                    ayah.number,
                    value,
                    notes: notesController.text,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ),
          TextField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: 'ملاحظات',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
      ],
    ),
  );
}

String _getStatusText(MemorizationStatus status) {
  switch (status) {
    case MemorizationStatus.notStarted:
      return 'لم يبدأ';
    case MemorizationStatus.inProgress:
      return 'قيد الحفظ';
    case MemorizationStatus.memorized:
      return 'محفوظ';
    case MemorizationStatus.needsReview:
      return 'يحتاج مراجعة';
  }
}

String _getRatingText(ReviewRating rating) {
  switch (rating) {
    case ReviewRating.excellent:
      return 'ممتاز';
    case ReviewRating.good:
      return 'جيد';
    case ReviewRating.fair:
      return 'متوسط';
    case ReviewRating.poor:
      return 'ضعيف';
    case ReviewRating.needsPractice:
      return 'يحتاج تدريب';
  }
}