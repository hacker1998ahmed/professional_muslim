import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fasting_tracker.dart';
import '../providers/fasting_provider.dart';

class FastingTrackerScreen extends StatelessWidget {
  const FastingTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تتبع الصيام'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'رمضان'),
              Tab(text: 'صيام تطوع'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RamadanTab(),
            _VoluntaryFastingTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFastingMonthDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddFastingMonthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddFastingMonthDialog(),
    );
  }
}

class _RamadanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FastingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error.isNotEmpty) {
          return Center(child: Text(provider.error));
        }

        final ramadanMonth = provider.getCurrentRamadan();
        if (ramadanMonth == null) {
          return const Center(child: Text('لا يوجد شهر رمضان حالي'));
        }

        return Column(
          children: [
            _buildProgressCard(ramadanMonth),
            Expanded(
              child: _buildDaysList(context, provider, ramadanMonth),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressCard(FastingMonth month) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'تقدم صيام رمضان ${month.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: month.completionPercentage / 100,
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              '${month.completedDays} من ${month.days.length} يوم',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoluntaryFastingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FastingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final voluntaryMonths = provider.getMonthsByType(FastingType.voluntary);
        
        if (voluntaryMonths.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('لا يوجد صيام تطوع مسجل'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showAddFastingMonthDialog(context),
                  child: const Text('إضافة صيام تطوع'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: voluntaryMonths.length,
          itemBuilder: (context, index) {
            final month = voluntaryMonths[index];
            return _buildMonthCard(context, provider, month);
          },
        );
      },
    );
  }

  void _showAddFastingMonthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddFastingMonthDialog(),
    );
  }
}

Widget _buildDaysList(BuildContext context, FastingProvider provider, FastingMonth month) {
  return ListView.builder(
    itemCount: month.days.length,
    itemBuilder: (context, index) {
      final day = month.days[index];
      return ListTile(
        leading: Checkbox(
          value: day.completed,
          onChanged: (value) {
            provider.updateFastDay(month, day, value ?? false);
          },
        ),
        title: Text(
          'اليوم ${index + 1}',
          style: TextStyle(
            decoration: day.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: day.notes != null ? Text(day.notes!) : null,
        onTap: () => _showDayDetailsDialog(context, provider, month, day),
      );
    },
  );
}

Widget _buildMonthCard(BuildContext context, FastingProvider provider, FastingMonth month) {
  return Card(
    margin: const EdgeInsets.all(8),
    child: Column(
      children: [
        ListTile(
          title: Text(month.name),
          subtitle: Text('${month.completedDays} من ${month.days.length} يوم'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => provider.deleteFastingMonth(month),
          ),
        ),
        LinearProgressIndicator(
          value: month.completionPercentage / 100,
          minHeight: 8,
        ),
        _buildDaysList(context, provider, month),
      ],
    ),
  );
}

void _showDayDetailsDialog(BuildContext context, FastingProvider provider,
    FastingMonth month, FastDay day) {
  final notesController = TextEditingController(text: day.notes);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('تفاصيل اليوم ${day.date.day}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: const Text('تم الصيام'),
            value: day.completed,
            onChanged: (value) {
              provider.updateFastDay(month, day, value ?? false);
              Navigator.pop(context);
            },
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
        TextButton(
          onPressed: () {
            provider.updateFastDay(
              month,
              day,
              day.completed,
              notes: notesController.text,
            );
            Navigator.pop(context);
          },
          child: const Text('حفظ'),
        ),
      ],
    ),
  );
}

class AddFastingMonthDialog extends StatefulWidget {
  const AddFastingMonthDialog({super.key});

  @override
  State<AddFastingMonthDialog> createState() => _AddFastingMonthDialogState();
}

class _AddFastingMonthDialogState extends State<AddFastingMonthDialog> {
  final _nameController = TextEditingController();
  FastingType _selectedType = FastingType.voluntary;
  int _numberOfDays = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة شهر صيام جديد'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم الشهر',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<FastingType>(
            value: _selectedType,
            items: FastingType.values
                .where((type) => type != FastingType.ramadan)
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(_getFastingTypeName(type)),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
            decoration: const InputDecoration(
              labelText: 'نوع الصيام',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('عدد الأيام: '),
              Expanded(
                child: Slider(
                  value: _numberOfDays.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: _numberOfDays.toString(),
                  onChanged: (value) {
                    setState(() {
                      _numberOfDays = value.round();
                    });
                  },
                ),
              ),
              Text(_numberOfDays.toString()),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            final now = DateTime.now();
            final days = List.generate(
              _numberOfDays,
              (index) => FastDay(
                date: DateTime(now.year, now.month, now.day + index),
                completed: false,
              ),
            );

            final month = FastingMonth(
              name: _nameController.text,
              year: now.year,
              days: days,
              type: _selectedType,
            );

            context.read<FastingProvider>().addFastingMonth(month);
            Navigator.pop(context);
          },
          child: const Text('إضافة'),
        ),
      ],
    );
  }

  String _getFastingTypeName(FastingType type) {
    switch (type) {
      case FastingType.voluntary:
        return 'صيام تطوع';
      case FastingType.sixShawwal:
        return 'ست من شوال';
      case FastingType.ashura:
        return 'عاشوراء';
      case FastingType.arafah:
        return 'يوم عرفة';
      case FastingType.mondayThursday:
        return 'الاثنين والخميس';
      case FastingType.ayamBeed:
        return 'أيام البيض';
      case FastingType.other:
        return 'آخر';
      default:
        return '';
    }
  }
}