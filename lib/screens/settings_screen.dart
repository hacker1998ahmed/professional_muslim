import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';

import '../core/utils/helpers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Services will be used in future updates
  // final NotificationService _notificationService = NotificationService();
  // final AudioService _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'المظهر',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.palette),
                ),
                const Divider(),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return SwitchListTile(
                      title: const Text('الوضع الليلي'),
                      subtitle: const Text('تفعيل الثيم الداكن'),
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      secondary: Icon(
                        themeProvider.isDarkMode 
                            ? Icons.dark_mode 
                            : Icons.light_mode,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Language Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'اللغة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.language),
                ),
                const Divider(),
                Consumer<LanguageProvider>(
                  builder: (context, languageProvider, child) {
                    return ListTile(
                      title: const Text('لغة التطبيق'),
                      subtitle: Text(languageProvider.currentLanguageName),
                      trailing: DropdownButton<String>(
                        value: languageProvider.currentLocale.languageCode,
                        items: const [
                          DropdownMenuItem(
                            value: 'ar',
                            child: Text('العربية'),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text('English'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            languageProvider.changeLanguage(value);
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Notification Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'الإشعارات',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.notifications),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('إشعارات مواقيت الصلاة'),
                  subtitle: const Text('تلقي إشعارات عند حلول وقت الصلاة'),
                  value: true, // يمكن ربطها بـ SharedPreferences
                  onChanged: (value) {
                    // حفظ الإعداد
                    AppHelpers.showInfoSnackBar(
                      context,
                      value ? 'تم تفعيل الإشعارات' : 'تم إلغاء الإشعارات',
                    );
                  },
                  secondary: const Icon(Icons.access_time),
                ),
                SwitchListTile(
                  title: const Text('تذكير الأذكار'),
                  subtitle: const Text('تذكير بأذكار الصباح والمساء'),
                  value: true,
                  onChanged: (value) {
                    AppHelpers.showInfoSnackBar(
                      context,
                      value ? 'تم تفعيل تذكير الأذكار' : 'تم إلغاء تذكير الأذكار',
                    );
                  },
                  secondary: const Icon(Icons.book),
                ),
                SwitchListTile(
                  title: const Text('تذكير قراءة القرآن'),
                  subtitle: const Text('تذكير يومي لقراءة القرآن'),
                  value: true,
                  onChanged: (value) {
                    AppHelpers.showInfoSnackBar(
                      context,
                      value ? 'تم تفعيل تذكير القرآن' : 'تم إلغاء تذكير القرآن',
                    );
                  },
                  secondary: const Icon(Icons.menu_book),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Audio Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'الصوت',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.volume_up),
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('أصوات التطبيق'),
                  subtitle: const Text('تشغيل الأصوات والتأثيرات'),
                  value: true,
                  onChanged: (value) {
                    AppHelpers.showInfoSnackBar(
                      context,
                      value ? 'تم تفعيل الأصوات' : 'تم إلغاء الأصوات',
                    );
                  },
                  secondary: const Icon(Icons.music_note),
                ),
                SwitchListTile(
                  title: const Text('الاهتزاز'),
                  subtitle: const Text('اهتزاز الجهاز مع الإشعارات'),
                  value: true,
                  onChanged: (value) {
                    if (value) {
                      AppHelpers.mediumHaptic();
                    }
                    AppHelpers.showInfoSnackBar(
                      context,
                      value ? 'تم تفعيل الاهتزاز' : 'تم إلغاء الاهتزاز',
                    );
                  },
                  secondary: const Icon(Icons.vibration),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // App Settings
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'إعدادات التطبيق',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.settings),
                ),
                const Divider(),
                ListTile(
                  title: const Text('إعدادات الأذان'),
                  subtitle: const Text('تخصيص أصوات ومواقيت الأذان'),
                  leading: const Icon(Icons.volume_up),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to Adhan settings
                    AppHelpers.showInfoSnackBar(
                      context,
                      'سيتم إضافة هذه الميزة قريباً',
                    );
                  },
                ),
                ListTile(
                  title: const Text('إعدادات القبلة'),
                  subtitle: const Text('تخصيص بوصلة القبلة'),
                  leading: const Icon(Icons.explore),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    AppHelpers.showInfoSnackBar(
                      context,
                      'سيتم إضافة هذه الميزة قريباً',
                    );
                  },
                ),
                ListTile(
                  title: const Text('نسخ احتياطي'),
                  subtitle: const Text('حفظ واستعادة البيانات'),
                  leading: const Icon(Icons.backup),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    AppHelpers.showInfoSnackBar(
                      context,
                      'سيتم إضافة هذه الميزة قريباً',
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    'حول التطبيق',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.info),
                ),
                const Divider(),
                const ListTile(
                  title: Text('إصدار التطبيق'),
                  subtitle: Text('1.0.0'),
                  leading: Icon(Icons.info_outline),
                ),
                const ListTile(
                  title: Text('المطور'),
                  subtitle: Text('أحمد مصطفى إبراهيم'),
                  leading: Icon(Icons.person),
                ),
                ListTile(
                  title: const Text('تقييم التطبيق'),
                  subtitle: const Text('قيم التطبيق في المتجر'),
                  leading: const Icon(Icons.star),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    AppHelpers.showInfoSnackBar(
                      context,
                      'شكراً لك! سيتم توجيهك للمتجر',
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
