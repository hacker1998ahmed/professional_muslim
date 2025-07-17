import 'package:flutter/material.dart';

import '../data/services/audio_service.dart';


class AdhanSettingsScreen extends StatefulWidget {
  const AdhanSettingsScreen({super.key});

  @override
  State<AdhanSettingsScreen> createState() => _AdhanSettingsScreenState();
}

class _AdhanSettingsScreenState extends State<AdhanSettingsScreen> {
  final AudioService _audioService = AudioService();

  
  bool _enableAdhan = true;
  bool _enableVibration = true;
  bool _enableNotifications = true;
  double _volume = 0.8;
  String _selectedAdhan = 'default';
  
  final List<Map<String, String>> _adhanOptions = [
    {'name': 'الأذان الافتراضي', 'value': 'default', 'file': 'audio/adhan_default.mp3'},
    {'name': 'أذان مكة المكرمة', 'value': 'makkah', 'file': 'audio/adhan_makkah.mp3'},
    {'name': 'أذان المدينة المنورة', 'value': 'madinah', 'file': 'audio/adhan_madinah.mp3'},
    {'name': 'أذان الأقصى', 'value': 'aqsa', 'file': 'audio/adhan_aqsa.mp3'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // Load settings from storage
    // This would typically load from SharedPreferences
    setState(() {
      _enableAdhan = true;
      _enableVibration = true;
      _enableNotifications = true;
      _volume = 0.8;
      _selectedAdhan = 'default';
    });
  }

  void _saveSettings() {
    // Save settings to storage
    // This would typically save to SharedPreferences
  }

  void _playTestAdhan() async {
    final selectedAdhanFile = _adhanOptions
        .firstWhere((adhan) => adhan['value'] == _selectedAdhan)['file']!;
    
    await _audioService.setVolume(_volume);
    await _audioService.playAsset(selectedAdhanFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات الأذان'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Enable Adhan Card
          Card(
            child: SwitchListTile(
              title: const Text(
                'تفعيل الأذان',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text('تشغيل الأذان عند حلول وقت الصلاة'),
              value: _enableAdhan,
              onChanged: (value) {
                setState(() {
                  _enableAdhan = value;
                });
              },
              secondary: const Icon(Icons.volume_up),
            ),
          ),

          const SizedBox(height: 16),

          // Adhan Selection Card
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'اختيار الأذان',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.music_note),
                ),
                const Divider(),
                ..._adhanOptions.map((adhan) => RadioListTile<String>(
                  title: Text(adhan['name']!),
                  value: adhan['value']!,
                  groupValue: _selectedAdhan,
                  onChanged: _enableAdhan ? (value) {
                    setState(() {
                      _selectedAdhan = value!;
                    });
                  } : null,
                )),
                const Divider(),
                ListTile(
                  title: const Text('تجربة الأذان'),
                  trailing: ElevatedButton.icon(
                    onPressed: _enableAdhan ? _playTestAdhan : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('تشغيل'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Volume Control Card
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'مستوى الصوت',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.volume_up),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.volume_down),
                      Expanded(
                        child: Slider(
                          value: _volume,
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          label: '${(_volume * 100).round()}%',
                          onChanged: _enableAdhan ? (value) {
                            setState(() {
                              _volume = value;
                            });
                          } : null,
                        ),
                      ),
                      const Icon(Icons.volume_up),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Additional Settings Card
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'إعدادات إضافية',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.settings),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('الاهتزاز'),
                  subtitle: const Text('اهتزاز الجهاز مع الأذان'),
                  value: _enableVibration,
                  onChanged: _enableAdhan ? (value) {
                    setState(() {
                      _enableVibration = value;
                    });
                  } : null,
                  secondary: const Icon(Icons.vibration),
                ),
                SwitchListTile(
                  title: const Text('الإشعارات'),
                  subtitle: const Text('إظهار إشعار عند حلول وقت الصلاة'),
                  value: _enableNotifications,
                  onChanged: (value) {
                    setState(() {
                      _enableNotifications = value;
                    });
                  },
                  secondary: const Icon(Icons.notifications),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Prayer Times Settings Card
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'إعدادات مواقيت الصلاة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.access_time),
                ),
                const Divider(),
                ListTile(
                  title: const Text('طريقة الحساب'),
                  subtitle: const Text('الهيئة العامة المصرية للمساحة'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to calculation method settings
                  },
                ),
                ListTile(
                  title: const Text('المذهب الفقهي'),
                  subtitle: const Text('الشافعي'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to madhab settings
                  },
                ),
                ListTile(
                  title: const Text('تعديل الأوقات'),
                  subtitle: const Text('تعديل يدوي لمواقيت الصلاة'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to time adjustment settings
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Save Button
          ElevatedButton.icon(
            onPressed: () {
              _saveSettings();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حفظ الإعدادات بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.save),
            label: const Text('حفظ الإعدادات'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }
}
